import 'package:flutter/material.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/weCenter/share_order/model/share_order_detail_model.dart';
import 'package:spanners/weCenter/store_order_page/model/store_order_details_model.dart';
import 'dart:convert' as convert;

import 'package:spanners/weCenter/store_order_page/model/store_order_model.dart';

class ShareOrderDetailsProvide extends BaseProvide {

  final StoreOrderRepo _repo = StoreOrderRepo();

  ShareOrderDetailsModel _detailsOrderModel = ShareOrderDetailsModel();
  ShareOrderDetailsModel get detailsOrderModel => _detailsOrderModel;
  set detailsOrderModel(ShareOrderDetailsModel value) {
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
      ShareOrderDetailsModel model = ShareOrderDetailsModel.fromJson(res['data']);
      this.detailsOrderModel = model;
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