import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/common/commonTools.dart';
import '../performanceRequestApi.dart';
import 'dart:convert' as convert;

class IndividualPerformance extends StatefulWidget {
  Map data;

  @override
  _IndividualPerformanceState createState() => _IndividualPerformanceState();

  IndividualPerformance({this.data});
}

class _IndividualPerformanceState extends State<IndividualPerformance> {
  //当月绩效临时变量
  DateTime dateForMonth;

  //当日绩效临时日期变量
  DateTime dateForDay;

  //当日时间
  DateTime now = DateTime.now();

  //当前是否为当月tab
  bool monthFlag = true;

  //当前是否为当日tab
  bool dayFlag = false;

  //当月绩效钱数
  String monthInCome;

  //当日绩效钱数
  String dayInCome;

  //是否有待分红订单
  String waitFlg;

  //员工绩效list
  List percentageDetailDtoList = [];

  //用户名
  String realName;

  //用户id
  String userId;

  @override
  void initState() {
    initData();
  }

//初始化数据
  void initData() async {
    monthFlag = true;
    dateForMonth = now;
    dateForDay = now;

    if (widget.data != null) {
      userId = widget.data['userId'];
      realName = widget.data['realName'];
      if (widget.data['flag'] == 'month') {
        monthFlag = true;
        dayFlag = false;
        await PerformanceDio.individualPerformance(
            param: {
              "nowMonth": FormatUtil.formatDateYM(now),
              "nowDay": FormatUtil.formatDateYMD(now),
              'userId': userId
            },
            onSuccess: (data) {
              monthInCome = (data["nowMonthInCome"] ?? 0).toInt().toString();
              dayInCome = (data["nowDayInCome"] ?? 0).toInt().toString();
              percentageDetailDtoList = data["percentagePersonOrderDtoList"];
              setState(() {});
            });
        widget.data['flag'] = null;
        return;
      }
      if (widget.data['flag'] == 'day') {
        dayFlag = true;
        monthFlag = false;
        await PerformanceDio.individualDayPerformance(
            param: {
              "nowDay":FormatUtil.formatDateYMD(dateForDay),
              'userId': userId
            },
            onSuccess: (data) {
              dayInCome = (data["nowDayInCome"] ?? 0).toInt().toString();
              percentageDetailDtoList = data["percentagePersonOrderDtoList"];
              setState(() {});
            });
        await PerformanceDio.individualPerformance(
            param: {
              "nowMonth": FormatUtil.formatDateYM(now),
              "nowDay": FormatUtil.formatDateYMD(now),
              'userId': userId
            },
            onSuccess: (data) {
              monthInCome = (data["nowMonthInCome"] ?? 0).toInt().toString();
              setState(() {});
            });
        widget.data['flag'] = null;
        return;
      }
    } else {
      userId = await SharedManager.getString('userid');
      String userInfoStr = SynchronizePreferences.Get('userInfo');
      Map<String, dynamic> userInfo = convert.jsonDecode(userInfoStr);
      realName = userInfo["realName"];
    }

    await PerformanceDio.individualPerformance(
        param: {
          "nowMonth": FormatUtil.formatDateYM(now),
          "nowDay": FormatUtil.formatDateYMD(now),
          'userId': userId
        },
        onSuccess: (data) {
          monthInCome = (data["nowMonthInCome"] ?? 0).toInt().toString();
          dayInCome = (data["nowDayInCome"] ?? 0).toInt().toString();
          percentageDetailDtoList = data["percentagePersonOrderDtoList"];
          setState(() {});
        });
  }

//当月绩效下的时间筛选
  changeMonth() async {
    await PerformanceDio.individualPerformance(
        param: {
          "nowMonth": FormatUtil.formatDateYM(dateForMonth),
          "nowDay": FormatUtil.formatDateYMD(now),
          'userId': userId
        },
        onSuccess: (data) {
          monthInCome = (data["nowMonthInCome"] ?? 0).toInt().toString();
          dayInCome = (data["nowDayInCome"] ?? 0).toInt().toString();
          percentageDetailDtoList = data["percentagePersonOrderDtoList"];
          setState(() {});
        });
  }

//当日绩效下的时间筛选
  changeDay() async {
    await PerformanceDio.individualDayPerformance(
        param: {
          "nowDay": FormatUtil.formatDateYMD(dateForDay),
          'userId': userId
        },
        onSuccess: (data) {
          dayInCome = (data["nowDayInCome"] ?? 0).toInt().toString();
          percentageDetailDtoList = data["percentagePersonOrderDtoList"];

          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //Navigator.pop(context);
        return await Future.delayed(Duration()).then((value) {
          return true;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidget.simpleAppBar(context, title: '${realName}'),
        body: Column(
          children: [
            head(),
            time(),
            orderList(),
          ],
        ),
      ),
    );
  }

//头部
  head() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      height: 74,
      color: Colors.amber,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (monthFlag == true) return;
                monthFlag = true;
                dayFlag = false;
                setState(() {
                  initData();
                });
              },
              child: Container(
                color: monthFlag == true
                    ? Color.fromRGBO(233, 245, 238, 1)
                    : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                      child: Column(
                        children: [
                          CommonWidget.font(text: "当月绩效"),
                          CommonWidget.font(
                              text: monthInCome ?? "0",
                              color: Color.fromRGBO(39, 153, 93, 1),
                              size: 18.0,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                    ),
                    Container(
                      height: 3,
                      color: monthFlag == true
                          ? Color.fromRGBO(39, 153, 93, 1)
                          : Color.fromRGBO(220, 220, 220, 1),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (dayFlag == true) return;
                changeDay();
                monthFlag = false;
                dayFlag = true;
                setState(() {});
              },
              child: Container(
                color: dayFlag == true
                    ? Color.fromRGBO(233, 245, 238, 1)
                    : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                      child: Column(
                        children: [
                          CommonWidget.font(text: "当日绩效"),
                          CommonWidget.font(
                              text: dayInCome ?? "0",
                              color: Color.fromRGBO(39, 153, 93, 1),
                              size: 18.0,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                    ),
                    Container(
                      height: 3,
                      color: dayFlag == true
                          ? Color.fromRGBO(39, 153, 93, 1)
                          : Color.fromRGBO(220, 220, 220, 1),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//时间筛选
  time() {
    if (monthFlag == true)
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 16, 14, 37),
            child: Row(
              children: [
                CommonWidget.font(text: "时间筛选", size: 13.0),
                SizedBox(width: 20),
                GestureDetector(
                  child: Container(
                    width: 95.s,
                    height: 25.s,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Color.fromRGBO(186, 224, 204, 1),
                            width: 1.0)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10.s,
                        ),
                        Text(
                          "${dateForMonth.year}-${dateForMonth.month}",
                          style: TextStyle(
                            color: Color.fromRGBO(8, 8, 8, 1),
                            fontSize: 13.s,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color.fromRGBO(8, 8, 8, 1),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    YinPicker.showDatePicker(context,
                        nowTimes: dateForMonth,
                        dateType: DateType.YM,
                        title: "",
                        minValue: DateTime(
                          2015,
                          10,
                        ),
                        maxValue: DateTime(
                          2023,
                          10,
                        ),
                        value: DateTime(
                          dateForMonth.year,
                          dateForMonth.month,
                        ), clickCallback: (var str, var time) {
                      setState(() {
                        dateForMonth = time;
                        changeMonth();
                      });
                    });
                  },
                ),
              ],
            ),
          )
        ],
      );
    if (dayFlag == true)
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 16, 14, 37),
            child: Row(
              children: [
                CommonWidget.font(text: "时间筛选", size: 13),
                SizedBox(width: 20),
                GestureDetector(
                  child: Container(
                    width: 115.s,
                    height: 25.s,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Color.fromRGBO(186, 224, 204, 1),
                            width: 1.0)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10.s,
                        ),
                        Text(
                          "${dateForDay.year}-${dateForDay.month}-${dateForDay.day}",
                          style: TextStyle(
                            color: Color.fromRGBO(8, 8, 8, 1),
                            fontSize: 13.s,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color.fromRGBO(8, 8, 8, 1),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    YinPicker.showDatePicker(context,
                        nowTimes: dateForDay,
                        dateType: DateType.YMD,
                        title: "",
                        minValue: DateTime(
                          2015,
                          10,
                        ),
                        maxValue: DateTime(
                          2023,
                          10,
                        ),
                        value: DateTime(
                          dateForDay.year,
                          dateForDay.month,
                        ), clickCallback: (var str, var time) {
                      setState(() {
                        dateForDay = time;
                        changeDay();
                      });
                    });
                  },
                ),
              ],
            ),
          )
        ],
      );
  }

//分红订单
  orderList() {
    return Expanded(
      child: ListView(
        children: [
          if (percentageDetailDtoList.length == 0)
            Image.asset("Assets/performance/noData.png",
                width: 150.s, height: 400.s),
          for (int i = 0; i < percentageDetailDtoList.length; i++)
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 20),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromRGBO(220, 220, 220, 1), width: 1),
                  color: Colors.white),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: 45,
                    decoration:
                        CommonWidget.grayBottomBorder(colorIntValue: 238),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidget.font(
                            text: "订单编号", fontWeight: FontWeight.bold),
                        CommonWidget.font(
                            text: "${percentageDetailDtoList[i]["orderSn"]}",
                            size: 14),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: 45,
                    decoration:
                        CommonWidget.grayBottomBorder(colorIntValue: 238),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidget.font(
                            text: "订单完成日期", fontWeight: FontWeight.bold),
                        CommonWidget.font(
                            text:
                                "${(percentageDetailDtoList[i]["payTime"]) ?? ''}",
                            size: 14.0),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Visibility(
                        visible: percentageDetailDtoList[i]["servicePersonList"]
                                .length !=
                            0,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      color: AppColors.primaryColor,
                                      width: 4,
                                      height: 16,
                                      margin:
                                          EdgeInsets.only(right: 10, top: 2),
                                    ),
                                    CommonWidget.font(
                                        text: "项目分红",
                                        size: 15,
                                        fontWeight: FontWeight.bold)
                                  ],
                                ),
                              ),
                              CommonWidget.font(
                                  text:
                                      "合计：¥${percentageDetailDtoList[i]["serviceSumPrice"].toInt()}",
                                  color: Color.fromRGBO(255, 77, 76, 1))
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: percentageDetailDtoList[i]["servicePersonList"]
                                .length !=
                            0,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 100.s,
                                      child: CommonWidget.font(
                                          text: "服务名称",
                                          size: 15,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    width: 70.s,
                                    child: CommonWidget.font(
                                        text: "单价",
                                        size: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 65.s,
                                    child: CommonWidget.font(
                                        text: "数量",
                                        size: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 40.s,
                                    child: CommonWidget.font(
                                        text: "分红",
                                        size: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              for (int j = 0;
                                  j <
                                      percentageDetailDtoList[i]
                                              ["servicePersonList"]
                                          .length;
                                  j++)
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 12.s,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: 100.s,
                                            child: CommonWidget.font(
                                              text:
                                                  "${percentageDetailDtoList[i]["servicePersonList"][j]["itemName"]}",
                                              size: 14.0,
                                            )),
                                        Container(
                                          width: 70.s,
                                          child: CommonWidget.font(
                                            text:
                                                "¥${percentageDetailDtoList[i]["servicePersonList"][j]["price"].toInt()}",
                                            size: 14.0,
                                          ),
                                        ),
                                        Container(
                                          width: 65.s,
                                          child: CommonWidget.font(
                                            text:
                                                "${percentageDetailDtoList[i]["servicePersonList"][j]["itemNumber"]}",
                                            size: 14.0,
                                          ),
                                        ),
                                        Container(
                                          width: 60.s,
                                          child: CommonWidget.font(
                                            text:
                                                "¥${percentageDetailDtoList[i]["servicePersonList"][j]["bonus"].toInt()}",
                                            size: 14.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: percentageDetailDtoList[i]["materialPersonList"]
                            .length !=
                        0,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      color: AppColors.primaryColor,
                                      width: 4,
                                      height: 16,
                                      margin:
                                          EdgeInsets.only(right: 10, top: 2),
                                    ),
                                    CommonWidget.font(
                                        text: "配件分红",
                                        size: 15,
                                        fontWeight: FontWeight.bold)
                                  ],
                                ),
                              ),
                              CommonWidget.font(
                                  text:
                                      "合计：¥${percentageDetailDtoList[i]["materialSumPrice"].toInt()}",
                                  color: Color.fromRGBO(255, 77, 76, 1))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: percentageDetailDtoList[i]
                                      ["materialPersonList"]
                                  .length !=
                              0,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 100.s,
                                        child: CommonWidget.font(
                                            text: "配件名称",
                                            size: 15,
                                            fontWeight: FontWeight.bold)),
                                    Container(
                                      width: 70.s,
                                      child: CommonWidget.font(
                                          text: "单价",
                                          size: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: 65.s,
                                      child: CommonWidget.font(
                                          text: "数量",
                                          size: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: 40.s,
                                      child: CommonWidget.font(
                                          text: "分红",
                                          size: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                for (int j = 0;
                                    j <
                                        percentageDetailDtoList[i]
                                                ["materialPersonList"]
                                            .length;
                                    j++)
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 12.s,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: 100.s,
                                              child: CommonWidget.font(
                                                text:
                                                    "${percentageDetailDtoList[i]["materialPersonList"][j]["itemName"]}",
                                                size: 14.0,
                                              )),
                                          Container(
                                            width: 70.s,
                                            child: CommonWidget.font(
                                              text:
                                                  "¥${percentageDetailDtoList[i]["materialPersonList"][j]["price"].toInt()}",
                                              size: 14.0,
                                            ),
                                          ),
                                          Container(
                                            width: 65.s,
                                            child: CommonWidget.font(
                                              text:
                                                  "${percentageDetailDtoList[i]["materialPersonList"][j]["itemNumber"]}",
                                              size: 14.0,
                                            ),
                                          ),
                                          Container(
                                            width: 60.s,
                                            child: CommonWidget.font(
                                              text:
                                                  "¥${percentageDetailDtoList[i]["materialPersonList"][j]["bonus"].toInt()}",
                                              size: 14.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
