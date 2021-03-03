import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/share_shop/model/ss_goods_details_model.dart';

class SSGoodsDetailsProvide extends BaseProvide {

  final ShareShopPageRepo _repo = ShareShopPageRepo();


  ShareShopDetailsModel _detailsModel = ShareShopDetailsModel();
  ShareShopDetailsModel get detailsModel => _detailsModel;
  set detailsModel(ShareShopDetailsModel value) {
    _detailsModel = value;
    notifyListeners();
  }

  ShareShopDetailsSpecModel _specModel = ShareShopDetailsSpecModel();
  ShareShopDetailsSpecModel get specModel => _specModel;
  set specModel(ShareShopDetailsSpecModel value) {
    _specModel = value;
    notifyListeners();
  }

  bool _showShopInfo = false;
  bool get showShopInfo => _showShopInfo;
  set showShopInfo(bool value) {
    _showShopInfo = value;
    notifyListeners();
  }

  int _buyNumber = 1;
  int get buyNumber => _buyNumber;
  set buyNumber(int value) {
    _buyNumber = value;
    notifyListeners();
  }

  Stream getShareShopGoodsDetails(String shareGoodsId) {
    var query = {
      'shareGoodsId':shareGoodsId,
    };
    return _repo
        .getShareShopGoodsDetails(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      Map resMap = res['data'];
      ShareShopDetailsModel model = ShareShopDetailsModel.fromJson(resMap);
      this.detailsModel = model;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream getShareShopGoodsSpec() {
    var query = {
      'goodsName':this.detailsModel.goodsName,
      'shopId':this.detailsModel.shopId,
    };
    return _repo
        .getShareShopGoodsSpec(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      Map resMap = res['data'];
      ShareShopDetailsSpecModel model = ShareShopDetailsSpecModel.fromJson(resMap);
      this.specModel = model;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

}