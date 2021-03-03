
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/inventory_manager/model/inventory_location_model.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

class InventoryLocationProvide extends BaseProvide {

  final InventoryManageRepo _repo = InventoryManageRepo();

  List _locationList = List();
  List get locationList => _locationList;
  set locationList(List value) {
    _locationList = value;
    notifyListeners();
  }

  Stream getInventoryLocationList({String searchKey = ''}){
    var query = {
      'searchKey': searchKey,
    };
    return _repo.getInventoryLocationList(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      List data = res['data'];
      List tempList = [];
      data.forEach((element) {
        InventoryLocationModel model = InventoryLocationModel.fromJson(element);
        tempList.add(model);
      });
      this.locationList = tempList;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

}