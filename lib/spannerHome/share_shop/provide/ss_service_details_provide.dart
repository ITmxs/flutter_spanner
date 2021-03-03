import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/share_shop/model/ss_service_details_model.dart';

class SSServiceDetailsProvide extends BaseProvide {

  final ShareShopPageRepo _repo = ShareShopPageRepo();

  ShareShopServiceModel _serviceModel = ShareShopServiceModel();
  ShareShopServiceModel get serviceModel => _serviceModel;
  set serviceModel(ShareShopServiceModel value) {
    _serviceModel = value;
    notifyListeners();
  }

  Stream getShareShopServiceDetails(String id) {
    var query = {
      'id':id,
    };
    return _repo
        .getShareShopServiceDetails(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      Map resMap = res['data'];
      ShareShopServiceModel model = ShareShopServiceModel.fromJson(resMap);
      this.serviceModel = model;
      print(res);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }


}