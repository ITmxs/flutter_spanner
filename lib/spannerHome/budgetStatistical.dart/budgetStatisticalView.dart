import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:spanners/cModel/budgetModel.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/budgetStatistical.dart/addBudgetStatistical.dart';
import 'package:spanners/spannerHome/budgetStatistical.dart/budgetApiRequst.dart';
import 'package:spanners/spannerHome/budgetStatistical.dart/budgetStatisticalDetail.dart';
import 'package:spanners/spannerHome/performanceStatistics/view/monthlyPerformance.dart';

class BudgetStatisticalView extends StatefulWidget {
  @override
  _BudgetStatisticalViewState createState() => _BudgetStatisticalViewState();
}

class _BudgetStatisticalViewState extends State<BudgetStatisticalView> {
  List titleList = ['洗车', '美容', '保养', '维修', '板喷', '轮胎', '其他'];
  List otherList = ['其他', '其他配件', '其他服务', '额外收入', '平台收入'];
  List titlesOther = [
    '采购',
    '绩效',
    '其他',
  ];
  Map dataMap = Map();
  bool typeBool = true; //true 收入  false 支出
  String timeShow; //用于选择展示
  DateTime date;
  DateTime nowTime = DateTime.now();
  _getBudgetMessage(String yearMonth) {
    BudgetApi.accounttantRequest(
      param: {'nowMonth': yearMonth},
      onSuccess: (data) {
        setState(() {
          dataMap = data;
        });
      },
    );
  }

  DateTime now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var month =
        nowTime.month < 10 ? '0${nowTime.month}' : nowTime.month.toString();
    timeShow = '${nowTime.year}-$month';
    _getBudgetMessage('${nowTime.year}-$month');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text('收支统计',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.popUntil(
                    context,
                    ModalRoute.withName(
                        SynchronizePreferences.Get('autoLogin') == null
                            ? '/'
                            : '/home'));
              }),
          actions: [
            InkWell(
              onTap: () {
                //权限处理 详细参考 后台Excel
                PermissionApi.whetherContain('accountant_opt')
                    ? print('')
                    : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddBudgetStatistical()))
                        .then((value) => _getBudgetMessage(timeShow));
              },
              child: Image.asset(
                'Assets/Home/appointadd.png',
                width: 26,
                height: 26,
              ),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        body: dataMap.length == 0
            ? Container()
            : ScrollConfiguration(
                behavior: NeverScrollBehavior(),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(49, 58, 67, 1)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '当月车辆',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                BudgetNowModel.fromJson(dataMap)
                                    .nowMonthCatNumber
                                    .toString(),
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          height: 65,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    '当月收入',
                                    style: TextStyle(
                                      color: Color.fromRGBO(8, 8, 8, 1),
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '¥' +
                                        BudgetNowModel.fromJson(dataMap)
                                            .nowMonthIncome
                                            .toString(),
                                    style: TextStyle(
                                        color: Color.fromRGBO(8, 8, 8, 1),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    '当月支出',
                                    style: TextStyle(
                                      color: Color.fromRGBO(8, 8, 8, 1),
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '¥' +
                                        BudgetNowModel.fromJson(dataMap)
                                            .nowMonthPlace
                                            .toString(),
                                    style: TextStyle(
                                        color: Color.fromRGBO(8, 8, 8, 1),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 15,
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
                      height: 15,
                    ),
                    Container(
                      height: 350,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    typeBool
                                        ? typeBool = false
                                        : typeBool = true;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      '收入图表',
                                      style: TextStyle(
                                          color: Color.fromRGBO(8, 8, 8, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    typeBool
                                        ? Container(
                                            height: 2,
                                            width: 56,
                                            color:
                                                Color.fromRGBO(255, 77, 76, 1),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    typeBool
                                        ? typeBool = false
                                        : typeBool = true;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      '支出图表',
                                      style: TextStyle(
                                          color: Color.fromRGBO(8, 8, 8, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    typeBool
                                        ? Container()
                                        : Container(
                                            height: 2,
                                            width: 56,
                                            color:
                                                Color.fromRGBO(63, 107, 255, 1),
                                          )
                                  ],
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              InkWell(
                                onTap: () {
                                  //日期时间选择 年月日
                                  YinPicker.showDatePicker(context,
                                      nowTimes: date == null ? nowTime : date,
                                      dateType: DateType.YM,
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
                                          ? DateTime(
                                              now.year,
                                              now.month,
                                            )
                                          : DateTime(
                                              date.year,
                                              date.month,
                                            ),
                                      clickCallback: (var str, var time) {
                                    print(str);
                                    print(time);
                                    setState(() {
                                      var month = time.month < 10
                                          ? '0${time.month}'
                                          : time.month.toString();
                                      timeShow = '${time.year}-$month';
                                      _getBudgetMessage(timeShow);
                                      date = time;
                                    });
                                  });
                                },
                                child: Container(
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: typeBool
                                              ? Color.fromRGBO(255, 219, 219, 1)
                                              : Color.fromRGBO(
                                                  235, 240, 255, 1),
                                          width: 1.0)),
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
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(height: 230, child: _simpleNull()),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    //展示列表
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(
                          typeBool ? titleList.length : titlesOther.length,
                          (index) => Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 12,
                                      ),
                                      typeBool
                                          ?
                                          //收入
                                          titleList[index] == '其他'
                                              ? Container(
                                                  height: 220,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Colors.white),
                                                  child: Container(
                                                    child: ListView(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        children: List.generate(
                                                            otherList.length,
                                                            (item) => InkWell(
                                                                  onTap: () {
                                                                    if (item ==
                                                                        0) {
                                                                      return;
                                                                    }
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(MaterialPageRoute(
                                                                            builder: (context) => DudgetDetail(
                                                                                  isof: false,
                                                                                  nowMonth: timeShow,
                                                                                  serviceId: BudgetSerModel.fromJson(dataMap['otherDetailList'][item - 1]).serviceId == null ? '' : BudgetSerModel.fromJson(dataMap['otherDetailList'][item - 1]).serviceId.toString(),
                                                                                  serviceFlg: BudgetSerModel.fromJson(dataMap['otherDetailList'][item - 1]).serviceFLg,
                                                                                  showThree: otherList[item] == '额外收入' || otherList[item] == '平台收入' ? 3 : 0,
                                                                                  titles: '收支统计',
                                                                                  types: otherList[item],
                                                                                  //sumPrice: '合计 ¥' + BudgetSerModel.fromJson(dataMap['otherDetailList'][item - 1]).materialprice.toString(),
                                                                                )));
                                                                  },
                                                                  child: Container(
                                                                      child: item == 0
                                                                          ? Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 15,
                                                                                    ),
                                                                                    Text(
                                                                                      otherList[item],
                                                                                      style: TextStyle(
                                                                                        color: Color.fromRGBO(8, 8, 8, 1),
                                                                                        fontSize: 13,
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(child: SizedBox()),
                                                                                    Text(
                                                                                      '¥' + BudgetSerModel.fromJson(dataMap['accountantDetailDtoList'][6]).materialprice.toString(),
                                                                                      style: TextStyle(
                                                                                        color: Color.fromRGBO(255, 77, 76, 1),
                                                                                        fontSize: 13,
                                                                                      ),
                                                                                    ),
                                                                                    Icon(
                                                                                      Icons.keyboard_arrow_down,
                                                                                      color: Color.fromRGBO(171, 171, 171, 1),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 8,
                                                                                    ),
                                                                                    Container(
                                                                                      width: MediaQuery.of(context).size.width - 30 - 16,
                                                                                      height: 1,
                                                                                      color: Color.fromRGBO(238, 238, 238, 1),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 8,
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            )
                                                                          : Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 24,
                                                                                    ),
                                                                                    Text(
                                                                                      otherList[item],
                                                                                      style: TextStyle(
                                                                                        color: Color.fromRGBO(8, 8, 8, 1),
                                                                                        fontSize: 13,
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(child: SizedBox()),
                                                                                    Text(
                                                                                      '¥' + BudgetSerModel.fromJson(dataMap['otherDetailList'][item - 1]).materialprice.toString(),
                                                                                      style: TextStyle(
                                                                                        color: Color.fromRGBO(255, 77, 76, 1),
                                                                                        fontSize: 13,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 35,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 8,
                                                                                    ),
                                                                                    Container(
                                                                                      width: MediaQuery.of(context).size.width - 30 - 16,
                                                                                      height: 1,
                                                                                      color: Color.fromRGBO(238, 238, 238, 1),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 8,
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            )),
                                                                ))),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    if (titleList[index] ==
                                                        '其他') {
                                                      return;
                                                    }
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DudgetDetail(
                                                                  isof: false,
                                                                  nowMonth:
                                                                      timeShow,
                                                                  serviceId: BudgetSerModel.fromJson(
                                                                          dataMap['accountantDetailDtoList']
                                                                              [
                                                                              index])
                                                                      .serviceId
                                                                      .toString(),
                                                                  serviceFlg:
                                                                      '',
                                                                  titles:
                                                                      '收支统计',
                                                                  types:
                                                                      titleList[
                                                                          index],
                                                                  // sumPrice: '合计 ¥' +
                                                                  // BudgetSerModel.fromJson(
                                                                  //         dataMap['accountantDetailDtoList']
                                                                  //             [
                                                                  //             index])
                                                                  //     .materialprice
                                                                  //     .toString(),
                                                                )));
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            30,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.white),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(
                                                          titleList[index],
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    8, 8, 8, 1),
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: SizedBox()),
                                                        Text(
                                                          '¥' +
                                                              BudgetSerModel.fromJson(
                                                                      dataMap['accountantDetailDtoList']
                                                                          [
                                                                          index])
                                                                  .materialprice
                                                                  .toString(),
                                                          style: TextStyle(
                                                            color: typeBool
                                                                ? Color
                                                                    .fromRGBO(
                                                                        255,
                                                                        77,
                                                                        76,
                                                                        1)
                                                                : Color
                                                                    .fromRGBO(
                                                                        63,
                                                                        107,
                                                                        255,
                                                                        1),
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.chevron_right,
                                                          color: Color.fromRGBO(
                                                              171, 171, 171, 1),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                          :
                                          //支出
                                          GestureDetector(
                                              onTap: () {
                                                if (titlesOther[index] ==
                                                    '绩效') {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PerformanceStatisticsPage(
                                                                flag: true,
                                                                day: timeShow,
                                                              )));
                                                }
                                                if (titlesOther[index] ==
                                                        '采购' ||
                                                    titlesOther[index] ==
                                                        '其他') {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DudgetDetail(
                                                                nowMonth:
                                                                    timeShow,
                                                                serviceId: '',
                                                                // BudgetSerModel
                                                                //         .fromJson(dataMap[
                                                                //                 'accountantDetailDtoList']
                                                                //             [index])
                                                                //     .serviceId
                                                                //     .toString(),
                                                                isof: titlesOther[
                                                                            index] ==
                                                                        '采购'
                                                                    ? false
                                                                    : true,
                                                                serviceFlg:
                                                                    titlesOther[index] ==
                                                                            '采购'
                                                                        ? '4'
                                                                        : '6',
                                                                showThree: 3,
                                                                titles: '收支统计',
                                                                types:
                                                                    titlesOther[
                                                                        index],
                                                                // sumPrice: '合计 ¥' +
                                                                //     BudgetSerModel.fromJson(dataMap['nowMonthBuyList']
                                                                //             [
                                                                //             index])
                                                                //         .materialprice
                                                                //         .toString(),
                                                              )));
                                                }
                                              },
                                              child: Container(
                                                height: 30,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    30,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.white),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      titlesOther[index],
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            8, 8, 8, 1),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                    Text(
                                                      '¥' +
                                                          BudgetSerModel.fromJson(
                                                                  dataMap['nowMonthBuyList']
                                                                      [index])
                                                              .materialprice
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: typeBool
                                                            ? Color.fromRGBO(
                                                                255, 77, 76, 1)
                                                            : Color.fromRGBO(63,
                                                                107, 255, 1),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.chevron_right,
                                                      color: Color.fromRGBO(
                                                          171, 171, 171, 1),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                        width: 18,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              )),
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ));
  }

  /*
    饼状图-空心显示
  */
  Widget _simpleNull() {
    List<PieSales> data = List();
    List colors = [
      Color.fromRGBO(180, 39, 38, 1),
      Color.fromRGBO(216, 65, 64, 1),
      Color.fromRGBO(255, 77, 76, 1),
      Color.fromRGBO(249, 125, 124, 1),
      Color.fromRGBO(246, 151, 150, 1),
      Color.fromRGBO(246, 176, 176, 1),
      Color.fromRGBO(255, 218, 218, 1),
    ];
    List colorOther = [
      Color.fromRGBO(80, 77, 165, 1),
      Color.fromRGBO(63, 107, 255, 1),
      Color.fromRGBO(45, 165, 253, 1),
    ];
    List titles = ['洗车', '美容', '保养', '维修', '钣喷', '轮胎', '其他'];

    List titleOther = [
      '采购',
      '绩效',
      '其他',
    ];
    var seriesList = [
      charts.Series<PieSales, int>(
        id: 'Sales',
        domainFn: (PieSales sales, _) => sales.year, //区域
        measureFn: (PieSales sales, _) => sales.sales, //比例
        colorFn: (PieSales sales, _) => sales.color, //颜色
        data: data,
        labelAccessorFn: (PieSales row, _) => '${row.message}',
        outsideLabelStyleAccessorFn: (PieSales sales, _) =>
            charts.TextStyleSpec(
          fontSize: 12,
          color: charts.ColorUtil.fromDartColor(
            Color.fromRGBO(78, 78, 78, 1),
          ),
        ),
      )
    ];
    //动态添加空心饼状图元素
    _insert() {
      int count = typeBool ? titles.length : titleOther.length;
      for (var i = 0; i < count; i++) {
        var a = typeBool
            ? BudgetSerModel.fromJson(dataMap['accountantDetailDtoList'][i])
                .materialprice
            : BudgetSerModel.fromJson(dataMap['nowMonthBuyList'][i])
                .materialprice;
        var b = typeBool
            ? BudgetNowModel.fromJson(dataMap).nowMonthIncome
            : BudgetNowModel.fromJson(dataMap).nowMonthPlace;
        var c = a == 0 ? 0 : (a / b) * 100;
        var s = c.toStringAsFixed(2);
        print('服务价格$a------收入价格$b');
        data.add(
          PieSales(
              i,
              b == 0
                  ? 2
                  : c == 0
                      ? 5
                      : c,
              charts.ColorUtil.fromDartColor(
                  typeBool ? colors[i] : colorOther[i]),
              typeBool ? '$s%\n${titles[i]}' : '$s%\n${titleOther[i]}'),
        );
      }
    }

    _insert();
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(
                height: 90,
              ),
              Text(
                typeBool
                    ? '¥' +
                        BudgetNowModel.fromJson(dataMap)
                            .nowMonthIncome
                            .toString()
                    : '¥' +
                        BudgetNowModel.fromJson(dataMap)
                            .nowMonthPlace
                            .toString(),
                style: TextStyle(
                    color: Color.fromRGBO(8, 8, 8, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                typeBool ? '收入统计' : '支出统计',
                style: TextStyle(
                  color: Color.fromRGBO(8, 8, 8, 1),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: charts.PieChart(seriesList,
              animate: true,
              defaultRenderer: charts.ArcRendererConfig(
                  arcWidth: 30,
                  arcRendererDecorators: [
                    charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.outside,
                      leaderLineStyleSpec: charts.ArcLabelLeaderLineStyleSpec(
                          color: charts.ColorUtil.fromDartColor(typeBool
                              ? Color.fromRGBO(255, 77, 76, 1)
                              : Color.fromRGBO(63, 107, 255, 1)),
                          length: 25,
                          thickness: 1.0),
                    )
                  ])),
        )
      ],
    );
  }
}

//饼状图 自定义颜色
class PieSales {
  final int year;
  final sales;
  final String message;
  final charts.Color color;
  PieSales(this.year, this.sales, this.color, this.message);
}
