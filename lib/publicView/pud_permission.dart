import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/publicView/pub_ApiDio.dart';
import 'dart:convert' as convert;

class PermissionApi {
  static String listToString(List list) {
    if (list == null) {
      return null;
    }
    String result;
    list.forEach((string) =>
        {if (result == null) result = string else result = '$result，$string'});
    return result.toString();
  }

  static getPermissionList() {
    PubDio.getPermissionRequest(onSuccess: (data) {
      //权限存储
      String jsonString = convert.jsonEncode(data);
      SharedManager.saveString(jsonString, 'permission');
    });
  }

  //判断是否有此权限
  static bool whetherContain(String key) {
    String permissions = SynchronizePreferences.Get('permission');
    Map permissionMap = convert.jsonDecode(permissions);
    List permissionList = permissionMap['permissions'];
    if (permissionList.contains(key)) {
      return false;
    } else {
      Alart.showAlartDialog('无此权限!', 1);
      return true;
    }
  }
}
