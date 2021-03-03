import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/spanner_store/model/spanner_order_details_model.dart';

class SpannerSubmitOrdersProvide extends BaseProvide {

  final SpannerStoreRepo _repo = SpannerStoreRepo();

  List _modelList = [];
  List get modelList => _modelList;
  set modelList(List value) {
    _modelList = value;
    notifyListeners();
  }

  double allPrice = 0.0;

  List textControllerList =[];

  Stream postSubmitSpannerShopOrder({List goodsList, String price}){
    var query = {
      "goodsList": goodsList,
      "price": price,
    };
    return _repo.postSubmitSpannerShopOrder(query)
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