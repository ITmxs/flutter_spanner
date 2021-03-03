import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spanners/cModel/pubModel.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/newOrder/carARquestApi.dart';
import './carMessageAdd.dart';
import './carServe.dart';
import './carComment.dart';
import './carSureView.dart';
import './vipTopView.dart';
import '../appointment/appointmentRequestApi.dart';

class NewOrder extends StatefulWidget {
  final String workOrderId;
  final type;

  const NewOrder({Key key, this.workOrderId, this.type}) : super(key: key);
  @override
  _NewOrderState createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  List oneSerList = List(); //汽车服务集
  List titleList = List(); //一级项目名称集
  String brand = ''; //车辆品牌
  String model = ''; //车辆类型
  Map upDataMap = Map(); //用于上传的Map
  int type = 0; //vip 类型 0 非会员 1 个人vip  2 公司会员
  Map vipMap = Map();
  Map vehcileMap = Map();
  Map valueMap = Map();
  //Map upMap = Map(); //
  List upData = List(); //
  String vehicleLicences;
  /* 获取一级服务*/
  _getOneSer() {
    ApiDio.getserviceDictList(
      pragm: '',
      onSuccess: (data) {
        setState(() {
          oneSerList = data;
          print('oneSerList--->$oneSerList');
        });
      },
      onError: (error) {
        _showAlartDialog('');
      },
    );
  }

  Future _showAlartDialog(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ServiceLoad(
          onChanged: (value) {
            _getOneSer();
          },
        );
      },
    );
  }

  //根据 workOrderId 获取车辆详细服务信息 且已经存在的项目不可修改
  _getDetail() {
    RecCarDio.getDetailRequest(
      param: widget.workOrderId,
      onSuccess: (data) {
        setState(() {
          if (data['type'] == 0) {
            for (var i = 0;
                i < data['receiveCar']['receiveCarServiceList'].length;
                i++) {
              for (var j = 0;
                  j <
                      data['receiveCar']['receiveCarServiceList'][i]
                              ['secondaryServicelList']
                          .length;
                  j++) {
                Map upMap = Map();
                upMap['serviceId'] = data['receiveCar']['receiveCarServiceList']
                        [i]['serviceId']
                    .toString();
                upMap['serviceName'] = data['receiveCar']
                        ['receiveCarServiceList'][i]['dictName']
                    .toString();
                upMap['secondaryId'] = data['receiveCar']
                            ['receiveCarServiceList'][i]
                        ['secondaryServicelList'][j]['secondaryId']
                    .toString();
                upMap['secondaryService'] = data['receiveCar']
                            ['receiveCarServiceList'][i]
                        ['secondaryServicelList'][j]['secondaryService']
                    .toString();
                upMap['price'] = data['receiveCar']['receiveCarServiceList'][i]
                        ['secondaryServicelList'][j]['price']
                    .toString();
                upMap['count'] = data['receiveCar']['receiveCarServiceList'][i]
                        ['secondaryServicelList'][j]['num']
                    .toString();
                upMap['receiveCarMaterialList'] = data['receiveCar']
                    ['receiveCarServiceList'][i]['receiveCarMaterialList'];
                //  可以根据二级list做循环 集合
                upData.add(upMap);
              }
            }
            if (widget.type == 'NO') {
            } else {
              SharedManager.saveString('0', 'type');
              SharedManager.removeString('receiveCarServiceList');
              SharedManager.saveString(
                  json.encode({'receiveCarServiceList': upData}).toString(),
                  'receiveCarServiceList');
            }
          }
          valueMap = data['receiveCar'];
          if (data['memberDetail'] != null) {
            if (data['memberDetail']['type'] == '1') {
              //个人
              type = 1;
              vipMap = data['memberDetail'];
              vehicleLicences = vipMap['member']['vehicleLicence'];
            } else if (data['memberDetail']['type'] == '1') {
              //公司
              type = 2;
              vipMap = data['memberDetail'];
              vehicleLicences = vipMap['member']['vehicleLicence'];
            } else {
              type = 0;
            }
          } else {
            type = 0;
          }
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //返回时清除接车工单缓存
    SharedManager.removeString('receiveCarServiceList');
    /* 获取一级服务*/
    _getOneSer();
    if (widget.workOrderId == null) {
    } else {
      _getDetail();
    }
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
            '接车确认',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                print('点击了返回');
                //返回时清除接车工单缓存
                SharedManager.removeString('receiveCarServiceList');
                SharedManager.removeString('upCarMap');
                SharedManager.removeString('CommentUpmap');
                Navigator.pop(context);
              }),
        ),
        body: WillPopScope(
            // ignore: missing_return
            onWillPop: () async {
              // 点击返回键的操作
              SharedManager.removeString('upCarMap');
            },
            child: ScrollConfiguration(
              behavior: NeverScrollBehavior(),
              child: ListView(
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  //非会员车辆信息填写
                  type == 0
                      ? CarMessageAdd(
                          valueMap: valueMap,
                          onChanged: (value) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                brand = value['brand'] ?? '';
                                model = value['model'] ?? '';
                                vehicleLicences = value['vehicleLicence'];
                                vehcileMap = value;
                                upDataMap.addAll(value);
                                print('车辆信息回调传值：$upDataMap');
                              });
                            });
                          },
                          onChangedVip: (value) {
                            setState(() {
                              vipMap = value;
                              type = int.parse(value['type']);
                              vehicleLicences =
                                  PublicModel.fromJson(vipMap['member'])
                                      .vehicleLicence;
                              print('回调信息$type');
                            });
                          },
                        )
                      : //会员车辆信息
                      VipTopView(
                          type: type,
                          vipMap: vipMap,
                        ),
                  type == 0
                      ? SizedBox(
                          height: 24,
                        )
                      :
                      //车辆服务 保养手册  全车检查
                      SizedBox(
                          height: 30,
                        ),
                  //汽车 服务
                  CarServe(
                    brands: brand,
                    models: model,
                    serList: oneSerList,
                    vehicleLicence: vehicleLicences,
                  ),

                  //备注 接车员 照片
                  SizedBox(
                    height: 30,
                  ),
                  CarComment(
                    dataMap: valueMap, //vehcileMap,
                    onChanged: (value) {
                      upDataMap.addAll(value);
                      print('车辆信息回调数据：$value');
                    },
                  ),
                  //下一步
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Container(
                    width: 105,
                    height: 30,
                    child: FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Color.fromRGBO(39, 153, 93, 1),
                        //  loginVisible
                        //     ? Color.fromRGBO(39, 153, 93, 1)
                        //     : Color.fromRGBO(39, 153, 93, 0.6),
                        onPressed: () {
                          //非会员 需要检测 ，会员不需要检测
                          if (type == 0) {
                            if (upDataMap.isEmpty) {
                              Alart.showAlartDialog('请先填写接车信息', 1);
                              return;
                            }
                            if (upDataMap['vehicleLicence'] == null ||
                                upDataMap['vehicleLicence'] == '' ||
                                upDataMap['brand'] == null ||
                                upDataMap['brand'] == '' ||
                                upDataMap['model'] == null ||
                                upDataMap['model'] == '') {
                              Alart.showAlartDialog('请先填写必填项', 1);

                              return;
                            }
                            var value = SynchronizePreferences.getCarMap();

                            if (value == null) {
                              Alart.showAlartDialog('未选择服务', 1);
                              return;
                            }
                            upDataMap['workOrderId'] = widget.workOrderId;
                            upDataMap.addAll(value);
                            for (var i = 0;
                                i < upDataMap['receiveCarServiceList'].length;
                                i++) {
                              if (upDataMap['receiveCarServiceList'][i]
                                  .containsKey('receiveCarMaterialList')) {
                                for (var j = 0;
                                    j <
                                        upDataMap['receiveCarServiceList'][i]
                                                ['receiveCarMaterialList']
                                            .length;
                                    j++) {
                                  if (upDataMap['receiveCarServiceList'][i]
                                              ['receiveCarMaterialList'][j]
                                          ['partsSource'] ==
                                      '库存') {
                                    upDataMap['receiveCarServiceList'][i]
                                            ['receiveCarMaterialList'][j]
                                        ['partsSource'] = '0';
                                  } else if (upDataMap['receiveCarServiceList']
                                              [i]['receiveCarMaterialList'][j]
                                          ['partsSource'] ==
                                      '采购') {
                                    upDataMap['receiveCarServiceList'][i]
                                            ['receiveCarMaterialList'][j]
                                        ['partsSource'] = '1';
                                  }
                                }
                              }
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CarSureView(
                                        working: widget.type == 'NO' ? 1 : 0,
                                        type: type,
                                        vipMap: vipMap,
                                        dataMap: upDataMap,
                                      )),
                            );
                          } else {
                            upDataMap['vehicleLicence'] =
                                vipMap['member']['vehicleLicence'];
                            var value = SynchronizePreferences.getCarMap();

                            if (value == null) {
                              Alart.showAlartDialog('未选择服务', 1);
                              return;
                            } else {
                              upDataMap['workOrderId'] = widget.workOrderId;
                              upDataMap.addAll(value);
                              for (var i = 0;
                                  i < upDataMap['receiveCarServiceList'].length;
                                  i++) {
                                if (upDataMap['receiveCarServiceList'][i]
                                    .containsKey('receiveCarMaterialList')) {
                                  for (var j = 0;
                                      j <
                                          upDataMap['receiveCarServiceList'][i]
                                                  ['receiveCarMaterialList']
                                              .length;
                                      j++) {
                                    if (upDataMap['receiveCarServiceList'][i]
                                                ['receiveCarMaterialList'][j]
                                            ['partsSource'] ==
                                        '库存') {
                                      upDataMap['receiveCarServiceList'][i]
                                              ['receiveCarMaterialList'][j]
                                          ['partsSource'] = '0';
                                    } else if (upDataMap[
                                                    'receiveCarServiceList'][i]
                                                ['receiveCarMaterialList'][j]
                                            ['partsSource'] ==
                                        '采购') {
                                      upDataMap['receiveCarServiceList'][i]
                                              ['receiveCarMaterialList'][j]
                                          ['partsSource'] = '1';
                                    }
                                  }
                                } else {}
                              }
                            }
                            upDataMap['vehicleLicences'] =
                                vipMap['vehicleLicences'];

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CarSureView(
                                        working: widget.type == 'NO' ? 1 : 0,
                                        type: type,
                                        vipMap: vipMap,
                                        dataMap: upDataMap,
                                      )),
                            );
                          }
                        },
                        child: Text('下一步',
                            style: TextStyle(
                              color: Colors.white,

                              // loginVisible
                              //     ? Colors.white
                              //     : Colors.white70,
                            ))),
                  )),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            )));
  }
}
