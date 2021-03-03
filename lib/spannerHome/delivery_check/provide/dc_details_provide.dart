import 'package:spanners/base/base_provide.dart';
import 'package:spanners/cTools/public_function.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/delivery_check/model/dc_details_model.dart';

class DCDetailsProvide extends BaseProvide {

  final DeliveryCheckRepo _repo = DeliveryCheckRepo();

  List _userInfoTitle = ['车牌号', '车辆品牌', '车辆型号', '车主姓名', '手机号', 'VIN码', '车辆颜色', '发动机型号'];
  List get userInfoTitle => _userInfoTitle;

  List _otherUserInfoTitle = ['行驶里程', '送修人姓名', '油表数', '接车员姓名'];
  List get otherUserInfoTitle => _otherUserInfoTitle;

  List _serviceTitle = ['名称', '规格', '单价', '数量', '总价'];
  List get serviceTitle => _serviceTitle;

  List _carImages = [];
  List get carImages => _carImages;
  set carImages(List carImages) {
    _carImages = carImages;
    notifyListeners();
  }

  bool _showAllInfo = false;
  get showAllInfo => _showAllInfo;
  set showAllInfo(bool showAllInfo) {
    _showAllInfo = showAllInfo;
    notifyListeners();
  }

  List _userInfoContent = [];
  List get userInfoContent =>_userInfoContent;
  set userInfoContent(List userInfoContent) {
    _userInfoContent = userInfoContent;
    notifyListeners();
  }

  List _otherUserInfoContent = [];
  List get otherUserInfoContent => _otherUserInfoContent;
  set otherUserInfoContent(List otherUserInfoContent) {
    _otherUserInfoContent = otherUserInfoContent;
    notifyListeners();
  }

  String _remark = '';
  String get remark => _remark;
  set remark(String remark){
    _remark = remark;
    notifyListeners();
  }

  List _serviceList = [];
  List get serviceList => _serviceList;
  set serviceList(List serviceList) {
    _serviceList = serviceList;
    notifyListeners();
  }

  bool _memberFlag = false;
  bool get memberFlag => _memberFlag;
  set memberFlag(bool value) {
    _memberFlag = value;
    notifyListeners();
  }

  ///消费金额
  String _consumeAmount = '0';
  String get consumeAmount => _consumeAmount;
  set consumeAmount(String consumeAmount){
    _consumeAmount = consumeAmount;
    print(consumeAmount);
    notifyListeners();
  }

  ///预付金额
  String _prepaymentAmount = '0';
  String get prepaymentAmount => _prepaymentAmount;
  set prepaymentAmount(String prepaymentAmount){
    _prepaymentAmount = prepaymentAmount;
    print(prepaymentAmount);
    notifyListeners();
  }

  ///尾款金额
  String _finalPayment = '0';
  String get finalPayment => _finalPayment;
  set finalPayment(String finalPayment){
    _finalPayment = finalPayment;
    print(finalPayment);
    notifyListeners();
  }

  bool _showShareRed = false;
  bool get showShareRed => _showShareRed;
  set showShareRed(bool value) {
    _showShareRed = value;
    notifyListeners();
  }

  ///优惠卡数组
  List _campaignInfoList = [];
  List get campaignInfoList => _campaignInfoList;
  set campaignInfoList(List value) {
    _campaignInfoList = value;
    notifyListeners();
  }

  ///优惠卡优惠金额
  String _campaignString = '0';
  String get campaignString => _campaignString;
  set campaignString(String value) {
    _campaignString = value;
    notifyListeners();
  }

  Stream getDeliveryDetails(String workOrderId) {

    var query = {
      'workOrderId': workOrderId,
    };
    print(query);
    return _repo.getDeliveryDetails(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      Map data = res['data'];
      _setupData(data);

    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream getCampaignInfo(String workOrderId) {

    var query = {
      'workOrderId': workOrderId,
    };
    print(query);
    return _repo.getCampaignInfo(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      this.campaignInfoList = res['data'];
      double allParse = 0.0;
      this.campaignInfoList.forEach((element) {
        String price = element['price'].toString();
        allParse += double.parse(price);
      });
      this.campaignString = allParse.toString();

    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  _setupData(Map data) {

    this.finalPayment = data['finalPayment'].toString();
    this.memberFlag = data['memberFlag'];
    Map receiveCarVO = data['receiveCarVO'];
    DCDetailMode model = DCDetailMode.fromJson(receiveCarVO);
    List userInfoContent = [model.vehicleLicence, model.brand, model.model, model.vehicleOwners, model.customerMobile, model.carVin, model.carColor, model.carEngine];
    List otherUserInfoContent = [model.roadHaulString, model.sendUser, model.oilMeters, model.requester];
    this.userInfoContent = userInfoContent;
    this.otherUserInfoContent = otherUserInfoContent;
    this.carImages = model.imgList;
    this.remark = model.remark;


    List serviceList = data['serviceEntities'];

    List serviceAllList = [];
    for(int i=0;i< serviceList.length; i++){
      List serviceItemList = [];
      Map serviceData = serviceList[i];
      DCDetailServiceMode serviceMode = DCDetailServiceMode(serviceData['secondaryService'].toString(), '/','¥'+ serviceData['price'].toString(), serviceData['num'].toString(), '¥'+ multiplyTotalPrices(serviceData['num'].toString(), serviceData['price'].toString()));
      serviceItemList.add([serviceMode.itemMaterial, serviceMode.spce, serviceMode.itemPrice, serviceMode.itemNumber, serviceMode.totalPrices]);
      List materialList = serviceData['receiveCarMaterialList'];
      materialList.forEach((materialData) {
        DCDetailServiceMode serviceMode = DCDetailServiceMode.fromJson(materialData);
        serviceItemList.add([serviceMode.itemMaterial, serviceMode.spce, serviceMode.itemPrice, serviceMode.itemNumber, serviceMode.totalPrices, serviceMode.itemModel]);
      });
      serviceAllList.add(serviceItemList);
    }
    this.serviceList = serviceAllList;

    this.consumeAmount = data['consumeAmount'].toString();
    this.prepaymentAmount = data['prepaymentAmount'].toString();

  }

}