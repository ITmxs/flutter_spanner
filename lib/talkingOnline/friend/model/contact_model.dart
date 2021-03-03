import 'package:azlistview/azlistview.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'dart:convert' as convert;

class ContactInfo extends ISuspensionBean {
  String name;
  String id;
  String headUrl;
  String tagIndex;
  String namePinyin;

  ContactInfo({
    this.name,
    this.id,
    this.headUrl,
    this.tagIndex,
    this.namePinyin,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : name = json['nickName'] == null ? '' : json['nickName'],
        id = json['userName'],
        headUrl =
            json['headUrl'] == null ? 'Assets/temp_icon.png' : json['headUrl'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'headUrl': headUrl,
        'tagIndex': tagIndex,
        'namePinyin': namePinyin,
        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() => convert.jsonEncode(this.toJson());

  getUserModel() {
    String userInfoStr = SynchronizePreferences.Get('userInfo');
    Map<String, dynamic> userInfo = convert.jsonDecode(userInfoStr);
    return ContactInfo(
        name: userInfo['realName'],
        id: userInfo['username'],
        headUrl: userInfo['headUrl'] == null
            ? 'Assets/temp_icon.png'
            : userInfo['headUrl']);
  }
}
