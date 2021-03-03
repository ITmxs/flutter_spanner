import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spanners/cTools/showEorror.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/dLoginOrOther/requestApi.dart';
import './editPassword.dart';

class forgetView extends StatefulWidget {
  @override
  _forgetViewState createState() => _forgetViewState();
}

class _forgetViewState extends State<forgetView> {
  String name = '';
  String password = '';

  TextEditingController nameControll = TextEditingController();
  TextEditingController passControll = TextEditingController();

  bool loginVisible = false;
  bool passwordVisible = false;
  bool saveVisible = false;
  bool yzVisible = false;
  //定义变量
  Timer _timer;
  //倒计时数值
  var countdownTime = 0;

//倒计时赋值
  String handleCodeText() {
    if (countdownTime > 0) {
      return "${countdownTime}s";
    } else
      return "获取";
  }

  //倒计时方法
  _startCountdown() {
    countdownTime = 60;
    final call = (timer) {
      setState(() {
        if (countdownTime < 1) {
          _timer.cancel();
          yzVisible = true;
        } else {
          countdownTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          //点击空白处隐藏键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 21,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
                Text(
                  '忘记密码',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'PingFang SC Bold'),
                ),
                SizedBox(
                  height: 49,
                ),
                Container(
                  height: 300,
                  color: Colors.white,
                  child: Column(
                    children: [
//--> 登陆name
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 41,
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 82,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromRGBO(39, 193, 93, 0.1)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.lock,
                                  color: Color.fromRGBO(39, 153, 93, 1),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  width: 2,
                                  height: 28,
                                  color: Color.fromRGBO(39, 193, 93, 1),
                                ),
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 30, maxWidth: 200),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          name = value;
                                          if (name.length > 0) {
                                            if (countdownTime < 1) {
                                              yzVisible = true;
                                            }
                                          } else {
                                            yzVisible = false;
                                          }
                                          if (name.length > 0 &&
                                              password.length > 0) {
                                            loginVisible = true;
                                          } else {
                                            loginVisible = false;
                                          }
                                        });
                                      },
                                      keyboardType: TextInputType.numberWithOptions(
                                          decimal: true),
                                      controller: nameControll,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      decoration: InputDecoration(
                                        suffixIcon: name.isEmpty
                                            ? Text("")
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color:
                                                      Color.fromRGBO(70, 70, 70, 1),
                                                  size: 17,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    name = '';
                                                    yzVisible = false;
                                                    nameControll
                                                        .clear(); //清除textfield的值
                                                  });
                                                }),
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 24),
                                        hintText: '请输入您的手机号',
                                        hintStyle: TextStyle(
                                            color: Color.fromRGBO(136, 133, 133, 1),
                                            fontSize: 15),
                                        border: new OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                      // keyboardType: TextInputType.multiline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 41,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
//--> password
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 41,
                          ),
                          Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width - 82,
                              color: Colors.white,
                              child: Row(children: [
                                Text(
                                  '验证码',
                                  style: TextStyle(
                                      color: Color.fromRGBO(33, 32, 32, 1),
                                      fontSize: 18,
                                      fontFamily: 'PingFang SC Medium'),
                                ),
                                SizedBox(
                                  width: 31,
                                ),
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 30, maxWidth: 200),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          password = value;
                                          if (name.length > 0 &&
                                              password.length > 0) {
                                            loginVisible = true;
                                          } else {
                                            loginVisible = false;
                                          }
                                        });
                                      },
                                      controller: passControll,
                                      //obscureText: passwordVisible,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(
                                          vertical: 0,
                                        ),
                                        hintText: '请输入验证码',
                                        hintStyle: TextStyle(
                                            color: Color.fromRGBO(136, 133, 133, 1),
                                            fontSize: 15),
                                        border: new OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                      // keyboardType: TextInputType.multiline,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (yzVisible) {
                                      if (name.length == 11) {
                                        if (countdownTime == 0) {
                                          yzVisible = false;

                                          DioRequest.phoneRequest(
                                              param: {
                                                "mobile": name,
                                              },
                                              onSuccess: (data) {
                                                _startCountdown();
                                              },
                                              onError: (error) {
                                                openTopReminder(context, error);
                                              });
                                        }
                                      } else {
                                        openTopReminder(context, '手机号码格式不正确');
                                        //FocusScope.of(context).requestFocus(FocusNode());
                                      }
                                    }
                                  },
                                  child: Container(
                                      width: 60,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: yzVisible
                                            ? Color.fromRGBO(39, 153, 93, 1)
                                            : Color.fromRGBO(39, 153, 93, 0.6),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(handleCodeText(),
                                            style: TextStyle(
                                                color: yzVisible
                                                    ? Colors.white
                                                    : Colors.white70,
                                                fontSize: 15)),
                                      )),
                                ),
                              ])),
                          SizedBox(
                            width: 41,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 92,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 92 * 2,
                            height: 1,
                            color: Color.fromRGBO(234, 234, 234, 1),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),

                      SizedBox(
                        height: 50,
                      ),
//--> 登录按钮
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: FlatButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                color: loginVisible
                                    ? Color.fromRGBO(39, 153, 93, 1)
                                    : Color.fromRGBO(39, 153, 93, 0.6),
                                onPressed: () {
                                  DioRequest.checkMsgRequest(
                                      param: {
                                        "mobile": nameControll.text,
                                        "message":passControll.text
                                      },
                                      onSuccess: (data) {
                                        RouterUtil.push(context,routerName: "editPassword",data: {"mobile": nameControll.text});
                                      },
                                      onError: (error) {
                                        openTopReminder(context, error);
                                      });
                                },
                                child: Text('下一步',
                                    style: TextStyle(
                                      color: loginVisible
                                          ? Colors.white
                                          : Colors.white70,
                                    ))),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
