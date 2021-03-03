import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spanners/cModel/operationStatisticsModel.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/cTools/yin_flutter_chart/yin_flutter.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/budgetStatistical.dart/budgetStatisticalDetail.dart';
import 'package:spanners/spannerHome/operationStatistics/operationApi.dart';
import 'package:spanners/spannerHome/operationStatistics/yBillStatistics.dart';
import 'package:spanners/spannerHome/performanceStatistics/view/monthlyPerformance.dart';

class MonthStatiotics extends StatefulWidget {
  @override
  _MonthStatioticsState createState() => _MonthStatioticsState();
}

class _MonthStatioticsState extends State<MonthStatiotics> {
  OperationProfitModel model;
  String timeShow; //用于选择展示
  DateTime date;
  DateTime nowTime = DateTime.now();
  // 获取月份利润统计
  _getResult(String ym) {
    OperationApi.profitStatisticsRequest(
      param: {'nowMonth': ym},
      onSuccess: (data) {
        setState(() {
          model = OperationProfitModel.fromJson(data);
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeShow = '${nowTime.year}-${nowTime.month}';
    _getResult('${nowTime.year}-${nowTime.month}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          title: Text(
            '利润统计',
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
        body: model == null
            ? Container()
            : ScrollConfiguration(
                behavior: NeverScrollBehavior(),
                child: ListView(children: [
                  //top
                  SizedBox(
                    height: 10,
                  ),
                  //绿卡区域
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: 130,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: AssetImage(
                                  'Assets/operationStatistics/topback.png',
                                ),
                                fit: BoxFit.cover)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 55,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.center,
                                  child: Text('¥${model.nowMonthInPrice}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      )),
                                )),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.center,
                                  child: Text('¥${model.nowMonthOutPrice}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      )),
                                )),
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.center,
                                  child: Text('月收入',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                )),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.center,
                                  child: Text('月支出',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                )),
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
                  //全年利润累计
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        child: Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '全年利润累计',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                15 -
                                                16,
                                            child: Row(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '¥${model.yearProfit}',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          39, 153, 93, 1),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  ],
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
                    height: 10,
                  ),
                  //利润走势图
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '本月利润统计',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 2,
                                      width: 84,
                                      color: Color.fromRGBO(255, 188, 0, 1),
                                    ),
                                  ],
                                ),
                                Expanded(child: SizedBox()),
                                InkWell(
                                  onTap: () {
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
                                                nowTime.year,
                                                nowTime.month,
                                              )
                                            : DateTime(
                                                date.year,
                                                date.month,
                                              ),
                                        clickCallback: (var str, var time) {
                                      setState(() {
                                        var month = time.month < 10
                                            ? '0${time.month}'
                                            : time.month.toString();
                                        timeShow = '${time.year}-$month';
                                        _getResult(timeShow);
                                        date = time;
                                      });
                                    });
                                    //日期时间选择 年月日
                                  },
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color:
                                                Color.fromRGBO(255, 188, 0, 1),
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
                                  width: 27,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                                height: 200,
                                child: _buildChartCurve(
                                    context, model.monthProfitDetailVos)),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '本月利润总额',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '¥${model.nowMonthProfit}',
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 188, 0, 1),
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25,
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
                    height: 5,
                  ),
                  //关于工单
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  //查看详情
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '关于工单',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    78, 78, 78, 1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            width: 56,
                                            height: 2,
                                            color:
                                                Color.fromRGBO(255, 188, 0, 1),
                                          )
                                        ],
                                      ),
                                      Expanded(child: SizedBox()),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BillStatistic()));
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              '查看详情',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      166, 166, 166, 1),
                                                  fontSize: 14),
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              color: Color.fromRGBO(
                                                  166, 166, 166, 1),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    height: 1,
                                    color: Color.fromRGBO(238, 238, 238, 1),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.center,
                                        child: Text('¥${model.nowMonthInPrice}',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    41, 157, 96, 1),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500)),
                                      )),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                            '¥${model.nowMonthOutPrice}',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    41, 157, 96, 1),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500)),
                                      )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.center,
                                        child: Text('工单实收金额',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.center,
                                        child: Text('工单配件成本',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width / 2 - 15,
                                    75,
                                    MediaQuery.of(context).size.width / 2 -
                                        15 -
                                        1,
                                    10),
                                child: Container(
                                  width: 1,
                                  height: 45,
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //员工绩效
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PerformanceStatisticsPage(
                                        flag: true,
                                        day: timeShow,
                                      )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '员工绩效',
                                style: TextStyle(
                                    color: Color.fromRGBO(78, 78, 78, 1),
                                    fontSize: 15),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                '¥${model.personAchievementsSum}',
                                style: TextStyle(
                                    color: Color.fromRGBO(39, 153, 93, 1),
                                    fontSize: 15),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Color.fromRGBO(171, 171, 171, 1),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //其他收入
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DudgetDetail(
                                    nowMonth: timeShow,
                                    //serviceId: ,
                                    serviceFlg: '1',
                                    showThree: 3,
                                    titles: '运营统计',
                                    types: '其他收入',
                                    //sumPrice: '合计 ¥' + model.otherIncomeSum,
                                  )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '其他收入',
                                style: TextStyle(
                                    color: Color.fromRGBO(78, 78, 78, 1),
                                    fontSize: 15),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                '¥${model.otherIncomeSum}',
                                style: TextStyle(
                                    color: Color.fromRGBO(39, 153, 93, 1),
                                    fontSize: 15),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Color.fromRGBO(171, 171, 171, 1),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //其他支出
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DudgetDetail(
                                    nowMonth: timeShow,
                                    //serviceId: ,
                                    serviceFlg: '6',
                                    showThree: 3,
                                    titles: '运营统计',
                                    types: '其他支出',
                                    //  sumPrice: '合计 ¥' + model.otherExpenditureSum,
                                  )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '其他支出',
                                style: TextStyle(
                                    color: Color.fromRGBO(78, 78, 78, 1),
                                    fontSize: 15),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                '¥${model.otherExpenditureSum}',
                                style: TextStyle(
                                    color: Color.fromRGBO(39, 153, 93, 1),
                                    fontSize: 15),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Color.fromRGBO(171, 171, 171, 1),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ])));
  }

  Widget _buildChartCurve(context, List dataList) {
    List<ChartBean> returnList() {
      List<ChartBean> arr = List();
      for (var i = 0; i < dataList.length; i++) {
        String time = dataList[i]['dateForYmd'].toString();
        String month = time.substring(time.length - 2, time.length);
        arr.add(ChartBean(x: month, y: dataList[i]['frofit']));
      }
      return arr;
    }

    var chartLine = ChartLine(
      chartBeans: returnList(),
      size: Size(MediaQuery.of(context).size.width, 200),
      isCurve: true,
      lineWidth: 2,
      lineColor: Color.fromRGBO(255, 183, 0, 1),
      fontColor: Color.fromRGBO(163, 163, 163, 1),
      xyColor: Color.fromRGBO(163, 163, 163, 1),
      shaderColors: [
        Color.fromRGBO(255, 183, 0, 0.8),
        Color.fromRGBO(255, 183, 0, 0.2)
      ],
      fontSize: 12,
      yNum: 4,
      isAnimation: true,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: Color.fromRGBO(255, 183, 0, 1),
      duration: Duration(milliseconds: 2000),
    );
    return Container(
      color: Colors.white,
      child: chartLine,
    );
  }
}
