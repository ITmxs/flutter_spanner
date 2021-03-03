import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/share_shop/model/ss_other_details_model.dart';

class SSOtherDetailsProvide extends BaseProvide {

  final ShareShopPageRepo _repo = ShareShopPageRepo();


  ShareShopOtherDetailsModel _detailsModel = ShareShopOtherDetailsModel();
  ShareShopOtherDetailsModel get detailsModel => _detailsModel;
  set detailsModel(ShareShopOtherDetailsModel value) {
    _detailsModel = value;
    notifyListeners();
  }

  bool _showShopInfo = false;
  bool get showShopInfo => _showShopInfo;
  set showShopInfo(bool value) {
    _showShopInfo = value;
    notifyListeners();
  }


  Stream getShareShopOtherDetails(String equipmentId) {
    var query = {
      'equipmentId':equipmentId,
    };
    return _repo
        .getShareShopOtherDetails(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      Map resMap = res['data'];
      ShareShopOtherDetailsModel model = ShareShopOtherDetailsModel.fromJson(resMap);
      this.detailsModel = model;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

}