import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/photoSelect.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/common/clipping_picture_demo.dart';
import 'package:spanners/common/commonTools.dart';

import '../employeeRequestApi.dart';

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  //角色列表
  List roleList = [];

  //分组列表
  List groupList = [];

  //员工详情
  Map employDetail = {};

  //图片List
  List imageList = [];

  //员工姓名文本controller
  TextEditingController realNameController = TextEditingController();

  //员工手机号文本controller
  TextEditingController mobileController = TextEditingController();

  //员工工号文本controller
  TextEditingController jobNumberController = TextEditingController();

  @override
  void initState() {
    initData();
  }

  //初始化数据
  initData() {
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
            ;
          }
          setState(() {});
        });
  }

  //插入员工
  insertEmployee() async {
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
    if (employDetail["enterTime"] == null || employDetail["enterTime"] == "") {
      CommonWidget.showAlertDialog("入职时间不能为空");
      return;
    }
    if (employDetail["headUrl"] == null || employDetail["headUrl"] == "") {
      CommonWidget.showAlertDialog("头像不能为空");
      return;
    }
    if (employDetail["workGroupId"] == null ||
        employDetail["workGroupId"] == "") {
      CommonWidget.showAlertDialog("组别不能为空");
      return;
    }
    if (employDetail["roleId"] == null || employDetail["roleId"] == "") {
      CommonWidget.showAlertDialog("角色不能为空");
      return;
    }
    if (realNameController.text == "") {
      CommonWidget.showAlertDialog("员工姓名不能为空");
      return;
    }
    if (mobileController.text == "") {
      CommonWidget.showAlertDialog("手机号不能为空");
      return;
    }
    await EmployeeRequestApi.addEmployeeRequest(
        param: {
          "enterTime": employDetail["enterTime"],
          "gender": employDetail["gender"],
          "jobNumber": jobNumberController.text,
          "headUrl": employDetail["headUrl"],
          "mobile": mobileController.text,
          "realName": realNameController.text,
          "roleId": employDetail["roleId"],
          "workGroupId": employDetail["workGroupId"],
        },
        onSuccess: (data) {
          setState(() {});
          Navigator.pop(context);
        },
        onError: (data) {
          CommonWidget.showAlertDialog(data);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "添加员工"),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.s, 15.s, 45.s, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonWidget.greenFont(text: "员工资料"),
                    ],
                  ),
                ),
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
                                    imageUrl: employDetail["headUrl"] ?? ""),
                                //positioned必须与stack同级
                                Positioned(
                                  top: -6.s,
                                  right: -6.s,
                                  child: GestureDetector(
                                    onTap: () {
                                      employDetail["headUrl"] = null;
                                      setState(() {});
                                    },
                                    child:
                                        Image.asset("Assets/employee/delete.png"),
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
                                      child: ClippingPictureDemo(push: (value) {
                                        employDetail["headUrl"] = value;
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
                  child: Column(
                    children: [
                      CommonWidget.inputRow(
                          rowName: "员工姓名",
                          sizedWidth: 20,
                          textController: realNameController),
                      CommonWidget.inputRow(
                          rowName: "手机号",
                          sizedWidth: 20,
                          textController: mobileController),
                      CommonWidget.chooseRow(
                          lineFlag: false,
                          rowName: "性别",
                          rowValue: employDetail["gender"] != null
                              ? (employDetail["gender"] == 0 ? "男" : "女")
                              : "请选择",
                          textColor: employDetail["enterTime"] == null
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Colors.black,
                          rowValueColor: employDetail["enterTime"] == null
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Colors.black,
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
                                            employDetail["gender"] = 0;
                                          } else {
                                            employDetail["gender"] = 1;
                                          }
                                        });
                                      },
                                    ),
                                  );
                                });
                          })
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
                  child: Column(
                    children: [
                      CommonWidget.chooseDateRow(
                        context,
                        rowText: "入职时间",
                        dateText: employDetail["enterTime"] ?? "请选择",
                        textColor: employDetail["enterTime"] == null
                            ? Color.fromRGBO(164, 164, 164, 1)
                            : Colors.black,
                        onTap: (str, time) {
                          employDetail["enterTime"] =
                              "${time.year}-${time.month}-${time.day}";
                          setState(() {});
                        },
                      ),
                      CommonWidget.inputRow(
                          rowName: "工号",
                          sizedWidth: 20,
                          lineFlag: false,
                          textController: jobNumberController),
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
                  child: Column(
                    children: [
                      CommonWidget.chooseRow(
                          lineFlag: true,
                          rowName: "角色",
                          rowValue: employDetail["roleName"] ?? "请选择",
                          textColor: employDetail["roleName"] == null
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Colors.black,
                          rowValueColor: employDetail["roleName"] == null
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Colors.black,
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
                                        for (int i = 0; i < roleList.length; i++)
                                          roleList[i]["roleName"]
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          employDetail["roleName"] = value;
                                        });
                                      },
                                    ),
                                  );
                                });
                          }),
                      CommonWidget.chooseRow(
                          lineFlag: false,
                          rowName: "组别",
                          rowValue: employDetail["workGroupName"] ?? "请选择",
                          textColor: employDetail["workGroupName"] == null
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Colors.black,
                          rowValueColor: employDetail["workGroupName"] == null
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Colors.black,
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
                                        for (int i = 0; i < groupList.length; i++)
                                          groupList[i]["groupName"]
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          employDetail["workGroupName"] = value;
                                        });
                                      },
                                    ),
                                  );
                                });
                          })
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.s,
                ),
                GestureDetector(
                  child: CommonWidget.button(
                      text: "确认创建", width: 90.s, height: 30.s),
                  onTap: () {
                    insertEmployee();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
