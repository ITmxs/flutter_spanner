import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spanners/cModel/operationStatisticsModel.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/cTools/yin_flutter_chart/yin_flutter.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/operationStatistics/operationApi.dart';

class VipStatiotics extends StatefulWidget {
  @override
  _VipStatioticsState createState() => _VipStatioticsState();
}

class _VipStatioticsState extends State<VipStatiotics> {
  NewVipModel model;
  bool showBool = true;
  String timeShow; //用于选择展示
  DateTime date;
  DateTime nowTime = DateTime.now();
  // 获取月份会员储值 走势
  _getResult(String ym) {
    OperationApi.operationstatisValueRequest(
      param: {'nowMonth': ym},
      onSuccess: (data) {
        setState(() {
          model = NewVipModel.fromJson(data);
        });
      },
    );
  }

  // 获取月消费 走势
  _gettResult(String ym) {
    OperationApi.operationstatisOutRequest(
      param: {'nowMonth': ym},
      onSuccess: (data) {
        setState(() {
          model = NewVipModel.fromJson(data);
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
            '会员储值',
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
                                  child: Text('¥${model.nowMonthStoreValue}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      )),
                                )),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.center,
                                  child: Text('¥${model.nowMonthConsume}',
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
                                  child: Text('本月新增储值额',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                )),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.center,
                                  child: Text('本月消费储值额',
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
                                            '会员储值总额',
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
                                                    '¥${model.storeValue}',
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
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showBool
                                          ? showBool = false
                                          : showBool = true;
                                      _getResult(timeShow);
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        '新增储值走势',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: showBool ? 14 : 13,
                                            fontWeight: showBool
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      showBool
                                          ? Container(
                                              height: 2,
                                              width: 84,
                                              color: Color.fromRGBO(
                                                  255, 77, 76, 1),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showBool
                                          ? showBool = false
                                          : showBool = true;
                                      _gettResult(timeShow);
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        '月消费走势',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: showBool ? 13 : 14,
                                            fontWeight: showBool
                                                ? FontWeight.normal
                                                : FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      showBool
                                          ? Container()
                                          : Container(
                                              height: 2,
                                              width: 70,
                                              color: Color.fromRGBO(
                                                  63, 107, 255, 1),
                                            ),
                                    ],
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                InkWell(
                                  onTap: () {
                                    YinPicker.showDatePicker(context,
                                        nowTimes: date == null ? nowTime : date,
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
                                        showBool
                                            ? _getResult(timeShow)
                                            : _gettResult(timeShow);
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
                                            color: showBool
                                                ? Color.fromRGBO(
                                                    255, 229, 229, 1)
                                                : Color.fromRGBO(
                                                    63, 107, 255, 1),
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
                                child: _buildChartCurve(context,
                                    model.monthStoreValueHistogramVos)),
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
                  //明细展示
                  model.monthStoreValueDetailVos == null
                      ? Container()
                      : Row(
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
                                  //
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            showBool ? '新增储值明细' : '月消费明细',
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
                                            width: 83,
                                            height: 2,
                                            color: showBool
                                                ? Color.fromRGBO(255, 77, 76, 1)
                                                : Color.fromRGBO(
                                                    63, 107, 255, 1),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  //分类 标题
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '会员手机号',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '时间',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '金额',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      SizedBox(
                                        width: 30,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  //详细列表展示
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          model.monthStoreValueDetailVos.length,
                                      itemBuilder:
                                          (BuildContext context, int item) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 21,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    model
                                                        .monthStoreValueDetailVos[
                                                            item]['tel']
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          139, 139, 139, 1),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                )),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                    child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    model
                                                        .monthStoreValueDetailVos[
                                                            item]['leaveTime']
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          139, 139, 139, 1),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    '￥${model.monthStoreValueDetailVos[item]['onAccount']}',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          139, 139, 139, 1),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                )),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              height: 1,
                                              color: Color.fromRGBO(
                                                  238, 238, 238, 1),
                                            )
                                          ],
                                        );
                                      })
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
      lineColor: showBool
          ? Color.fromRGBO(255, 77, 76, 1)
          : Color.fromRGBO(63, 107, 255, 1),
      fontColor: Color.fromRGBO(163, 163, 163, 1),
      xyColor: Color.fromRGBO(163, 163, 163, 1),
      shaderColors: [
        showBool
            ? Color.fromRGBO(255, 77, 76, 0.8)
            : Color.fromRGBO(63, 107, 255, 1),
        showBool
            ? Color.fromRGBO(255, 77, 76, 0.2)
            : Color.fromRGBO(63, 107, 255, 1)
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
