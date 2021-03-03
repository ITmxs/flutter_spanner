import 'package:flutter/material.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/weCenter/store_order_page/model/store_order_details_model.dart';
import 'dart:convert' as convert;

import 'package:spanners/weCenter/store_order_page/model/store_order_model.dart';

class StoreOrderDetailsProvide extends BaseProvide {

  final StoreOrderRepo _repo = StoreOrderRepo();

  StoreOrderDetailsModel _detailsOrderModel = StoreOrderDetailsModel();
  StoreOrderDetailsModel get detailsOrderModel => _detailsOrderModel;
  set detailsOrderModel(StoreOrderDetailsModel value) {
    _detailsOrderModel = value;
    notifyListeners();
  }

  Stream getStoreOrderList({String tradeId}) {
    var query = {
      'tradeId': tradeId,
    };
    return _repo
        .getStoreOrderDetails(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      StoreOrderDetailsModel model = StoreOrderDetailsModel.fromJson(res['data']);
      this.detailsOrderModel = model;
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