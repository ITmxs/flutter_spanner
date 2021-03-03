/*
   数据  存储  
*/
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class SharedManager {
  /* 存储 */
  static saveString(String value, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  /* 删除 */
  static removeString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  /* 获取 */
  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /* 获取shopId */
  static Future<String> getShopIdString() async {
    var mapStr = await SharedManager.getString('mapUseridShopid');

    if (mapStr == null) {
      return '';
    } else {
      Map<String, dynamic> dataMap = convert.jsonDecode(mapStr);

      var userId = await SharedManager.getString('userid');
      return dataMap[userId];
    }
  }

  /* 获取map */
  static Future<Map> getCarMap() async {
    var mapStr = await SharedManager.getString('receiveCarServiceList');

    if (mapStr == null) {
      return null;
    } else {
      Map<String, dynamic> dataMap = convert.jsonDecode(mapStr);

      return dataMap;
    }
  }
}

//同步 处理
class SynchronizePreferences {
  static SharedPreferences preferences;

  static Future<bool> getInstance() async {
    preferences = await SharedPreferences.getInstance();
    return true;
  }

  // ignore: non_constant_identifier_names
  static String Get(String key) {
    return preferences.getString(key);
  }

  // ignore: non_constant_identifier_names
  static List GetList(String key) {
    return preferences.getStringList(key);
  }

  // ignore: non_constant_identifier_names
  static Set(String key, var value) {
    if (value is String) {
      preferences.setString(key, value);
    } else if (value is List) {
      preferences.setStringList(key, value);
    }
  }

  // ignore: non_constant_identifier_names
  static Remove(String key) {
    preferences.remove(key);
  }

  /* 获取map */
  static Map getCarMap() {
    var mapStr = preferences.getString('receiveCarServiceList');
    print('----->$mapStr');
    if (mapStr == null) {
      return null;
    } else {
      Map<String, dynamic> dataMap = convert.jsonDecode(mapStr);
      print('----->$dataMap');

      return dataMap;
    }
  }
}
