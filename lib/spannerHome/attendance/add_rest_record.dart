import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/employee/employeeRequestApi.dart';

import 'attendanceApi.dart';
import 'attendance_rule.dart';

/// Copyright (C), 2015-2020, spanners
/// FileName: add_rest_record
/// Author: Jack
/// Date: 2020/11/25
/// Description:

class AddRestRecord extends StatefulWidget {
  @override
  _AddRestRecordState createState() => _AddRestRecordState();
}

class _AddRestRecordState extends State<AddRestRecord> {
  //员工列表
  List employList = [];

  //休息记录
  Map restRecord = {};

  //休假 true 请假 false
  bool restFlag = true;

  //考勤时间
  String ruleTime;

  //开始时间
  DateTime startTime;

  //结束时间
  DateTime endTime;

  //用户id
  String userId;

  //备注文本框控制器
  TextEditingController commentController = TextEditingController();
  TextEditingController hourController = TextEditingController();

  @override
  void initState() {
    initData();
  }

  //初始化数据
  initData()  {
     EmployeeRequestApi.getEmployeeListRequest(
        param: {"": ""},
        onSuccess: (data) {
          employList = data["employeeList"];
          setState(() {});
        });
  }

  //获取考勤时间
  getRule(String name) async {
    ruleTime = null;
    for (var item in employList) {
      if (name == item["realName"]) {
        userId = item["userId"];
        break;
      }
    }
    await AttendanceApi.getAttRuleRequest(
        param: {"userId": userId},
        onSuccess: (data) {
          int time = int.parse(data["endTime"]?.substring(11, 13)) -
              int.parse(data["startTime"]?.substring(11, 13));
          ruleTime =
              "${data["startTime"]?.substring(11, 16)}~${data["endTime"]?.substring(11, 16)}($time)h";
          print(ruleTime);
          setState(() {});
        });
  }

  addRestRecord() async {
    await AttendanceApi.saveLeaveRequest(
        param: {
          "beginTime":
              "${startTime.year}-${startTime.month}-${startTime.day} ${startTime.hour}:${startTime.minute}",
          "comment": "${commentController.text}",
          "duration": int.parse(hourController.text),
          "endTime":
              "${endTime.year}-${endTime.month}-${endTime.day} ${endTime.hour}:${endTime.minute}",
          "type": restFlag ? 0 : 1,
          "userId": userId
        },
        onSuccess: (data) {
          setState(() {});
          Navigator.pop(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "添加休假记录"),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(80.s, 15.s, 80.s, 15.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CommonWidget.picCheckBox(
                              checkFlag: restFlag,
                              onTap: () {
                                restFlag = !restFlag;
                                setState(() {});
                              }),
                          CommonWidget.font(text: "休假")
                        ],
                      ),
                      Row(
                        children: [
                          CommonWidget.picCheckBox(
                              checkFlag: !restFlag,
                              onTap: () {
                                restFlag = !restFlag;
                                setState(() {});
                              }),
                          CommonWidget.font(text: "请假")
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: 345.s,
                  height: 50.s,
                  margin: EdgeInsets.fromLTRB(20.s, 0, 20.s, 5.s),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.s)),
                  child: CommonWidget.chooseRow(
                      rowName: "员工姓名",
                      rowValue: restRecord["employeeName"] ?? "请选择",
                      rowValueColor: restRecord["employeeName"] != null
                          ? Colors.black
                          : Color.fromRGBO(199, 199, 199, 1),
                      textColor: Color.fromRGBO(199, 199, 199, 1),
                      onChoose: () {
                        showModalBottomSheet(
                            isDismissible: true,
                            enableDrag: false,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 300.0,
                                child: ShowBottomSheet(
                                  type: 8,
                                  dataList: [
                                    for (int i = 0; i < employList.length; i++)
                                      employList[i]["realName"]
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      print(value);
                                      getRule(value);
                                      restRecord["employeeName"] = value;
                                    });
                                  },
                                ),
                              );
                            });
                      }),
                ),
                Container(
                  width: 345.s,
                  height: 50.s,
                  margin: EdgeInsets.fromLTRB(20.s, 0, 20.s, 5.s),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.s)),
                  child: CommonWidget.chooseDateRow(
                    context,
                    rowText: "开始时间",
                    dateText: restRecord["startDate"] ?? "请选择",
                    dateType: DateType.YMD_HM,
                    textColor: restRecord["startDate"] == null
                        ? Color.fromRGBO(164, 164, 164, 1)
                        : Colors.black,
                    onTap: (str, time) {
                      setState(() {
                        restRecord["startDate"] = str;
                        startTime = time;
                      });
                    },
                  ),
                ),
                Container(
                  width: 345.s,
                  height: 50.s,
                  margin: EdgeInsets.fromLTRB(20.s, 0, 20.s, 5.s),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.s)),
                  child: CommonWidget.chooseDateRow(
                    context,
                    rowText: "结束时间",
                    dateText: restRecord["endDate"] ?? "请选择",
                    dateType: DateType.YMD_HM,
                    textColor: restRecord["endDate"] == null
                        ? Color.fromRGBO(164, 164, 164, 1)
                        : Colors.black,
                    onTap: (str, time) {
                      setState(() {
                        restRecord["endDate"] = str;
                        endTime = time;
                      });
                    },
                  ),
                ),
                Container(
                    width: 345.s,
                    height: 50.s,
                    padding: EdgeInsets.fromLTRB(5.s, 0, 15.s, 0),
                    margin: EdgeInsets.fromLTRB(20.s, 0, 20.s, 5.s),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.s)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidget.font(text: "时长（小时）"),
                        Container(
                          width: 200.s,
                          child: CommonWidget.textField(
                              hintText: "请输入时长",
                              textAlign: TextAlign.end,
                              textController: hourController),
                        )
                      ],
                    )),
                Visibility(
                  visible: ruleTime != null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CommonWidget.font(
                          text: "考勤规则   $ruleTime",
                          color: Color.fromRGBO(138, 138, 138, 1),
                          size: 13),
                      SizedBox(
                        width: 50.s,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.s,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 5.s),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidget.font(text: "备注"),
                      SizedBox(
                        height: 20.s,
                      ),
                      Container(
                        width: 345.s,
                        height: 90.s,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.s)),
                        child: CommonWidget.textField(
                            hintText: "请填写您需要备注的信息",
                            textController: commentController),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 55.s,
                ),
                GestureDetector(
                  child: CommonWidget.button(
                      text: "确认添加", width: 110.s, height: 30.s),
                  onTap: () {
                    addRestRecord();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
