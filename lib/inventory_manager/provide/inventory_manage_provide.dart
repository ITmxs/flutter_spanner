import 'package:spanners/base/base_provide.dart';
import 'package:spanners/inventory_manager/model/inventory_manage_model.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

class InventoryManageProvide extends BaseProvide {

  final InventoryManageRepo _repo = InventoryManageRepo();

  List _inventoryManageList = List();
  List get inventoryManageList => _inventoryManageList;
  set inventoryManageList(List value) {
    _inventoryManageList = value;
    notifyListeners();
  }

  int _showInventoryType = 0;
  int get showInventoryType => _showInventoryType;
  set showInventoryType(int value) {
    _showInventoryType = value;
    notifyListeners();
  }

  bool _hideSelectType = false;
  bool get hideSelectType => _hideSelectType;
  set hideSelectType(bool value) {
    _hideSelectType = value;
    notifyListeners();
  }

  List inventoryTypeList = ['全部库存', '预警库存'];
  List shareGoodsTypeList = ['全部状态', '共享商品', '非共享商品'];

  List _inventoryCountList = [];
  List get inventoryCountList => _inventoryCountList;
  set inventoryCountList(List value) {
    _inventoryCountList = value;
    notifyListeners();
  }


  Stream getInventoryManageContentList(distinguish, {String stockDistinguish = '0', String categoryId = '0', String shareType = '0', String searchKey = ''}) {
    var query = {
      'distinguish':distinguish,
      'stockDistinguish':stockDistinguish,
      'categoryId':categoryId,
      'shareType':shareType,
      'searchKey':searchKey
    };
    return _repo.getInventoryManageContentList(query: query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      List dataList = res['data'];
      List tempList = List();
      dataList.forEach((element) {
        InventoryManageContentListModel model = InventoryManageContentListModel.fromJson(element);
        tempList.add(model);
      });
      this.inventoryCountList = tempList;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }


}
