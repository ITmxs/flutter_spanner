import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/common/commonTools.dart';

import 'attendanceApi.dart';
import 'model/attendance_model.dart';

/// Copyright (C), 2015-2020, spanners
/// FileName: add_rule
/// Author: Jack
/// Date: 2020/11/25
/// Description:
class AttendanceRule extends StatefulWidget {
  @override
  _AttendanceRuleState createState() => _AttendanceRuleState();
}

class _AttendanceRuleState extends State<AttendanceRule> {
  @override
  void initState() {
    initData();
  }

  AttendanceModel attendanceModel;

  //初始化数据
  initData() {
    AttendanceApi.attendanceRuleListRequest(
      param: {'': ""},
      onSuccess: (data) {
        attendanceModel =
            AttendanceModel(attendanceRuleLists: data["attendanceRuleLists"]);
        setState(() {});
      },
    );
  }

  //删除规则
  deleteRule(ruleId) {
    AttendanceApi.deleteRuleRequest(
      param: ruleId,
      onSuccess: (data) {
        initData();
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.iconAppBar(context, "考勤规则",
          rIcon: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 30.s, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    RouterUtil.push(context, routerName: "addAttendanceRule",
                        pushThen: (value) {
                      attendanceModel = null;
                      initData();
                      setState(() {});
                    });
                  },
                  child: Image.asset(
                    "Assets/employee/add.png",
                    width: 23.s,
                    height: 23.s,
                  ),
                ),
              ],
            ),
          )),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(height: 20.s),
                if (attendanceModel != null)
                  for (var rule in attendanceModel.attendanceRuleLists)
                    Container(
                      width: 345.s,
                      padding: EdgeInsets.fromLTRB(15.s, 20.s, 20.s, 15.s),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20.s),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.s)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidget.font(
                              text: "考勤时间",
                              color: Color.fromRGBO(39, 153, 93, 1)),
                          SizedBox(height: 15.s),
                          CommonWidget.font(text: "上班时间：${rule["inWorkTime"]}"),
                          SizedBox(height: 15.s),
                          CommonWidget.font(text: "下班时间：${rule["outWorkTime"]}"),
                          SizedBox(
                            height: 25.s,
                          ),
                          CommonWidget.font(
                              text: "考勤人员",
                              color: Color.fromRGBO(39, 153, 93, 1)),
                          SizedBox(
                            height: 15.s,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidget.font(text: "姓       名 : "),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var group in rule["attDtos"])
                                    Row(
                                      children: [
                                        CommonWidget.font(
                                            text: group["groupName"]),
                                        SizedBox(
                                          width: 5.s,
                                        ),
                                        for (int i = 0;
                                            i < group["personGroupList"].length &&
                                                i < 4;
                                            i++)
                                          Row(
                                            children: [
                                              CommonWidget.font(
                                                  text: group["personGroupList"]
                                                      [i]["userName"]),
                                              if (i <
                                                      group["personGroupList"]
                                                              .length -
                                                          1 &&
                                                  i < 3)
                                                CommonWidget.font(text: " / ")
                                            ],
                                          )
                                      ],
                                    )
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(60.s, 45.s, 60.s, 20.s),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: CommonWidget.button(
                                      text: "删除", width: 65.s, height: 30.s),
                                  onTap: () {
                                    deleteRule(rule["ruleId"]);
                                  },
                                ),
                                GestureDetector(
                                  child: CommonWidget.button(
                                      text: "修改", width: 65.s, height: 30.s),
                                  onTap: () {
                                    RouterUtil.push(context,
                                        routerName: 'updateAttendanceRule',
                                        data: rule, pushThen: (value) {
                                      attendanceModel = null;
                                      initData();
                                      setState(() {});
                                    });
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
              ],
            )
          ],
        ),
      ),
    );
  }
}
