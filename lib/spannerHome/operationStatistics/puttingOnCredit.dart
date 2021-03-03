import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spanners/cModel/operationStatisticsModel.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/cTools/yin_flutter_chart/yin_flutter.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/operationStatistics/operationApi.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_details_page.dart';

class PuttingOnCredit extends StatefulWidget {
  @override
  _PuttingOnCreditState createState() => _PuttingOnCreditState();
}

class _PuttingOnCreditState extends State<PuttingOnCredit> {
  PuttingModel model;

  String timeShow; //用于选择展示
  DateTime date;
  DateTime nowTime = DateTime.now();
  // 获取月份会员储值 走势
  _getResult(String ym) {
    OperationApi.operationstatisAccount(
      param: {'nowMonth': ym},
      onSuccess: (data) {
        setState(() {
          model = PuttingModel.fromJson(data);
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var month =
        nowTime.month < 10 ? '0${nowTime.month}' : nowTime.month.toString();
    timeShow = '${nowTime.year}-$month';
    _getResult('${nowTime.year}-$month');
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
            '挂帐情况',
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
                                  child: Text('¥${model.nowMonthOnAccount}',
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
                                  child: Text('本月新增挂账额',
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
                  //会员挂账总额
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
                                            '会员挂账总额',
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
                                                    '¥${model.onAccountSum}',
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
                  //会员挂账明细
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
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      Text(
                                        '当月挂账明细',
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
                                        color: Color.fromRGBO(39, 153, 93, 1),
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

                                        _getResult('${time.year}-$month');
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
                                                Color.fromRGBO(39, 153, 93, 1),
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
                                          '挂账车牌号',
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
                                          '挂账时间',
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
                                  model.monthOnAccountDetailVos.length == 0
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              30,
                                          height: 80,
                                          child: Center(
                                            child: Text(
                                              '当月无挂帐记录',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: model
                                              .monthOnAccountDetailVos.length,
                                          itemBuilder:
                                              (BuildContext context, int item) {
                                            return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => SettlementDetailsPage(
                                                              model
                                                                  .monthOnAccountDetailVos[
                                                                      item][
                                                                      'workOrderId']
                                                                  .toString(),
                                                              model
                                                                  .monthOnAccountDetailVos[
                                                                      item][
                                                                      'vehicleLicence']
                                                                  .toString(),
                                                              true)));
                                                },
                                                child: Column(
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
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            model
                                                                .monthOnAccountDetailVos[
                                                                    item][
                                                                    'vehicleLicence']
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      139,
                                                                      139,
                                                                      139,
                                                                      1),
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                            child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            model
                                                                .monthOnAccountDetailVos[
                                                                    item][
                                                                    'leaveTime']
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      139,
                                                                      139,
                                                                      139,
                                                                      1),
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )),
                                                        Expanded(
                                                            child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            '￥${model.monthOnAccountDetailVos[item]['onAccount']}',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      139,
                                                                      139,
                                                                      139,
                                                                      1),
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )),
                                                        Icon(
                                                          Icons.chevron_right,
                                                          color: Color.fromRGBO(
                                                              139, 139, 139, 1),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              30,
                                                      height: 1,
                                                      color: Color.fromRGBO(
                                                          238, 238, 238, 1),
                                                    )
                                                  ],
                                                ));
                                          })
                                ],
                              ),
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
                ])));
  }
}
