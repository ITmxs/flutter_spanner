
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/inventory_manager/model/inventory_goods_type_model.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

class InventoryGoodsTypeProvide extends BaseProvide {

  final InventoryManageRepo _repo = InventoryManageRepo();

  List _goodsTypeList = List();
  List get goodsTypeList => _goodsTypeList;
  set goodsTypeList(List value) {
    _goodsTypeList = value;
    notifyListeners();
  }

  Stream getGoodsTypeList({String searchKey = ''}){
    var query = {
      'searchKey': searchKey,
    };
    return _repo.getGoodsTypeList(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      List data = res['data'];
      List tempList = [];
      data.forEach((element) {
        InventoryGoodsTypeModel model = InventoryGoodsTypeModel.fromJson(element);
        tempList.add(model);
      });
      this.goodsTypeList = tempList;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

}