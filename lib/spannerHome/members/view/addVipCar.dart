import 'dart:convert';
import 'dart:convert' as convert;
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/notificationCenter.dart';
import 'package:spanners/cTools/photoSelect.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/spannerHome/newOrder/carARquestApi.dart';

class AddVipCar extends StatefulWidget {
  final ValueChanged<Map> onChanged;

  final Map valueMap;

  const AddVipCar({Key key, this.onChanged, this.valueMap}) : super(key: key);
  @override
  _AddVipCarState createState() => _AddVipCarState();
}

class _AddVipCarState extends State<AddVipCar> {
  /* */
  var _carNamecontroller = TextEditingController();
  var _brankcontroller = TextEditingController();
  var _modelcontroller = TextEditingController();
  var _namecontroller = TextEditingController();
  var _mobilecontroller = TextEditingController();
  var _vinSourcecontroller = TextEditingController();
  var _carColorCostcontroller = TextEditingController();
  var _carEnginecontroller = TextEditingController();
  /* */

  //用于 按钮换行
  FocusNode brankNode = FocusNode();
  FocusNode modelNode = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode moblieNode = FocusNode();
  FocusNode vinNode = FocusNode();
  FocusNode carColorNode = FocusNode();
  FocusNode carEngineNode = FocusNode();

  //车牌号
  List vecList = List();
  List titleList = ['车牌号', '车辆品牌', '车辆型号', 'VIN码', '车辆颜色', '发动机型号'];
  Map upVipCarMap = Map();
  bool ocrBool = false;
  //判断 是否 必填
  String _isMust(String value) {
    if (value == '车牌号' || value == '车辆品牌' || value == '车辆型号') {
      return '0'; //非必填
    } else {
      return '1';
    }
  }

  int whereInt = 0;
  int workInt = 0;
  String vin = '';
  //判断 是否显示 OCR 识别
  String _isScan(String value) {
    if (value == '车牌号' || value == 'VIN码') {
      return '1'; //显示 扫描
    } else {
      return '0';
    }
    // if (widget.valueMap.isNotEmpty) {
    //   return '0';
    // } else {
    //   if (value == '车牌号' || value == 'VIN码') {
    //     return '1'; //显示 扫描
    //   } else {
    //     return '0';
    //   }
    // }
  }

  //获取车辆登记 信息
  _getCarMessage(String value) {
    RecCarDio.getMemberRequest(
      param: value,
      onSuccess: (data) {
        data['vehicle'] == null
            ? print('====================>$data')
            : upVipCarMap['vehicleId'] = data['vehicle']['vehicleId'];
        print('====================>$data');
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var mapstr = SynchronizePreferences.Get('upVipCarMap');
    if (mapstr == null) {
      if (widget.valueMap.length > 0) {}
    } else {
      Map<String, dynamic> dataMap = convert.jsonDecode(mapstr);
      if (dataMap['vehicleLicence'] == null) {
      } else {
        String vehicleLicence = dataMap['vehicleLicence'];
        //vecList = vehicleLicence.split(',');
        for (var i = 0; i < vehicleLicence.length; i++) {
          vecList.add(vehicleLicence[i]);
        }
      }
      _brankcontroller.text = dataMap['brand'] == null ? '' : dataMap['brand'];
      _modelcontroller.text = dataMap['model'] == null ? '' : dataMap['model'];
      _namecontroller.text =
          dataMap['vehicleOwners'] == null ? '' : dataMap['vehicleOwners'];
      _mobilecontroller.text =
          dataMap['customerMobile'] == null ? '' : dataMap['customerMobile'];
      _vinSourcecontroller.text =
          dataMap['carVin'] == null ? '' : dataMap['carVin'];
      _carColorCostcontroller.text =
          dataMap['carColor'] == null ? '' : dataMap['carColor'];
      _carEnginecontroller.text =
          dataMap['carEngine'] == null ? '' : dataMap['carEngine'];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.valueMap.length > 0) {
      if (workInt == 0) {
        if (widget.valueMap['vehicleLicence'] == null) {
        } else {
          String vehicleLicence = widget.valueMap['vehicleLicence'];

          vecList.clear();
          for (var i = 0; i < vehicleLicence.length; i++) {
            vecList.add(vehicleLicence[i]);
          }
        }
        upVipCarMap['vehicleLicence'] = widget.valueMap['vehicleLicence'];
        _brankcontroller.text = widget.valueMap['brand'];
        upVipCarMap['brand'] = widget.valueMap['brand'];
        _modelcontroller.text = widget.valueMap['model'];
        upVipCarMap['model'] = widget.valueMap['model'];
        _vinSourcecontroller.text = widget.valueMap['carVin'];
        upVipCarMap['carVin'] = widget.valueMap['carVin'];
        _carColorCostcontroller.text = widget.valueMap['carColor'];
        upVipCarMap['carColor'] = widget.valueMap['carColor'];
        _carEnginecontroller.text = widget.valueMap['carEngine'];
        upVipCarMap['carEngine'] = widget.valueMap['carEngine'];
        if (whereInt == 0) {
          whereInt = 1;
          //传值
          widget.onChanged(upVipCarMap);
          SharedManager.saveString(
              json.encode(upVipCarMap).toString(), 'upVipCarMap');
        }
      }
    }
    return GestureDetector(
        onTap: () {
          //点击空白处隐藏键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
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
                  '车辆资料信息',
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
                                titleList.length,
                                (index) => InkWell(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              _isMust(titleList[index]
                                                          .toString()) ==
                                                      '0'
                                                  ? Text(
                                                      '*',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              255, 42, 42, 1),
                                                          fontSize: 15),
                                                    )
                                                  : Text(
                                                      '*',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                              Text(
                                                titleList[index],
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        30, 30, 30, 1),
                                                    fontSize: 15),
                                              ),
                                              SizedBox(
                                                width: 70,
                                              ),
                                              Expanded(
                                                  child: index == 0
                                                      ? InkWell(
                                                          onTap: () {
                                                            // widget.valueMap
                                                            //         .isNotEmpty
                                                            //     ? print('')
                                                            //     :
                                                            showModalBottomSheet(
                                                              barrierColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          0),
                                                              isScrollControlled:
                                                                  true,
                                                              isDismissible:
                                                                  true,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CarKeyboard(
                                                                  type:
                                                                      vecList.length ==
                                                                              0
                                                                          ? 0
                                                                          : 1,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      if (value ==
                                                                          'del') {
                                                                        //删除操作
                                                                        if (vecList.length >
                                                                            0) {
                                                                          vecList
                                                                              .removeLast();
                                                                        }
                                                                        if (vecList.length ==
                                                                            0) {
                                                                          //if (ocrBool) {
                                                                          ocrBool =
                                                                              false;
                                                                          //发送通知
                                                                          NotificationCenter.instance.postNotification(
                                                                              'change',
                                                                              0);
                                                                          //}
                                                                        }

                                                                        _brankcontroller.text =
                                                                            '';
                                                                        upVipCarMap['brand'] =
                                                                            '';
                                                                        _modelcontroller.text =
                                                                            '';
                                                                        upVipCarMap['model'] =
                                                                            '';
                                                                        _namecontroller.text =
                                                                            '';
                                                                        upVipCarMap['vehicleOwners'] =
                                                                            '';
                                                                        _mobilecontroller.text =
                                                                            '';
                                                                        upVipCarMap['customerMobile'] =
                                                                            '';
                                                                        _vinSourcecontroller.text =
                                                                            '';
                                                                        upVipCarMap['carVin'] =
                                                                            '';
                                                                        _carColorCostcontroller.text =
                                                                            '';
                                                                        upVipCarMap['carColor'] =
                                                                            '';
                                                                        _carEnginecontroller.text =
                                                                            '';
                                                                        upVipCarMap['carEngine'] =
                                                                            '';
                                                                        SharedManager.saveString(
                                                                            json.encode(upVipCarMap).toString(),
                                                                            'upVipCarMap');
                                                                      } else {
                                                                        ocrBool =
                                                                            true;
                                                                        //车牌号展示 逻辑
                                                                        if (vecList.length <
                                                                            8) {
                                                                          vecList
                                                                              .add(value);
                                                                        }
                                                                        if (vecList.length >
                                                                            6) {
                                                                          //数组list转 string
                                                                          String
                                                                              result;
                                                                          vecList.forEach((string) =>
                                                                              {
                                                                                if (result == null) result = string else result = '$result$string'
                                                                              });
                                                                          _getCarMessage(
                                                                              result);
                                                                        }
                                                                      }

                                                                      //数组list转 string
                                                                      String
                                                                          result;
                                                                      vecList.forEach(
                                                                          (string) =>
                                                                              {
                                                                                if (result == null) result = string else result = '$result$string'
                                                                              });

                                                                      var mapstr =
                                                                          SynchronizePreferences.Get(
                                                                              'upVipCarMap');
                                                                      if (mapstr ==
                                                                          null) {
                                                                      } else {
                                                                        Map<String,
                                                                                dynamic>
                                                                            dataMap =
                                                                            convert.jsonDecode(mapstr);
                                                                        upVipCarMap =
                                                                            dataMap;
                                                                      }

                                                                      upVipCarMap[
                                                                              'vehicleLicence'] =
                                                                          result;
                                                                      //传值
                                                                      widget.onChanged(
                                                                          upVipCarMap);
                                                                      SharedManager.saveString(
                                                                          json
                                                                              .encode(upVipCarMap)
                                                                              .toString(),
                                                                          'upVipCarMap');

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
                                                              physics: new NeverScrollableScrollPhysics(),
                                                              //禁止滑动
                                                              itemCount: 8,
                                                              //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                  //横轴元素个数
                                                                  crossAxisCount: 8,
                                                                  //纵轴间距
                                                                  mainAxisSpacing: 0.0,
                                                                  //横轴间距
                                                                  crossAxisSpacing: 5.0,
                                                                  //子组件宽高长度比例
                                                                  childAspectRatio: 15 / 20),
                                                              itemBuilder: (BuildContext context, int item) {
                                                                return Container(
                                                                  width: 15,
                                                                  height: 20,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      border: Border.all(
                                                                          color: item == vecList.length - 1
                                                                              ? Color.fromRGBO(
                                                                                  39, 153, 93, 1)
                                                                              : Color.fromRGBO(220, 220, 220,
                                                                                  1),
                                                                          width:
                                                                              1),
                                                                      color: item ==
                                                                              7
                                                                          ? Color.fromRGBO(
                                                                              233,
                                                                              245,
                                                                              238,
                                                                              1)
                                                                          : Colors
                                                                              .white),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      //用于解决 车牌号未输入完其余空展示
                                                                      vecList.length ==
                                                                              8
                                                                          ? vecList[
                                                                              item]
                                                                          : item < vecList.length
                                                                              ? vecList[item]
                                                                              : '',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              8,
                                                                              8,
                                                                              8,
                                                                              1),
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                        )
                                                      : Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: ConstrainedBox(
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxHeight:
                                                                        20,
                                                                    maxWidth:
                                                                        200),
                                                            child:
                                                                TextFormField(
                                                              enabled:
                                                                  // widget
                                                                  //         .valueMap
                                                                  //         .isNotEmpty
                                                                  //     ?
                                                                  titleList[index] == '车牌号' ||
                                                                          titleList[index] ==
                                                                              '车辆型号' ||
                                                                          titleList[index] ==
                                                                              '车辆品牌'
                                                                      ? true
                                                                      : true,
                                                              // : true,
                                                              focusNode: titleList[
                                                                          index] ==
                                                                      '车辆品牌'
                                                                  ? brankNode
                                                                  : titleList[index] ==
                                                                          '车辆型号'
                                                                      ? modelNode
                                                                      : titleList[index] ==
                                                                              'VIN码'
                                                                          ? vinNode
                                                                          : titleList[index] == '车辆颜色'
                                                                              ? carColorNode
                                                                              : titleList[index] == '发动机型号'
                                                                                  ? carEngineNode
                                                                                  : null,
                                                              controller: titleList[
                                                                          index] ==
                                                                      '车牌号'
                                                                  ? _carNamecontroller
                                                                  : titleList[index] ==
                                                                          '车辆品牌'
                                                                      ? _brankcontroller
                                                                      : titleList[index] ==
                                                                              '车辆型号'
                                                                          ? _modelcontroller
                                                                          : titleList[index] == 'VIN码'
                                                                              ? _vinSourcecontroller
                                                                              : titleList[index] == '车辆颜色'
                                                                                  ? _carColorCostcontroller
                                                                                  : _carEnginecontroller,
                                                              onEditingComplete:
                                                                  () {
                                                                switch (
                                                                    titleList[
                                                                        index]) {
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
                                                                            vinNode);

                                                                    break;

                                                                  case 'VIN码':
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            carColorNode);

                                                                    break;
                                                                  case '车辆颜色':
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            carEngineNode);

                                                                    break;

                                                                  default:
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            FocusNode());
                                                                }
                                                              },
                                                              onChanged:
                                                                  (value) {
                                                                //为防止 刷新
                                                                workInt = 1;
                                                                var mapstr =
                                                                    SynchronizePreferences
                                                                        .Get(
                                                                            'upVipCarMap');
                                                                if (mapstr ==
                                                                    null) {
                                                                } else {
                                                                  Map<String,
                                                                          dynamic>
                                                                      dataMap =
                                                                      convert.jsonDecode(
                                                                          mapstr);
                                                                  upVipCarMap =
                                                                      dataMap;
                                                                }

                                                                switch (
                                                                    titleList[
                                                                        index]) {
                                                                  case '车牌号':
                                                                    break;
                                                                  case '车辆品牌':
                                                                    upVipCarMap[
                                                                            'brand'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case '车辆型号':
                                                                    upVipCarMap[
                                                                            'model'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case '车主姓名':
                                                                    upVipCarMap[
                                                                            'vehicleOwners'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case '手机号':
                                                                    upVipCarMap[
                                                                            'customerMobile'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case 'VIN码':
                                                                    upVipCarMap[
                                                                            'carVin'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case '车辆颜色':
                                                                    upVipCarMap[
                                                                            'carColor'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case '发动机型号':
                                                                    upVipCarMap[
                                                                            'carEngine'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  default:
                                                                }
                                                                //传值
                                                                widget.onChanged(
                                                                    upVipCarMap);
                                                                SharedManager.saveString(
                                                                    json
                                                                        .encode(
                                                                            upVipCarMap)
                                                                        .toString(),
                                                                    'upVipCarMap');
                                                              },
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                                hintText: '请输入',
                                                                hintStyle: TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            164,
                                                                            164,
                                                                            164,
                                                                            1),
                                                                    fontSize:
                                                                        14),
                                                                border: OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none),
                                                              ),
                                                              //  keyboardType: _changesKeyboard(titleList[index])
                                                            ),
                                                          ),
                                                        )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              _isScan(titleList[index]
                                                          .toString()) ==
                                                      '1'
                                                  ? InkWell(
                                                      child: Image.asset(
                                                        'Assets/apointMent/photos.png',
                                                        width: 16,
                                                        height: 16,
                                                      ),
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          isDismissible: true,
                                                          enableDrag: false,
                                                          context: context,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          builder: (BuildContext
                                                              context) {
                                                            return new Container(
                                                              height: 160.0,
                                                              child:
                                                                  PhotoSelect(
                                                                isScan:
                                                                    /*
                                                                 ocr/vin 扫描成功后的 回调逻辑处理
                                                                */
                                                                    titleList[index].toString() ==
                                                                            '车牌号'
                                                                        ? true
                                                                        : false,
                                                                isVin: titleList[index]
                                                                            .toString() ==
                                                                        '车牌号'
                                                                    ? false
                                                                    : true,
                                                                onPutString:
                                                                    (value) {
                                                                  /* 回调 车牌号*/
                                                                  setState(() {
                                                                    if (titleList[index]
                                                                            .toString() ==
                                                                        '车牌号') {
                                                                      ocrBool =
                                                                          true;

                                                                      _carNamecontroller
                                                                              .text =
                                                                          value;

                                                                      vecList
                                                                          .clear();
                                                                      //   车牌号  OCR  相关 操作
                                                                      for (var i =
                                                                              0;
                                                                          i < value.length;
                                                                          i++) {
                                                                        vecList.add(
                                                                            value[i]);
                                                                      }

                                                                      //传值
                                                                      // widget.onChanged(
                                                                      //     upCarMap);

                                                                      var mapstr =
                                                                          SynchronizePreferences.Get(
                                                                              'upVipCarMap');
                                                                      if (mapstr ==
                                                                          null) {
                                                                      } else {
                                                                        Map<String,
                                                                                dynamic>
                                                                            dataMap =
                                                                            convert.jsonDecode(mapstr);
                                                                        upVipCarMap =
                                                                            dataMap;
                                                                      }

                                                                      upVipCarMap[
                                                                              'vehicleLicence'] =
                                                                          value;
                                                                      //传值
                                                                      widget.onChanged(
                                                                          upVipCarMap);
                                                                    } else {
                                                                      _vinSourcecontroller
                                                                              .text =
                                                                          value;
                                                                      upVipCarMap[
                                                                              'carVin'] =
                                                                          value
                                                                              .toString();
                                                                      //传值
                                                                      widget.onChanged(
                                                                          upVipCarMap);
                                                                    }
                                                                    SharedManager.saveString(
                                                                        json
                                                                            .encode(upVipCarMap)
                                                                            .toString(),
                                                                        'upVipCarMap');
                                                                  });
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      })
                                                  : SizedBox(
                                                      width: 16,
                                                    ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 1,
                                            color: Color.fromRGBO(
                                                229, 229, 229, 1),
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
        ));
  }
}
