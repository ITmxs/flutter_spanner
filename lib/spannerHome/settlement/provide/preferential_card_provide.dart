import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/settlement/model/preferential_card_model.dart';

class PreferentialCardProvide extends BaseProvide {

  final PreferentialCardPageRepo _repo = PreferentialCardPageRepo();

  List _selectList = List();
  List get selectList => _selectList;
  set selectList(List value) {
    _selectList = value;
    notifyListeners();
  }

  List _pCardModelList = List();
  List get pCardModelList => _pCardModelList;
  set pCardModelList(List value) {
    _pCardModelList = value;
    notifyListeners();
  }

  Stream getCouponList(String workOrderId, List selectCardList) {

    var query = {
      'workOrderId': workOrderId,
    };
    return _repo.getCouponList(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      List resList = res['data'];
      List cardTemp = [];
      resList.forEach((element) {
        PreferentialCardModel model = PreferentialCardModel.fromJson(element);
        cardTemp.add(model);
        this.selectList.add(false);
      });

      for(int i=0; i<cardTemp.length;i++) {
        PreferentialCardModel model = cardTemp[i];
        selectCardList.forEach((element) {
          PreferentialCardModel selectModel = element;
          if(model.campaignServiceId == selectModel.campaignServiceId){
            this.selectList[i] = true;
          }
        });
      }

      this.pCardModelList = cardTemp;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  reload(){
    notifyListeners();
  }
}