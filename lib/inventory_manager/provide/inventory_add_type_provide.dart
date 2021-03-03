
import 'package:bot_toast/bot_toast.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
class InventoryAddTypeProvide extends BaseProvide {

  final InventoryManageRepo _repo = InventoryManageRepo();

  Stream postSetGoodsTypeName(String name){
    var query = {
      'name': name,
    };
    return _repo.postSetGoodsTypeName(query)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      var data = res['data'];
      if(data.toString() == '1'){
        BotToast.showText(text: '创建成功');
      }else {
        BotToast.showText(text: data);
      }
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

}