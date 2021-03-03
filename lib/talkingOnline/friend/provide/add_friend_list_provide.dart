import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/talkingOnline/friend/model/add_friend_model.dart';
import 'dart:convert' as convert;

import 'package:spanners/talkingOnline/friend/model/contact_model.dart';

class AddFriendListProvide extends BaseProvide {
  final ApplyFriendRepo _applyFriendRepo = ApplyFriendRepo();

  ContactInfo _userModel = ContactInfo().getUserModel();

  List<AddFriendModel> _modelList = [];

  List get modelList => _modelList;

  set modelList(List modelList) {
    _modelList = modelList;
    notifyListeners();
  }

  Stream getApplyMessage() {
    return _applyFriendRepo
        .getApplyMessage(query: {'username': _userModel.id})
        .doOnData((result) {
          print('查询结果');

          var res = convert.jsonDecode(result.toString()); //转json
          List messageList = res['data'];
          List<AddFriendModel> tempList = [];
          messageList.forEach((element) {
            // AddFriendModel model = AddFriendModel.fromJson(element);
            tempList.add(AddFriendModel.fromJson(element));
          });
          this.modelList = tempList;
        })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  ///1、通过。2、拒绝
  Stream postApplyMessage(String friendUsername, String status) {
    var body = {
      "friendUsername": friendUsername,
      "status": status,
      "username": _userModel.id,
    };
    return _applyFriendRepo
        .postApplyMessage(body)
        .doOnData((result) {
          var res = convert.jsonDecode(result.toString()); //转json
          List messageList = res['data'];
          List<AddFriendModel> tempList = [];
          messageList.forEach((element) {
            // AddFriendModel model = AddFriendModel.fromJson(element);
            tempList.add(AddFriendModel.fromJson(element));
          });
          this.modelList = tempList;
        })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }
}
