import 'package:flutter/material.dart';
import 'package:spanners/cTools/showEorror.dart';
import 'package:spanners/dLoginOrOther/requestApi.dart';
import './login.dart';

class editPasswordView extends StatefulWidget {
  Map data;
  setData(data){
    this.data = data;
  }
  @override
  _editPasswordViewState createState() => _editPasswordViewState();
}

class _editPasswordViewState extends State<editPasswordView> {
  String name = '';
  String password = '';

  TextEditingController nameControll = TextEditingController();
  TextEditingController passControll = TextEditingController();

  bool loginVisible = false;
  bool passwordVisible = false;
  bool saveVisible = false;

  @override
  Widget build(BuildContext context) {
    print(widget.data);
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
                  '修改密码',
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
                                        maxHeight: 30, maxWidth: 300),
                                    child: TextFormField(
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
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 24),
                                        hintText: '请设置8~12位新密码',
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
                                      obscureText: passwordVisible,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 24),
                                        hintText: '请再次输入新密码',
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
                              ])),
                          SizedBox(
                            width: 41,
                          ),
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
                                  password == name
                                      ? DioRequest.sureRequest(
                                          param: {
                                              "mobile": widget.data["mobile"],
                                              'password': password,
                                              'type': 2
                                            },
                                          onSuccess: (data) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginView()),
                                            );
                                          },
                                          onError: (error) {
                                            openTopReminder(context, error);
                                          })
                                      : openTopReminder(context, '密码两次输入不同，请确认');
                                },
                                child: Text('确定',
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
