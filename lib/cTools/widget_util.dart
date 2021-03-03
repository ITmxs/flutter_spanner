import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WidgetUtil {
  /// 用户头像
  static Widget buildUserPortrait(String path) {
    print(path);
    Widget protraitWidget =
        Image.asset("Assets/temp_icon.png", fit: BoxFit.fill);
    print(path);
    if (path.startsWith("http")) {
      protraitWidget = CachedNetworkImage(
        fit: BoxFit.fill,
        imageUrl: path,
      );
    } else {
      File file = File(path);
      if (file.existsSync()) {
        protraitWidget = Image.file(
          file,
          fit: BoxFit.fill,
        );
      }
    }
    return ClipOval(
      child: Container(
        height: 46,
        width: 46,
        child: protraitWidget,
      ),
    );
  }

  static Widget avatarType(String path, double width, double height) {
    Widget protraitWidget;
    print(path.runtimeType);
    if (path.startsWith("http")) {
      protraitWidget = CachedNetworkImage(
        fit: BoxFit.fill,
        imageUrl: path,
        width: width,
        height: height,
      );
    } else if (path != '') {
      protraitWidget = Image.asset(
        path,
        fit: BoxFit.fill,
        width: width,
        height: height,
      );
    } else {
      protraitWidget = Image.asset(
        'Assets/temp_icon.png',
        fit: BoxFit.fill,
        width: width,
        height: height,
      );
    }
    return protraitWidget;
  }
}

class TimeUtil {
  //将 unix 时间戳转换为特定时间文本，如年月日
  static String convertTime(int timestamp) {
    DateTime msgTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime nowTime = DateTime.now();

    if (nowTime.year == msgTime.year) {
      //同一年
      if (nowTime.month == msgTime.month) {
        //同一月
        if (nowTime.day == msgTime.day) {
          //同一天 时:分
          return msgTime.hour.toString() + ":" + msgTime.minute.toString();
        } else {
          if (nowTime.day - msgTime.day == 1) {
            //昨天
            return "昨天";
          } else if (nowTime.day - msgTime.day < 7) {
            return _getWeekday(msgTime.weekday);
          }
        }
      }
    }
    return msgTime.year.toString() +
        "/" +
        msgTime.month.toString() +
        "/" +
        msgTime.day.toString();
  }

  ///是否需要显示时间，相差 5 分钟
  static bool needShowTime(int sentTime1, int sentTime2) {
    return (sentTime1 - sentTime2).abs() > 5 * 60 * 1000;
  }

  static String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return "星期一";
      case 2:
        return "星期二";
      case 3:
        return "星期三";
      case 4:
        return "星期四";
      case 5:
        return "星期五";
      case 6:
        return "星期六";
      default:
        return "星期日";
    }
  }
}