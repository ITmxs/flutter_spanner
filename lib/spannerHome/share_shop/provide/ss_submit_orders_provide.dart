import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/share_shop/model/ss_submit_orders_model.dart';

class SSSubmitOrdersProvide extends BaseProvide {

  final ShareShopPageRepo _repo = ShareShopPageRepo();

  SSSubmitOrdersModel _submitOrdersModel = SSSubmitOrdersModel();
  SSSubmitOrdersModel get submitOrdersModel => _submitOrdersModel;
  set submitOrdersModel(SSSubmitOrdersModel value) {
    _submitOrdersModel = value;
    notifyListeners();
  }

  Stream postSubmitOrder({String count, String price, String remarks, String shopGoodsId, String equipmentId, String type,}){
    var query = {
      "count": count,
      "price": price,
      "remarks": remarks,
      "shopGoodsId": shopGoodsId,
      'equipmentId':equipmentId,
      "type": type
    };
    return _repo.postSubmitOrder(query)
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