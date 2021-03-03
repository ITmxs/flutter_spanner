import 'package:flutter/material.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/weCenter/share_order/model/share_order_model.dart';

class ShareOrderProvide extends BaseProvide {


  final ShareOrderRepo _repo = ShareOrderRepo();

  ShareOrderModel _countModel = ShareOrderModel();
  ShareOrderModel get countModel => _countModel;
  set countModel(ShareOrderModel value) {
    _countModel = value;
    notifyListeners();
  }

  ///获取列表
  Stream getOrderCount() {
    return _repo
        .getOrderCount()
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      Map dataMap = res['data'];
      Map shareGoodsMap = dataMap['shareGoods'];
      Map shareEquipmentMap = dataMap['shareEquipment'];
      Map secondGoodsMap = dataMap['secondGoods'];
      ShareOrderModel model = ShareOrderModel(shareGoodsWaitReceive: shareGoodsMap['waitReceive'], shareEquipmentWaitReceive: shareEquipmentMap['waitReceive'], shareEquipmentWaitReturn: shareEquipmentMap['waitReturn'], secondGoodsWaitReceive: secondGoodsMap['waitReceive']);
      this.countModel = model;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

}