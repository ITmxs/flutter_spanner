import 'package:flutter/material.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/share_red/model/share_red_model.dart';

class ShareRedProvide extends BaseProvide {

  final ShareRedPageRepo _repo = ShareRedPageRepo();

  List _serviceModelList = [];
  List get serviceModelList => _serviceModelList;
  set serviceModelList(List serviceModelList) {
    _serviceModelList = serviceModelList;
    notifyListeners();
  }

  List _textControllerList = [];
  List get textControllerList => _textControllerList;
  set textControllerList(List value) {
    _textControllerList = value;
  }

  List serviceTextEditingControllerList = [];

  Stream getShareRedList(String workOrderId){
    var query = {
      'workOrderId': workOrderId,
    };
    return _repo.getShareRedList(query: query)
        .doOnData((result) {
          Map res = convert.jsonDecode(result.toString());
          List serviceList = res['data'];
          List tempList = [];
          serviceList.forEach((element) {
            ShareRedServiceModel serviceModel = ShareRedServiceModel.fromJson(element);
            serviceModel.setMaterialList();
            tempList.add(serviceModel);

            TextEditingController textEditingController = TextEditingController();
            this.serviceTextEditingControllerList.add(textEditingController);
          });
          this.serviceModelList = tempList;

    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream postShareRedList(List data){
    return _repo.postShareRedList(data).doOnData((result) {
      var res = convert.jsonDecode(result.toString()); //转json
    }).doOnError((e, stacktrace) {
    }).doOnListen(() {
    }).doOnDone(() {
    });
  }

}