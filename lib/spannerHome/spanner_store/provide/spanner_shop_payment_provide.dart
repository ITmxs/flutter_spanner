import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/share_shop/model/ss_other_details_model.dart';

class SpannerShopPaymentProvide extends BaseProvide {

  final SpannerStoreRepo _repo = SpannerStoreRepo();


  int _selectType = -1;
  int get selectType => _selectType;
  set selectType(int value) {
    _selectType = value;
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  bool _showPassword = false;
  bool get showPassword => _showPassword;
  set showPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  // Stream getPasswordStatus() {
  //   return _repo
  //       .getPasswordStatus()
  //       .doOnData((result) {
  //     Map res = convert.jsonDecode(result.toString());
  //     Map resMap = res['data'];
  //     print(res);
  //   })
  //       .doOnError((e, stacktrace) {})
  //       .doOnListen(() {})
  //       .doOnDone(() {});
  // }

  Stream postPaymentOrder({String mallOrderId, String password, String type}){

    var query = {
      "mallOrderId": mallOrderId,
      "password": password,
      "type": type,
    };
    return _repo.postPaymentOrder(query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      var data = res['data'];
      print(res);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream postPaymentOtherOrder({Map result}){

    return _repo.postPaymentOtherOrder(result)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      var data = res['data'];
      print(res);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream getWeChatPaymentInfo({String orderId}){
    var query = {
      "mallOrderId": orderId,
    };
    return _repo.getWeChatPaymentInfo(query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      var data = res['data'];
      print(res);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }


}