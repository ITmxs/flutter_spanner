import 'package:spanners/base/base_provide.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/settlement/model/settlement_list_model.dart';

class SettlementProvide extends BaseProvide {
  final SettlementPageRepo _repo = SettlementPageRepo();

  List _itemInfoTitle = ['消费金额', '预付金额', '尾款金额', '实收金额', '订单编号', '接车时间'];
  List get itemInfoTitle => _itemInfoTitle;

  List<SettlementListModel> _notSettlementModelList = [];
  List<SettlementListModel> get notSettlementModelList => _notSettlementModelList;
  set notSettlementModelList(List<SettlementListModel> notSettlementModelList) {
    _notSettlementModelList = notSettlementModelList;
    notifyListeners();
  }

  List<SettlementListModel> _yesSettlementModelList = [];
  List<SettlementListModel> get yesSettlementModelList => _yesSettlementModelList;
  set yesSettlementModelList(List<SettlementListModel> yesSettlementModelList) {
    _yesSettlementModelList = yesSettlementModelList;
    notifyListeners();
  }

  List<SettlementListModel> _delaySettlementModelList = [];
  List<SettlementListModel> get delaySettlementModelList => _delaySettlementModelList;
  set delaySettlementModelList(List<SettlementListModel> delaySettlementModelList) {
    _delaySettlementModelList = delaySettlementModelList;
    notifyListeners();
  }

  String _selectSearchType = '0';
  String get selectSearchType => _selectSearchType;
  set selectSearchType(String value) {
    _selectSearchType = value;
    notifyListeners();
  }

  String judgeText(){
    switch(this.selectSearchType){
      case '0':
        return '车牌号';
      case '1':
        return '手机号';
      case '2':
        return '公司名';
      default:
        return '';
    }
  }

  ///7.未结算 8.结算 9.挂账
  Stream getSettlementList(String type, {String searchKey, String isAccurate}) {
    Map<String, dynamic> dataMap = convert.jsonDecode(SynchronizePreferences.Get('mapUseridShopid'));
    String userId = SynchronizePreferences.Get('userid');
    var query = {
      'type': type,
      'searchKey':searchKey,
      'flag':isAccurate,
      'selectType':this.selectSearchType,
    };
    return _repo
        .getSettlementList(query: query)
        .doOnData((result) {
          List<SettlementListModel> tempList = [];
          Map res = convert.jsonDecode(result.toString());
          List resList = res['data'];
          resList.forEach((element) {
            SettlementListModel model = SettlementListModel.fromJson(element);
            tempList.add(model);
          });
          if(type == '7') {
            this.notSettlementModelList = tempList;
          }else if(type == '8'){
            this.yesSettlementModelList = tempList;
          }else {
            this.delaySettlementModelList = tempList;
          }
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }
}
