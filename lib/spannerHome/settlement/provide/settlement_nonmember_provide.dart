import 'package:spanners/base/base_provide.dart';
import 'package:spanners/cTools/public_function.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/delivery_check/model/dc_details_model.dart';

class SettlementNonmemberProvide extends BaseProvide {
  final DeliveryCheckRepo _repo = DeliveryCheckRepo();

  List _userInfoTitle = [
    '车牌号',
    '车辆品牌',
    '车辆型号',
    '车主姓名',
    '手机号',
    'VIN码',
    '车辆颜色',
    '发动机型号'
  ];

  List get userInfoTitle => _userInfoTitle;

  List _otherUserInfoTitle = ['行驶里程', '送修人姓名', '油表数', '接车员姓名'];
  List get otherUserInfoTitle => _otherUserInfoTitle;

  List _otherUserInfoContent = [];
  List get otherUserInfoContent => _otherUserInfoContent;
  set otherUserInfoContent(List otherUserInfoContent) {
    _otherUserInfoContent = otherUserInfoContent;
    notifyListeners();
  }

  List _carImages = [];
  List get carImages => _carImages;
  set carImages(List carImages) {
    _carImages = carImages;
    notifyListeners();
  }

  String _remark = '';
  String get remark => _remark;
  set remark(String remark) {
    _remark = remark;
    notifyListeners();
  }

  bool _showAllInfo = false;
  get showAllInfo => _showAllInfo;
  set showAllInfo(bool showAllInfo) {
    _showAllInfo = showAllInfo;
    notifyListeners();
  }

  List serviceIdList = [];

  Stream getDeliveryDetails(String workOrderId) {
    var query = {
      'workOrderId': workOrderId,
    };
    print(query);
    return _repo
        .getDeliveryDetails(query: query)
        .doOnData((result) {
          Map res = convert.jsonDecode(result.toString());
          Map data = res['data'];
          _setupData(data);
        })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  _setupData(Map data) {
    Map receiveCarVO = data['receiveCarVO'];
    DCDetailMode model = DCDetailMode.fromJson(receiveCarVO);
    List userInfoContent = [
      model.vehicleLicence,
      model.brand,
      model.model,
      model.vehicleOwners,
      model.customerMobile,
      model.carVin,
      model.carColor,
      model.carEngine
    ];
    List otherUserInfoContent = [
      model.roadHaulString,
      model.sendUser,
      model.model,
      model.oilMeters,
      model.requester
    ];
    this.userInfoContent = userInfoContent;
    this.otherUserInfoContent = otherUserInfoContent;
    this.carImages = model.imgList;
    this.remark = model.remark;
  }

  List _serviceTitle = ['名称', '规格', '单价', '数量', '总价'];
  List get serviceTitle => _serviceTitle;

  List _userInfoContent = [];
  List get userInfoContent => _userInfoContent;
  set userInfoContent(List userInfoContent) {
    _userInfoContent = userInfoContent;
    notifyListeners();
  }

  List _serviceList = [];
  List get serviceList => _serviceList;
  set serviceList(List serviceList) {
    _serviceList = serviceList;
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

  final SettlementPageRepo _settlementRepo = SettlementPageRepo();

  Stream getSettlementDetailsService(String orderId) {
    var query = {
      'workOrderId': orderId,
    };
    return _settlementRepo
        .getSettlementDetailsService(query: query)
        .doOnData((result) {
          Map res = convert.jsonDecode(result.toString());
          List serviceList = res['data'];
          List serviceAllList = [];
          for (int i = 0; i < serviceList.length; i++) {
            List serviceItemList = [];
            Map serviceData = serviceList[i];
            DCDetailServiceMode serviceMode = DCDetailServiceMode(
                serviceData['secondaryService'].toString(),
                '/',
                '¥' + serviceData['price'].toString(),
                serviceData['num'].toString(),
                '¥' +
                    multiplyTotalPrices(serviceData['num'].toString(),
                        serviceData['price'].toString()),
                serviceId: serviceData['serviceId'].toString());
            serviceItemList.add([
              serviceMode.itemMaterial,
              serviceMode.spce,
              serviceMode.itemPrice,
              serviceMode.itemNumber,
              serviceMode.totalPrices
            ]);
            this.serviceIdList.add(serviceMode.serviceId);
            List materialList = serviceData['materialList'];
            materialList.forEach((materialData) {
              DCDetailServiceMode serviceMode =
                  DCDetailServiceMode.fromJson(materialData);
              serviceItemList.add([
                serviceMode.itemMaterial,
                serviceMode.spce,
                serviceMode.itemPrice,
                serviceMode.itemNumber,
                serviceMode.totalPrices,
                serviceMode.itemModel
              ]);
            });
            serviceAllList.add(serviceItemList);
          }
          this.serviceList = serviceAllList;
        })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream getAllPrice(String orderId, List serviceIds) {
    String serviceIdString = '';
    serviceIds.forEach((element) {
      serviceIdString = serviceIdString + element + ',';
    });
    var query = {'workOrderId': orderId, 'serviceIds': serviceIdString};
    return _settlementRepo
        .postSettlementDetailsAmount(query)
        .doOnData((result) {
          Map res = convert.jsonDecode(result.toString());

          this.consumeAmount =
              double.parse(res['data']['consumeAmount'].toString());
          this.prepaymentAmount =
              double.parse(res['data']['prepaymentAmount'].toString());
          this.disCountAmount =
              double.parse(res['data']['disCountAmount'].toString());
          this.repairAmount =
              this.consumeAmount - this.prepaymentAmount - disCountAmount;
          this.fixedRepairAmount =
              this.consumeAmount - this.prepaymentAmount - disCountAmount;
          this.realDiscountAmount = disCountAmount +
              this.consumeAmount -
              this.prepaymentAmount -
              disCountAmount -
              this.repairAmount;
          this.allAmount = this.prepaymentAmount + this.repairAmount;
          notifyListeners();
        })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  changeRepairAmount(double newAmount, double differenceAmount) {
    this.repairAmount = newAmount;
    this.realDiscountAmount += differenceAmount;
    this.allAmount = this.prepaymentAmount + this.repairAmount;
    notifyListeners();
  }

  Stream payment(bool type, String orderId) {
    var request = {
      'discountPrices': this.realDiscountAmount,
      'finalPayment': this.repairAmount,
      "orderIds": [orderId],
      "payMethod": 'OFFLINE',
      "type": type

      ///(true:结算 false:挂账)
    };
    return _settlementRepo
        .postPayment(request)
        .doOnData((result) {
          print('拿到回调！');
        })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }
}
