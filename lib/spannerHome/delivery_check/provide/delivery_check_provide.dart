import 'package:spanners/base/base_provide.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/delivery_check/model/dc_list_model.dart';

class DeliveryCheckProvide extends BaseProvide {

  final DeliveryCheckRepo _repo = DeliveryCheckRepo();

  List<bool> _hideCellList = [];

  List<bool> get hideCellList => _hideCellList;

  set hideCellList(List<bool> hideCellList) {
    _hideCellList = hideCellList;
    notifyListeners();
  }

  List<DCListModel> _modelList = [];

  List<DCListModel> get modelList => _modelList;

  set modelList(List<DCListModel> modelList) {
    _modelList = modelList;
    notifyListeners();
  }

  Stream getList() {

    this.hideCellList.clear();
    this.modelList.clear();

    Map<String, dynamic> dataMap = convert.jsonDecode(SynchronizePreferences.Get('mapUseridShopid'));
    String userId = SynchronizePreferences.Get('userid');
    var query = {
      'shopId': dataMap[userId],
    };
    return _repo
        .getDeliveryCheckList(query: query)
        .doOnData((result) {
          Map res = convert.jsonDecode(result.toString());
          List data = res['data'];
          List<DCListModel> tempModelList = [];
          for (int i = 0; i < data.length; i++) {
            DCListModel model = DCListModel.fromJson(data[i]);
            model.setItemListMode(data[i]);
            tempModelList.add(model);
            this.hideCellList.add(false);
          }
          this.modelList = tempModelList;

          notifyListeners();
        })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream refuseBecauseRequest(var query) {
    return _repo
        .postRefuseBecauseRequest(query)
        .doOnData((result) {
          print('拿到回调！！！！');
          print(result);
          notifyListeners();
        })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }
}
