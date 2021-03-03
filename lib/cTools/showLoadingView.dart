import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';

class ShowLoading extends StatefulWidget {
  final String title;

  const ShowLoading({Key key, this.title}) : super(key: key);
  @override
  _ShowLoadingState createState() => _ShowLoadingState();
}

class _ShowLoadingState extends State<ShowLoading> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: 120,
          height: 120,
          child: Material(
            elevation: 24.0,
            color: Colors.white70,
            type: MaterialType.card,
            borderRadius: BorderRadius.circular(10),
            //在这里修改成我们想要显示的widget就行了，外部的属性跟其他Dialog保持一致
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BallSpinFadeLoaderIndicator(
                  ballColor: Colors.black87,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: new Text(widget.title),
                ),
              ],
            ),
          )),
    );
  }
}

// 请求 成功 提示框
class ShowSuccess extends StatefulWidget {
  final String title;

  const ShowSuccess({Key key, this.title}) : super(key: key);
  @override
  _ShowSuccessState createState() => _ShowSuccessState();
}

class _ShowSuccessState extends State<ShowSuccess> {
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
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: 120,
          height: 120,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 24.0,
            color: Theme.of(context).dialogBackgroundColor,
            type: MaterialType.card,
            //在这里修改成我们想要显示的widget就行了，外部的属性跟其他Dialog保持一致
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.done,
                  size: 50,
                  color: Colors.black87,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: new Text(widget.title),
                ),
              ],
            ),
          )),
    );
  }
}

// 纯文字 提示框
class ShowAlart extends StatefulWidget {
  final String title;
  final int backLart; //0 白色， 1 黑色
  final int position; //0 顶部  1 中部  2 底部
  const ShowAlart({Key key, this.title, this.backLart, this.position})
      : super(key: key);
  @override
  _ShowAlartState createState() => _ShowAlartState();
}

class _ShowAlartState extends State<ShowAlart> {
  /// 倒计时的计时器。
  Timer _timer;

  /// 启动倒计时的计时器。
  _startTimer() {
    _timer = Timer(
      // 持续时间参数。
      Duration(seconds: 1),
      // 回调函数参数。
      () {
        Navigator.of(context).pop(true);
      },
    );
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
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.position == 2
        ?
        //底部部
        Center(
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                SizedBox(
                    //width: 180,
                    //height: 35,
                    child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 24.0,
                  color: widget.backLart == 1 ? Colors.black54 : Colors.white,
                  type: MaterialType.card,
                  //在这里修改成我们想要显示的widget就行了，外部的属性跟其他Dialog保持一致
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: new Text(
                          widget.title,
                          style: TextStyle(
                              color: widget.backLart == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ],
                  ),
                )),
                SizedBox(
                  height: 90,
                ),
              ],
            ),
          )
        :
        //中部
        Center(
            child: SizedBox(
                //width: 180,
                //height: 35,
                child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 24.0,
              color: widget.backLart == 1 ? Colors.black54 : Colors.white,
              type: MaterialType.card,
              //在这里修改成我们想要显示的widget就行了，外部的属性跟其他Dialog保持一致
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: new Text(
                      widget.title,
                      style: TextStyle(
                          color: widget.backLart == 1
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
            )),
          );
  }
}

// 请求 失败 提示框
class ShowError extends StatefulWidget {
  final String title;

  const ShowError({Key key, this.title}) : super(key: key);
  @override
  _ShowErrorState createState() => _ShowErrorState();
}

class _ShowErrorState extends State<ShowError> {
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
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: 120,
          height: 120,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 24.0,
            color: Theme.of(context).dialogBackgroundColor,
            type: MaterialType.card,
            //在这里修改成我们想要显示的widget就行了，外部的属性跟其他Dialog保持一致
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.close,
                  size: 50,
                  color: Colors.black87,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: new Text(widget.title),
                ),
              ],
            ),
          )),
    );
  }
}

//系统异常  提示页
class CatchPage extends StatefulWidget {
  @override
  _CatchPageState createState() => _CatchPageState();
}

class _CatchPageState extends State<CatchPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      body: Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width - 60,
            height: 3 * MediaQuery.of(context).size.height / 4,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 24.0,
              color: Color.fromRGBO(238, 238, 238, 1),
              type: MaterialType.card,
              //在这里修改成我们想要显示的widget就行了，外部的属性跟其他Dialog保持一致
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    height:
                        3 * MediaQuery.of(context).size.height / 4 - 65 - 120,
                    child: Center(
                      child: Image.asset(
                        'Assets/catach/catch.png',
                        width: MediaQuery.of(context).size.width - 60 - 30,
                        height: MediaQuery.of(context).size.width - 60 - 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    height: 25,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '系统出错~',
                        style: TextStyle(
                            color: Color.fromRGBO(172, 178, 188, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                            width: 60,
                            height: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Color.fromRGBO(172, 178, 188, 1),
                                    width: 1)),
                            child: Text(
                              '返回',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(172, 178, 188, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )),
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class ServiceLoad extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const ServiceLoad({Key key, this.onChanged})
      : super(key: key); // 视频上传成功返回值url
  @override
  _ServiceLoadState createState() => _ServiceLoadState();
}

class _ServiceLoadState extends State<ServiceLoad> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          //width: 180,
          //height: 35,
          child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 24.0,
        color: Colors.white,
        type: MaterialType.card,
        //在这里修改成我们想要显示的widget就行了，外部的属性跟其他Dialog保持一致
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Icon(
              Icons.close,
              size: 50,
              color: Colors.black87,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: new Text(
                '服务列表获取失败',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  widget.onChanged('');
                  Navigator.of(context).pop(true);
                },
                child: Container(
                  width: 80,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Color.fromRGBO(39, 153, 93, 1)),
                  child: Text(
                    '重新获取',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      )),
    );
    // Scaffold(
    //   backgroundColor: Color.fromRGBO(238, 238, 238, 1),
    //   body: Center(
    //     child: SizedBox(
    //         width: MediaQuery.of(context).size.width - 60,
    //         height: 3 * MediaQuery.of(context).size.height / 4,
    //         child: Material(
    //           borderRadius: BorderRadius.circular(10),
    //           elevation: 24.0,
    //           color: Color.fromRGBO(238, 238, 238, 1),
    //           type: MaterialType.card,
    //           //在这里修改成我们想要显示的widget就行了，外部的属性跟其他Dialog保持一致
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               Container(
    //                 width: MediaQuery.of(context).size.width - 60,
    //                 height:
    //                     3 * MediaQuery.of(context).size.height / 4 - 65 - 120,
    //                 child: Center(
    //                   child: Image.asset(
    //                     'Assets/catach/catch.png',
    //                     width: MediaQuery.of(context).size.width - 60 - 30,
    //                     height: MediaQuery.of(context).size.width - 60 - 30,
    //                     fit: BoxFit.cover,
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               Container(
    //                 width: MediaQuery.of(context).size.width - 60,
    //                 height: 25,
    //                 child: Align(
    //                   alignment: Alignment.center,
    //                   child: Text(
    //                     '服务列表获取失败',
    //                     style: TextStyle(
    //                         color: Color.fromRGBO(172, 178, 188, 1),
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.w500),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 45,
    //               ),
    //               Align(
    //                   alignment: Alignment.center,
    //                   child: GestureDetector(
    //                     onTap: () {
    //                       widget.onChanged('');
    //                       Navigator.of(context).pop(true);
    //                     },
    //                     child: Container(
    //                         width: 60,
    //                         height: 25,
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(10),
    //                             border: Border.all(
    //                                 color: Color.fromRGBO(172, 178, 188, 1),
    //                                 width: 1)),
    //                         child: Text(
    //                           '重新获取',
    //                           textAlign: TextAlign.center,
    //                           style: TextStyle(
    //                               color: Color.fromRGBO(172, 178, 188, 1),
    //                               fontSize: 16,
    //                               fontWeight: FontWeight.w500),
    //                         )),
    //                   )),
    //               SizedBox(
    //                 height: 50,
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //             ],
    //           ),
    //         )),
    //   ),
    // );
  }
}
