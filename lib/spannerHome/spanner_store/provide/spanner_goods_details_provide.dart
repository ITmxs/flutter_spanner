import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/spannerHome/spanner_store/model/spanner_goods_details_model.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/spanner_store/model/spanner_store_type_model.dart';

class SpannerGoodsDetailsProvide extends BaseProvide {

  final SpannerStoreRepo _repo = SpannerStoreRepo();

  SpannerGoodsDetailsModel _detailsModel = SpannerGoodsDetailsModel();
  SpannerGoodsDetailsModel get detailsModel => _detailsModel;
  set detailsModel(SpannerGoodsDetailsModel value) {
    _detailsModel = value;
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

  Map _specMap = {};
  Map get specMap => _specMap;
  set specMap(Map value) {
    _specMap = value;
  }

  Map _optionalMap = {};
  Map get optionalMap => _optionalMap;
  set optionalMap(Map value) {
    _optionalMap = value;
  }

  ///商品详情
  Stream getSpannerGoodsDetails(String shareGoodsId) {
    var query = {
      'shopGoodsId': shareGoodsId,
    };
    return _repo
        .getSpannerGoodsDetails(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      Map resMap = res['data'];
      SpannerGoodsDetailsModel model = SpannerGoodsDetailsModel.fromJson(
          resMap);
      this.detailsModel = model;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  ///规格
  Stream getSpannerGoodsSpec({String shareGoodsId, String goodsName}) {
    var query = {
      'goodsName':goodsName,
    };
    return _repo
        .getSpannerGoodsSpec(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      Map resMap = res['data'];
      this.specMap = resMap;
      _setOptionalMap();
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  ///加入购物车
  Stream postAddStoreCar({String count, String shopGoodsId}){
    var query = {
      "count": count,
      "shopGoodsId": shopGoodsId
    };
    return _repo.postAddStoreCar(query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      var data = res['data'];
      if(data){
        BotToast.showText(text: '加入订货单成功！');
      }else {
        BotToast.showText(text: res['msg']);
      }
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }


  _setOptionalMap(){

    List dataList = this.specMap['data'];

    List modelList = this.specMap['modelList'];
    List modelButtonList = [];
    modelList.forEach((element) {
      Map modelButtonMap = {
        'title':element,
      };
      List tempList = [];
      for (int j = 0; j < dataList.length; j++) {
        Map dataMap = dataList[j];
        String title = dataMap['model'];
        if (title == element) {
          tempList.add(dataMap['spec']);
        }
      }
      modelButtonMap.addAll({'optional':tempList},);
      modelButtonList.add(modelButtonMap);
    });

    List specList = this.specMap['specList'];
    List specButtonList = [];
    specList.forEach((element) {
      Map specButtonMap = {
        'title':element,
      };
      List tempList = [];
      for (int j = 0; j < dataList.length; j++) {
        Map dataMap = dataList[j];
        String title = dataMap['spec'];
        if (title == element) {
          tempList.add(dataMap['model']);
        }
      }
      specButtonMap.addAll({'optional':tempList},);
      specButtonList.add(specButtonMap);
    });

    this.optionalMap.addAll({'model':modelButtonList, 'spec':specButtonList});

  }



}