import 'package:flutter/material.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/common/commonRouter.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/attendance/attendanceApi.dart';
import 'package:spanners/spannerHome/attendance/attendanceShow.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool dateShow = true; //默认显示 日
  DateTime date = DateTime.now();
  DateTime monthDay = DateTime.now();
  DateTime nowTime = DateTime.now();
  String timeShow; //用于展示时间
  List items = [
    '平均工时（h）',
    '出勤（天）',
    '迟到（次）',
    '早退（次）',
    '缺卡（次）',
    '旷工（天）',
    '请假（h）',
    '休假（h）'
  ];

  //日考勤信息
  List attendanceList = [];

  //日缺勤信息
  List absentRecordList = [];

  //月考勤信息
  List attendanceMonthList = [];

  //日考勤分析
  _getInitDetail(String date) {
    AttendanceApi.initDetailRequest(
      param: {'date': date},
      onSuccess: (data) {
        print(data);
        attendanceList = data["attendanceDetailDtos"];
        setState(() {});
      },
    );
  }

  //月考勤分析
  _getInitMonth(String date) {
    AttendanceApi.attendancePersonMonthRequest(
      param: {'month': date},
      onSuccess: (data) {
        attendanceMonthList = data;
        for (var item in attendanceMonthList) {
          item["showFlag"] = true;
        }
        print(attendanceMonthList);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeShow = FormatUtil.formatDateYMD(nowTime);
    _getInitDetail(timeShow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 1,
        brightness: Brightness.light,
        title: Text(
          '考勤分析',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          InkWell(
            onTap: () {
         RouterUtil.push(context, routerName: "addRestRecord");            },
            child: Image.asset(
              'Assets/attendance/rest.png',
              width: 26,
              height: 26,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {

              RouterUtil.push(context, routerName: "attendanceRule");
            },
            child: Image.asset(
              'Assets/attendance/date.png',
              width: 26,
              height: 26,
            ),
          ),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            dateLoad(),
            dateShow ? dayListView() : monthListView(),
          ],
        ),
      ),
    );
  }

//考勤 日期筛选
  dateLoad() {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        //-->   日
        InkWell(
          onTap: () {
            setState(() {
              dateShow = true;
              timeShow =
                  '${date == null ? nowTime.year : date.year}-${date == null ? nowTime.month : date.month}-${date == null ? nowTime.day : date.day}';
            });
          },
          child: Container(
            width: 45,
            height: 25,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Color.fromRGBO(39, 153, 93, 1), width: 2.0),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
              color: dateShow
                  ? Color.fromRGBO(39, 153, 93, 1)
                  : Color.fromRGBO(255, 255, 255, 1),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '日',
                style: TextStyle(
                  color: dateShow
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(10, 10, 10, 1),
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
//-->  月
        InkWell(
          onTap: () {
            setState(() {
              dateShow = false;
              timeShow = date == null ?FormatUtil.formatDateYM(nowTime):FormatUtil.formatDateYM(date);
              _getInitMonth(timeShow);
            });
          },
          child: Container(
            width: 45,
            height: 25,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Color.fromRGBO(39, 153, 93, 1), width: 2.0),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              color: dateShow
                  ? Color.fromRGBO(255, 255, 255, 1)
                  : Color.fromRGBO(39, 153, 93, 1),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '月',
                style: TextStyle(
                  color: dateShow
                      ? Color.fromRGBO(10, 10, 10, 1)
                      : Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
        Expanded(child: SizedBox()),
        //日期选择
        InkWell(
          onTap: () {
            YinPicker.showDatePicker(context,
                nowTimes: date == null ? nowTime : date,
                dateType: dateShow ? DateType.YMD : DateType.YM,
                // dateType: DateType.YM,
                // dateType: DateType.YMD_HM,
                // dateType: DateType.YMD_AP_HM,
                title: "",
                minValue: DateTime(
                  2015,
                  10,
                ),
                maxValue: DateTime(
                  2023,
                  10,
                ),
                value: date == null
                    ? DateTime(nowTime.year, nowTime.month, nowTime.day)
                    : DateTime(date.year, date.month, date.day),
                clickCallback: (var str, var time) {
              setState(() {
                dateShow
                    ? timeShow =
                        '${time.year}-${(time.month.toString().length > 1) ? time.month : ("0" + time.month.toString())}-${(time.day.toString().length > 1) ? time.day : ("0" + time.day.toString())}'
                    : timeShow =
                        '${time.year}-${(time.month.toString().length > 1) ? time.month : ("0" + time.month.toString())}';
                dateShow ? _getInitDetail(timeShow) : _getInitMonth(timeShow);

                //_getBudgetMessage(timeShow);
                date = time;
              });
            });
            //日期时间选择 年月日
          },
          child: Container(
            width: dateShow ? 110 : 90,
            height: 25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: Color.fromRGBO(186, 224, 204, 1), width: 1.0),
                color: Color.fromRGBO(255, 255, 255, 1)),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  timeShow,
                  style: TextStyle(
                    color: Color.fromRGBO(8, 8, 8, 1),
                    fontSize: 13,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Color.fromRGBO(8, 8, 8, 1),
                )
              ],
            ),
          ),
        ),

        SizedBox(
          width: 30,
        )
      ],
    );
  }

// 日  列表展示
  dayListView() {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: attendanceList.length ?? 0,
            itemBuilder: (BuildContext context, int item) {
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  //展示部分
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),

                      //记录
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  10 -
                                  30 -
                                  12,
                              child: Row(
                                children: [
                                  Text(
                                    attendanceList[item]["userName"],
                                    style: TextStyle(
                                        color: Color.fromRGBO(10, 10, 10, 1),
                                        fontSize: 14),
                                  ),
                                  Expanded(child: SizedBox()),
                                  GestureDetector(
                                    onTap: () {
                                      RouterUtil.push(context,
                                          routerName: "attendanceShow",
                                          data: attendanceList[item]["id"]);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '详情',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(39, 153, 93, 1),
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            //打卡状态
                            Row(
                              children: [
                                Container(
                                  width: 35,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: attendanceList[item]
                                                  ["onWorkFlg"] ==
                                              "0"
                                          ? Color.fromRGBO(39, 153, 93, 1)
                                          : ((attendanceList[item]
                                                      ["onWorkFlg"] ==
                                                  "1")
                                              ? Color.fromRGBO(255, 77, 76, 1)
                                              : Color.fromRGBO(
                                                  255, 206, 95, 1))),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${(attendanceList[item]["onWorkFlg"] == "0" ? "正常" : ((attendanceList[item]["onWorkFlg"] == "1") ? "缺卡" : "迟到"))}',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  '上班打卡  ${attendanceList[item]["onWorkTime"]}',
                                  style: TextStyle(
                                      color: Color.fromRGBO(34, 34, 34, 1),
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 35,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: attendanceList[item]
                                                  ["outWorkFlg"] ==
                                              "0"
                                          ? Color.fromRGBO(39, 153, 93, 1)
                                          : ((attendanceList[item]
                                                      ["outWorkFlg"] ==
                                                  "1")
                                              ? Color.fromRGBO(255, 77, 76, 1)
                                              : Color.fromRGBO(
                                                  255, 206, 95, 1))),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${(attendanceList[item]["outWorkFlg"] == "0" ? "正常" : ((attendanceList[item]["outWorkFlg"] == "1") ? "缺卡" : "早退"))}',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  '下班打卡   ${attendanceList[item]["outWorkTime"]}',
                                  style: TextStyle(
                                      color: Color.fromRGBO(34, 34, 34, 1),
                                      fontSize: 15),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //分割线
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: 1,
                        color: Color.fromRGBO(238, 238, 238, 1),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  )
                ],
              );
            }),
        for (var item in absentRecordList)
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              //展示部分
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  //头像
                  SizedBox(
                    width: 14,
                  ),
                  //记录
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 40 - 12,
                          child: Row(
                            children: [
                              Text(
                                item["userName"],
                                style: TextStyle(
                                    color: Color.fromRGBO(10, 10, 10, 1),
                                    fontSize: 14),
                              ),
                              Expanded(child: SizedBox()),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AttendanceShow()));
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '详情',
                                    style: TextStyle(
                                        color: Color.fromRGBO(39, 153, 93, 1),
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        //打卡状态
                        Row(
                          children: [
                            Container(
                              width: 35,
                              height: 18,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromRGBO(243, 152, 0, 1)),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  //  '${(attendanceList[item]["onWorkFlg"] == 0 ? "正常" : ((attendanceList[item]["onWorkFlg"] == 1) ? "缺卡" : "迟到"))}',
                                  "休假",
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              //分割线
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 1,
                    color: Color.fromRGBO(238, 238, 238, 1),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              )
            ],
          )
      ],
    );
  }

// 月  列表展示
  monthListView() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: attendanceMonthList.length,
        itemBuilder: (BuildContext context, int item) {
          return Column(
            children: [
              item == 0
                  ? SizedBox(
                      height: 22,
                    )
                  : SizedBox(
                      height: 10,
                    ),
              Stack(
                children: [
                  //message
                  Visibility(
                    visible: attendanceMonthList[item]["showFlag"],
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: 230,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Color.fromRGBO(238, 238, 238, 1),
                                width: 1),
                            color: Colors.white),
                        child: Column(
                          children: [
                            //记录
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        //禁止滑动
                                        itemCount: items.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          //横轴元素个数
                                          crossAxisCount: 4,
                                          //纵轴间距
                                          //mainAxisSpacing: 12.0,
                                          //横轴间距
                                          //crossAxisSpacing: 1.0,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                monthText(index, item),
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        39, 153, 93, 1),
                                                    fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 11,
                                              ),
                                              Text(
                                                items[index],
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        34, 24, 24, 1),
                                                    fontSize: 13),
                                              ),
                                            ],
                                          );
                                        })),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Expanded(child: SizedBox()),
                            //查看详情
                            Row(
                              children: [
                                Expanded(child: SizedBox()),
                                GestureDetector(
                                  onTap: () {
                                    print(attendanceMonthList[item]);
                                    RouterUtil.push(context,
                                        routerName: "attendanceShow",
                                        data: attendanceMonthList[item]
                                            ["userId"]);
                                  },
                                  child: Align(
                                    child: Text(
                                      '查看详情',
                                      style: TextStyle(
                                          color: Color.fromRGBO(39, 153, 93, 1),
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //name
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromRGBO(39, 153, 93, 1), width: 1),
                          color: Color.fromRGBO(39, 153, 93, 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '${attendanceMonthList[item]["userName"]}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              attendanceMonthList[item]["showFlag"] =
                                  !attendanceMonthList[item]["showFlag"];
                              setState(() {});
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                              child: attendanceMonthList[item]["showFlag"]
                                  ? Image.asset('Assets/attendance/up.png')
                                  : Image.asset('Assets/attendance/down.png'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        });
  }

// 月 数字展示
  monthText(index, item) {
    var textContent = '';
    switch (index) {
      case 0:
        {
          textContent = attendanceMonthList[item]["workAverageTime"].toString();
        }
        break;
      case 1:
        {
          textContent = attendanceMonthList[item]["workDay"].toString();
        }
        break;
      case 2:
        {
          textContent = attendanceMonthList[item]["workLate"].toString();
        }
        break;
      case 3:
        {
          textContent = attendanceMonthList[item]["workLeaveEarly"].toString();
        }
        break;
      case 4:
        {
          textContent = attendanceMonthList[item]["workNull"].toString();
        }
        break;
      case 5:
        {
          textContent = attendanceMonthList[item]["workMiner"].toString();
        }
        break;
      case 6:
        {
          textContent = attendanceMonthList[item]["workLeave"].toString();
        }
        break;
      case 7:
        {
          textContent = attendanceMonthList[item]["vacation"].toString();
        }
        break;
        break;
      default:
        {
          textContent = '0';
        }
        break;
    }
    return textContent;
  }
}
