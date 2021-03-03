import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/settlement/model/settlement_all_model.dart';

class SettlementAllProvide extends BaseProvide {

  final SettlementPageRepo _repo = SettlementPageRepo();

  bool _payType = false;
  bool get payType => _payType;
  set payType(bool payType) {
    _payType = payType;
    notifyListeners();
  }

  SettlementAllModel _allModel = SettlementAllModel();

  SettlementAllModel get allModel => _allModel;
  set allModel(SettlementAllModel value) {
    _allModel = value;
    notifyListeners();
  }

  Stream postAllSettlementDetails(List orderIdList){
    var request = {
      'orderIds':orderIdList,
      'shopId':'',
    };
    return _repo.postAllSettlementDetails(request).doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      print(res['data']);
      SettlementAllModel allModel = SettlementAllModel.fromJson(res['data']);
      this.allModel = allModel;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream postAllPayment(bool type, List orderIdList){
    var request = {
      'finalPayment':this.allModel.totalAmount,
      "orderIds": orderIdList,
      "payMethod": this.payType?'BALANCEPAY':'OFFLINE',/// "BALANCEPAY" // 支付方式[OFFLINE,BALANCEPAY]}
    };
    return _repo.postAllPayment(request).doOnData((result) {
      print('拿到回调！');
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

}