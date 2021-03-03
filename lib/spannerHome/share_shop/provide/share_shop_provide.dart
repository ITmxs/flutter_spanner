import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/share_shop/model/share_shop_model.dart';

class ShareShopProvide extends BaseProvide {

  final ShareShopPageRepo _repo = ShareShopPageRepo();

  List _countList = [];
  List get countList => _countList;
  set countList(List value) {
    _countList = value;
    notifyListeners();
  }

  ///0:商品,1:工具,2:二手配件,3:服务  sort [desc:降序,asc:升序]
  Stream getShareShopQueryList(String distinguish, {String properties = '', String sort = '', String searchKey = ''}) {
    var query = {
      'distinguish': distinguish,
      'properties':properties,
      'sort':sort,
      'searchKey':searchKey,
    };
    return _repo
        .getShareShopPageList(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      List resList = res['data'];
      List tempList = [];
      resList.forEach((element) {
        ShareShopModel model = ShareShopModel.fromJson(element);
        tempList.add(model);
        this.countList = tempList;
      });
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

}