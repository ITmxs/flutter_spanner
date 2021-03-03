import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/photoSelect.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/common/clipping_picture_demo.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';

import '../employeeRequestApi.dart';

class EmployeeDetail extends StatefulWidget {
  //前画面传递的数据
  Map data;

  setData(data) {
    this.data = data;
  }

  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  //员工详情
  Map employDetail = {};

  //修改标志
  bool updateFlag = false;

  //图片List
  List imageList = [];

  //角色列表
  List roleList = [];

  //分组列表
  List groupList = [];

  //工号文本框controller
  TextEditingController jobNumberController = TextEditingController();

  @override
  // ignore: must_call_super
  void initState() {
    initData();
  }

  //初始化数据
  void initData() {
    EmployeeRequestApi.getEmployeeDetailRequest(
        param: {"userId": widget.data["userId"]},
        onSuccess: (data) {
          employDetail = data;
          String a = employDetail["enterTime"];
          employDetail["enterTime"] = a?.substring(0, 10);
          jobNumberController.text = employDetail["jobNumber"];
          setState(() {});
        });
    EmployeeRequestApi.addEmployeeInitRequest(
        param: {"": ""},
        onSuccess: (data) {
          roleList = data["roleList"];
          groupList = data["groupList"];
          for (int i = 0; i < groupList.length; i++) {
            if (groupList[i]["groupName"] == null) {
              groupList.removeAt(i);
              break;
            }
          }
          setState(() {});
        });
  }

//删除员工
  deleteEmployee() async {
    await EmployeeRequestApi.deleteEmployeeRequest(
        param: {"userId": widget.data["userId"]},
        onSuccess: (data) {
          Navigator.pop(context);
        });
  }

//更新员工
  updateEmployee() async {
    for (int i = 0; i < groupList.length; i++) {
      if (groupList[i]["groupName"] == employDetail["workGroupName"]) {
        employDetail["workGroupId"] = groupList[i]["groupId"];
        break;
      }
      ;
    }
    for (int i = 0; i < roleList.length; i++) {
      if (roleList[i]["roleName"] == employDetail["roleName"]) {
        employDetail["roleId"] = roleList[i]["id"];
        break;
      }
      ;
    }
    if (employDetail["gender"] == null || employDetail["gender"] == "") {
      CommonWidget.showAlertDialog("性别不能为空");
      return;
    }
    if (employDetail["enterTime"] == "" || employDetail["enterTime"] == null) {
      CommonWidget.showAlertDialog("入职时间不能为空");
      return;
    }
    if (employDetail["roleId"] == "" || employDetail["roleId"] == null) {
      CommonWidget.showAlertDialog("角色不能为空");
      return;
    }
    if (employDetail["workGroupId"] == "" ||
        employDetail["workGroupId"] == null) {
      CommonWidget.showAlertDialog("组别不能为空");
      return;
    }

    await EmployeeRequestApi.updateEmployeeDetailRequest(
        param: {
          "enterTime": employDetail["enterTime"],
          "gender": employDetail["gender"],
          "headUrl": employDetail["headUrl"],
          "jobNumber": jobNumberController.text,
          "roleId": employDetail["roleId"],
          "workGroupId": employDetail["workGroupId"],
          "userId": widget.data["userId"]
        },
        onSuccess: (data) {
          Navigator.pop(context);
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "员工详情"),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.s, 15.s, 45.s, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.greenFont(text: "员工资料"),
                      GestureDetector(
                        onTap: () {
                          PermissionApi.whetherContain('employee_manage_view')
                              ? print('')
                              : updateFlag = !updateFlag;
                          setState(() {});
                        },
                        child: CommonWidget.font(
                            text: updateFlag == false ? "修改" : "完成",
                            fontWeight: FontWeight.bold,
                            size: 18),
                      )
                    ],
                  ),
                ),
                updateFlag == false
                    ? Column(
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
                                CommonWidget.imageWithLine(
                                    imageUrl: employDetail["headUrl"] ?? "")
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
                    : Column(
                        children: [
                          Container(
                            width: 345.s,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.s),
                                color: Colors.white),
                            padding: EdgeInsets.fromLTRB(15.s, 15.s, 0, 10.s),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonWidget.font(text: "员工照片"),
                                SizedBox(
                                  height: 15.s,
                                ),
                                employDetail["headUrl"] != null
                                    ? Stack(
                                        overflow: Overflow.visible,
                                        children: [
                                          CommonWidget.imageWithLine(
                                              imageUrl:
                                                  employDetail["headUrl"] ??
                                                      ""),
                                          //positioned必须与stack同级
                                          Positioned(
                                            top: -6.s,
                                            right: -6.s,
                                            child: GestureDetector(
                                              onTap: () {
                                                employDetail["headUrl"] = null;
                                                setState(() {});
                                              },
                                              child: Image.asset(
                                                  "Assets/employee/delete.png"),
                                            ),
                                          )
                                        ],
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
                                                child: ClippingPictureDemo(
                                                    push: (value) {
                                                  employDetail["headUrl"] =
                                                      value;
                                                  setState(() {});
                                                }),
                                              );
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                          "Assets/employee/addCamera.png",
                                          width: 91.s,
                                          height: 91.s,
                                        )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.s,
                          ),
                          Container(
                            width: 345.s,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.s),
                                color: Colors.white),
                            padding: EdgeInsets.fromLTRB(15.s, 0.s, 0, 0.s),
                            child: Column(
                              children: [
                                CommonWidget.simpleList(
                                    sizeWidth: 5.s,
                                    mustFlag: false,
                                    bottomLineFlag: true,
                                    valueList: [
                                      employDetail["realName"],
                                      employDetail["mobile"]
                                    ],
                                    keyList: [
                                      "员工名",
                                      "手机号"
                                    ]),
                                CommonWidget.chooseRow(
                                    rowName: "性别",
                                    rowValue: employDetail["gender"] != null
                                        ? (employDetail["gender"] == 0
                                            ? "男"
                                            : "女")
                                        : "请选择",
                                    lineFlag: false,
                                    textController: jobNumberController,
                                    sizedWidth: 20,
                                    onChoose: () {
                                      showModalBottomSheet(
                                          isDismissible: true,
                                          enableDrag: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 300.0,
                                              child: ShowBottomSheet(
                                                type: 6,
                                                dataList: ["男", "女"],
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value == "男") {
                                                      employDetail["gender"] =
                                                          0;
                                                    } else {
                                                      employDetail["gender"] =
                                                          1;
                                                    }
                                                  });
                                                },
                                              ),
                                            );
                                          });
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.s,
                          ),
                          Container(
                            width: 345.s,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.s),
                                color: Colors.white),
                            padding: EdgeInsets.fromLTRB(15.s, 0.s, 0, 0.s),
                            child: Column(
                              children: [
                                CommonWidget.chooseDateRow(context,
                                    rowText: "入职时间",
                                    dateText: employDetail["enterTime"] ??
                                        "请选择", onTap: (str, time) {
                                  employDetail["enterTime"] =
                                      "${time.year}-${time.month}-${time.day}";
                                  setState(() {});
                                }),
                                CommonWidget.inputRow(
                                    rowName: "工号",
                                    sizedWidth: 0,
                                    textController: jobNumberController,
                                    lineFlag: false),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.s,
                          ),
                          Container(
                            width: 345.s,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.s),
                                color: Colors.white),
                            padding: EdgeInsets.fromLTRB(15.s, 0.s, 0, 10.s),
                            child: Column(
                              children: [
                                CommonWidget.chooseRow(
                                    rowName: "角色",
                                    rowValue: employDetail["roleName"] ?? "请选择",
                                    lineFlag: true,
                                    sizedWidth: 20,
                                    onChoose: () {
                                      showModalBottomSheet(
                                          isDismissible: true,
                                          enableDrag: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 300.0,
                                              child: ShowBottomSheet(
                                                type: 7,
                                                dataList: [
                                                  for (int i = 0;
                                                      i < roleList.length;
                                                      i++)
                                                    roleList[i]["roleName"]
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    employDetail["roleName"] =
                                                        value;
                                                  });
                                                },
                                              ),
                                            );
                                          });
                                    }),
                                CommonWidget.chooseRow(
                                    rowName: "组别",
                                    rowValue:
                                        employDetail["workGroupName"] ?? "请选择",
                                    lineFlag: false,
                                    textController: jobNumberController,
                                    sizedWidth: 20,
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
                                                  for (int i = 0;
                                                      i < groupList.length;
                                                      i++)
                                                    groupList[i]["groupName"]
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    employDetail[
                                                            "workGroupName"] =
                                                        value;
                                                  });
                                                },
                                              ),
                                            );
                                          });
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                Visibility(
                  visible: updateFlag,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(50.s, 50.s, 50.s, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            deleteEmployee();
                          },
                          child: CommonWidget.button(
                              text: "删除员工", width: 90.s, height: 30.s),
                        ),
                        GestureDetector(
                          onTap: () {
                            updateEmployee();
                          },
                          child: CommonWidget.button(
                              text: "保存修改", width: 90.s, height: 30.s),
                        )
                      ],
                    ),
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
