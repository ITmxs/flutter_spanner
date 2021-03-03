import 'package:flutter/material.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/weCenter/store_order_page/model/store_order_model.dart';

class StoreOrderProvide extends BaseProvide {

  final StoreOrderRepo _repo = StoreOrderRepo();

  List _countList = [];
  List get countList => _countList;
  set countList(List value) {
    _countList = value;
    notifyListeners();
  }

  ///'交易状态 0：已下单[待付款] 1：已付款[待发货] 2：待收取货 3：已收取货 4：已退款'
  Stream getStoreOrderList({String status}) {
    var query = {
      'orderStatus': status,
      'size':80,
      'current':1,
    };
    return _repo
        .getStoreOrderList(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      List dataList = res['data']['records'];
      List tempList = [];
      dataList.forEach((element) {
        tempList.add(StoreOrderModel.fromJson(element));
      });
      this.countList = tempList;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream postDeleteOrder(String orderId){
    var query = {
      'orderId': orderId,
    };
    return _repo.postDeleteOrder(query).doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
       print(res);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream postConfirm(String mallOrderId){
    var query = {
      'mallOrderId': mallOrderId,
    };
    return _repo.postConfirm(query).doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      print(res);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream postRemind(String mallOrderId){
    var query = {
      'mallOrderId': mallOrderId,
    };
    return _repo.postRemind(query).doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      print(res);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }


}