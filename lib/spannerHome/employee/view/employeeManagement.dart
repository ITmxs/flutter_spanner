import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';

import '../employeeRequestApi.dart';

class EmployeeManagement extends StatefulWidget {
  @override
  _EmployeeManagementState createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {
  //分组员工列表
  List employeeGroupList = [];

  //分组列表
  List groupList = [];

  @override
  void initState() {
    initData();
  }

  //初始化数据
  initData() {
    EmployeeRequestApi.getEmployeeListRequest(
        param: {"": ""},
        onSuccess: (data) {
          groupList = data["groupList"];
          initEmployeeList(data["employeeList"]);
          setState(() {});
        });
  }

  //初始化员工列表
  initEmployeeList(data) {
    funcA:
    for (int i = 0; i < data.length; i++) {
      if (employeeGroupList.length == 0 && data[i]["groupName"] != null) {
        employeeGroupList.add({
          "groupId": data[i]["groupId"],
          "groupName": data[i]["groupName"] ??= "未命名",
          "showFlag": true,
          "employeeList": []
        });
        employeeGroupList[i]["employeeList"].add(data[i]);
        continue;
      }

      for (int j = 0; j < employeeGroupList.length; j++) {
        if (data[i]["groupId"] == employeeGroupList[j]["groupId"]) {
          employeeGroupList[j]["employeeList"].add(data[i]);
          continue funcA;
        }
      }
      employeeGroupList.add({
        "groupId": data[i]["groupId"],
        "groupName": data[i]["groupName"] ??= "未分组",
        "showFlag": true,
        "employeeList": []
      });
      employeeGroupList[employeeGroupList.length - 1]["employeeList"]
          .add(data[i]);
    }
    for (int i = 0; i < employeeGroupList.length; i++) {
      for (int j = 0; j < groupList.length; j++) {
        if (employeeGroupList[i]["groupName"] == groupList[j]["groupName"] ||
            groupList[j]["groupName"] == null) {
          groupList.removeAt(j);
        }
      }
    }
    employeeGroupList.addAll(groupList);
    for (int i = 0; i < employeeGroupList.length; i++) {
      if (employeeGroupList[i]["groupName"] == "未分组") {
        Map tempList = employeeGroupList[i];
        employeeGroupList.removeAt(i);
        employeeGroupList.add(tempList);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.iconAppBar(context, "员工管理",
          rIcon: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 30.s, 0),
            child: Row(
              children: [
                GestureDetector(
                  child: Image.asset(
                    "Assets/employee/group.png",
                    width: 26.s,
                    height: 23.s,
                  ),
                  //直接放方法会报错
                  onTap: () {
                    PermissionApi.whetherContain('employee_manage_view')
                        ? print('')
                        : RouterUtil.push(context, routerName: "groupList",
                            pushThen: (value) {
                            employeeGroupList = [];
                            groupList = [];
                            initData();
                          });
                  },
                ),
                SizedBox(
                  width: 8.s,
                ),
                GestureDetector(
                  onTap: () {
                    PermissionApi.whetherContain('employee_manage_view')
                        ? print('')
                        : RouterUtil.push(context, routerName: "addEmployee",
                            pushThen: (value) {
                            employeeGroupList = [];
                            groupList = [];
                            initData();
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
            for (int i = 0; i < employeeGroupList.length; i++)
              Container(
                margin: EdgeInsets.fromLTRB(15.s, 10.s, 15.s, 0),
                child: Column(
                  children: [
                    Container(
                      width: 345.s,
                      height: 30.s,
                      padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.s),
                          color: Color.fromRGBO(39, 153, 93, 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonWidget.font(
                              text:
                                  "${employeeGroupList[i]["groupName"]}（${(employeeGroupList[i].containsKey("employeeList")) ? (employeeGroupList[i]["employeeList"].length) : 0}人）",
                              color: Colors.white),
                          GestureDetector(
                            onTap: () {
                              employeeGroupList[i]["showFlag"] =
                                  !employeeGroupList[i]["showFlag"];
                              setState(() {});
                            },
                            child: employeeGroupList[i]["showFlag"] == true
                                ? Image.asset(
                                    "Assets/employee/up.png",
                                    width: 17.s,
                                    height: 10.s,
                                  )
                                : Image.asset(
                                    "Assets/employee/down.png",
                                    width: 17.s,
                                    height: 10.s,
                                  ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: employeeGroupList[i]["showFlag"] ?? false,
                      child: Column(
                        children: [
                          for (int j = 0;
                              j <
                                  ((employeeGroupList[i]
                                          .containsKey("employeeList"))
                                      ? (employeeGroupList[i]["employeeList"]
                                          .length)
                                      : 0);
                              j++)
                            GestureDetector(
                              onTap: () {
                                RouterUtil.push(context,
                                    routerName: "employeeDetail",
                                    data: {
                                      "userId": employeeGroupList[i]
                                          ["employeeList"][j]["userId"]
                                    }, pushThen: (value) {
                                  employeeGroupList = [];
                                  groupList = [];
                                  initData();
                                });
                              },
                              child: Container(
                                height: 120.s,
                                width: 345.s,
                                color: Colors.white,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 5.s),
                                padding:
                                    EdgeInsets.fromLTRB(20.s, 15.s, 0, 15.s),
                                child: Row(
                                  children: [
                                    Image.network(
                                      employeeGroupList[i]["employeeList"][j]
                                          ["headUrl"],
                                      width: 90.s,
                                      height: 90.s,
                                    ),
                                    SizedBox(
                                      width: 15.s,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10.s,
                                        ),
                                        CommonWidget.font(
                                            text:
                                                "${employeeGroupList[i]["employeeList"][j]["realName"]}（${employeeGroupList[i]["employeeList"][j]["roleName"]}）"),
                                        SizedBox(
                                          height: 15.s,
                                        ),
                                        CommonWidget.font(
                                            text:
                                                "${employeeGroupList[i]["employeeList"][j]["userPhone"]}")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
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
