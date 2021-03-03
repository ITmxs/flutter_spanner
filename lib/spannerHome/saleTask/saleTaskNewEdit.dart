import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/keyboardLimit.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/saleTask/saleApiRequst.dart';

class NewOrEdite extends StatefulWidget {
  final date;
  final employeeList;
  final id;
  const NewOrEdite({Key key, this.employeeList, this.date, this.id})
      : super(key: key);
  @override
  _NewOrEditeState createState() => _NewOrEditeState();
}

class _NewOrEditeState extends State<NewOrEdite> {
  String ids = '';
  List updata = List();
  Map upMap = Map();
  String emPrice = '';
  TextEditingController piceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  FocusNode priceNode = FocusNode();

  //去掉 冗余 判空
  _returnList() {
    for (var i = 0; i < updata.length; i++) {
      if (updata[i]['targetAmount'] == '' && updata[i]['userId'] == '') {
        updata.removeAt(i);
      }
      if (updata[i]['targetAmount'] == '' && updata[i]['userId'] != '') {
        Alart.showAlartDialog('请分配任务金额', 1);
      }
      if (updata[i]['targetAmount'] != '' && updata[i]['userId'] == '') {
        Alart.showAlartDialog('请选择店内人员', 1);
      }
    }
  }

  //待分配余额是否超出 与 销售任务 判空 检测
  _returnPrice() {
    if (!upMap.containsKey('taskName')) {
      Alart.showAlartDialog('请输入任务名称', 1);
      return;
    }
    if (upMap.containsKey('taskName') && upMap['taskName'] == '') {
      Alart.showAlartDialog('请输入任务名称', 1);
      return;
    }
    if (piceController.text == '') {
      Alart.showAlartDialog('请输入目标金额', 1);
      return;
    }
    if (piceController.text == '') {
      Alart.showAlartDialog('请输入目标金额', 1);
      return;
    }
    double sum = 0;
    //当前已分配的
    for (var i = 0; i < updata.length; i++) {
      if (updata[i]['targetAmount'] != '') {
        if (updata[i]['targetAmount'].contains('.')) {
          double a = double.parse(updata[i]['targetAmount']);
          sum = sum + a;
        } else {
          int a = int.parse(updata[i]['targetAmount']);
          sum = sum + a;
        }
      }
    }
    //目标金额
    if (piceController.text.contains('.')) {
      double a = double.parse(piceController.text);
      if (a - sum < 0) {
        Alart.showAlartDialog('超出可分配金额', 1);
        return;
      } else {
        emPrice = (a - sum).toStringAsFixed(1);
        return;
      }
    } else {
      int a = int.parse(piceController.text);
      if (a - sum < 0) {
        Alart.showAlartDialog('超出可分配金额', 1);
        return;
      } else {
        emPrice = (a - sum).toStringAsFixed(1);
        return;
      }
    }
  }

  //post数据
  _postData() {
    SaleApiRequst.salesTaskSaveRequest(
      param: {
        'id': ids,
        'salesTime': widget.date,
        'taskName': upMap['taskName'],
        'total': upMap['total'],
        'employeeList': updata,
      },
      onSuccess: (data) {
        setState(() {
          Navigator.pop(context);
        });
      },
    );
  }

  //获取详细信息
  _getDetail() {
    SaleApiRequst.taskInfoRequest(
      param: {
        'taskId': widget.id,
      },
      onSuccess: (data) {
        setState(() {
          ids = data['id'].toString();
          piceController.text = data['total'].toString();
          nameController.text = data['taskName'].toString();
          upMap['taskName'] = data['taskName'].toString();
          upMap['total'] = data['total'].toString();
          updata = data['salesTaskEmployeeList'];
          _returnPrice();
        });
      },
    );
  }

  //删除
  _delete() {
    SaleApiRequst.salesTaskDeleteRequest(
      param: {
        'id': widget.id,
      },
      onSuccess: (data) {
        setState(() {
          Navigator.pop(context);
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.id == null
        ?
        //新建 map初始化
        updata.add({'userId': '', 'realName': '', 'targetAmount': ''})
        : _getDetail();
    priceNode.addListener(() {
      if (!priceNode.hasFocus) {
        print('失去焦点');
        setState(() {
          emPrice = piceController.text;
        });
      } else {
        print('得到焦点');
      }
    });
    // itemPriceNode.addListener(() {
    //   if (!itemPriceNode.hasFocus) {
    //     print('失去焦点');
    //     setState(() {
    //       _returnPrice();
    //     });
    //   } else {
    //     print('得到焦点');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _returnPrice();
          });
          //点击空白处隐藏键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(238, 238, 238, 1),
            appBar: AppBar(
              centerTitle: true,
              title: Text('任务编辑',
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
                  Row(
                    children: [
                      SizedBox(
                        width: 22,
                      ),
                      Text('销售任务',
                          style: TextStyle(
                            color: Color.fromRGBO(39, 153, 93, 1),
                            fontSize: 18,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  //销售任务
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
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: 20, maxWidth: 100),
                                        child: TextFormField(
                                          controller: nameController,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0, horizontal: 0),
                                            hintText: '请输入',
                                            hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    164, 164, 164, 1),
                                                fontSize: 14),
                                            border: new OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                          onChanged: (value) {
                                            upMap['taskName'] = value;
                                          },
                                        ))),
                                SizedBox(
                                  width: 20,
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
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: 20, maxWidth: 100),
                                        child: TextFormField(
                                          focusNode: priceNode,
                                          controller: piceController,
                                          inputFormatters: [KeyboardLimit(1)],
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0, horizontal: 0),
                                            hintText: '请输入',
                                            hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    164, 164, 164, 1),
                                                fontSize: 14),
                                            border: new OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                          onChanged: (value) {
                                            upMap['total'] = value;
                                          },
                                          onFieldSubmitted: (value) {
                                            setState(() {
                                              _returnPrice();
                                            });
                                          },
                                        ))),
                                SizedBox(
                                  width: 20,
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
                  ),

                  //分配任务
                  SizedBox(
                    height: 21,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 22,
                      ),
                      Text('分配任务',
                          style: TextStyle(
                            color: Color.fromRGBO(39, 153, 93, 1),
                            fontSize: 18,
                          )),
                      SizedBox(
                        width: 15,
                      ),
                      Text('剩余¥${emPrice == '' ? 0 : emPrice}待分配',
                          style: TextStyle(
                            color: Color.fromRGBO(126, 126, 126, 1),
                            fontSize: 13,
                          )),
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
                          setState(() {
                            updata.add({
                              'userId': '',
                              'realName': '',
                              'targetAmount': ''
                            });
                          });
                        },
                        child: Text(
                          '添加员工+',
                          style: TextStyle(
                              color: Color.fromRGBO(39, 153, 93, 1),
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.id == null
                              ? Navigator.pop(context)
                              : _delete();
                        },
                        child: Container(
                          width: 70,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(255, 77, 76, 1)),
                          child: Text(
                            '删除',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _returnList();
                            _returnPrice();
                            //保存
                            _postData();
                          });
                        },
                        child: Container(
                          width: 70,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(39, 153, 93, 1)),
                          child: Text(
                            '保存',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 200,
                  )
                ],
              ),
            )));
  }

  list() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: updata.length,
        itemBuilder: (BuildContext context, int item) {
          return Column(
            children: [
              SizedBox(
                height: 11,
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
                              '员工姓名',
                              style: TextStyle(
                                  color: Color.fromRGBO(35, 33, 33, 1),
                                  fontSize: 15),
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
                                            updata[item]['realName'] = name;
                                            updata[item]['userId'] = id;
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
                                    updata[item]['realName'] == ''
                                        ? '请选择'
                                        : updata[item]['realName'],
                                    style: TextStyle(
                                        color: updata[item]['userId'] == ''
                                            ? Color.fromRGBO(133, 133, 133, 1)
                                            : Color.fromRGBO(40, 40, 40, 1),
                                        fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          updata.removeAt(item);
                                          _returnPrice();
                                        });
                                      },
                                      child: Icon(
                                        Icons.remove_circle_outline,
                                        color: Color.fromRGBO(255, 76, 77, 1),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 11,
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
                            Row(
                              children: [
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: 20, maxWidth: 100),
                                        child: TextFormField(
                                          //  focusNode: itemPriceNode,
                                          controller: TextEditingController
                                              .fromValue(TextEditingValue(
                                                  // 设置内容
                                                  text: updata[item]
                                                      ['targetAmount'],
                                                  // 保持光标在最后
                                                  selection: TextSelection
                                                      .fromPosition(TextPosition(
                                                          affinity: TextAffinity
                                                              .downstream,
                                                          offset: updata[item][
                                                                  'targetAmount']
                                                              .length)))),
                                          inputFormatters: [KeyboardLimit(1)],
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0, horizontal: 0),
                                            hintText: '请输入',
                                            hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    164, 164, 164, 1),
                                                fontSize: 14),
                                            border: new OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                          onChanged: (value) {
                                            updata[item]['targetAmount'] =
                                                value;
                                            setState(() {
                                              _returnPrice();
                                            });
                                          },
                                        ))),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 11,
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
              ),
            ],
          );
        });
  }
}
