import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/performanceStatistics/view/toBonusList.dart';

import '../performanceRequestApi.dart';
import 'individualPerformance.dart';

class PerformanceStatisticsPage extends StatefulWidget {
  //运营统计相关逻辑标志位
  final bool flag;

  //运营统计相关日期  格式"2020-11"
  final String day;

  const PerformanceStatisticsPage({Key key, this.flag, this.day})
      : super(key: key);

  @override
  _PerformanceStatisticsState createState() => _PerformanceStatisticsState();
}

class _PerformanceStatisticsState extends State<PerformanceStatisticsPage> {
  //当月绩效临时变量
  DateTime dateForMonth = DateTime.now();

  //当日绩效临时日期变量
  DateTime dateForDay = DateTime.now();

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

  @override
  void initState() {
    initData();
  }

  //页面初始化数据
  initData() async {
    monthFlag = true;
    dateForDay = now;
    dateForMonth = now;
    await PerformanceDio.performanceRequest(
        param: {
          "nowMonth":
              widget.day == null ? FormatUtil.formatDateYM(now): widget.day,
          "nowDay": FormatUtil.formatDateYMD(now),
        },
        onSuccess: (data) {
          monthInCome = (data["monthInCome"] ?? 0).toString();
          dayInCome = (data["dayIncome"] ?? 0).toString();
          waitFlg = data["waitFlg"];
          percentageDetailDtoList = data["percentageDetailDtoList"];
          setState(() {});
        });
  }

  //更改月份
  changeMonth() async {
    await PerformanceDio.performanceRequest(
        param: {
          "nowMonth":FormatUtil.formatDateYM(dateForMonth) ,
          "nowDay": FormatUtil.formatDateYMD(now),
        },
        onSuccess: (data) {
          monthInCome = (data["monthInCome"] ?? 0).toString();
          waitFlg = data["waitFlg"];
          percentageDetailDtoList = data["percentageDetailDtoList"];
          setState(() {});
        });
  }

  //更改日期
  changeDay() async {
    await PerformanceDio.dayPerformanceRequest(
        param: {
          "nowDay": FormatUtil.formatDateYMD(dateForMonth)
        },
        onSuccess: (data) {
          dayInCome = (data["dayIncome"] ?? 0).toString();
          percentageDetailDtoList = data["percentageDetailDtoList"];
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.iconAppBar(
          context, widget.flag == true ? "运营统计" : '绩效统计',
          rIcon: GestureDetector(
            onTap: () {
              PermissionApi.whetherContain('share_order_view')
                  ? print('')
                  : CommonRouter.push(context, widget: ToBonusList());
            },
            child: widget.flag == true
                ? Container()
                : Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 31.s, 0),
                    child: (waitFlg == "0")
                        ? Image.asset(
                            "Assets/performance/hasMoney.png",
                            width: 25.s,
                            height: 25.s,
                          )
                        : Image.asset(
                            "Assets/performance/money.png",
                            width: 25.s,
                            height: 25.s,
                          )),
          )),
      body: Column(
        children: [
          head(),
          time(),
          listTile(),
          listContent(),
          //monthDetail(),
        ],
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
                              text: "¥${monthInCome ?? 0}",
                              color: Color.fromRGBO(39, 153, 93, 1),
                              size: 18,
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
                monthFlag = false;
                dayFlag = true;
                changeDay();
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
                              text: "¥${dayInCome ?? 0}",
                              color: Color.fromRGBO(39, 153, 93, 1),
                              size: 18,
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
            padding: EdgeInsets.fromLTRB(0, 16, 20, 37),
            child: Row(
              children: [
                CommonWidget.font(text: "时间筛选", size: 13),
                SizedBox(width: 20.s),
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
                        print(str);
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

  //列表标题
  listTile() {
    return monthFlag == true
        ? Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(60.s, 0, 70.s, 0),
                child: CommonWidget.font(
                    text: "员工姓名", fontWeight: FontWeight.bold),
              ),
              CommonWidget.font(text: "当月绩效", fontWeight: FontWeight.bold)
            ],
          )
        : Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(60.s, 0, 70.s, 0),
                child: CommonWidget.font(
                    text: "员工姓名", fontWeight: FontWeight.bold),
              ),
              CommonWidget.font(text: "当日绩效", fontWeight: FontWeight.bold)
            ],
          );
  }

  //列表内容
  listContent() {
    return Expanded(
      child: ListView(
        children: [
          if (percentageDetailDtoList.length == 0)
            Image.asset("Assets/performance/noData.png",
                width: 150.s, height: 400.s),
          for (int i = 0; i < percentageDetailDtoList.length; i++)
            Container(
              margin: EdgeInsets.fromLTRB(15.s, 0, 15.s, 0),
              width: 345.s,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                width: 1,
                color: Color.fromRGBO(238, 238, 238, 1),
              ))),
              child: Padding(
                padding: EdgeInsets.fromLTRB(50.s, 10.s, 0.s, 9.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 140.s,
                      child: CommonWidget.font(
                          text: "${percentageDetailDtoList[i]["realName"]}"),
                    ),
                    Container(
                      width: 95.s,
                      child: CommonWidget.font(
                          text: "¥${percentageDetailDtoList[i]["money"]}"),
                    ),
                    Container(
                      width: 40.s,
                      child: GestureDetector(
                        child: CommonWidget.font(
                            text: "详情", color: Color.fromRGBO(39, 153, 93, 1)),
                        onTap: () {
                          CommonRouter.push(
                            context,
                            widget: IndividualPerformance(data: {
                              "userId": percentageDetailDtoList[i]["userId"],
                              "realName": percentageDetailDtoList[i]
                                  ["realName"],
                              "flag": monthFlag == true ? "month" : "day"
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
