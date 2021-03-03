import 'package:flutter/material.dart';
import 'package:spanners/cTools/custom_password_keyboard/custom_keyboard_button.dart';

class CustomPasswordKeyboard extends StatefulWidget {

  final callback;

  CustomPasswordKeyboard(this.callback);

  @override
  _CustomPasswordKeyboardState createState() => _CustomPasswordKeyboardState();
}

class _CustomPasswordKeyboardState extends State<CustomPasswordKeyboard> {

  /// 定义 确定 按钮 接口  暴露给调用方
  ///回调函数执行体
  var backMethod;
  void onCommitChange() {
    widget.callback("commit");
  }

  void onOneChange(BuildContext cont) {
    widget.callback("1");
  }

  void onTwoChange(BuildContext cont) {
    widget.callback("2");
  }

  void onThreeChange(BuildContext cont) {
    widget.callback("3");
  }

  void onFourChange(BuildContext cont) {
    widget.callback("4");
  }

  void onFiveChange(BuildContext cont) {
    widget.callback("5");
  }

  void onSixChange(BuildContext cont) {
    widget.callback("6");
  }

  void onSevenChange(BuildContext cont) {
    widget.callback("7");
  }

  void onEightChange(BuildContext cont) {
    widget.callback("8");
  }

  void onNineChange(BuildContext cont) {
    widget.callback("9");
  }

  void onZeroChange(BuildContext cont) {
    widget.callback("0");
  }

  /// 点击删除
  void onDeleteChange() {
    widget.callback("del");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 200,
      child: Column(
        children: <Widget>[
          ///  第一行
          new Row(
            children: <Widget>[
              CustomKbBtn(
                  text: '1', callback: (val) => onOneChange(context)),
              CustomKbBtn(
                  text: '2', callback: (val) => onTwoChange(context)),
              CustomKbBtn(
                  text: '3', callback: (val) => onThreeChange(context)),
            ],
          ),

          ///  第二行
          new Row(
            children: <Widget>[
              CustomKbBtn(
                  text: '4', callback: (val) => onFourChange(context)),
              CustomKbBtn(
                  text: '5', callback: (val) => onFiveChange(context)),
              CustomKbBtn(
                  text: '6', callback: (val) => onSixChange(context)),
            ],
          ),

          ///  第三行
          new Row(
            children: <Widget>[
              CustomKbBtn(
                  text: '7', callback: (val) => onSevenChange(context)),
              CustomKbBtn(
                  text: '8', callback: (val) => onEightChange(context)),
              CustomKbBtn(
                  text: '9', callback: (val) => onNineChange(context)),
            ],
          ),

          ///  第四行
          new Row(
            children: <Widget>[
              CustomKbBtn(text: '删除', callback: (val) => onDeleteChange()),
              CustomKbBtn(
                  text: '0', callback: (val) => onZeroChange(context)),
              CustomKbBtn(text: '确定', callback: (val) => onCommitChange()),
            ],
          ),
        ],
      ),
    );
  }
}
