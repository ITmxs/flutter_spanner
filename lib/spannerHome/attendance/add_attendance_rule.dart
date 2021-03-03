import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/common/commonTools.dart';

import 'attendanceApi.dart';
import 'model/employee_group_model.dart';

/// Copyright (C), 2015-2020, spanners
/// FileName: add_attendance_rule
/// Author: Jack
/// Date: 2020/11/26
/// Description:
class AddAttendanceRule extends StatefulWidget {
  @override
  _AddAttendanceRuleState createState() => _AddAttendanceRuleState();
}

class _AddAttendanceRuleState extends State<AddAttendanceRule> {
  Map ruleInfo = {};
  List<EmployByGroupModel> employList = [];

  @override
  void initState() {
    initData();
  }

  //初始化数据
  initData()  {
     AttendanceApi.getWorkgroupAttListRequest(
      param: {'': ""},
      onSuccess: (data) {
        for (var item in data) {
          employList.add(EmployByGroupModel.fromJson(item));
        }
        setState(() {});
      },
    );
  }
  //添加规则
  addRule() async {
    List personGroupList = [];
    for(var item in employList){
      if(item.chooseFlag == true){
        for(var list in item.personGroupList){
          personGroupList.add({"userId":list.userId,"userName":list.userName});
        }

      }
      else{
        for(var list in item.personGroupList){
          if(list.chooseFlag == true) personGroupList.add({"userId":list.userId,"userName":list.userName});
        }
      }
    }
    print(personGroupList);

    await AttendanceApi.addAttRuleRequest(
      param: {
        "inWorkTime": ruleInfo["startDate"] ,
        "outWorkTime": ruleInfo["endDate"] ,
        "personGroupList": personGroupList,
      },
      onSuccess: (data) {
        Navigator.pop(context);

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "添加规则"),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            time(),
            people(),
            SizedBox(
              height: 100.s,
            ),
            GestureDetector(
              onTap: (){
                addRule();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonWidget.button(text: "保存", width: 92.s, height: 30.s),
                  SizedBox(
                    height: 20.s,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  //考勤时间
  time() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25.s, 20.s, 0, 10.s),
          child: CommonWidget.font(
              text: "考勤时间", size: 18, color: Color.fromRGBO(39, 153, 93, 1)),
        ),
        Container(
          width: 345.s,
          height: 50.s,
          margin: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5.s)),
          child: CommonWidget.chooseDateRow(
            context,
            rowText: "上班时间",
            dateText: ruleInfo["startDate"] ?? "请选择",
            dateType: DateType.HM,
            textColor: ruleInfo["startDate"] == null
                ? Color.fromRGBO(164, 164, 164, 1)
                : Colors.black,
            onTap: (str, time) {
              setState(() {
                ruleInfo["startDate"] =
                    "${(time.hour.toString().length > 1) ? time.hour : ("0" + time.hour.toString())}:${(time.minute.toString().length > 1) ? time.minute : ("0" + time.minute.toString())}";
              });
            },
          ),
        ),
        Container(
          width: 345.s,
          height: 50.s,
          margin: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0.s),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5.s)),
          child: CommonWidget.chooseDateRow(
            context,
            rowText: "下班时间",
            dateText: ruleInfo["endDate"] ?? "请选择",
            dateType: DateType.HM,
            textColor: ruleInfo["endDate"] == null
                ? Color.fromRGBO(164, 164, 164, 1)
                : Colors.black,
            onTap: (str, time) {
              setState(() {
                ruleInfo["endDate"] =
                    "${(time.hour.toString().length > 1) ? time.hour : ("0" + time.hour.toString())}:${(time.minute.toString().length > 1) ? time.minute : ("0" + time.minute.toString())}";
              });
            },
          ),
        ),
      ],
    );
  }
  //考勤人员
  people() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25.s, 20.s, 0, 10.s),
          child: CommonWidget.font(
              text: "考勤人员", size: 18, color: Color.fromRGBO(39, 153, 93, 1)),
        ),
        for (EmployByGroupModel item in employList)
          Container(
            width: 345.s,
            margin: EdgeInsets.fromLTRB(20.s, 0, 20.s, 10.s),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5.s)),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: CommonWidget.grayBottomBorder(),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5.s,
                                  ),
                                  CommonWidget.circleCheckBox(
                                      checkFlag: item.chooseFlag,
                                      onTap: () {
                                        item.chooseFlag = !item.chooseFlag;
                                        setState(() {});
                                      }),
                                  SizedBox(
                                    width: 5.s,
                                  ),
                                  CommonWidget.font(text: item.groupName)
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      item.showFlag = !item.showFlag;
                                      setState(() {});
                                    },
                                    child: item.showFlag
                                        ? Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Color.fromRGBO(
                                                189, 189, 189, 1),
                                          )
                                        : Icon(
                                            Icons.chevron_right,
                                            color: Color.fromRGBO(
                                                189, 189, 189, 1),
                                          ),
                                  ),
                                  SizedBox(
                                    width: 5.s,
                                  )
                                ],
                              ),
                            ],
                          ),
                          width: 335.s,
                          height: 45.s,
                        )
                      ],
                    ),
                    if (item.showFlag)
                      for (PersonGroupList list in item.personGroupList)
                        Container(
                          decoration: (list !=
                                  item.personGroupList[
                                      item.personGroupList.length - 1])
                              ? CommonWidget.grayBottomBorder()
                              : null,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5.s,
                              ),
                              CommonWidget.circleCheckBox(
                                  checkFlag: list.chooseFlag || item.chooseFlag,
                                  onTap: () {
                                    list.chooseFlag = !list.chooseFlag;
                                    setState(() {});
                                  }),
                              SizedBox(
                                width: 5.s,
                              ),
                              CommonWidget.font(text: list.userName),
                            ],
                          ),
                          width: 335.s,
                          height: 45.s,
                        )
                  ],
                ),
              ],
            ),
          )
      ],
    );
  }
}
