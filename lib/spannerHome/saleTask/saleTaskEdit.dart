import 'package:flutter/material.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/saleTask/saleApiRequst.dart';
import 'package:spanners/spannerHome/saleTask/saleTaskNewEdit.dart';

class TaskEdit extends StatefulWidget {
  final years;
  final months;
  const TaskEdit({Key key, this.years, this.months}) : super(key: key);
  @override
  _TaskEditState createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  List peopleList = List(); // 人员列表
  String showTime; //年月展示
  var year;
  var month;
  List dataList = List();
  _getTaskList() {
    SaleApiRequst.editTaskListRequest(
      param: {
        'salesTime': year.toString() + '-' + month.toString(),
      },
      onSuccess: (data) {
        setState(() {
          dataList = data;
        });
      },
    );
  }

  // 人员列表
  _getEmployeeList() {
    SaleApiRequst.employeeListRequest(
      onSuccess: (data) {
        setState(() {
          peopleList = data['employeeList'];
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    year = widget.years;
    month = widget.months;
    showTime = '${widget.years}年${widget.months}月';
    _getTaskList();
    _getEmployeeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text('店内任务',
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
                height: 20,
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
                                _getTaskList();
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
                                _getTaskList();
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
                  ),
                ],
              ),

              list(),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 37,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewOrEdite(
                                    employeeList: peopleList,
                                    date: year.toString() +
                                        '-' +
                                        month.toString(),
                                  ))).then((value) => _getTaskList());
                    },
                    child: Text(
                      '添加新的店内任务+',
                      style: TextStyle(
                          color: Color.fromRGBO(39, 153, 93, 1), fontSize: 15),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ));
  }

  list() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: dataList.length,
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
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 19,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 4,
                              height: 16,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Color.fromRGBO(39, 153, 93, 1)),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '任务名称',
                              style: TextStyle(
                                  color: Color.fromRGBO(35, 33, 33, 1),
                                  fontSize: 15),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              dataList[item]['taskName'],
                              style: TextStyle(
                                  color: Color.fromRGBO(35, 33, 33, 1),
                                  fontSize: 15),
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewOrEdite(
                                              id: dataList[item]['id'],
                                              employeeList: peopleList,
                                              date: year.toString() +
                                                  '-' +
                                                  month.toString(),
                                            ))).then((value) => _getTaskList());
                              },
                              child: Image.asset(
                                'Assets/salesTask/salesedit.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 1,
                          color: Color.fromRGBO(238, 238, 238, 1),
                        ),
                        SizedBox(
                          height: 19,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 4,
                              height: 16,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '目标金额',
                              style: TextStyle(
                                  color: Color.fromRGBO(35, 33, 33, 1),
                                  fontSize: 15),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '¥${dataList[item]['total']}',
                              style: TextStyle(
                                  color: Color.fromRGBO(35, 33, 33, 1),
                                  fontSize: 15),
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 16,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 11,
                        )
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
        });
  }
}
