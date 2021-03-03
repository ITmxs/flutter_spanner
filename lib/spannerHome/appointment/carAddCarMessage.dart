import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/notificationCenter.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/spannerHome/appointment/appointmentRequestApi.dart';

class CarMessageList extends StatefulWidget {
  final ValueChanged<Map> onChanged;

  const CarMessageList({Key key, this.onChanged}) : super(key: key);
  @override
  _CarMessageListState createState() => _CarMessageListState();
}

class _CarMessageListState extends State<CarMessageList> {
  Map<String, String> dataMap = Map(); //上传数据
  Map<String, dynamic> getMap = Map(); //得到的数据
  bool ocrBool = false; //控制键盘显示样式
  //车牌号
  List vecList = List();
  List _carTitles = [
    '预约车牌',
    '车辆品牌',
    '车辆型号',
    '预约人手机号',
    '预约人姓名',
    'VIN码',
    '车辆颜色',
  ];

  FocusNode vehicleNode = FocusNode();
  FocusNode modelNode = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode moblieNode = FocusNode();
  FocusNode vinNode = FocusNode();
  FocusNode carColorNode = FocusNode();

  /*  根据车牌号获取信息*/
  _getVehicleLicenceDictList(String value) {
    ApiDio.getVehicleLicenceDictList(
      pragm: value,
      onSuccess: (data) {
        if (data.toString() == 'null') {
        } else {
          setState(() {
            getMap = data;
            print('获取到的datamap:$getMap');
          });
        }
      },
    );
  }

  //判断 是否 必填
  String _isMust(String value) {
    if (value == 'VIN码' || value == '车辆颜色') {
      return '0'; //非必填
    } else {
      return '1';
    }
  }

  //赋值
  String _getMapString(String value) {
    switch (value) {
      case '预约车牌':
        if (getMap['vehicleLicence'].toString() == 'null') {
          print('---->0123');
        } else {
          print('---->123');
          dataMap['vehicleLicence'] = getMap['vehicleLicence'].toString();
          widget.onChanged(dataMap);
        }
        return dataMap['vehicleLicence'].toString();
        break;
      case '车辆品牌':
        if (getMap['brand'].toString() == 'null') {
          print('---->0123');
        } else {
          print('---->123');
          dataMap['carBrand'] = getMap['brand'].toString();
          widget.onChanged(dataMap);
        }
        return dataMap['carBrand'].toString();
        break;
      case '车辆型号':
        if (getMap['model'].toString() == 'null') {
        } else {
          dataMap['model'] = getMap['model'].toString();
          widget.onChanged(dataMap);
        }
        return dataMap['model'].toString();
        break;
      case '预约人手机号':
        if (getMap['mobile'].toString() == 'null') {
        } else {
          dataMap['mobile'] = getMap['mobile'].toString();
          widget.onChanged(dataMap);
        }
        return dataMap['mobile'].toString();
        break;
      case '预约人姓名':
        if (getMap['realName'].toString() == 'null') {
        } else {
          dataMap['appointmentName'] = getMap['realName'].toString();
          widget.onChanged(dataMap);
        }
        return dataMap['appointmentName'].toString();
        break;
      case 'VIN码':
        if (getMap['carVin'].toString() == 'null') {
        } else {
          dataMap['carVin'] = getMap['carVin'].toString();
          widget.onChanged(dataMap);
        }
        return dataMap['carVin'].toString();
        break;
      case '车辆颜色':
        if (getMap['carColor'].toString() == 'null') {
        } else {
          dataMap['carColor'] = getMap['carColor'].toString();
          widget.onChanged(dataMap);
        }
        return dataMap['carColor'].toString();
        break;

      default:
        return '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vehicleNode.addListener(() {
      if (!vehicleNode.hasFocus) {
        print('失去焦点-->${dataMap['vehicleLicence']}');
        //setState(() {
        if (dataMap['vehicleLicence'].toString() == 'null') {
        } else {
          _getVehicleLicenceDictList(dataMap['vehicleLicence'].toString());
        }
        // });
      } else {
        print('得到焦点');
        //  setState(() {});
      }
    });
    moblieNode.addListener(() {
      if (!moblieNode.hasFocus) {
        print('失去焦点-->}');
        // setState(() {
        if (dataMap['mobile'].length != 11) {
          Alart.showAlartDialog('当前手机号输入有误', 1);
          moblieNode.unfocus();
          //dataMap.remove('mobile');
        }
        //  });
      } else {
        print('得到焦点');
        //setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 25,
        ),
        Row(
          children: [
            SizedBox(
              width: 14,
            ),
            Image.asset(
              'Assets/apointMent/apointcar.png',
              width: 19,
              height: 16,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              '车辆信息',
              style: TextStyle(
                  color: Color.fromRGBO(39, 153, 93, 1), fontSize: 18),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            SizedBox(
              width: 14,
            ),
            Container(
                width: MediaQuery.of(context).size.width - 28,
                //height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                            _carTitles.length,
                            (index) => InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 11,
                                          ),
                                          _isMust(_carTitles[index]
                                                      .toString()) ==
                                                  '1'
                                              ? Container(
                                                  height: 16,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '*',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              255, 42, 42, 1),
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          Text(
                                            _carTitles[index].toString(),
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    30, 30, 30, 1),
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            width: 60,
                                          ),
                                          _carTitles[index].toString() == '预约车牌'
                                              ? Expanded(
                                                  child: InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      barrierColor:
                                                          Color.fromRGBO(
                                                              255, 255, 255, 0),
                                                      isScrollControlled: true,
                                                      isDismissible: true,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CarKeyboard(
                                                          type: ocrBool ? 1 : 0,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              if (value ==
                                                                  'del') {
                                                                if (vecList
                                                                        .length >
                                                                    0) {
                                                                  vecList
                                                                      .removeLast();
                                                                }
                                                                if (vecList
                                                                        .length ==
                                                                    0) {
                                                                  ocrBool =
                                                                      false;
                                                                  //发送通知
                                                                  NotificationCenter
                                                                      .instance
                                                                      .postNotification(
                                                                          'change',
                                                                          0);
                                                                }
                                                                dataMap.clear();
                                                              } else {
                                                                ocrBool = true;
                                                                //车牌号展示 逻辑
                                                                if (vecList
                                                                        .length <
                                                                    8) {
                                                                  vecList.add(
                                                                      value);
                                                                }
                                                              }

                                                              //数组list转 string
                                                              String result;
                                                              vecList.forEach(
                                                                  (string) => {
                                                                        if (result ==
                                                                            null)
                                                                          result =
                                                                              string
                                                                        else
                                                                          result =
                                                                              '$result$string'
                                                                      });
                                                              dataMap['vehicleLicence'] =
                                                                  result;

                                                              if (vecList
                                                                      .length >
                                                                  6) {
                                                                _getVehicleLicenceDictList(
                                                                    result);
                                                              }

                                                              print(
                                                                  '回调车牌:$result');
                                                            });
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: GridView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          new NeverScrollableScrollPhysics(),
                                                      //禁止滑动
                                                      itemCount: 8,
                                                      //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                              //横轴元素个数
                                                              crossAxisCount: 8,
                                                              //纵轴间距
                                                              mainAxisSpacing:
                                                                  0.0,
                                                              //横轴间距
                                                              crossAxisSpacing:
                                                                  5.0,
                                                              //子组件宽高长度比例
                                                              childAspectRatio:
                                                                  15 / 20),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int item) {
                                                        return Container(
                                                          width: 15,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      5),
                                                              border: Border.all(
                                                                  color: item ==
                                                                          vecList.length -
                                                                              1
                                                                      ? Color.fromRGBO(
                                                                          39,
                                                                          153,
                                                                          93,
                                                                          1)
                                                                      : Color.fromRGBO(
                                                                          220,
                                                                          220,
                                                                          220,
                                                                          1),
                                                                  width: 1),
                                                              color: item == 7
                                                                  ? Color.fromRGBO(
                                                                      233,
                                                                      245,
                                                                      238,
                                                                      1)
                                                                  : Colors.white),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              //用于解决 车牌号未输入完其余空展示
                                                              vecList.length ==
                                                                      8
                                                                  ? vecList[
                                                                      item]
                                                                  : item <
                                                                          vecList
                                                                              .length
                                                                      ? vecList[
                                                                          item]
                                                                      : '',
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          8,
                                                                          8,
                                                                          8,
                                                                          1),
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ))
                                              : Expanded(
                                                  child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxHeight: 20,
                                                        maxWidth: 200),
                                                    child: TextFormField(
                                                      controller: TextEditingController.fromValue(
                                                          TextEditingValue(
                                                              text: _getMapString(_carTitles[index].toString()) ==
                                                                      'null'
                                                                  ? ''
                                                                  : _getMapString(
                                                                      _carTitles[index]
                                                                          .toString()),
                                                              /* 设置光标停留位置，保持始终停留在末尾*/
                                                              selection: TextSelection.fromPosition(TextPosition(
                                                                  affinity:
                                                                      TextAffinity
                                                                          .downstream,
                                                                  offset: _getMapString(
                                                                          _carTitles[index]
                                                                              .toString())
                                                                      .length)))),

                                                      focusNode: _carTitles[
                                                                      index]
                                                                  .toString() ==
                                                              '预约人手机号'
                                                          ? moblieNode
                                                          : _carTitles[index]
                                                                      .toString() ==
                                                                  '车辆型号'
                                                              ? modelNode
                                                              : _carTitles[index]
                                                                          .toString() ==
                                                                      '预约人姓名'
                                                                  ? nameNode
                                                                  : _carTitles[index]
                                                                              .toString() ==
                                                                          'VIN码'
                                                                      ? vinNode
                                                                      : _carTitles[index].toString() ==
                                                                              '车辆颜色'
                                                                          ? carColorNode
                                                                          : null,
                                                      // enabled: _carTitles[index]
                                                      //                 .toString() ==
                                                      //             '预约人手机号' ||
                                                      //         _carTitles[index]
                                                      //                 .toString() ==
                                                      //             '预约人姓名'
                                                      //     ? getMap.length == 0
                                                      //         ? true
                                                      //         : false
                                                      //     : true,
                                                      keyboardType: _carTitles[
                                                                      index]
                                                                  .toString() ==
                                                              '预约人手机号'
                                                          ? TextInputType
                                                              .numberWithOptions(
                                                                  decimal: true)
                                                          : null,
                                                      onEditingComplete: () {
                                                        switch (
                                                            _carTitles[index]
                                                                .toString()) {
                                                          case '车辆品牌':
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    modelNode);
                                                            break;
                                                          case '车辆型号':
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    moblieNode);
                                                            break;
                                                          case '预约人手机号':
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    nameNode);
                                                            break;
                                                          case '预约人姓名':
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    vinNode);
                                                            break;
                                                          case 'VIN码':
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    carColorNode);
                                                            break;

                                                          default:
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    FocusNode());
                                                        }
                                                      },
                                                      onChanged: (value) {
                                                        /*  参数封装  */
                                                        switch (
                                                            _carTitles[index]
                                                                .toString()) {
                                                          case '车辆品牌':
                                                            dataMap['carBrand'] =
                                                                value
                                                                    .toString();
                                                            break;
                                                          case '车辆型号':
                                                            dataMap['model'] =
                                                                value
                                                                    .toString();
                                                            break;
                                                          case '预约人手机号':
                                                            dataMap['mobile'] =
                                                                value
                                                                    .toString();
                                                            break;
                                                          case '预约人姓名':
                                                            dataMap['appointmentName'] =
                                                                value
                                                                    .toString();
                                                            break;
                                                          case 'VIN码':
                                                            dataMap['carVin'] =
                                                                value
                                                                    .toString();
                                                            break;
                                                          case '车辆颜色':
                                                            dataMap['carColor'] =
                                                                value
                                                                    .toString();
                                                            break;

                                                          default:
                                                        }
                                                        widget
                                                            .onChanged(dataMap);
                                                      },
                                                      //controller: nameControll,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 0,
                                                                horizontal: 0),
                                                        hintText: '请输入',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    164,
                                                                    164,
                                                                    164,
                                                                    1),
                                                            fontSize: 14),
                                                        border:
                                                            new OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          SizedBox(
                                            width: 30,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 1,
                                        color: Color.fromRGBO(229, 229, 229, 1),
                                      ),
                                    ],
                                  ),
                                ))),
                  ],
                )),
            SizedBox(
              width: 14,
            ),
          ],
        ),
      ],
    );
  }
}
