import 'package:flutter/material.dart';
import 'dart:async';
import 'package:spanners/dLoginOrOther/login.dart';
/*
//**********alart  调用*********//

Future _showAlertDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowAlart(
          text: '',
        );
      },
    );
  }

*/

enum Action { Ok, Cancel }

class ShowMessageAlart extends StatefulWidget {
  final String title;
  final String text;

  const ShowMessageAlart({Key key, this.title, this.text}) : super(key: key);
  @override
  _ShowMessageAlartState createState() => _ShowMessageAlartState();
}

class _ShowMessageAlartState extends State<ShowMessageAlart> {
  String _choice = 'Nothing';

  /// 倒计时的计时器。
  Timer _timer;

  /// 启动倒计时的计时器。
  _startTimer() {
    _timer = Timer(
      // 持续时间参数。
      Duration(seconds: 2),
      // 回调函数参数。
      () {
        Navigator.of(context).pop(true);
      },
    );
  }

  Future _openAlertDialog() async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false, //// user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text(widget.text),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context, Action.Cancel);
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                Navigator.pop(context, Action.Ok);
              },
            ),
          ],
        );
      },
    );

    switch (action) {
      case Action.Ok:
        setState(() {
          _choice = 'Ok';
        });
        break;
      case Action.Cancel:
        setState(() {
          _choice = 'Cancel';
        });
        break;
      default:
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //启动倒计时
    _startTimer();

    // _openAlertDialog();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(widget.text),
    );
  }
}

//空数据页面
class ShowNullDataAlart extends StatefulWidget {
  final String alartText;

  const ShowNullDataAlart({Key key, this.alartText}) : super(key: key);
  @override
  _ShowNullDataAlartState createState() => _ShowNullDataAlartState();
}

class _ShowNullDataAlartState extends State<ShowNullDataAlart> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: Column(
        children: [
          Image.asset(
            'Assets/alartIcon/alartIcon.png',
            width: 150,
            height: 167,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {},
            child: Text(
              widget.alartText,
              style: TextStyle(
                  color: Color.fromRGBO(203, 221, 255, 1),
                  fontSize: 23,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      )),
    );
  }
}

//弹出 自定义页面 --> 派工看板人员选择
class AtWorkAlart extends StatefulWidget {
  final List atList;
  final Function(String name, String id) onChanges;
  const AtWorkAlart({Key key, this.atList, this.onChanges}) : super(key: key);
  @override
  _AtWorkAlartState createState() => _AtWorkAlartState();
}

class _AtWorkAlartState extends State<AtWorkAlart> {
  int indexs = 1000; //所选人
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width - 90,
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 0,
                ),
                Container(
                  width: 3,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Color.fromRGBO(39, 153, 93, 1),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '施工人员',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Color.fromRGBO(38, 38, 38, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
                child: ListView(
              shrinkWrap: true,
              children: List.generate(
                widget.atList.length,
                (index) => InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
                        indexs = index;
                        //点击 人员 回调
                        widget.onChanges(
                            widget.atList[index]['realName'].toString(),
                            widget.atList[index]['id'].toString());
                      });
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.atList[index]['realName'].toString(),
                                style: TextStyle(
                                  color: Color.fromRGBO(33, 34, 33, 1),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Icon(
                              indexs == index
                                  ? Icons.check_circle
                                  : Icons.panorama_fish_eye,
                              color: indexs == index
                                  ? Color.fromRGBO(39, 153, 93, 1)
                                  : Color.fromRGBO(112, 112, 112, 1),
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 1,
                          color: Color.fromRGBO(238, 238, 238, 1),
                        )
                      ],
                    )),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class ShowEorrDataAlart extends StatefulWidget {
  final String errors;

  const ShowEorrDataAlart({Key key, this.errors}) : super(key: key);
  @override
  _ShowEorrDataAlartState createState() => _ShowEorrDataAlartState();
}

class _ShowEorrDataAlartState extends State<ShowEorrDataAlart> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        widget.errors,
        style: TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }
}

class ApointmentTimeEditAlart extends StatefulWidget {
  final String time;

  const ApointmentTimeEditAlart({Key key, this.time}) : super(key: key);
  @override
  _ApointmentTimeEditAlartState createState() =>
      _ApointmentTimeEditAlartState();
}

class _ApointmentTimeEditAlartState extends State<ApointmentTimeEditAlart> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
      width: MediaQuery.of(context).size.width - 120,
      height: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Column(
        children: [
          Text(
            widget.time,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginView()));
            },
            child: Text(
              '返回登录',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          )
        ],
      ),
    ));
  }
}

class ShowTokenEorrAlart extends StatefulWidget {
  final String errors;

  const ShowTokenEorrAlart({Key key, this.errors}) : super(key: key);
  @override
  _ShowTokenEorrAlartState createState() => _ShowTokenEorrAlartState();
}

class _ShowTokenEorrAlartState extends State<ShowTokenEorrAlart> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Column(
      children: [
        Text(
          widget.errors,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginView()));
          },
          child: Text(
            '返回登录',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        )
      ],
    ));
  }
}

class ShowWarnAlart extends StatefulWidget {
  final String warn;

  const ShowWarnAlart({Key key, this.warn}) : super(key: key);
  @override
  _ShowWarnAlartState createState() => _ShowWarnAlartState();
}

class _ShowWarnAlartState extends State<ShowWarnAlart> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
            width: 160,
            height: 110,
            child: Column(
              children: [
                Text(
                  widget.warn,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 1,
                  color: Color.fromRGBO(41, 39, 39, 1),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '确定',
                    style: TextStyle(
                        color: Color.fromRGBO(41, 39, 39, 1), fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )));
  }
}
