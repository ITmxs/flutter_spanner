import 'package:flutter/material.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/showLoadingView.dart';

class Alart {
  static Future showAlartDialog(String message, int type) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowAlart(
          backLart: 1,
          title: message,
          position: type, //0 顶部  1 中部  2 底部
        );
      },
    );
  }
}
