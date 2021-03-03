import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/notificationCenter.dart';
import 'package:spanners/cTools/photoSelect.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/spannerHome/newOrder/carARquestApi.dart';

class CarMessageAdd extends StatefulWidget {
  final ValueChanged<Map> onChanged;
  final ValueChanged<Map> onChangedVip;
  final Map valueMap;

  CarMessageAdd({Key key, this.onChanged, this.onChangedVip, this.valueMap})
      : super(key: key);
  @override
  _CarMessageAddState createState() => _CarMessageAddState();
}

class _CarMessageAddState extends State<CarMessageAdd> {
  Map upCarMap = Map();
  int showInt;
  int whereInt = 0;
  bool ocrBool = false;
  //车牌号
  List vecList = List();
  List titleList = [
    '车牌号',
    '车辆品牌',
    '车辆型号',
    '车主姓名',
    '手机号',
    'VIN码',
    '车辆颜色',
    '发动机型号'
  ];
  //String ocr = '';
  String vin = '';
  //判断 是否显示 OCR 识别
  String _isScan(String value) {
    if (widget.valueMap.isNotEmpty) {
      return '0';
    } else {
      if (value == '车牌号' || value == 'VIN码') {
        return '1'; //显示 扫描
      } else {
        return '0';
      }
    }
  }

  //判断 是否 必填
  String _isMust(String value) {
    if (value == '车牌号' || value == '车辆品牌' || value == '车辆型号') {
      return '0'; //非必填
    } else {
      return '1';
    }
  }

  //获取车辆登记 信息
  _getCarMessage(String value) {
    RecCarDio.getMemberRequest(
      param: value,
      onSuccess: (data) {
        print('====================>$data');
        if (data['member'] == null && data['vehicle'] == null) {
          upCarMap['vehicleLicence'] = value;
          widget.onChanged(upCarMap);
        } else {
          if (data['member'] == null) {
            upCarMap['vehicleLicence'] = data['vehicle']['vehicleLicence'];
            _brankcontroller.text = data['vehicle']['brand'];
            upCarMap['brand'] = data['vehicle']['brand'];
            _modelcontroller.text = data['vehicle']['model'];
            upCarMap['model'] = data['vehicle']['model'];
            _namecontroller.text = data['vehicle']['vehicleOwners'];
            upCarMap['vehicleOwners'] = data['vehicle']['vehicleOwners'];
            _mobilecontroller.text = data['vehicle']['customerMobile'];
            upCarMap['customerMobile'] = data['vehicle']['customerMobile'];
            _vinSourcecontroller.text = data['vehicle']['carVin'];
            upCarMap['carVin'] = data['vehicle']['carVin'];
            _carColorCostcontroller.text = data['vehicle']['carColor'];
            upCarMap['carColor'] = data['vehicle']['carColor'];
            _carEnginecontroller.text = data['vehicle']['carEngine'];
            upCarMap['carEngine'] = data['vehicle']['carEngine'];
            widget.onChanged(upCarMap);
            SharedManager.removeString('upCarMap');
            SharedManager.saveString(
                json.encode(upCarMap).toString(), 'upCarMap');
          } else {
            widget.onChangedVip(data);
          }
        }
      },
    );
  }

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

  _changesKeyboard(String type) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      if (type == '手机号') {
        return TextInputType.phone;
      }
      return TextInputType.text;
    });
    // });
  }

  @override
  void initState() {
    super.initState();

    if (widget.valueMap.length > 0) {
      // _carNamecontroller.text = widget.valueMap['vehicleLicence'];

      if (widget.valueMap['vehicleLicence'] == null) {
      } else {
        vecList.clear();
        String vehicleLicence = widget.valueMap['vehicleLicence'];
        for (var i = 0; i < vehicleLicence.length; i++) {
          vecList.add(vehicleLicence[i]);
        }
      }
      upCarMap['vehicleLicence'] = widget.valueMap['vehicleLicence'];
      _brankcontroller.text = widget.valueMap['brand'];
      upCarMap['brand'] = widget.valueMap['brand'];
      _modelcontroller.text = widget.valueMap['model'];
      upCarMap['model'] = widget.valueMap['model'];
      _namecontroller.text = widget.valueMap['vehicleOwners'];
      upCarMap['vehicleOwners'] = widget.valueMap['vehicleOwners'];
      _mobilecontroller.text = widget.valueMap['customerMobile'];
      upCarMap['customerMobile'] = widget.valueMap['customerMobile'];
      _vinSourcecontroller.text = widget.valueMap['carVin'];
      upCarMap['carVin'] = widget.valueMap['carVin'];
      _carColorCostcontroller.text = widget.valueMap['carColor'];
      upCarMap['carColor'] = widget.valueMap['carColor'];
      _carEnginecontroller.text = widget.valueMap['carEngine'];
      upCarMap['carEngine'] = widget.valueMap['carEngine'];

      if (widget.valueMap.length > 0) {
        if (whereInt == 0) {
          whereInt = 1;
          //传值
          widget.onChanged(widget.valueMap);
        }
      }
    } else {
      var mapstr = SynchronizePreferences.Get('upCarMap');
      if (mapstr == null) {
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
        _brankcontroller.text =
            dataMap['brand'] == null ? '' : dataMap['brand'];
        _modelcontroller.text =
            dataMap['model'] == null ? '' : dataMap['model'];
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
    moblieNode.addListener(() {
      if (!moblieNode.hasFocus) {
        print('失去焦点-->}');
        // setState(() {
        if (upCarMap['customerMobile'].length != 11) {
          Alart.showAlartDialog('当前手机号输入有误', 1);
          //dataMap.remove('mobile');
        }
        // });
      } else {
        print('得到焦点');
        //setState(() {});

      }
    });
  }

  // 通过workOrderId 查询出的车辆信息 做部分修改时 为防止刷新动作 导致重新赋值
  int workInt = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.valueMap.length > 0) {
      if (workInt == 0) {
        if (widget.valueMap['vehicleLicence'] == null) {
        } else {
          String vehicleLicence = widget.valueMap['vehicleLicence'];
          //vecList = vehicleLicence.split(',');
          vecList.clear();
          for (var i = 0; i < vehicleLicence.length; i++) {
            vecList.add(vehicleLicence[i]);
          }
        }
        upCarMap['vehicleLicence'] = widget.valueMap['vehicleLicence'];
        _brankcontroller.text = widget.valueMap['brand'];
        upCarMap['brand'] = widget.valueMap['brand'];
        _modelcontroller.text = widget.valueMap['model'];
        upCarMap['model'] = widget.valueMap['model'];
        _namecontroller.text = widget.valueMap['vehicleOwners'];
        upCarMap['vehicleOwners'] = widget.valueMap['vehicleOwners'];
        _mobilecontroller.text = widget.valueMap['customerMobile'];
        upCarMap['cumstomerMobile'] = widget.valueMap['customerMobile'];
        _vinSourcecontroller.text = widget.valueMap['carVin'];
        upCarMap['carVin'] = widget.valueMap['carVin'];
        _carColorCostcontroller.text = widget.valueMap['carColor'];
        upCarMap['carColor'] = widget.valueMap['carColor'];
        _carEnginecontroller.text = widget.valueMap['carEngine'];
        upCarMap['carEngine'] = widget.valueMap['carEngine'];
        if (whereInt == 0) {
          whereInt = 1;
          //传值
          widget.onChanged(widget.valueMap);
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
                                                            widget.valueMap
                                                                    .isNotEmpty
                                                                ? print('')
                                                                : showModalBottomSheet(
                                                                    barrierColor:
                                                                        Color.fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            0),
                                                                    isScrollControlled:
                                                                        true,
                                                                    isDismissible:
                                                                        true,
                                                                    enableDrag:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return CarKeyboard(
                                                                        type: vecList.length ==
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
                                                                              if (vecList.length > 0) {
                                                                                vecList.removeLast();
                                                                              }
                                                                              if (vecList.length == 0) {
                                                                                //if (ocrBool) {
                                                                                ocrBool = false;
                                                                                //发送通知
                                                                                NotificationCenter.instance.postNotification('change', 0);
                                                                                //}
                                                                              }

                                                                              _brankcontroller.text = '';
                                                                              upCarMap['brand'] = '';
                                                                              _modelcontroller.text = '';
                                                                              upCarMap['model'] = '';
                                                                              _namecontroller.text = '';
                                                                              upCarMap['vehicleOwners'] = '';
                                                                              _mobilecontroller.text = '';
                                                                              upCarMap['customerMobile'] = '';
                                                                              _vinSourcecontroller.text = '';
                                                                              upCarMap['carVin'] = '';
                                                                              _carColorCostcontroller.text = '';
                                                                              upCarMap['carColor'] = '';
                                                                              _carEnginecontroller.text = '';
                                                                              upCarMap['carEngine'] = '';
                                                                              SharedManager.saveString(json.encode(upCarMap).toString(), 'upCarMap');
                                                                            } else {
                                                                              ocrBool = true;
                                                                              //车牌号展示 逻辑
                                                                              if (vecList.length < 8) {
                                                                                vecList.add(value);
                                                                              }
                                                                            }

                                                                            //数组list转 string
                                                                            String
                                                                                result;
                                                                            vecList.forEach((string) =>
                                                                                {
                                                                                  if (result == null) result = string else result = '$result$string'
                                                                                });

                                                                            var mapstr =
                                                                                SynchronizePreferences.Get('upCarMap');
                                                                            if (mapstr ==
                                                                                null) {
                                                                            } else {
                                                                              Map<String, dynamic> dataMap = convert.jsonDecode(mapstr);
                                                                              upCarMap = dataMap;
                                                                            }

                                                                            upCarMap['vehicleLicence'] =
                                                                                result;
                                                                            SharedManager.saveString(json.encode(upCarMap).toString(),
                                                                                'upCarMap');

                                                                            if (vecList.length >
                                                                                6) {
                                                                              _getCarMessage(result);
                                                                            }

                                                                            print('回调车牌:$result');
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
                                                              enabled: widget
                                                                      .valueMap
                                                                      .isNotEmpty
                                                                  ? titleList[index] == '车牌号' ||
                                                                          titleList[index] ==
                                                                              '车辆型号' ||
                                                                          titleList[index] ==
                                                                              '车辆品牌'
                                                                      ? false
                                                                      : true
                                                                  : true,
                                                              focusNode: titleList[
                                                                          index] ==
                                                                      '车辆品牌'
                                                                  ? brankNode
                                                                  : titleList[index] ==
                                                                          '车辆型号'
                                                                      ? modelNode
                                                                      : titleList[index] ==
                                                                              '车主姓名'
                                                                          ? nameNode
                                                                          : titleList[index] == '手机号'
                                                                              ? moblieNode
                                                                              : titleList[index] == 'VIN码'
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
                                                                          : titleList[index] == '车主姓名'
                                                                              ? _namecontroller
                                                                              : titleList[index] == '手机号'
                                                                                  ? _mobilecontroller
                                                                                  : titleList[index] == 'VIN码'
                                                                                      ? _vinSourcecontroller
                                                                                      : titleList[index] == '车辆颜色'
                                                                                          ? _carColorCostcontroller
                                                                                          : _carEnginecontroller,
                                                              keyboardType: titleList[
                                                                          index] ==
                                                                      '手机号'
                                                                  ? TextInputType
                                                                      .numberWithOptions(
                                                                          decimal:
                                                                              true)
                                                                  : null,
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
                                                                            nameNode);

                                                                    break;
                                                                  case '车主姓名':
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            moblieNode);

                                                                    break;
                                                                  case '手机号':
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
                                                                upCarMap['vehicleLicence']
                                                                            .length <
                                                                        7
                                                                    ? Alart.showAlartDialog(
                                                                        '当前录入车牌号不能少于7位',
                                                                        1)
                                                                    : print('');

                                                                //为防止 刷新
                                                                workInt = 1;
                                                                var mapstr =
                                                                    SynchronizePreferences
                                                                        .Get(
                                                                            'upCarMap');
                                                                if (mapstr ==
                                                                    null) {
                                                                } else {
                                                                  Map<String,
                                                                          dynamic>
                                                                      dataMap =
                                                                      convert.jsonDecode(
                                                                          mapstr);
                                                                  upCarMap =
                                                                      dataMap;
                                                                }

                                                                switch (
                                                                    titleList[
                                                                        index]) {
                                                                  case '车牌号':
                                                                    // upCarMap[
                                                                    //         'vehicleLicence'] =
                                                                    //     value
                                                                    //         .toString();

                                                                    break;
                                                                  case '车辆品牌':
                                                                    upCarMap[
                                                                            'brand'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case '车辆型号':
                                                                    upCarMap[
                                                                            'model'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case '车主姓名':
                                                                    upCarMap[
                                                                            'vehicleOwners'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case '手机号':
                                                                    upCarMap[
                                                                            'customerMobile'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case 'VIN码':
                                                                    upCarMap[
                                                                            'carVin'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case '车辆颜色':
                                                                    upCarMap[
                                                                            'carColor'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  case '发动机型号':
                                                                    upCarMap[
                                                                            'carEngine'] =
                                                                        value
                                                                            .toString();

                                                                    break;
                                                                  default:
                                                                }
                                                                //传值
                                                                widget.onChanged(
                                                                    upCarMap);
                                                                SharedManager.saveString(
                                                                    json
                                                                        .encode(
                                                                            upCarMap)
                                                                        .toString(),
                                                                    'upCarMap');
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
                                                                      _getCarMessage(
                                                                          value);
                                                                      ocrBool =
                                                                          true;

                                                                      _carNamecontroller
                                                                              .text =
                                                                          value;
                                                                      // upCarMap[
                                                                      //         'vehicleLicence'] =
                                                                      //     value
                                                                      //         .toString();
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
                                                                      widget.onChanged(
                                                                          upCarMap);

                                                                      var mapstr =
                                                                          SynchronizePreferences.Get(
                                                                              'upCarMap');
                                                                      if (mapstr ==
                                                                          null) {
                                                                      } else {
                                                                        Map<String,
                                                                                dynamic>
                                                                            dataMap =
                                                                            convert.jsonDecode(mapstr);
                                                                        upCarMap =
                                                                            dataMap;
                                                                      }

                                                                      upCarMap[
                                                                              'vehicleLicence'] =
                                                                          value;
                                                                      SharedManager.saveString(
                                                                          json
                                                                              .encode(upCarMap)
                                                                              .toString(),
                                                                          'upCarMap');

                                                                      if (vecList
                                                                              .length >
                                                                          6) {
                                                                        _getCarMessage(
                                                                            value);
                                                                      }
                                                                    } else {
                                                                      _vinSourcecontroller
                                                                              .text =
                                                                          value;
                                                                      upCarMap[
                                                                              'carVin'] =
                                                                          value
                                                                              .toString();
                                                                      //传值
                                                                      widget.onChanged(
                                                                          upCarMap);
                                                                      print(
                                                                          '================>$vin,$value');
                                                                    }
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
