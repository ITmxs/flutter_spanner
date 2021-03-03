import 'package:flutter/material.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/weCenter/share_order/model/share_order_model.dart';

class VerifyCodeProvide extends BaseProvide {

  final ShareOrderRepo _repo = ShareOrderRepo();

  ///获取列表
  Stream getCheckPickupCode({String pickupCode, String tradeId}) {

    var query = {
      'pickupCode' : pickupCode,
      'tradeId' : tradeId,
    };
    return _repo
        .getCheckPickupCode(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
     print(res);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

}