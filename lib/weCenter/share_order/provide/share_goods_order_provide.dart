import 'package:flutter/material.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/weCenter/share_order/model/share_goods_order_model.dart';

class ShareGoodsOrderProvide extends BaseProvide {

  final ShareOrderRepo _repo = ShareOrderRepo();

  ///待收取货:2 已取货:3 待发货:1
  String _tradeStatus = '2';
  String get tradeStatus => _tradeStatus;
  set tradeStatus(String value) {
    _tradeStatus = value;
    notifyListeners();
  }

  List _countList = [];
  List get countList => _countList;
  set countList(List value) {
    _countList = value;
    notifyListeners();
  }

  ///获取列表
  Stream getOrderList({String distinguish, String tradeStatus, String tradeType}) {
    var query = {
      'distinguish' : distinguish,
      'tradeStatus' : tradeStatus,
      'tradeType' : tradeType,
    };
    return _repo
        .getOrderList(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      List dataList = res['data'];
      List tempList = [];
      dataList.forEach((element) {
        ShareGoodsOrderModel model = ShareGoodsOrderModel.fromJson(element);
        tempList.add(model);
      });
      this.countList = tempList;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  final StoreOrderRepo _otherRepo = StoreOrderRepo();

  Stream postConfirm(String mallOrderId){
    var query = {
      'mallOrderId': mallOrderId,
    };
    return _otherRepo.postConfirm(query).doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      print(res);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

}