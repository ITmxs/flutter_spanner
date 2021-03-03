import 'package:flutter/material.dart';
import 'package:spanners/common/commonTools.dart';

import 'attendanceApi.dart';

class AttendanceShow extends StatefulWidget {
  var data;

  setData(data) {
    this.data = data;
  }

  @override
  _AttendanceShowState createState() => _AttendanceShowState();
}

class _AttendanceShowState extends State<AttendanceShow> {
  List week = [
    '日',
    '一',
    '二',
    '三',
    '四',
    '五',
    '六',
  ];

  /* 选中 标识*/
  int selectValue = 40; // 天
  int monthValue = 13; // 月
  int yearValue = 100; // 年
  /* 左右月份 选择*/
  int monthIn = 0;

  //创建时间对象，获取当前时间
  DateTime now = DateTime.now();

  /* 获取这个月的天数   ⬇️*/
  List<int> _monthDays = <int>[31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      if (isLeapYear) return 29;
      return 28;
    }
    return _monthDays[month - 1];
  }

  /* 获取这个月的天数   ⬆️*/

  /* 得到这个月的第一天是星期几（0 是星期日 1 是星期一...）⬇️*/
  int computeFirstDayOffset(
      int year, int month, MaterialLocalizations localizations) {
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;

    final int firstDayOfWeekFromSunday = localizations.firstDayOfWeekIndex;

    final int firstDayOfWeekFromMonday = (firstDayOfWeekFromSunday - 1) % 7;

    return (weekdayFromMonday - firstDayOfWeekFromMonday) % 7;
  }

  /* 得到这个月的第一天是星期几（0 是星期日 1 是星期一...）⬆️*/

  /* 排版从 周几 开始  一个 多少单元格⬇️ */
  int fromLocationNums(int year, int month) {
    var day = getDaysInMonth(year, month);
    var index =
        computeFirstDayOffset(year, month, MaterialLocalizations.of(context));
    var nums = day + index;
    return nums;
  }

  /* 排版  从周几 开始  一共 多少单元格 ⬆️ */

  /* 排版  动态添加 day 数组 ⬇️ */
  List getDays(int year, int month) {
    var nums =
        computeFirstDayOffset(year, month, MaterialLocalizations.of(context));
    List day = [
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List one = [
      '',
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List two = [
      '',
      '',
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List three = [
      '',
      '',
      '',
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List four = [
      '',
      '',
      '',
      '',
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List five = [
      '',
      '',
      '',
      '',
      '',
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List six = [
      '',
      '',
      '',
      '',
      '',
      '',
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];

    if (nums == 1) {
      moreDay = nums;
      return one;
    } else if (nums == 2) {
      moreDay = nums;
      return two;
    } else if (nums == 3) {
      moreDay = nums;
      return three;
    } else if (nums == 4) {
      moreDay = nums;
      return four;
    } else if (nums == 5) {
      moreDay = nums;
      return five;
    } else if (nums == 6) {
      moreDay = nums;
      return six;
    } else {
      moreDay = 0;
      return day;
    }
  }

  /* 排版  动态添加 day 数组 ⬆️ */
  /* 标示 今天 日期 */
  bool today(int index) {
    if (monthIn == 0) {
      var todays = getDays(now.year, now.month)[index];
      var nowday = now.day > 9 ? now.day.toString() : '0${now.day}';
      if (todays == nowday) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /* 当前选中日期 */
  bool selectDay(int index) {
    var years = (now.month + monthIn) > 12 ? now.year + 1 : now.year;
    var months = (now.month + monthIn) > 12
        ? (now.month + monthIn) - 12
        : now.month + monthIn;
    if (years == yearValue && monthValue == months && index == selectValue) {
      return true;
    } else {
      return false;
    }
  }

//⬆️
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

  Map attendanceMonthMap = {};
  List nowMonthForDayList = [];
  int moreDay = 0;
  Map attendancePersonForDayDetailDto = {};

  @override
  void initState() {
    _getInitMonth("${DateTime.now().year}-${DateTime.now().month}");
  }

  _getInitMonth(String date) {
    AttendanceApi.attendanceDetailRequest(
      param: {'month': date, 'userId': widget.data},
      onSuccess: (data) {
        attendanceMonthMap = data["nowMonthAttendanceDetail"];
        nowMonthForDayList = data["nowMonthForDayList"];
        attendancePersonForDayDetailDto =
            data["attendancePersonForDayDetailDto"];
        setState(() {});
      },
    );
  }

  _getInitDay(String date) {
    AttendanceApi.attendanceDayDetailRequest(
      param: {'monthDay': date, 'userId': widget.data},
      onSuccess: (data) {
        attendancePersonForDayDetailDto = data;
        setState(() {});
      },
    );
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
      ),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 15,
            ),
            //月份展示筛选
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  '${(now.month + monthIn) > 0 ? now.year : now.year - 1}年${(now.month + monthIn) > 0 ? (now.month + monthIn) : 12 - (now.month + monthIn)}月',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(child: SizedBox()),
                //上一月
                GestureDetector(
                  onTap: () {
                    setState(() {
                      monthIn == -11 ? monthIn = -11 : monthIn = monthIn - 1;
                    });
                  },
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
                //下一月
                GestureDetector(
                  onTap: () {
                    setState(() {
                      monthIn == 0 ? monthIn = 0 : monthIn = monthIn + 1;
                    });
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
                SizedBox(
                  width: 36,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            monthShow(),
            calendar(),
            workTime()
          ],
        ),
      ),
    );
  }

  workTime() {
    return attendancePersonForDayDetailDto["status"] == 0
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 345.s,
                    height: 25.s,
                    color: Color.fromRGBO(233, 245, 238, 1),
                    child: CommonWidget.font(
                        text:
                            "打卡时间 ${attendancePersonForDayDetailDto["onWorkTime"] ?? ""}-${attendancePersonForDayDetailDto["outWorkTime"] ?? ""}"),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25.s, 20.s, 0, 30.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "Assets/attendance/line.png",
                      height: 95.s,
                    ),
                    SizedBox(
                      width: 5.s,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 90.s,
                              height: 90.s,
                              child:
                                  attendancePersonForDayDetailDto["onPicUrl"] !=
                                          null
                                      ? Image.network(
                                          attendancePersonForDayDetailDto[
                                              "onPicUrl"],
                                          width: 90.s,
                                          height: 90.s,
                                        )
                                      : Image.asset(
                                          "Assets/attendance/noPic.png",
                                          width: 90.s,
                                          height: 90.s,
                                        ),
                            ),
                            SizedBox(
                              width: 5.s,
                            ),
                            CommonWidget.font(
                                text:
                                    "上班：${attendancePersonForDayDetailDto["onWorkTime"] ?? ""}"),
                            SizedBox(
                              width: 5.s,
                            ),
                            CommonWidget.customButton(
                                text: workState(attendancePersonForDayDetailDto[
                                    "onWorkStatus"]),
                                width: 50.s,
                                height: 20.s,
                                buttonColor: attendancePersonForDayDetailDto[
                                            "onWorkStatus"] ==
                                        0
                                    ? Colors.green
                                    : Colors.amber,
                                fontSize: 12.s),
                          ],
                        ),
                        SizedBox(
                          height: 20.s,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 90.s,
                              height: 90.s,
                              child: attendancePersonForDayDetailDto[
                                          "outPicUrl"] !=
                                      null
                                  ? Image.network(
                                      attendancePersonForDayDetailDto[
                                          "outPicUrl"],
                                      width: 90.s,
                                      height: 90.s,
                                    )
                                  : Image.asset(
                                      "Assets/attendance/noPic.png",
                                      width: 90.s,
                                      height: 90.s,
                                    ),
                            ),
                            SizedBox(
                              width: 5.s,
                            ),
                            CommonWidget.font(
                                text:
                                    "下班：${attendancePersonForDayDetailDto["outWorkTime"] ?? ""}"),
                            SizedBox(
                              width: 5.s,
                            ),
                            CommonWidget.customButton(
                                text: workState2(attendancePersonForDayDetailDto[
                                    "outWorkStatus"]),
                                width: 50.s,
                                height: 20.s,
                                buttonColor: attendancePersonForDayDetailDto[
                                            "outWorkStatus"] ==
                                        0
                                    ? Colors.green
                                    : Colors.amber,
                                fontSize: 12.s),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 345.s,
                    height: 25.s,
                    color: Color.fromRGBO(233, 245, 238, 1),
                    child: CommonWidget.font(text: "打卡时间 "),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25.s, 20.s, 0, 30.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5.s,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Image.asset(
                                "Assets/attendance/noPic.png",
                                width: 90.s,
                                height: 90.s,
                              ),
                            ),
                            SizedBox(
                              width: 5.s,
                            ),
                            Column(
                              children: [
                                CommonWidget.font(
                                    text: workState3(
                                        attendancePersonForDayDetailDto[
                                            "status"]))
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
  }

  //个人月份统计
  monthShow() {
    return Column(
      children: [
        SizedBox(
          height: 22,
        ),
        Stack(
          children: [
            //message
            Padding(
              padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Color.fromRGBO(238, 238, 238, 1), width: 1),
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
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        monthText(index),
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(39, 153, 93, 1),
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 11,
                                      ),
                                      Text(
                                        items[index],
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(34, 24, 24, 1),
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
                  ],
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
                          '${attendanceMonthMap["userName"] ?? ""}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
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
  }

  monthText(index) {
    var textContent = '';
    switch (index) {
      case 0:
        {
          textContent =
              (attendanceMonthMap["workAverageTime"] ?? "").toString();
        }
        break;
      case 1:
        {
          textContent = (attendanceMonthMap["workDay"] ?? "").toString();
        }
        break;
      case 2:
        {
          textContent = (attendanceMonthMap["workLate"] ?? "").toString();
        }
        break;
      case 3:
        {
          textContent = (attendanceMonthMap["workLeaveEarly"] ?? "").toString();
        }
        break;
      case 4:
        {
          textContent = (attendanceMonthMap["workNull"] ?? "").toString();
        }
        break;
      case 5:
        {
          textContent = (attendanceMonthMap["workMiner"] ?? "").toString();
        }
        break;
      case 6:
        {
          textContent = (attendanceMonthMap["workLeave"] ?? "").toString();
        }
        break;
      case 7:
        {
          textContent = (attendanceMonthMap["vacation"] ?? "").toString();
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

  calendar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Color.fromRGBO(188, 188, 188, 1), width: 0.5.s)),
        child: Column(
          children: [
            Container(
              color: Color.fromRGBO(39, 153, 93, 1),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: new NeverScrollableScrollPhysics(),
                  //禁止滑动
                  itemCount: 7,
                  //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 7,
                      //纵轴间距
                      mainAxisSpacing: 10.0,
                      //横轴间距
                      crossAxisSpacing: 10.0,
                      //子组件宽高长度比例
                      childAspectRatio: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    //Widget Function(BuildContext context, int index)
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        week[index],
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 15,
            ),
            GridView.builder(
                shrinkWrap: true,
                physics: new NeverScrollableScrollPhysics(),
                //禁止滑动
                itemCount: fromLocationNums(
                    (now.month + monthIn) > 0 ? now.year : now.year - 1,
                    (now.month + monthIn) > 0
                        ? (now.month + monthIn) ////
                        : 12 - (now.month + monthIn)),
                //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //横轴元素个数
                    crossAxisCount: 7,
                    //纵轴间距
                    mainAxisSpacing: 15.0,
                    //横轴间距
                    crossAxisSpacing: 20.0,
                    //子组件宽高长度比例
                    childAspectRatio: 1.0),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      getDays(
                                  (now.month + monthIn) > 12
                                      ? now.year + 1
                                      : now.year,
                                  (now.month + monthIn) > 12
                                      ? (now.month + monthIn) - 12
                                      : now.month + monthIn)[index] ==
                              ''
                          ? print('')
                          : setState(() {
                              selectValue = index;
                              monthValue = (now.month + monthIn) > 12
                                  ? (now.month + monthIn) - 12
                                  : now.month + monthIn;
                              yearValue = (now.month + monthIn) > 12
                                  ? now.year + 1
                                  : now.year;
                              String month = monthValue > 9
                                  ? '$monthValue'
                                  : '0$monthValue';
                              //这里实现 选中日期 日 用于逻辑
                              _getInitDay(
                                  '$yearValue-$month-${getDays((now.month + monthIn) > 12 ? now.year + 1 : now.year, (now.month + monthIn) > 12 ? (now.month + monthIn) - 12 : now.month + monthIn)[index]}');
                            });
                    },
                    //这里可对每一天的 UI 做 处理
                    child: Container(
                      // width: 25,
                      // height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:
                              /*  对 月和日 做判断   */
                              selectDay(index)
                                  ? Color.fromRGBO(39, 153, 93, 0.1)
                                  : Colors.transparent),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              getDays(
                                  (now.month + monthIn) > 0
                                      ? now.year
                                      : now.year - 1,
                                  (now.month + monthIn) > 0
                                      ? (now.month + monthIn)
                                      : 12 - (now.month + monthIn))[index],
                              style: today(index)
                                  ?
                                  /* today */
                                  TextStyle(
                                      color: Color.fromRGBO(39, 153, 93, 0.7),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)
                                  :
                                  /*正常日期  显示*/
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 5.s),
                          Container(
                            width: 5.s,
                            height: 5.s,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(120.s),
                                color: index >= moreDay &&
                                        nowMonthForDayList[index - moreDay]
                                                ["status"] ==
                                            0 &&
                                        nowMonthForDayList[index - moreDay]
                                                ["inWorkStatus"] ==
                                            0 &&
                                        nowMonthForDayList[index - moreDay]
                                                ["outWorkStatus"] ==
                                            0
                                    ? Colors.green
                                    : Colors.amber),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  workState(index) {
    switch (index) {
      case 1:
        return "迟到";
      case 2:
        return "缺卡";
      default:
        return "正常";
    }
  }

  workState2(index) {
    switch (index) {
      case 1:
        return "缺卡";
      case 2:
        return "早退";
      default:
        return "正常";
    }
  }

  workState3(index) {
    switch (index) {
      case 1:
        return "旷工";
      case 2:
        return "休息";
      case 3:
        return "请假";
      default:
        return "正常";
    }
  }
}
