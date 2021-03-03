import 'dart:convert' as convert;
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
// import 'package:getuiflut/getuiflut.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spanners/cTools/showEorror.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/dLoginOrOther/webview.dart';
import 'package:spanners/em_manager/em_manager.dart';
import 'package:spanners/homeTabbottom/homeTabbottom.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import './requestApi.dart';
import './forget.dart';
import 'package:spanners/publicView/pud_permission.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String name = '';
  String password = '';

  TextEditingController nameControll = TextEditingController();
  TextEditingController passControll = TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool loginVisible = false;
  bool passwordVisible = false;
  bool saveVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          // GestureDetector(
          //   onTap: () {
          //     //点击空白处隐藏键盘
          //     // FocusScope.of(context).requestFocus(FocusNode());
          //   },
          //   behavior: HitTestBehavior.translucent,
          //   child:
          ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            SizedBox(
              height: 150,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                '用户登录',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PingFang SC Bold'),
              ),
            ),
            SizedBox(
              height: 49,
            ),
            Container(
              //height: 400,
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
                            color: Color.fromRGBO(39, 153, 93, 0.1)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.phone_iphone,
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
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  onChanged: (value) {
                                    setState(() {
                                      name = value;
                                      if (name.length > 0 &&
                                          password.length > 0) {
                                        loginVisible = true;
                                      } else {
                                        loginVisible = false;
                                      }
                                    });
                                  },
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
                                                loginVisible = false;
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(39, 193, 93, 0.1)),
                          child: Row(children: [
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
                                    maxHeight: 45, maxWidth: 300),
                                child: TextField(
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
                                  obscureText: passwordVisible,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: password.isEmpty
                                          ? Text('')
                                          : Icon(
                                              //根据passwordVisible状态显示不同的图标
                                              passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color:
                                                  Color.fromRGBO(70, 70, 70, 1),
                                              size: 17,
                                            ),
                                      onPressed: () {
                                        //更新状态控制密码显示或隐藏
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 24),
                                    hintText: '请输入您的密码',
                                    hintStyle: TextStyle(
                                        color: Color.fromRGBO(136, 133, 133, 1),
                                        fontSize: 15),
                                    border: new OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ),
                          ])),
                      SizedBox(
                        width: 41,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
//--> 忘记密码
                  Row(children: <Widget>[
                    Expanded(child: SizedBox()),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => forgetView()),
                        );
                      },
                      child: Text(
                        '忘记密码',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color.fromRGBO(39, 153, 93, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),

                    // FlatButton(
                    //     splashColor: Colors.transparent,
                    //     highlightColor: Colors.transparent,
                    //     onPressed: () {
                    //       //  Navigator.push(
                    //       //     context,
                    //       //     new MaterialPageRoute(
                    //       //         builder: (context) => new forgetPassword()),
                    //       //   );
                    //     },
                    //     child: ),
                    SizedBox(
                      width: 40,
                    ),
                  ]),
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
                            onPressed: () async {
                              print('--------------登陆');
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => homeView()));

                              Map<String, dynamic> dataMap;
                              DioRequest.loginRequest(
                                  param: {
                                    "mobile": name,
                                    "password": password,
                                    // 'clientId': await Getuiflut.getClientId
                                  },
                                  onSuccess: (data) {
                                    String jsonString =
                                        convert.jsonEncode(data.mapInfo);
                                    SynchronizePreferences.Set(
                                        'userInfo', jsonString);
                                    SharedManager.saveString(
                                        data.userid.toString(), 'userid');
                                    SharedManager.saveString(
                                        data.mapInfo['mobile'], 'mobile');
                                    SharedManager.saveString(
                                        data.shopId.toString(), 'shopId');
                                    /* SharedManager  header 中 shopId 本地验证 存储 ⬇️ */
                                    SharedManager.getString('mapUseridShopid')
                                        .then((value) => {
                                              print('本地缓存了：$value'),
                                              if (value == null)
                                                {
                                                  SharedManager.saveString(
                                                      json.encode(
                                                        {
                                                          data.userid
                                                                  .toString():
                                                              data.shopId
                                                                  .toString()
                                                        },
                                                      ).toString(),
                                                      'mapUseridShopid'),
                                                }
                                              else
                                                {
                                                  /*
                                                    对本地缓存的做 map 是否包含 userid 
                                                  */
                                                  dataMap =
                                                      convert.jsonDecode(value),
                                                  if (dataMap.containsKey(
                                                      data.userid.toString()))
                                                    {
                                                      /*  包含了已存在Key  不再登录做处理，在切换店铺 ‘改’ 处理 */
                                                      dataMap[data.userid
                                                              .toString()] =
                                                          data.shopId
                                                              .toString(),
                                                      SharedManager.saveString(
                                                          json
                                                              .encode(dataMap)
                                                              .toString(),
                                                          'mapUseridShopid'),
                                                      print(
                                                          '本地存储的map：$dataMap,'),
                                                    }
                                                  else
                                                    {
                                                      dataMap[data.userid
                                                              .toString()] =
                                                          data.shopId
                                                              .toString(),
                                                      SharedManager.saveString(
                                                          json
                                                              .encode(dataMap)
                                                              .toString(),
                                                          'mapUseridShopid'),
                                                      print(
                                                          '本地存储的map：$dataMap,'),
                                                    }
                                                }
                                            });

                                    /* SharedManager  header 中 shopId 本地验证 存储 ⬇⬆️ */
                                    print('-------------登录回调');

                                    //登录
                                    em_login(
                                      name,
                                      password,
                                      () {},
                                      () {
                                        BotToast.showText(text: '聊天系统登录失败');
                                      },
                                    );
                                    //验证
                                    SharedManager.saveString(
                                        'login', 'autoLogin');
                                    //登录获取权限
                                    PermissionApi.getPermissionList();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          settings:
                                              RouteSettings(name: "/home"),
                                          builder: (context) => HomeView()),
                                    );
                                  },
                                  onError: (error) {
                                    print('-------------错误回调');
                                    openTopReminder(context, error);
                                  });
                            },
                            child: Text('登录',
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
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebviewPage()));
                        },
                        child: Text(
                          '扳手兄弟隐私政策',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
