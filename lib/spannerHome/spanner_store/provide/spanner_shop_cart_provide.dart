import 'package:bot_toast/bot_toast.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/spanner_store/model/spanner_order_details_model.dart';
import 'package:spanners/spannerHome/spanner_store/model/spanner_shop_cart_model.dart';

class SpannerShopCartProvide extends BaseProvide {

  final SpannerStoreRepo _repo = SpannerStoreRepo();


  bool _management = false;
  bool get management => _management;
  set management(bool value) {
    _management = value;
    notifyListeners();
  }

  List _goodsList = [];
  List get goodsList => _goodsList;
  set goodsList(List value) {
    _goodsList = value;
    notifyListeners();
  }

  List _selectItem = [];
  List get selectItem => _selectItem;
  set selectItem(List value) {
    _selectItem = value;
    notifyListeners();
  }

  bool _allSelectItem = false;
  bool get allSelectItem => _allSelectItem;
  set allSelectItem(bool value) {
    _allSelectItem = value;
    List tempList = [];
      this.selectItem.forEach((element) {
        tempList.add(value);
      });
      this.selectItem = tempList;
    notifyListeners();
  }

  String _allPrice = '0.0';
  String get allPrice => _allPrice;
  set allPrice(String value) {
    _allPrice = value;
    notifyListeners();
  }

  int selectNumber = 0;

  Stream getShopCartInfo(){

    return _repo.getShopCartInfo()
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      List data = res['data'];
      List tempList = [];
      data.forEach((element) {
        SpannerShopCartModel cartModel = SpannerShopCartModel.fromJson(element);
        tempList.add(cartModel);
        selectItem.add(false);
      });
      this.goodsList = tempList;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }


  Stream postChangeCount({String count, String cartId, String shopGoodsId,}){
    var query = {
      "cartId": cartId,
      "count": count,
      "shopGoodsId": shopGoodsId,
    };
    return _repo.postChangeCount(query)
        .doOnData((result) {
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }


  Stream postAllDelete({List cartIds}){
    var query = {
      "cartIds": cartIds,
    };
    return _repo.postAllDelete(query)
        .doOnData((result) {
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }


}