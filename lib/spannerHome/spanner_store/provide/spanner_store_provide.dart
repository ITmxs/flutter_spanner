import 'package:flutter/material.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/spanner_store/model/spanner_store_model.dart';

class SpannerStoreProvide extends BaseProvide {

  final SpannerStoreRepo _repo = SpannerStoreRepo();

  var _bannerHeight = 160.0;
  get bannerHeight => _bannerHeight;

  var _sHeight = 0.0;
  get sHeight => _sHeight;
  set sHeight(value) {
    _sHeight = value;
  }

  var _typeItemWidth = 120.0;
  get typeItemWidth => _typeItemWidth;

  var _listViewHeight = 0.0;
  get listViewHeight => _listViewHeight;
  set listViewHeight(value) {
    _listViewHeight = value;
  }

  List _typeList = [];
  List get typeList => _typeList;
  set typeList(List value) {
    _typeList = value;
    notifyListeners();
  }

  List _contentList = [];
  List get contentList => _contentList;
  set contentList(List value) {
    _contentList = value;
    notifyListeners();
    print(_contentList);
  }

  int _selectType = 0;
  int get selectType => _selectType;
  set selectType(int value) {
    _selectType = value;
    notifyListeners();
  }


  ///获取列表
  Stream getTypeList() {
    return _repo
        .getTypeList()
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      List resList = res['data'];
      List tempList = [];
      resList.forEach((element) {
        SpannerStoreTypeModel model = SpannerStoreTypeModel.fromJson(element);
        tempList.add(model);
      });
      this.typeList = tempList;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  ///内容
  Stream getContentList({String id}) {

    var query = {
      'firstCategoryId': id,
    };

    return _repo
        .getContentList(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      List resList = res['data'];
      List tempList = [];
      resList.forEach((element) {
        SpannerStoreContentModel model = SpannerStoreContentModel.fromJson(element);
        tempList.add(model);
      });
      this.contentList = tempList;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }


}