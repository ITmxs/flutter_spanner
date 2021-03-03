import 'package:flutter/material.dart';
import 'package:spanners/cModel/recCarModel.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/keyboardLimit.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/appointment/appointmentRequestApi.dart';
import 'package:spanners/spannerHome/newOrder/carName.dart';
import 'package:spanners/spannerHome/storeActivity/astoreActivityApi.dart';

class StoreActivityEdite extends StatefulWidget {
  final String title;
  final String campaignId;
  final int edit; // 1  是从 修改而来
  const StoreActivityEdite({Key key, this.title, this.campaignId, this.edit})
      : super(key: key);
  @override
  _StoreActivityEditeState createState() => _StoreActivityEditeState();
}

class _StoreActivityEditeState extends State<StoreActivityEdite> {
  DateTime nowTime = DateTime.now();
  String moneyTime = ''; //使用期限
  String startTime = '';
  String endTime = '';
  List projectList = List(); //一级项目集
  List titleList = List(); //一级项目名称集
  List sonProjectList = List(); //二级项目集
  List sonTitleList = List(); //二级项目名称集
  String projectType = ''; //一级项目名称
  String sonprojectType = ''; //二级项目名称
  List dataList = List();
  Map dataMap = Map(); //上传数据
  bool open = false; //是否启用
  bool showOpen = false; //广告位是否展示
  var _titleController = TextEditingController(); //主题
  //次卡
  var _hdpriceController = TextEditingController(); //活动价格
  var _secondController = TextEditingController(); //项目名称
  var _countController = TextEditingController(); //项目次数
  //充值
  var _czpriceController = TextEditingController(); //充值金额
  var _gmpriceController = TextEditingController(); //购买金额

  var _remarkController = TextEditingController(); //活动详情
  /*  获取一二级分类 */
  _getTypeList() {
    ApiDio.getserviceDictList(
        pragm: '',
        onSuccess: (data) {
          projectList = data;
          var count = projectList.length;
          print('projectList--->$projectList');
          for (var i = 0; i < count; i++) {
            if (projectList[i]['dictName'] == '其他配件项目') {
              projectList.removeAt(i);
            } else {
              titleList.add(projectList[i]['dictName']);
            }
          }
          print('projectList--->$titleList');
        },
        onError: (value) {
          _showAlartDialogs('');
        });
  }

  Future _showAlartDialogs(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ServiceLoad(
          onChanged: (value) {
            _getTypeList();
          },
        );
      },
    );
  }

  //修改时获取详细信息
  _getMessage() {
    ActivityDio.campaignDetailRequest(
      param: {'id': widget.campaignId},
      onSuccess: (data) {
        setState(() {
          //展示区域
          data['status'] == 0 ? open = true : open = false;
          data['adFlag'] == 1 ? showOpen = true : showOpen = false;
          _titleController.text = data['campaignName'];
          _remarkController.text = data['remarks'];
          if (widget.title == '项目次卡') {
            moneyTime = data['month'] == 6
                ? '半年'
                : data['month'] == 12
                    ? '一年'
                    : data['month'] == 24
                        ? '两年'
                        : '';
            _hdpriceController.text = data['buyPrice'].toString();
            projectType = data['campaignService']['serviceName'] ?? '';
            _secondController.text = data['campaignService']['secondaryName'];
            sonprojectType = data['campaignService']['secondaryName'];
            _countController.text =
                data['campaignService']['quantity'].toString();
          }
          if (widget.title == '充值优惠') {
            _czpriceController.text = data['accountPrice'].toString();
            _gmpriceController.text = data['buyPrice'].toString();
            startTime = data['beginTime'];
            endTime = data['endTime'];
          }
          /**
            数据封装区域 
            */
          dataMap['id'] = widget.campaignId;
          dataMap['status'] = data['status'];
          dataMap['adFlag'] = data['adFlag'];
          dataMap['campaignName'] = data['campaignName'];
          dataMap['remarks'] = data['remarks'];
          if (widget.title == '项目次卡') {
            //差一个 使用期限
            dataMap['month'] = data['month'];
            dataMap['buyPrice'] = data['buyPrice'];
            dataMap['secondaryName'] = data['campaignService']['secondaryName'];
            dataMap['serviceId'] = data['campaignService']['serviceId'];
            dataMap['serviceName'] = data['campaignService']['serviceName'];
            dataMap['service'] = data['campaignService']['service'];
            dataMap['quantity'] = data['campaignService']['quantity'];
          }
          if (widget.title == '充值优惠') {
            dataMap['accountPrice'] = data['accountPrice'];
            dataMap['buyPrice'] = data['buyPrice'];
            dataMap['beginTime'] = data['beginTime'];
            dataMap['endTime'] = data['endTime'];
          }
        });
      },
    );
  }

  /* 本地模糊搜索 */
  _searchSecondaryList(String secText) {
    //
    setState(() {
      dataList.clear();
    });
    for (var i = 0; i < projectList.length; i++) {
      if (projectList[i]['id'] == dataMap['service']) {
        for (var j = 0; j < projectList[i]['secondaryList'].length; j++) {
          if (projectList[i]['secondaryList'][j]['secondaryDictName']
              .contains(secText)) {
            dataList.add(projectList[i]['secondaryList'][j]);
          }
        }
      }
    }
  }

  // 保存提交
  _postSave() {
    if (!dataMap.containsKey('serviceId') && dataMap['type'] == 1) {
      Alart.showAlartDialog('请选择项目名称', 1);
      return;
    }
    if (!dataMap.containsKey('campaignName') || dataMap['campaignName'] == '') {
      Alart.showAlartDialog('请输入活动主题', 1);
      return;
    }
    if (!dataMap.containsKey('beginTime') && dataMap['type'] == 0) {
      Alart.showAlartDialog('请选择开始时间', 1);
      return;
    }
    if (!dataMap.containsKey('endTime') && dataMap['type'] == 0) {
      Alart.showAlartDialog('请选择结束时间', 1);
      return;
    }

    if (!dataMap.containsKey('month') && dataMap['type'] == 1) {
      Alart.showAlartDialog('请选择使用期限', 1);
      return;
    }
    if (!dataMap.containsKey('buyPrice') || dataMap['buyPrice'] == '') {
      dataMap['type'] == 1
          ? Alart.showAlartDialog('请输入活动价格', 1)
          : Alart.showAlartDialog('请输入购买价格', 1);
      return;
    }
    if (dataMap['type'] == 0) {
      if (!dataMap.containsKey('accountPrice') ||
          dataMap['accountPrice'] == '') {
        Alart.showAlartDialog('请输入活动价格', 1);
        return;
      }
    }
    if (dataMap['type'] == 1) {
      if (!dataMap.containsKey('quantity') || dataMap['quantity'] == '') {
        Alart.showAlartDialog('请输入项目数量', 1);
        return;
      }
    }

    ActivityDio.campaignSaveRequest(
      param: dataMap,
      onSuccess: (data) {
        Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTypeList();
    widget.title == '充值优惠' ? dataMap['type'] = 0 : dataMap['type'] = 1;
    dataMap['status'] = 1;
    dataMap['adFlag'] = 0;
    dataMap['month'] = '';
    if (widget.campaignId != null) {
      _getMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          brightness: Brightness.light,
          title: Text(
            widget.title,
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
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: [
              SizedBox(
                height: 24,
              ),
              widget.title == '充值优惠' ? money() : card(),
              SizedBox(
                height: 26,
              ),
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        open ? open = false : open = true;
                        open ? dataMap['status'] = 0 : dataMap['status'] = 1;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          open ? Icons.check_circle : Icons.lens,
                          color: open ? Colors.black : Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '启用',
                          style: TextStyle(
                              color: Color.fromRGBO(30, 30, 30, 1),
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showOpen ? showOpen = false : showOpen = true;
                        showOpen
                            ? dataMap['adFlag'] = 1
                            : dataMap['adFlag'] = 0;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          showOpen ? Icons.check_circle : Icons.lens,
                          color: showOpen ? Colors.black : Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '广告位展示',
                          style: TextStyle(
                              color: Color.fromRGBO(30, 30, 30, 1),
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    print('123');
                    _postSave();
                  },
                  child: Container(
                    width: 105,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(39, 153, 93, 1)),
                    child: Text(
                      '保存',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  //充值
  money() {
    return Column(
      children: [
        // 主题活动
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3), color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '活动主题',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  Expanded(child: SizedBox()),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 20, maxWidth: 100),
                          child: TextFormField(
                            // inputFormatters: [KeyboardLimit(1)],
                            // keyboardType:
                            //     TextInputType.numberWithOptions(
                            //         decimal: true),
                            enabled: widget.edit == 1 ? false : true,
                            controller: _titleController,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              hintText: '请输入',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(164, 164, 164, 1),
                                  fontSize: 14),
                              border: new OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            onChanged: (value) {
                              dataMap['campaignName'] = value;
                            },
                          ))),
                  Icon(Icons.chevron_right, color: Colors.white)
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
        //充值金额
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3)),
                  color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '赠送金额',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  Expanded(child: SizedBox()),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 20, maxWidth: 100),
                          child: TextFormField(
                            controller: _czpriceController,
                            enabled: widget.edit == 1 ? false : true,
                            inputFormatters: [KeyboardLimit(1)],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              hintText: '请输入',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(164, 164, 164, 1),
                                  fontSize: 14),
                              border: new OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            onChanged: (value) {
                              dataMap['accountPrice'] = value;
                            },
                          ))),
                  Icon(Icons.chevron_right, color: Colors.white)
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
        SizedBox(
          height: 1,
        ),
        //购买价格
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0), color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '充值价格',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  Expanded(child: SizedBox()),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 20, maxWidth: 100),
                          child: TextFormField(
                            enabled: widget.edit == 1 ? false : true,
                            controller: _gmpriceController,
                            inputFormatters: [KeyboardLimit(1)],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              hintText: '请输入',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(164, 164, 164, 1),
                                  fontSize: 14),
                              border: new OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            onChanged: (value) {
                              dataMap['buyPrice'] = value;
                            },
                          ))),
                  Icon(Icons.chevron_right, color: Colors.white)
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
        SizedBox(
          height: 1,
        ),
        //开始时间
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0), color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '开始时间',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      YinPicker.showDatePicker(context,
                          nowTimes: nowTime,
                          dateType: DateType.YMD,
                          title: "",
                          minValue: DateTime(
                            2015,
                            10,
                          ),
                          maxValue: DateTime(
                            2023,
                            10,
                          ),
                          value: DateTime(
                              nowTime.year, nowTime.month, nowTime.day),
                          clickCallback: (var str, var time) {
                        setState(() {
                          var month = time.month < 10
                              ? '0${time.month}'
                              : time.month.toString();
                          startTime = '${time.year}-$month-${time.day}';
                          dataMap['beginTime'] = startTime;
                        });
                      });
                    },
                    child: Text(
                      startTime == '' ? '请选择' : startTime,
                      style: TextStyle(
                          color: startTime == ''
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Color.fromRGBO(40, 40, 40, 1),
                          fontSize: 14),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: startTime == ''
                        ? Color.fromRGBO(164, 164, 164, 1)
                        : Color.fromRGBO(40, 40, 40, 1),
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
          height: 1,
        ),
        //结束时间
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(3),
                      bottomRight: Radius.circular(3)),
                  color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '结束时间',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      YinPicker.showDatePicker(context,
                          nowTimes: nowTime,
                          dateType: DateType.YMD,
                          title: "",
                          minValue: DateTime(
                            2015,
                            10,
                          ),
                          maxValue: DateTime(
                            2023,
                            10,
                          ),
                          value: DateTime(
                              nowTime.year, nowTime.month, nowTime.day),
                          clickCallback: (var str, var time) {
                        setState(() {
                          var month = time.month < 10
                              ? '0${time.month}'
                              : time.month.toString();
                          endTime = '${time.year}-$month-${time.day}';
                          dataMap['endTime'] = startTime;
                        });
                      });
                    },
                    child: Text(
                      endTime == '' ? '请选择' : endTime,
                      style: TextStyle(
                          color: endTime == ''
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Color.fromRGBO(40, 40, 40, 1),
                          fontSize: 14),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: endTime == ''
                        ? Color.fromRGBO(164, 164, 164, 1)
                        : Color.fromRGBO(40, 40, 40, 1),
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
          height: 21,
        ),
        Row(
          children: [
            SizedBox(
              width: 26,
            ),
            Text(
              '活动详情',
              style:
                  TextStyle(color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
            ),
          ],
        ),
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
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 30),
                      child: TextFormField(
                        controller: _remarkController,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 0),
                          hintText: '  请输入......',
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(164, 164, 164, 1),
                              fontSize: 14),
                          border: new OutlineInputBorder(
                              borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          dataMap['remarks'] = value;
                        },
                      ))),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        )
      ],
    );
  }

  //次卡
  card() {
    return Column(
      children: [
        // 主题活动
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3), color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '活动主题',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  Expanded(child: SizedBox()),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 20, maxWidth: 100),
                          child: TextFormField(
                            // inputFormatters: [KeyboardLimit(1)],
                            // keyboardType:
                            //     TextInputType.numberWithOptions(
                            //         decimal: true),
                            enabled: widget.edit == 1 ? false : true,
                            controller: _titleController,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              hintText: '请输入',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(164, 164, 164, 1),
                                  fontSize: 14),
                              border: new OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            onChanged: (value) {
                              dataMap['campaignName'] = value;
                            },
                          ))),
                  Icon(Icons.chevron_right, color: Colors.white)
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
        //使用期限
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0), color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '使用期限',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showModalBottomSheet(
                        isDismissible: true,
                        enableDrag: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 300.0,
                            child: ShowBottomSheet(
                                type: 12,
                                dataList: ['半年', '一年', '两年'],
                                onChanged: (value) {
                                  setState(() {
                                    moneyTime = value;
                                    if (value == '半年') {
                                      dataMap['month'] = 6;
                                    }
                                    if (value == '一年') {
                                      dataMap['month'] = 12;
                                    }
                                    if (value == '两年') {
                                      dataMap['month'] = 24;
                                    }
                                  });
                                }),
                          );
                        },
                      );
                    },
                    child: Text(
                      moneyTime == '' ? '请选择' : moneyTime,
                      style: TextStyle(
                          color: moneyTime == ''
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Color.fromRGBO(30, 30, 30, 1),
                          fontSize: 14),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: moneyTime == ''
                        ? Color.fromRGBO(164, 164, 164, 1)
                        : Color.fromRGBO(30, 30, 30, 1),
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
        //活动价格
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3), color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '活动价格',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  Expanded(child: SizedBox()),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 20, maxWidth: 100),
                          child: TextFormField(
                            enabled: widget.edit == 1 ? false : true,
                            controller: _hdpriceController,
                            inputFormatters: [KeyboardLimit(1)],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              hintText: '请输入',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(164, 164, 164, 1),
                                  fontSize: 14),
                              border: new OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            onChanged: (value) {
                              dataMap['buyPrice'] = value;
                            },
                          ))),
                  Icon(Icons.chevron_right, color: Colors.white)
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
        //项目种类
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3)),
                  color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '项目种类',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showModalBottomSheet(
                        isDismissible: true,
                        enableDrag: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 300.0,
                            child: ShowBottomSheet(
                              type: 1,
                              dataList: titleList,
                              onChanged: (value) {
                                setState(() {
                                  print('项目种类$value');
                                  if (value == null) {
                                  } else {
                                    for (var i = 0;
                                        i < projectList.length;
                                        i++) {
                                      if (projectList[i]['dictName'] == value) {
                                        print(
                                            '指向这里${projectList[i]['dictName']}');
                                        dataMap['service'] =
                                            projectList[i]['id']; //一级分类 id
                                        dataMap['serviceName'] = projectList[i]
                                            ['dictName']; //一级分类 id
                                        sonTitleList.clear();

                                        sonProjectList =
                                            projectList[i]['secondaryList'];
                                        for (var i = 0;
                                            i < sonProjectList.length;
                                            i++) {
                                          sonTitleList.add(sonProjectList[i]
                                              ['secondaryDictName']);
                                        }
                                        print('二级项目名：$sonTitleList,');
                                      }
                                    }
                                    print('二级项目集合：$sonProjectList,');

                                    sonprojectType = '';
                                    _secondController.text = '';
                                    dataMap.remove('serviceId');
                                    projectType = value;
                                  }
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      projectType == '' ? '请选择 ' : projectType,
                      style: TextStyle(
                          color: projectType == ''
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Color.fromRGBO(40, 40, 40, 1),
                          fontSize: 14),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: projectType == ''
                        ? Color.fromRGBO(164, 164, 164, 1)
                        : Color.fromRGBO(40, 40, 40, 1),
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
          height: 1,
        ),
        //项目名称
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(3),
                      bottomRight: Radius.circular(3)),
                  color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '项目名称',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  Expanded(child: SizedBox()),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 20, maxWidth: 130),
                          child: TextFormField(
                            controller: _secondController,
                            // inputFormatters: [KeyboardLimit(1)],
                            // keyboardType:
                            //     TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              hintText: '请输入并选择项目',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(164, 164, 164, 1),
                                  fontSize: 14),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (projectType == '') {
                                  Alart.showAlartDialog('请先选择项目种类', 1);
                                } else {
                                  // sonprojectType = value;
                                  // dataMap['secondaryServiceId'] = '';
                                  // dataMap['secondaryService'] = value;
                                  dataMap.remove('serviceId');
                                  dataMap.remove('secondaryName');
                                  _searchSecondaryList(value);
                                }
                              });
                            },
                          ))),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
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
          height: 2,
        ),
        dataList.length == 0
            ? Container()
            : Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  CarNameList(
                    type: 2,
                    dataList: dataList,
                    onChanged: (value) {
                      setState(() {
                        /*  传来的 二级项目名 ID*/
                        // dataMap['secondaryService'] =
                        //     RecCarModel.fromJson(value).dictName.toString();
                        dataMap['serviceId'] =
                            RecCarModel.fromJson(value).id.toString();
                        dataMap['secondaryName'] =
                            RecCarModel.fromJson(value).dictName.toString();
                        sonprojectType =
                            RecCarModel.fromJson(value).dictName.toString();

                        _secondController.text = sonprojectType;

                        dataList.clear();
                      });
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
        SizedBox(
          height: 8,
        ),
        // 项目次数
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3), color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    '项目次数',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  Expanded(child: SizedBox()),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 20, maxWidth: 100),
                          child: TextFormField(
                            enabled: widget.edit == 1 ? false : true,
                            controller: _countController,
                            inputFormatters: [KeyboardLimit(1)],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              hintText: '请输入',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(164, 164, 164, 1),
                                  fontSize: 14),
                              border: new OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            onChanged: (value) {
                              dataMap['quantity'] = value;
                            },
                          ))),
                  Icon(Icons.chevron_right, color: Colors.white)
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
        SizedBox(
          height: 21,
        ),
        Row(
          children: [
            SizedBox(
              width: 26,
            ),
            Text(
              '活动详情',
              style:
                  TextStyle(color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
            ),
          ],
        ),

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
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 30),
                      child: TextFormField(
                        controller: _remarkController,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 0),
                          hintText: '  请输入......',
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(164, 164, 164, 1),
                              fontSize: 14),
                          border: new OutlineInputBorder(
                              borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          dataMap['remarks'] = value;
                        },
                      ))),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        )
      ],
    );
  }
}
