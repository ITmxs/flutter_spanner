
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/photoSelect.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/common/commonTools.dart';

import 'attendanceClockApi.dart';

/// Copyright (C), 2020-2020, spanners
/// FileName: attendance_clock
/// Author: Jack
/// Date: 2020/12/8
/// Description:
class AttendanceClock extends StatefulWidget {
  @override
  _AttendanceClockState createState() => _AttendanceClockState();
}

class _AttendanceClockState extends State<AttendanceClock> {
  @override
  void initState() {
    initData();
  }

  int second = 10000;
  Timer timer;
  bool hasRuleFlag = true;
  List picList = [];
  Map timeMap = {};

  void initData() {
    //以[Duration]的间隔重复调用[callback]，直到
    //
    // *使用[cancel]函数取消。
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
      second--;
      if (second == 0) {
        timer.cancel();
      }
    });
    AttendanceApi.attendanceClockInitRequest(
        param: {
          "userId": json.decode(SynchronizePreferences.Get("userInfo"))["id"]
        },
        onSuccess: (data) {
          if (data == 0) {
            hasRuleFlag = false;
          }
          else{
            timeMap = data;
          }
          setState(() {});
        });
  }

  clock(value, type) {
    AttendanceApi.attendanceClockInRequest(
        param: {
          "userId": json.decode(SynchronizePreferences.Get("userInfo"))["id"],
          'clockInType': type,
          'imgUrl': value,
          "clockInDate":
              "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour }:${DateTime.now().minute}:${DateTime.now().second}",
          'id': timeMap["attendanceId"]
        },
        onSuccess: (data) {
          AttendanceApi.attendanceClockInitRequest(
              param: {
                "userId":
                    json.decode(SynchronizePreferences.Get("userInfo"))["id"]
              },
              onSuccess: (data) {
                timeMap = data;
                setState(() {});
              });
        });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "考勤打卡"),
      body: Column(
        children: [
          Container(
              width: 345.s,
              margin: EdgeInsets.fromLTRB(20.s, 10.s, 20.s, 20.s),
              padding: EdgeInsets.fromLTRB(20.s, 10.s, 20.s, 15.s),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3.s)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(
                          text:
                              "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                          size: 12),
                      CommonWidget.font(
                          text: "星期${DateTime.now().weekday}", size: 12),
                    ],
                  ),
                  SizedBox(
                    height: 13.s,
                  ),
                  CommonWidget.font(
                      text:
                          "${DateTime.now().hour }: ${DateTime.now().minute}: ${DateTime.now().second}",
                      size: 31),
                  SizedBox(
                    height: 18.s,
                  ),
                  Divider(height: 1.s, color: Color.fromRGBO(238, 238, 238, 1)),
                  SizedBox(
                    height: 18.s,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: CommonWidget.button(
                            text: "考勤记录", width: 75.s, height: 30.s),
                        onTap: () {
                          RouterUtil.push(context,
                              routerName: "attendanceShow",
                              data: json.decode(SynchronizePreferences.Get(
                                  "userInfo"))["id"]);
                        },
                      ),
                      SizedBox(
                        width: 80.s,
                      ),
                      GestureDetector(
                        child: CommonWidget.customButton(
                            text: "考勤规则",
                            width: 75.s,
                            height: 30.s,
                            buttonColor: hasRuleFlag
                                ? Color.fromRGBO(39, 153, 93, 1)
                                : Colors.grey),
                        onTap: () {
                          if (!hasRuleFlag) {
                            return;
                          }
                          showDialog(
                              context: context,
                              builder: (context) => Center(
                                    child: Container(
                                      width: 285.s,
                                      height: 210.s,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            18.s, 25.s, 0, 30.s),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonWidget.font(
                                                text: "考勤时间",
                                                color: Color.fromRGBO(
                                                    39, 153, 93, 1)),
                                            SizedBox(
                                              height: 20.s,
                                            ),
                                            CommonWidget.font(
                                                text:
                                                    "上班时间  ${timeMap["startTime"].substring(11, 16)}",
                                                size: 13),
                                            SizedBox(
                                              height: 10.s,
                                            ),
                                            CommonWidget.font(
                                                text:
                                                    "下班时间  ${timeMap["endTime"].substring(11, 16)}",
                                                size: 13),
                                            SizedBox(
                                              height: 35.s,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  child: CommonWidget.button(
                                                      text: "知道了",
                                                      width: 85.s,
                                                      height: 28.s),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                      )
                    ],
                  )
                ],
              )),
          Expanded(
            child: Container(
                color: Colors.white,
                width: 375.s,
                child: hasRuleFlag
                    ? Column(children: [
                        SizedBox(
                          height: 30.s,
                        ),
                        Container(
                          width: 345.s,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(233, 245, 238, 1),
                              borderRadius: BorderRadius.circular(5.s)),
                          child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(40.s, 20.s, 40.s, 30.s),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonWidget.font(
                                        text: "上班打卡",
                                        color: Color.fromRGBO(39, 153, 93, 1)),
                                    SizedBox(
                                      height: 10.s,
                                    ),
                                    CommonWidget.font(
                                      text:
                                          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                                    ),
                                    SizedBox(
                                      height: 10.s,
                                    ),
                                    Visibility(
                                      visible:
                                          timeMap["starWorkDetail"] != null,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CommonWidget.font(
                                                  text: "打卡时间",
                                                  color: Color.fromRGBO(
                                                      39, 153, 93, 1)),
                                              SizedBox(
                                                width: 5.s,
                                              ),
                                              timeMap["starWorkDetail"] !=
                                                          null &&
                                                      timeMap["starWorkDetail"]
                                                              ["status"] ==
                                                          1
                                                  ? CommonWidget.customButton(
                                                        text: "正常",
                                                      width: 35.s,
                                                      height: 20.s,
                                                      fontSize: 13.s)
                                                  : CommonWidget.customButton(
                                                      text: "迟到",
                                                      width: 35.s,
                                                      height: 20.s,
                                                      fontSize: 13.s,
                                                      buttonColor: Colors.amber)
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.s,
                                          ),
                                          CommonWidget.font(
                                            text: timeMap["starWorkDetail"] !=
                                                    null
                                                ? "${timeMap["starWorkDetail"]["workTime"]}"
                                                : "",
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                timeMap["starWorkDetail"] != null
                                    ? Container(
                                        width: 95.s,
                                        height: 95.s,
                                        child: Image.network(
                                            "${timeMap["starWorkDetail"]["picUrl"]}"),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            isDismissible: true,
                                            enableDrag: false,
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            builder: (BuildContext context) {
                                              return new Container(
                                                height: 160.0,
                                                child: PhotoSelect(
                                                  isScan: false,
                                                  isVin: false,
                                                  imageNumber: 1,
                                                  type: 3,
                                                  onChanged: (value) {
                                                    setState(
                                                      () {
                                                        print(value);
                                                        clock(value[0], "0");
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                            "Assets/attendance/camera.png")),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.s,
                        ),
                        Container(
                          width: 345.s,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(233, 245, 238, 1),
                              borderRadius: BorderRadius.circular(5.s)),
                          child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(40.s, 20.s, 40.s, 30.s),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonWidget.font(
                                        text: "下班打卡",
                                        color: Color.fromRGBO(39, 153, 93, 1)),
                                    SizedBox(
                                      height: 10.s,
                                    ),
                                    CommonWidget.font(
                                      text:
                                          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                                    ),
                                    SizedBox(
                                      height: 10.s,
                                    ),
                                    Visibility(
                                      visible: timeMap["endWorkDetail"] != null,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CommonWidget.font(
                                                  text: "打卡时间",
                                                  color: Color.fromRGBO(
                                                      39, 153, 93, 1)),
                                              SizedBox(
                                                width: 5.s,
                                              ),
                                              timeMap["endWorkDetail"] !=
                                                          null &&
                                                      timeMap["endWorkDetail"]
                                                              ["status"] ==
                                                          0
                                                  ? CommonWidget.customButton(
                                                      text: "正常",
                                                      width: 35.s,
                                                      height: 20.s,
                                                      fontSize: 13.s)
                                                  : CommonWidget.customButton(
                                                      text: "早退",
                                                      width: 35.s,
                                                      height: 20.s,
                                                      fontSize: 13.s,
                                                      buttonColor: Colors.amber)
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.s,
                                          ),
                                          CommonWidget.font(
                                            text: timeMap["endWorkDetail"] !=
                                                    null
                                                ? "${timeMap["endWorkDetail"]["workTime"]}"
                                                : "",
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                timeMap["endWorkDetail"] != null
                                    ? Container(
                                        width: 95.s,
                                        height: 95.s,
                                        child: Image.network(
                                            "${timeMap["endWorkDetail"]["picUrl"]}"),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            isDismissible: true,
                                            enableDrag: false,
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            builder: (BuildContext context) {
                                              return new Container(
                                                height: 160.0,
                                                child: PhotoSelect(
                                                  isScan: false,
                                                  isVin: false,
                                                  imageNumber: 1,
                                                  type: 3,
                                                  onChanged: (value) {
                                                    setState(
                                                      () {
                                                        print(value);
                                                        if (value != null)
                                                          clock(value[0], "1");
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                            "Assets/attendance/camera.png")),
                              ],
                            ),
                          ),
                        ),
                      ])
                    : Column(
                        children: [
                          SizedBox(
                            height: 30.s,
                          ),
                          CommonWidget.font(text: "没有考勤规则,请联系管理员添加!")
                        ],
                      )),
          )
        ],
      ),
    );
  }
}
