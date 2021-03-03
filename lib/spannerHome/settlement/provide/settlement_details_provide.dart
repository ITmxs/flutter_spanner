import 'package:spanners/base/base_provide.dart';
import 'package:spanners/cTools/public_function.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/delivery_check/model/dc_details_model.dart';
import 'package:spanners/spannerHome/settlement/model/preferential_card_model.dart';
import 'package:spanners/spannerHome/settlement/model/settlement_details_model.dart';

class SettlementDetailsProvide extends BaseProvide {

  final SettlementPageRepo _repo = SettlementPageRepo();

  List _serviceTitle = ['名称', '规格', '单价', '数量', '总价'];
  List get serviceTitle => _serviceTitle;

  bool _showCardDetails = false;
  bool get showCardDetails => _showCardDetails;
  set showCardDetails(bool showCardDetails) {
    _showCardDetails = showCardDetails;
    notifyListeners();
  }

  List _serviceList = [];
  List get serviceList => _serviceList;
  set serviceList(List serviceList) {
    _serviceList = serviceList;
    notifyListeners();
  }

  bool _payType = false;
  bool get payType => _payType;
  set payType(bool payType) {
    _payType = payType;
    notifyListeners();
  }

  SettlementDetailsUserInfoModel _userInfoModel = SettlementDetailsUserInfoModel();
  SettlementDetailsUserInfoModel get userInfoModel => _userInfoModel;
  set userInfoModel(SettlementDetailsUserInfoModel userInfoModel) {
    _userInfoModel = userInfoModel;
    notifyListeners();
  }

  List _setMealList = [];
  List get setMealList => _setMealList;
  set setMealList(List setMealList) {
    _setMealList = setMealList;
    notifyListeners();
  }

  List _cardSelectList = [];
  List get cardSelectList => _cardSelectList;
  set cardSelectList(List cardSelectList) {
    _cardSelectList = cardSelectList;
    notifyListeners();
  }

  ///消费金额
  double consumeAmount = 0.0;

  ///预付金额
  double prepaymentAmount = 0.0;

  ///尾款金额
  double repairAmount = 0.0;

  ///固定尾款金额
  double fixedRepairAmount = 0.0;

  ///优惠券金额
  double disCountAmount = 0.0;

  ///优惠金额
  double realDiscountAmount = 0.0;

  ///实收金额
  double allAmount = 0.0;

  ///优惠价数量
  int couponCount = 0;


  Stream getSettlementDetailsService(String orderId) {
    var query = {
      'workOrderId': orderId,
    };
    return _repo.getSettlementDetailsService(query: query)
        .doOnData((result) {
          Map res = convert.jsonDecode(result.toString());
          List serviceList = res['data'];
          List serviceAllList = [];
          for(int i=0;i< serviceList.length; i++){
            List serviceItemList = [];
            Map serviceData = serviceList[i];
            DCDetailServiceMode serviceMode = DCDetailServiceMode(serviceData['secondaryService'].toString(), '/','¥'+ serviceData['price'].toString(), serviceData['num'].toString(), '¥'+ multiplyTotalPrices(serviceData['num'].toString(), serviceData['price'].toString()), serviceId: serviceData['serviceId'].toString());
            serviceItemList.add([serviceMode.itemMaterial, serviceMode.spce, serviceMode.itemPrice, serviceMode.itemNumber, serviceMode.totalPrices]);
            List materialList = serviceData['materialList'];
            materialList.forEach((materialData) {
              DCDetailServiceMode serviceMode = DCDetailServiceMode.fromJson(materialData);
              serviceItemList.add([serviceMode.itemMaterial, serviceMode.spce, serviceMode.itemPrice, serviceMode.itemNumber, serviceMode.totalPrices, serviceMode.itemModel]);
            });
            serviceAllList.add(serviceItemList);
          }
          this.serviceList = serviceAllList;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }


  Stream getUserCardInfo(String vehicleLicence) {
    var query = {
      'vehicleLicence': vehicleLicence,
    };
    return _repo.getUserCardInfo(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      SettlementDetailsUserInfoModel userInfoModel = SettlementDetailsUserInfoModel.fromJson(res['data']['member']);
      userInfoModel.type = res['data']['type'].toString();
      this.userInfoModel = userInfoModel;

      List setMealData = res['data']['ownList'];
      List setMealTempList = [];
      setMealData.forEach((element) {
        setMealTempList.add([element['campaignName']
          ,element['frequency'].toString()]);
      });
      this.setMealList = setMealTempList;

    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream postAllPrice(String orderId,{List campaignServiceId}){
    var query = {
      'workOrderId': orderId,
      'campaignIds': campaignServiceId,
    };
    return _repo.postSettlementDetailsAmount(query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());


      this.consumeAmount = double.parse(res['data']['consumeAmount'].toString());
      this.prepaymentAmount = double.parse(res['data']['prepaymentAmount'].toString());
      this.disCountAmount = double.parse(res['data']['disCountAmount'].toString());
      this.couponCount = int.parse(res['data']['couponCount'].toString());
      this.repairAmount = this.consumeAmount-this.prepaymentAmount-disCountAmount;
      this.fixedRepairAmount = this.consumeAmount-this.prepaymentAmount-disCountAmount;
      this.realDiscountAmount = disCountAmount + this.consumeAmount-this.prepaymentAmount-disCountAmount - this.repairAmount;
      this.allAmount = this.prepaymentAmount+this.repairAmount;
      notifyListeners();
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  changeRepairAmount(double newAmount, double differenceAmount){
    this.repairAmount = newAmount;
    this.realDiscountAmount += differenceAmount;
    this.allAmount = this.prepaymentAmount+this.repairAmount;
    notifyListeners();
  }

  Stream payment(bool type, String orderId){
    var request = {
      'discountPrices':this.realDiscountAmount,
      'finalPayment':this.repairAmount,
      "orderIds": [orderId],
      "payMethod": this.payType?'BALANCEPAY':'OFFLINE',/// "BALANCEPAY" // 支付方式[OFFLINE,BALANCEPAY]}
      "type": type ///(true:结算 false:挂账)
    };
    return _repo.postPayment(request).doOnData((result) {
      print('拿到回调！');
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

}