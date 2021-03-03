import 'package:flutter/material.dart';
import 'package:spanners/cModel/operationStatisticsModel.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/operationStatistics/operationApi.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_details_page.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_nonmember_page.dart';

class BillStatistic extends StatefulWidget {
  @override
  _BillStatisticState createState() => _BillStatisticState();
}

class _BillStatisticState extends State<BillStatistic> {
  BillModel billModel;
  String timeShow; //用于选择展示
  DateTime date;
  DateTime nowTime = DateTime.now();
  // 工单详情
  _getMenuResult(String ym) {
    OperationApi.workOrderListRequst(
      param: {'nowMonth': ym},
      onSuccess: (data) {
        setState(() {
          billModel = BillModel.fromJson(data);
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeShow = '${nowTime.year}-${nowTime.month}';
    _getMenuResult('${nowTime.year}-${nowTime.month}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 1,
          title: Text(
            '运营统计',
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
        body: billModel == null
            ? Container()
            : ScrollConfiguration(
                behavior: NeverScrollBehavior(),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    //top 工单type
                    Row(
                      children: [
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: Text('工单实收金额',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                        )),
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: Text('工单配件成本',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    //金额
                    Row(
                      children: [
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: Text('¥${billModel.workOrderMoney}',
                              style: TextStyle(
                                  color: Color.fromRGBO(39, 153, 93, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        )),
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: Text('¥${billModel.workOrderPartMoney}',
                              style: TextStyle(
                                  color: Color.fromRGBO(39, 153, 93, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 3,
                          color: Color.fromRGBO(238, 238, 238, 1),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    //时间筛选
                    Row(
                      children: [
                        Expanded(child: SizedBox()),
                        Text(
                          '时间筛选',
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                        SizedBox(
                          width: 30,
                        ),
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
                                      ), clickCallback: (var str, var time) {
                              setState(() {
                                var month = time.month < 10
                                    ? '0${time.month}'
                                    : time.month.toString();
                                timeShow = '${time.year}-$month';
                                _getMenuResult(timeShow);
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
                                    color: Color.fromRGBO(186, 224, 204, 1),
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
                        ),
                      ],
                    ),
                    //列表展示
                    billModel.workOrderListDtos.length == 0
                        ? Container(
                            width: MediaQuery.of(context).size.width - 30,
                            height: 80,
                            child: Center(
                              child: Text(
                                '当月工单记录',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: billModel.workOrderListDtos.length,
                            itemBuilder: (BuildContext context, int item) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    238, 238, 238, 1))),
                                        child: Column(
                                          children: [
                                            //详情
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color.fromRGBO(
                                                      238, 238, 238, 1)),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    BillListModel.fromJson(billModel
                                                                .workOrderListDtos[
                                                            item])
                                                        .carNo,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  GestureDetector(
                                                    onTap: () {
                                                      //跳转 结算详情
                                                      billModel.workOrderListDtos[
                                                                      item][
                                                                  'memberId'] ==
                                                              null
                                                          ? Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => SettlementNonmemberPage(
                                                                      billModel
                                                                          .workOrderListDtos[
                                                                              item]
                                                                              [
                                                                              'workOrderId']
                                                                          .toString(),
                                                                      BillListModel.fromJson(
                                                                              billModel.workOrderListDtos[item])
                                                                          .carNo,
                                                                      true)),
                                                            )
                                                          : Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => SettlementDetailsPage(
                                                                      billModel
                                                                          .workOrderListDtos[
                                                                              item]
                                                                              [
                                                                              'workOrderId']
                                                                          .toString(),
                                                                      BillListModel.fromJson(
                                                                              billModel.workOrderListDtos[item])
                                                                          .carNo,
                                                                      true)),
                                                            );
                                                    },
                                                    child: Text(
                                                      '详情',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            39, 153, 93, 1),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //配件成本
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '配件成本',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '工单收入',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    '结算时间',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '¥${BillListModel.fromJson(billModel.workOrderListDtos[item]).workOrderPartMoney}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '¥${BillListModel.fromJson(billModel.workOrderListDtos[item]).workOrderMoney}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    BillListModel.fromJson(billModel
                                                                .workOrderListDtos[
                                                            item])
                                                        .time
                                                        .substring(
                                                            5,
                                                            BillListModel.fromJson(
                                                                    billModel
                                                                            .workOrderListDtos[
                                                                        item])
                                                                .time
                                                                .length),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                )),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  )
                                ],
                              );
                            }),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ));
  }
}
