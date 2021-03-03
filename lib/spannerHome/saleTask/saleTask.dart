import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:spanners/cModel/saleTaskModel.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/saleTask/saleApiRequst.dart';
import 'package:spanners/spannerHome/saleTask/saleTaskEdit.dart';
import 'package:spanners/spannerHome/saleTask/saleTaskReview.dart';

class SaleTask extends StatefulWidget {
  @override
  _SaleTaskState createState() => _SaleTaskState();
}

class _SaleTaskState extends State<SaleTask> {
  bool showTask = true; //店内与员工任务切换，默认展示店内任务
  Map dataMap = Map();
  String showTime; //年月展示
  DateTime nowTime = DateTime.now();
  var year;
  var month;
  //
  _getsalesTask(String date) {
    SaleApiRequst.salesTaskRequest(
      param: {'salesTime': date},
      onSuccess: (data) {
        setState(() {
          dataMap = data;
        });
      },
    );
  }

  // data 非空判断
  int isNull(List list) {
    if (list == null) {
      print('--->null');
      return 0;
    } else if (list.length == 0) {
      print('--->0');
      return 0;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    year = nowTime.year;
    month = nowTime.month;
    showTime = '${nowTime.year}年${nowTime.month}月';
    _getsalesTask('${nowTime.year}-${nowTime.month}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text('销售任务',
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
                Navigator.pop(context);
              }),
        ),
        body: dataMap.length == 0
            ? Container()
            : ScrollConfiguration(
                behavior: NeverScrollBehavior(),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 11,
                    ),
                    //总进度
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              CircularPercentIndicator(
                                  radius: 190.0,
                                  lineWidth: 13.0,
                                  percent: dataMap['complete'] /
                                              dataMap['allAmount'] >
                                          1.0
                                      ? 1.0
                                      : dataMap['complete'] /
                                          dataMap['allAmount'],
                                  animation: true,
                                  animationDuration: 1000, //动画时长
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            dataMap['complete'].toString(),
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    39, 153, 93, 1),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 41.0),
                                          ),
                                          Text(
                                            '万',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    39, 153, 93, 1),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 26.0),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '已完成',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(39, 153, 93, 1),
                                            fontSize: 18.0),
                                      ),
                                      SizedBox(
                                        height: 13,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          //权限处理 详细参考 后台Excel
                                          PermissionApi.whetherContain(
                                                  'sales_task_opt_add')
                                              ? print('')
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SaleTaskReview(
                                                            year: year,
                                                            month: month,
                                                          )));
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 70,
                                          height: 28,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color.fromRGBO(
                                                  39, 153, 93, 1)),
                                          child: Text(
                                            '添加记录',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                fontSize: 13.0),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  backgroundColor:
                                      Color.fromRGBO(39, 153, 93, 0.1),
                                  linearGradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      dataMap['complete'] /
                                                  dataMap['allAmount'] >
                                              1.0
                                          ? Color.fromRGBO(39, 153, 93, 1)
                                          : Color.fromRGBO(39, 153, 93, 0.3),
                                      Color.fromRGBO(39, 153, 93, 1)
                                    ],
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '总任务${dataMap['allAmount']}万',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(40, 40, 40, 1),
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 26,
                                    color: Color.fromRGBO(39, 153, 93, 1),
                                  ),
                                  Expanded(
                                      child: Text(
                                    '待完成${(dataMap['allAmount'] - dataMap['complete']).toStringAsFixed(1)}万',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(40, 40, 40, 1),
                                        fontSize: 15.0),
                                  ))
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
                      height: 11,
                    ),
                    //月份筛选
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromRGBO(39, 153, 93, 1),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      month = month - 1 < 1 ? 12 : month - 1;
                                      if (month == 12) {
                                        year = year - 1;
                                      }
                                      showTime = '$year年$month月';
                                      _getsalesTask('$year-$month');
                                    });
                                  }),
                              Expanded(
                                  child: Text(
                                showTime,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              )),
                              GestureDetector(
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      month = month + 1 > 12 ? 1 : month + 1;
                                      if (month == 1) {
                                        year = year + 1;
                                      }
                                      showTime = '$year年$month月';
                                      _getsalesTask('$year-$month');
                                    });
                                  }),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        )
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    //店内任务  员工任务
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
                                height: 20,
                              ),
                              //店内  员工  筛选
                              Row(
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showTask
                                            ? showTask = false
                                            : showTask = true;
                                      });
                                    },
                                    child: Text(
                                      '店内任务',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(40, 40, 40, 1),
                                          fontWeight:
                                              showTask ? FontWeight.bold : null,
                                          fontSize: showTask ? 16.0 : 15.0),
                                    ),
                                  )),
                                  Expanded(
                                      child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showTask
                                                  ? showTask = false
                                                  : showTask = true;
                                            });
                                          },
                                          child: Text(
                                            '员工任务',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    40, 40, 40, 1),
                                                fontWeight: showTask
                                                    ? null
                                                    : FontWeight.bold,
                                                fontSize:
                                                    showTask ? 15.0 : 16.0),
                                          )))
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            30 / 2,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: showTask
                                            ? Color.fromRGBO(39, 153, 93, 1)
                                            : Color.fromRGBO(238, 238, 238, 1)),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            30 / 2,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            showTask ? 0 : 2),
                                        color: showTask
                                            ? Color.fromRGBO(238, 238, 238, 1)
                                            : Color.fromRGBO(39, 153, 93, 1)),
                                  ),
                                ],
                              ),

                              showTask
                                  ?
                                  //店内任务列表展示
                                  taskView()
                                  :
                                  //员工任务列表展示
                                  employeeView(),
                              SizedBox(
                                height: 26,
                              ),
                              //编辑店内任务
                              showTask
                                  ? GestureDetector(
                                      onTap: () {
                                        //权限处理 详细参考 后台Excel
                                        PermissionApi.whetherContain(
                                                'sales_task_opt')
                                            ? print('')
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskEdit(
                                                          years: year,
                                                          months: month,
                                                        ))).then((value) =>
                                                _getsalesTask('$year-$month'));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 135,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color:
                                                Color.fromRGBO(39, 153, 93, 1)),
                                        child: Text(
                                          '编辑店内任务',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              fontSize: 15.0),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 20,
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
                      height: 50,
                    ),
                  ],
                )));
  }

  //店内任务列表展示
  taskView() {
    return isNull(dataMap['taskList']) == 0
        ? Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text('当前暂无店内任务')
            ],
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dataMap['taskList'].length,
            itemBuilder: (BuildContext context, int item) {
              return Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        SalesModel.fromJson(dataMap['taskList'][item]).taskName,
                        style: TextStyle(
                            color: Color.fromRGBO(40, 40, 40, 1),
                            fontSize: 15.0),
                      )
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
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 46,
                        lineHeight: 8.0,
                        percent: SalesModel.fromJson(dataMap['taskList'][item])
                                        .complete /
                                    SalesModel.fromJson(
                                            dataMap['taskList'][item])
                                        .total >
                                1.0
                            ? 1.0
                            : SalesModel.fromJson(dataMap['taskList'][item])
                                    .complete /
                                SalesModel.fromJson(dataMap['taskList'][item])
                                    .total,
                        animation: true,
                        animationDuration: 500,
                        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
                        linearGradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            SalesModel.fromJson(dataMap['taskList'][item])
                                            .complete /
                                        SalesModel.fromJson(
                                                dataMap['taskList'][item])
                                            .total >
                                    1
                                ? Color.fromRGBO(39, 153, 93, 1)
                                : Color.fromRGBO(39, 153, 93, 0.1),
                            Color.fromRGBO(39, 153, 93, 1)
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
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
                      Text(
                        '已完成￥${SalesModel.fromJson(dataMap['taskList'][item]).complete}',
                        style: TextStyle(
                            color: Color.fromRGBO(168, 168, 168, 1),
                            fontSize: 12.0),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        '总任务￥${SalesModel.fromJson(dataMap['taskList'][item]).total}',
                        style: TextStyle(
                            color: Color.fromRGBO(168, 168, 168, 1),
                            fontSize: 12.0),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 19,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 1,
                    color: Color.fromRGBO(238, 238, 238, 1),
                  )
                ],
              );
            });
  }

  //店内任务列表展示
  employeeView() {
    return isNull(dataMap['employeeList']) == 0
        ? Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text('当前暂无员工任务')
            ],
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dataMap['employeeList'].length,
            itemBuilder: (BuildContext context, int item) {
              return Column(
                children: [
                  item == 0
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 5,
                          color: Color.fromRGBO(238, 238, 238, 1),
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Color.fromRGBO(39, 153, 93, 1)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        dataMap['employeeList'][item]['realName'],
                        style: TextStyle(
                            color: Color.fromRGBO(
                              40,
                              40,
                              40,
                              1,
                            ),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  //员工任务列表
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          dataMap['employeeList'][item]['taskList'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 23,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  SalesModel.fromJson(dataMap['employeeList']
                                          [item]['taskList'][index])
                                      .taskName,
                                  style: TextStyle(
                                      color: Color.fromRGBO(40, 40, 40, 1),
                                      fontSize: 15.0),
                                )
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
                                LinearPercentIndicator(
                                  width: MediaQuery.of(context).size.width - 46,
                                  lineHeight: 8.0,
                                  percent: SalesModel.fromJson(dataMap['employeeList'][item]['taskList'][index])
                                                  .complete /
                                              SalesModel.fromJson(
                                                      dataMap['employeeList'][item]
                                                          ['taskList'][index])
                                                  .total >
                                          1.0
                                      ? 1.0
                                      : SalesModel.fromJson(dataMap['employeeList'][item]['taskList'][index])
                                              .complete /
                                          SalesModel.fromJson(dataMap['employeeList']
                                                  [item]['taskList'][index])
                                              .total,
                                  animation: true,
                                  animationDuration: 500,
                                  backgroundColor:
                                      Color.fromRGBO(238, 238, 238, 1),
                                  linearGradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      SalesModel.fromJson(dataMap['employeeList']
                                                              [item]['taskList']
                                                          [index])
                                                      .complete /
                                                  SalesModel.fromJson(
                                                          dataMap['employeeList']
                                                                      [item]
                                                                  ['taskList']
                                                              [index])
                                                      .total >
                                              1
                                          ? Color.fromRGBO(39, 153, 93, 1)
                                          : Color.fromRGBO(39, 153, 93, 0.1),
                                      Color.fromRGBO(39, 153, 93, 1)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
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
                                Text(
                                  '已完成￥${SalesModel.fromJson(dataMap['employeeList'][item]['taskList'][index]).complete}',
                                  style: TextStyle(
                                      color: Color.fromRGBO(168, 168, 168, 1),
                                      fontSize: 12.0),
                                ),
                                Expanded(child: SizedBox()),
                                Text(
                                  '总任务￥${SalesModel.fromJson(dataMap['employeeList'][item]['taskList'][index]).total}',
                                  style: TextStyle(
                                      color: Color.fromRGBO(168, 168, 168, 1),
                                      fontSize: 12.0),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 19,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 1,
                              color: Color.fromRGBO(238, 238, 238, 1),
                            )
                          ],
                        );
                      }),
                ],
              );
            });
  }
}
