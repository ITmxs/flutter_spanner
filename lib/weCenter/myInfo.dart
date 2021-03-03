import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/employee/employeeRequestApi.dart';
import 'package:spanners/common/commonTools.dart';

/// Copyright (C), 2015-2020, spanners
/// FileName: myInfo
/// Author: Jack
/// Date: 2020/12/2
/// Description:

class MyInfo extends StatefulWidget {
  @override
  _MyInfoState createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  //员工详情
  Map employDetail = {};

  void initState() {
    initData();
  }

  //初始化数据
  initData() {
    EmployeeRequestApi.getEmployeeDetailRequest(
        param: {
          "userId": json.decode(SynchronizePreferences.Get("userInfo"))["id"]
        },
        onSuccess: (data) {
          employDetail = data;
          String a = employDetail["enterTime"];
          employDetail["enterTime"] = a?.substring(0, 10);
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "个人信息"),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20.s,
                ),
                Column(
                  children: [
                    Container(
                      width: 345.s,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.s),
                          color: Colors.white),
                      padding: EdgeInsets.fromLTRB(15.s, 15.s, 0, 0.s),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidget.font(text: "员工照片"),
                          SizedBox(
                            height: 15.s,
                          ),
                          Visibility(
                            visible: employDetail["headUrl"] != null,
                            child: CommonWidget.imageWithLine(
                                imageUrl: employDetail["headUrl"] ?? ""),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.s,
                    ),
                    Container(
                      width: 345.s,
                      color: Colors.white,
                      child: CommonWidget.simpleList(keyList: [
                        "员工姓名",
                        "手机号",
                        "性别"
                      ], valueList: [
                        employDetail["realName"],
                        employDetail["mobile"],
                        employDetail["gender"] == 0 ? "男" : "女"
                      ], mustFlag: false),
                    ),
                    SizedBox(
                      height: 5.s,
                    ),
                    Container(
                      width: 345.s,
                      color: Colors.white,
                      child: CommonWidget.simpleList(keyList: [
                        "入职时间",
                        "工号"
                      ], valueList: [
                        employDetail["enterTime"],
                        employDetail["jobNumber"]
                      ], mustFlag: false),
                    ),
                    SizedBox(
                      height: 5.s,
                    ),
                    Container(
                      width: 345.s,
                      color: Colors.white,
                      child: CommonWidget.simpleList(keyList: [
                        "角色",
                        "组别"
                      ], valueList: [
                        employDetail["roleName"],
                        employDetail["workGroupName"]
                      ], mustFlag: false),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
