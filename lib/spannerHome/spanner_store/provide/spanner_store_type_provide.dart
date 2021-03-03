import 'package:flutter/material.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/spanner_store/model/spanner_store_type_model.dart';

class SpannerStoreTypeProvide extends BaseProvide {

  final SpannerStoreRepo _repo = SpannerStoreRepo();

  List _contentList = [];
  List get contentList => _contentList;
  set contentList(List value) {
    _contentList = value;
    notifyListeners();
  }

  ///列表
  Stream getGoodsList({String id, String searchKey = ''}) {

    var query = {
      'firstCategoryId': id,
      'searchKey':searchKey
    };

    return _repo
        .getGoodsList(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      List resList = res['data'];
      print(res);
      List tempList = [];
      resList.forEach((element) {
        SpannerStoreTypeListModel model = SpannerStoreTypeListModel.fromJson(element);
        tempList.add(model);
      });
      this.contentList = tempList;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }
}