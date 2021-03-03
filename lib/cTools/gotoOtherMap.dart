import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './showLoadingView.dart';
import 'Router.dart';

class MapUtil {
  /*  加载数据的  请求成功  */
  static Future _showDialog(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowAlart(
          title: message,
        );
      },
    );
  }

  /// 高德地图
  static Future<bool> gotoAMap(slongitude, slatitude, elongitude, elatitude,
      startAdress, endAdress) async {
    var url =
        '${Platform.isAndroid ? 'android' : 'ios'}amap://path?sourceApplication=applicationName&sid=&slat=$slatitude&slon=$slongitude&sname=$startAdress&did=&dlat=$elatitude&dlon=$elongitude&dname=$endAdress&dev=0&t=0';
    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      _showDialog('未检测到高德地图~');
      return false;
    }

    await launch(url);
    return true;
  }

  /// 腾讯地图
  static Future<bool> gotoTencentMap(longitude, latitude) async {
    var url =
        'qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=$latitude,$longitude&referer=IXHBZ-QIZE4-ZQ6UP-DJYEO-HC2K2-EZBXJ';
    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      _showDialog('未检测到腾讯地图~');
      return false;
    }

    await launch(url);
    return canLaunchUrl;
  }

  /// 百度地图
  static Future<bool> gotoBaiduMap(slongitude, slatitude, elongitude, elatitude,
      startAdress, endAdress) async {
    //高德=>百度 坐标系转化
    var pi = 3.14159265358979324 * 3000.0 / 180.0;
    //起始
    var sx = slongitude, sy = slatitude;
    var sz = sqrt(sx * sx + sy * sy) + 0.00002 * sin(sy * pi);
    var stheta = atan2(sy, sx) + 0.000003 * cos(sx * pi);
    var slng = sz * cos(stheta) + 0.0065;
    var slat = sz * sin(stheta) + 0.006;
    //终点
    var ex = elongitude, ey = elatitude;
    var ez = sqrt(ex * ex + ey * ey) + 0.00002 * sin(ey * pi);
    var etheta = atan2(ey, ex) + 0.000003 * cos(ex * pi);
    var elng = ez * cos(etheta) + 0.0065;
    var elat = ez * sin(etheta) + 0.006;
    //调起三方地图
    var url =
        'baidumap://map/direction?origin=$slat,$slng&destination=$elat,$elng&origin==$startAdress&destination=$endAdress&coord_type=bd09ll&mode=driving';

    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      _showDialog('未检测到百度地图~');
      return false;
    }

    await launch(url);
    return canLaunchUrl;
  }

  /// 苹果地图
  static Future<bool> gotoAppleMap(slongitude, slatitude, elongitude, elatitude,
      startAdress, endAdress) async {
    var url =
        'http://maps.apple.com/?saddr=$slatitude,$slongitude&daddr=$elatitude,$elongitude';

    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      _showDialog('未检测到苹果自带地图～');
      return false;
    }
    await launch(url);
    return canLaunchUrl;
  }
}
