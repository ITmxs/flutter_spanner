import 'package:flutter/material.dart';
import 'package:spanners/cModel/saleTaskModel.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/saleTask/saleApiRequst.dart';
import 'package:spanners/spannerHome/saleTask/saleTaskAdd.dart';
import 'package:spanners/publicView/pud_permission.dart';

class SaleTaskReview extends StatefulWidget {
  final year;
  final month;

  const SaleTaskReview({Key key, this.year, this.month}) : super(key: key);
  @override
  _SaleTaskReviewState createState() => _SaleTaskReviewState();
}

class _SaleTaskReviewState extends State<SaleTaskReview> {
  String showTime; //年月展示
  String employeeName = '';
  String employeeId = '';
  int page = 0;
  var year;
  var month;
  List peopleList = List(); // 人员列表
  List tasksList = List(); // 任务列表
  List dataList = List(); //
  ScrollController scrollController = ScrollController();
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

  // 任务list
  _getTaskList() {
    SaleApiRequst.taskListRequest(
      param: {
        'salesTime': year.toString() + '-' + month.toString(),
      },
      onSuccess: (data) {
        tasksList = data;
      },
    );
  }

  //员工销售记录分页
  _getrecordList(pages) {
    SaleApiRequst.recordListRequest(
      param: {
        'userId': employeeId == '' ? '' : employeeId,
        'salesTime': year.toString() + '-' + month.toString(),
        'current': pages,
        'size': 20
      },
      onSuccess: (data) {
        setState(() {
          if (data['list'].length == 0) {
            if (pages > 1) {
              Alart.showAlartDialog('没有更多了', 1);
            }
          }
          if (pages == 1) {
            dataList = data['list'];
          } else {
            dataList.addAll(data['list']);
          }
        });
      },
    );
  }

  // 通过 拒绝
  _putReview(String id, int status) {
    SaleApiRequst.reviewRequest(
      param: {'taskId': id, 'status': status},
      onSuccess: (data) {
        setState(() {
          _getrecordList(1);
        });
      },
    );
  }

  // 删除
  _delete(String id) {
    SaleApiRequst.deleteRequest(
      param: {
        'id': id,
      },
      onSuccess: (data) {
        setState(() {
          _getrecordList(1);
        });
      },
    );
  }

/*
下拉刷新
*/
  Future _toRefresh() async {
    page = 1;
    _getrecordList(1);
    return null;
  }

/*
加载更多
*/
  _loadMore() {
    //滑动到底部监听
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page++;
        print('滑动到了最底部${scrollController.position.pixels}');
        _getrecordList(page);
      }
    });
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
    year = widget.year;
    month = widget.month;
    showTime = '${widget.year}年${widget.month}月';
    _getrecordList(1);
    _getEmployeeList();
    _getTaskList();
    _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text('审核列表',
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
          actions: [
            InkWell(
              onTap: () {
                //权限处理 详细参考 后台Excel
                PermissionApi.whetherContain('sales_task_opt_add')
                    ? print('')
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SaleTaskAdd(
                                  employeeList: peopleList,
                                  taskList: tasksList,
                                ))).then((value) => _getrecordList(1));
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
        body: RefreshIndicator(
            onRefresh: _toRefresh,
            child: ScrollConfiguration(
              behavior: NeverScrollBehavior(),
              child: ListView(
                controller: scrollController,
                children: [
                  //全部员工筛选 据角色而定
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 21,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
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
                                        type: 9,
                                        dataList: peopleList,
                                        onChanges: (name, id) {
                                          setState(() {
                                            employeeName = name;
                                            employeeId = id;
                                            page = 1;
                                            _getrecordList(1);
                                            print('员工名$name,员工id$id');
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
                                    employeeName == '' ? '全部员工' : employeeName,
                                    style: TextStyle(
                                        color: Color.fromRGBO(67, 67, 67, 1),
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color.fromRGBO(67, 67, 67, 1),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
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
                                    page = 1;
                                    _getrecordList(1);
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
                                    page = 1;
                                    _getrecordList(1);
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

                  isNull(dataList) == 0
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('当前暂无审核')
                          ],
                        )
                      : taskList(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )));
  }

  //
  taskList() {
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
                        //时间  状态  删除操作
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
                                  SalesReviewModel.fromJson(dataList[item])
                                      .updateTime,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),
                                Expanded(child: SizedBox()),
                                Text(
                                  SalesReviewModel.fromJson(dataList[item])
                                              .status ==
                                          1
                                      ? '待审核'
                                      : SalesReviewModel.fromJson(
                                                      dataList[item])
                                                  .status ==
                                              2
                                          ? '已通过'
                                          : SalesReviewModel.fromJson(
                                                          dataList[item])
                                                      .status ==
                                                  3
                                              ? '已拒绝'
                                              : '',
                                  style: TextStyle(
                                      color: Color.fromRGBO(39, 153, 93, 1),
                                      fontSize: 15.0),
                                ),
                                //
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //权限处理 详细参考 后台Excel
                                    PermissionApi.whetherContain(
                                            'sales_task_opt_add')
                                        ? print('')
                                        : _delete(SalesReviewModel.fromJson(
                                                dataList[item])
                                            .id);
                                  },
                                  child: Text(
                                    '删除',
                                    style: TextStyle(
                                        color: Color.fromRGBO(39, 153, 93, 1),
                                        fontSize: 15.0),
                                  ),
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
                              width: MediaQuery.of(context).size.width - 30,
                              height: 1,
                              color: Color.fromRGBO(238, 238, 238, 1),
                            )
                          ],
                        ),
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
                                Text(
                                  SalesReviewModel.fromJson(dataList[item])
                                      .realName,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
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
                                Text(
                                  SalesReviewModel.fromJson(dataList[item])
                                      .taskName,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
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
                                Text(
                                  '¥${SalesReviewModel.fromJson(dataList[item]).amount}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
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
                              width: MediaQuery.of(context).size.width - 30,
                              height: 1,
                              color: Color.fromRGBO(238, 238, 238, 1),
                            )
                          ],
                        ),
                        //完成时间
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
                                  '完成时间',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),
                                Expanded(child: SizedBox()),
                                Text(
                                  SalesReviewModel.fromJson(dataList[item])
                                      .completeTime,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SalesReviewModel.fromJson(dataList[item]).status ==
                                    1
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    height: 1,
                                    color: Color.fromRGBO(238, 238, 238, 1),
                                  )
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //拒绝 通过 按钮
                        //状态 待审核 显示 拒绝通过
                        SalesReviewModel.fromJson(dataList[item]).status == 1
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //权限处理 详细参考 后台Excel
                                      PermissionApi.whetherContain(
                                              'sales_task_opt_check')
                                          ? print('')
                                          : _putReview(
                                              SalesReviewModel.fromJson(
                                                      dataList[item])
                                                  .id,
                                              3);
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              Color.fromRGBO(255, 77, 76, 1)),
                                      child: Text(
                                        '拒绝',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  ),
                                  Expanded(child: SizedBox()),
                                  GestureDetector(
                                    onTap: () {
                                      //权限处理 详细参考 后台Excel
                                      PermissionApi.whetherContain(
                                              'sales_task_opt_check')
                                          ? print('')
                                          : _putReview(
                                              SalesReviewModel.fromJson(
                                                      dataList[item])
                                                  .id,
                                              2);
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              Color.fromRGBO(39, 153, 93, 1)),
                                      child: Text(
                                        '通过',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                ],
                              )
                            : Container(),
                        SalesReviewModel.fromJson(dataList[item]).status == 1
                            ? SizedBox(
                                height: 30,
                              )
                            : Container()
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ],
          );
        });
  }
}
