//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spanners/cModel/recCarModel.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/newOrder/carName.dart';
import 'package:spanners/cTools/Alart.dart';
import './carAddCarMessage.dart';
import './appointmentRequestApi.dart';

class CarAddAppointment extends StatefulWidget {
  final ValueChanged<int> onChanged; //返回页面刷新操作  1

  const CarAddAppointment({Key key, this.onChanged}) : super(key: key);
  @override
  _CarAddAppointmentState createState() => _CarAddAppointmentState();
}

class _CarAddAppointmentState extends State<CarAddAppointment>
    with WidgetsBindingObserver {
  List projectList = List(); //一级项目集
  List titleList = List(); //一级项目名称集
  List sonProjectList = List(); //二级项目集
  List sonTitleList = List(); //二级项目名称集
  String projectType = ''; //一级项目名称
  String sonprojectType = ''; //二级项目名称
  List dataList = List();
  bool liu = false;
  String dateValue = '';
  String flowtext = ''; //  备注信息
  Map dataMap = Map(); //上传数据

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
          //  print('projectList--->$titleList');
        },
        onError: (error) {
          _showAlartDialog('');
        });
  }

  Future _showAlartDialog(String message) async {
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

  /* 新建预约*/
  _postData() {
    ApiDio.newApointMentRequests(
      pragm: dataMap,
      onSuccess: (data) {
        widget.onChanged(1);
        Navigator.pop(context);
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
      if (projectList[i]['id'] == dataMap['serviceId']) {
        for (var j = 0; j < projectList[i]['secondaryList'].length; j++) {
          if (projectList[i]['secondaryList'][j]['secondaryDictName']
              .contains(secText)) {
            dataList.add(projectList[i]['secondaryList'][j]);
          }
        }
      }
    }

    print('模糊搜索结果');
  }

  var _secondController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getTypeList();
    //初始化
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          //关闭键盘
          print('关闭键盘');
          dataList.clear();
        } else {
          //显示键盘
          print('显示键盘');
        }
      });
    });
  }

  @override
  void dispose() {
    //销毁
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          // elevation: 0,
          brightness: Brightness.light,
          title: Text(
            '添加预约',
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
                //车辆信息
                CarMessageList(
                  onChanged: (value) {
                    dataMap.addAll(value);
                    print('传来的map:$dataMap');
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                //服务信息
                Row(
                  children: [
                    SizedBox(
                      width: 14,
                    ),
                    Image.asset(
                      'Assets/apointMent/services.png',
                      width: 19,
                      height: 16,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '服务信息',
                      style: TextStyle(
                          color: Color.fromRGBO(39, 153, 93, 1), fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                //一级项目种类
                Row(
                  children: [
                    SizedBox(
                      width: 14,
                    ),
                    InkWell(
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
                                        if (projectList[i]['dictName'] ==
                                            value) {
                                          print(
                                              '指向这里${projectList[i]['dictName']}');
                                          dataMap['serviceId'] =
                                              projectList[i]['id']; //一级分类 id
                                          dataMap['serviceName'] =
                                              projectList[i]
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
                                      projectType = value;
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '项目种类',
                                style: TextStyle(
                                    color: Color.fromRGBO(42, 42, 42, 1),
                                    fontSize: 14),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                projectType == '' ? '请选择 ' : '$projectType ',
                                style: TextStyle(
                                    color: projectType == ''
                                        ? Color.fromRGBO(164, 164, 164, 1)
                                        : Colors.black,
                                    fontSize: 14),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Color.fromRGBO(164, 164, 164, 1),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                  ],
                ),

                SizedBox(
                  height: 5,
                ),

                //二级项目名称  模糊查询
                Row(
                  children: [
                    SizedBox(
                      width: 14,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '项目名称',
                              style: TextStyle(
                                  color: Color.fromRGBO(42, 42, 42, 1),
                                  fontSize: 14),
                            ),
                          ),
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerRight,
                            child: ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxHeight: 20, maxWidth: 100),
                              child: TextFormField(
                                controller: _secondController,
                                onChanged: (value) {
                                  setState(() {
                                    if (dataMap['serviceId'] == null) {
                                      Alart.showAlartDialog('请先选择项目种类', 1);
                                    } else {
                                      sonprojectType = value;
                                      dataMap['secondaryServiceId'] = '';
                                      dataMap['secondaryService'] = value;
                                      _searchSecondaryList(value);
                                    }
                                  });
                                },
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
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
                              ),
                            ),
                          )),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.transparent,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 14,
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
                                dataMap['secondaryService'] =
                                    RecCarModel.fromJson(value)
                                        .dictName
                                        .toString();
                                dataMap['secondaryServiceId'] =
                                    RecCarModel.fromJson(value).id.toString();

                                dataMap['cost'] = double.parse(
                                    RecCarModel.fromJson(value)
                                        .cost
                                        .toString());

                                sonprojectType = RecCarModel.fromJson(value)
                                    .dictName
                                    .toString();

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
                  height: 5,
                ),
                //服务时间
                Row(
                  children: [
                    SizedBox(
                      width: 14,
                    ),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        showModalBottomSheet(
                          isDismissible: true,
                          enableDrag: false,
                          context: context,
                          builder: (BuildContext context) {
                            return DatePickerView(
                              onChanged: (value) {
                                setState(() {
                                  dataMap['appointmentTime'] = value;
                                  dateValue = value;
                                });
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '服务时间',
                                style: TextStyle(
                                    color: Color.fromRGBO(42, 42, 42, 1),
                                    fontSize: 14),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                dateValue == '' ? '请选择 ' : dateValue,
                                style: TextStyle(
                                    color: dateValue == ''
                                        ? Color.fromRGBO(164, 164, 164, 1)
                                        : Color.fromRGBO(42, 42, 42, 1),
                                    fontSize: 14),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Color.fromRGBO(164, 164, 164, 1),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                  ],
                ),
                // //添加照片
                // CarAddImageView(),
                //备注
                Column(children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '备注',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 200, maxWidth: 300),
                          child: TextFormField(
                            maxLines: 6,
                            onChanged: (value) {
                              setState(() {
                                flowtext = value;
                                /*  发布 文字 数量 限制  */
                                if (value.length > 500) {
                                  Alart.showAlartDialog('超出字数限制', 1);
                                } else {
                                  dataMap['remark'] = value;
                                  flowtext = value;
                                }
                              });
                            },
                            style: TextStyle(fontSize: 15, color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              hintText: '请输入发表的内容',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(136, 133, 133, 1),
                                  fontSize: 15),
                              enabledBorder: OutlineInputBorder(
                                //未选中时候的颜色
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                //选中时外边框颜色
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ]),
                SizedBox(
                  height: 35,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      print('提交map$dataMap');
                      if (dataMap['vehicleLicence'] == null ||
                          dataMap['carBrand'] == null ||
                          dataMap['model'] == null ||
                          dataMap['mobile'] == null ||
                          dataMap['appointmentName'] == null) {
                        Alart.showAlartDialog('必填项不能为空', 1);
                      } else if (projectType == '') {
                        Alart.showAlartDialog('请选择项目种类', 1);
                      } else if (sonprojectType == '') {
                        Alart.showAlartDialog('请选择项目名称', 1);
                      } else if (dateValue == '') {
                        Alart.showAlartDialog('请选择预约时间', 1);
                      } else {
                        /* 新建工单提交*/
                        _postData();
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(39, 153, 93, 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '提交',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            )));
  }
}
