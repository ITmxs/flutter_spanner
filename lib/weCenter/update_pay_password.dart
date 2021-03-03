import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/dLoginOrOther/requestApi.dart';
import 'package:spanners/weCenter/weCenterRequestApi.dart';

import 'model/shop_info_model.dart';

/// Copyright (C), 2020-2020, spanners
/// FileName: update_pay_password
/// Author: Jack
/// Date: 2020/12/4
/// Description:
class UpdatePayPassword extends StatefulWidget {
  bool flag = true;

  setData(data) {
    this.flag = data;
  }

  @override
  _UpdatePayPasswordState createState() => _UpdatePayPasswordState();
}

class _UpdatePayPasswordState extends State<UpdatePayPassword> {
  ShopInfoModel shopInfoModel = ShopInfoModel();
  Map info;

  TextEditingController textEditingController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    info = json.decode(SynchronizePreferences.Get("userInfo"));
    initData();
  }

  initData()  {
     WeCenterDio.myInfoRequest(
      param: info["shopId"],
      onError: (error) {
        print(error);
      },
      onSuccess: (data) {
        shopInfoModel = ShopInfoModel.fromJson(data);
        setState(() {});
      },
    );
  }

  sendMsg() {
    DioRequest.msgRequest(
        param: {
          "mobile": shopInfoModel.mobile,
          // "mobile": "15114501225",
        },
        onSuccess: (data) {
          print("发送成功");
        },
        onError: (error) {});
  }

  checkMsg() {
    DioRequest.checkMsgRequest(
        param: {
          "mobile": shopInfoModel.mobile,
          // "mobile": "15114501225",
          "message": textEditingController.text
        },
        onSuccess: (data) {
          print("成功了");
          updatePassword();
        },
        onError: (error) {
          CommonWidget.showAlertDialog("验证码不对");
        });
  }

  updatePassword() async{
    if(password1Controller.text != password1Controller.text){
      CommonWidget.showAlertDialog("两次密码输入不一致");
      return;
    }
    await WeCenterDio.updatePayPasswordRequest(
      param: {"password":password1Controller.text},
      onError: (error) {
        print(error);
      },
      onSuccess: (data) {
        Navigator.pop(context);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context,
          title: widget.flag ? "修改支付密码" : "设置支付密码"),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 5.s,
                ),
                Container(
                  width: 375.s,
                  height: 46.s,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(169, 169, 172, 1),
                              width: 0.5.s))),
                  padding: EdgeInsets.fromLTRB(25.s, 0, 25.s, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "手机号"),
                      CommonWidget.font(text: "${shopInfoModel.mobile}"),
                    ],
                  ),
                ),
                Container(
                  width: 375.s,
                  height: 46.s,
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(25.s, 0, 25.s, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "验证码"),
                      Row(
                        children: [
                          Container(
                            width: 100.s,
                            child: CommonWidget.textField(
                                hintText: "请输入验证码",
                                textController: textEditingController),
                          ),
                          GestureDetector(
                            child: CommonWidget.button(
                                text: "获取", width: 70.s, height: 25.s),
                            onTap: () {
                              sendMsg();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.s,
                ),
                Container(
                  width: 375.s,
                  height: 46.s,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(169, 169, 172, 1),
                              width: 0.5.s))),
                  padding: EdgeInsets.fromLTRB(25.s, 0, 25.s, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: widget.flag ? "新支付密码" : "支付密码"),
                      Row(
                        children: [
                          Container(
                            width: 150.s,
                            child: CommonWidget.textField(
                                hintText: "请输入支付密码",
                                textController: password1Controller),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: 375.s,
                  height: 46.s,
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(25.s, 0, 25.s, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "确认密码"),
                      Row(
                        children: [
                          Container(
                            width: 150.s,
                            child: CommonWidget.textField(
                                hintText: "请再次输入支付密码",
                                textController: password2Controller),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 200.s,
                ),
                GestureDetector(
                  onTap: () {
                    checkMsg()();
                  },
                  child:
                      CommonWidget.button(text: "提交", width: 90.s, height: 30.s),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
