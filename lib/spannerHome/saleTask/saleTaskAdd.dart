import 'package:flutter/material.dart';
import 'package:spanners/cTools/keyboardLimit.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/saleTask/saleApiRequst.dart';
import 'package:spanners/cTools/Alart.dart';

class SaleTaskAdd extends StatefulWidget {
  final employeeList;
  final taskList;
  const SaleTaskAdd({Key key, this.employeeList, this.taskList})
      : super(key: key);
  @override
  _SaleTaskAddState createState() => _SaleTaskAddState();
}

class _SaleTaskAddState extends State<SaleTaskAdd> {
  String employeeName = '';
  String employeeId = '';
  String taskName = '';
  String taskId = '';
  String timeShow; //用于选择展示
  DateTime date;
  DateTime nowTime = DateTime.now();
  String amount = '';

  //
  _postSave() {
    if (amount == '' || taskId == '' || employeeId == '' || timeShow == null) {
      Alart.showAlartDialog('各项不能为空', 1);
      return;
    }
    SaleApiRequst.saveRequest(
      param: {
        'amount': amount,
        'id': taskId,
        'userId': employeeId,
        'completeTime': timeShow
      },
      onSuccess: (data) {
        setState(() {
          Navigator.pop(context);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text('新建审核',
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
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        //员工姓名
                        Column(
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 21,
                                ),
                                Text(
                                  '员工姓名',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),
                                Expanded(child: SizedBox()),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      isDismissible: true,
                                      enableDrag: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return new Container(
                                          height: 300.0,
                                          child: ShowBottomSheet(
                                            type: 10,
                                            dataList: widget.employeeList,
                                            onChanges: (name, id) {
                                              setState(() {
                                                employeeName = name;
                                                employeeId = id;
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        employeeName == ''
                                            ? '请选择'
                                            : employeeName,
                                        style: TextStyle(
                                            color: employeeName == ''
                                                ? Color.fromRGBO(
                                                    133, 133, 133, 1)
                                                : Color.fromRGBO(40, 40, 40, 1),
                                            fontSize: 14.0),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: employeeName == ''
                                            ? Color.fromRGBO(133, 133, 133, 1)
                                            : Color.fromRGBO(40, 40, 40, 1),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 1,
                              color: Color.fromRGBO(238, 238, 238, 1),
                            )
                          ],
                        ),
                        //任务名称
                        Column(
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 21,
                                ),
                                Text(
                                  '任务名称',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),
                                Expanded(child: SizedBox()),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      isDismissible: true,
                                      enableDrag: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return new Container(
                                          height: 300.0,
                                          child: ShowBottomSheet(
                                            type: 11,
                                            dataList: widget.taskList,
                                            onChanges: (name, id) {
                                              setState(() {
                                                taskName = name;
                                                taskId = id;
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        taskName == '' ? '请选择' : taskName,
                                        style: TextStyle(
                                            color: taskName == ''
                                                ? Color.fromRGBO(
                                                    133, 133, 133, 1)
                                                : Color.fromRGBO(40, 40, 40, 1),
                                            fontSize: 14.0),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: taskName == ''
                                            ? Color.fromRGBO(133, 133, 133, 1)
                                            : Color.fromRGBO(40, 40, 40, 1),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 1,
                              color: Color.fromRGBO(238, 238, 238, 1),
                            )
                          ],
                        ),
                        //销售额
                        Column(
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 21,
                                ),
                                Text(
                                  '销售额',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),
                                Expanded(child: SizedBox()),
                                Row(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxHeight: 20, maxWidth: 100),
                                            child: TextFormField(
                                              inputFormatters: [
                                                KeyboardLimit(1)
                                              ],
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 0),
                                                hintText: '请输入',
                                                hintStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        164, 164, 164, 1),
                                                    fontSize: 14),
                                                border: new OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                              onChanged: (value) {
                                                amount = value;
                                              },
                                            ))),
                                    Icon(Icons.chevron_right,
                                        color: Colors.white)
                                  ],
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 1,
                              color: Color.fromRGBO(238, 238, 238, 1),
                            )
                          ],
                        ),
                        //完成时间
                        Column(children: [
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 21,
                              ),
                              Text(
                                '完成时间',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.0),
                              ),
                              Expanded(child: SizedBox()),
                              GestureDetector(
                                onTap: () {
                                  YinPicker.showDatePicker(context,
                                      nowTimes: date == null ? nowTime : date,
                                      dateType: DateType.YMD,
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
                                              nowTime.day,
                                            )
                                          : DateTime(
                                              date.year,
                                              date.month,
                                              nowTime.day,
                                            ),
                                      clickCallback: (var str, var time) {
                                    print(str);
                                    print(time);
                                    setState(() {
                                      var month = time.month < 10
                                          ? '0${time.month}'
                                          : time.month.toString();
                                      timeShow =
                                          '${time.year}-$month-${time.day}';

                                      date = time;
                                    });
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      timeShow == null ? '请选择' : timeShow,
                                      style: TextStyle(
                                          color: timeShow == null
                                              ? Color.fromRGBO(133, 133, 133, 1)
                                              : Color.fromRGBO(40, 40, 40, 1),
                                          fontSize: 14.0),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: timeShow == null
                                          ? Color.fromRGBO(133, 133, 133, 1)
                                          : Color.fromRGBO(40, 40, 40, 1),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 14,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ])
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _postSave();
                  },
                  child: Container(
                    width: 203,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(39, 153, 93, 1)),
                    child: Text(
                      '保存并等待店长审核',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
