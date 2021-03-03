import 'package:lpinyin/lpinyin.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/talkingOnline/friend/model/contact_model.dart';
import 'package:azlistview/azlistview.dart';

class FriendProvide extends BaseProvide {
  final FriendListRepo _repo = FriendListRepo();

  final ApplyFriendRepo _applyFriendRepo = ApplyFriendRepo();

  List _systemItem = [
    {
      'icon': 'Assets/friend/new_friend.png',
      'name': '新的好友',
    },
    {
      'icon': 'Assets/friend/focus_friend.png',
      'name': '关注的人',
    },
    {'icon': 'Assets/friend/group_friend.png', 'name': '群聊'}
  ];

  get systemItem => _systemItem;

  List<ContactInfo> _contactsList = [];

  List get contactsList => _contactsList;

  set contactsList(List contactsList) {
    _contactsList = contactsList;
    notifyListeners();
  }

  ContactInfo _userModel = ContactInfo().getUserModel();

  Stream getContactsList() {
    return _repo
        .getFriendList(query: {'username': _userModel.id})
        .doOnData((result) {
          var res = convert.jsonDecode(result.toString()); //转json
          List<ContactInfo> contacts = [];
          List list = res['data'];
          list.forEach((value) {
            ContactInfo model = ContactInfo.fromJson(value);
            contacts.add(ContactInfo.fromJson(value));
            SynchronizePreferences.Set(model.id, model.toString());
          });
          _handleList(contacts);
        })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  void _handleList(List<ContactInfo> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(list);
    this.contactsList = list;
    notifyListeners();
  }

  bool showNewFriendMessage = false;

  Stream getApplyMessage() {
    return _applyFriendRepo
        .getApplyMessage(query: {'username': _userModel.id})
        .doOnData((result) {
          print('查询结果');
          print(result.runtimeType);
          var res = convert.jsonDecode(result.toString()); //转json
          List messageList = res['data'];
          print(messageList.length);
          if (messageList.length > 0) {
            this.showNewFriendMessage = true;
          }
        })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }
}
