//import 'dart:async';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/keyboardLimit.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import './carServeMenu.dart';
import './carName.dart';
import '../../cModel/recCarModel.dart';

class CarServeChildView extends StatefulWidget {
  final ValueChanged<List> onChanged;
  final String serviceId;
  final String serviceName;
  final String brand;
  final String model;
  final String shopId;
  final int indexs;
  final List serviceList;
  final int materInt; // == 1 直接添加服务配件

  const CarServeChildView({
    Key key,
    this.onChanged,
    this.serviceId,
    this.brand,
    this.model,
    this.shopId,
    this.serviceName,
    this.indexs,
    this.serviceList,
    this.materInt,
  }) : super(key: key);
  @override
  _CarServeChildViewState createState() => _CarServeChildViewState();
}

class _CarServeChildViewState extends State<CarServeChildView> {
  List upData = List(); //一二级服务相关集合
  bool typeBool = true;
  bool doneBool = false;
  bool editBool = false; //修改
  String names = ''; //服务名称
  String editName = ''; // 用于判断 修改 的二级服务名称
  double proNum = 1.0; //服务数量
  double price = 0.00; //单价
  double sumPrice = 0.00; //总价
  bool orBool = false; // 点击 添加配件 为true
  List titles = ['名称', '单价', '数量', '总价'];
  List dataList = List(); //模糊查询结果
  int values = 999; //展示对应 服务下添加配件
  bool addBool = false;
  Map upMap = Map();
  // map
  Map valueMap = Map();
  //
  //局部刷新
  // final StreamController<String> _streamController = StreamController<String>();
  List items = [
    {'name': 'A汽修', 'id': '1'},
    {'name': 'A美容', 'id': '2'},
    {'name': 'A洗车', 'id': '3'},
    {'name': 'A贴膜', 'id': '4'}
  ];
  // /* 模糊搜索 */
  // _searchSecondaryList(String secText) {
  //   setState(() {
  //     dataList.clear();
  //   });
  //   RecCarDio.secondaryListRequest(
  //     param: widget.serviceId + '/' + secText,
  //     onSuccess: (data) {
  //       setState(() {
  //         dataList.clear();
  //         dataList.addAll(data);
  //       });
  //       print('模糊查询结果$dataList');
  //     },
  //     onError: (error) {},
  //   );
  // }
  /* 本地模糊搜索 */
  _searchSecondaryList(String secText) {
    setState(() {
      dataList.clear();
    });
    for (var i = 0; i < widget.serviceList.length; i++) {
      if (widget.serviceList[i]['id'] == widget.serviceId) {
        for (var j = 0;
            j < widget.serviceList[i]['secondaryList'].length;
            j++) {
          if (widget.serviceList[i]['secondaryList'][j]['secondaryDictName']
              .contains(secText)) {
            dataList.add(widget.serviceList[i]['secondaryList'][j]);
          }
        }
      }
    }
    print('模糊搜索结果');
  }

  var _namecontroller = TextEditingController();
  var _pricecontroller = TextEditingController();
  var _countcontroller = TextEditingController();
  var _sumcontroller = TextEditingController();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _countFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //是否展示服务清单
    if (widget.materInt == 1) {
      var value = SynchronizePreferences.getCarMap();
      bool add = true;
      doneBool = true;
      if (value != null) {
        if (value.containsKey('receiveCarServiceList')) {
          for (var i = 0; i < value['receiveCarServiceList'].length; i++) {
            if (value['receiveCarServiceList'][i]['serviceName'] == '其他配件项目') {
              add = false;
              upData.add(value['receiveCarServiceList'][i]);
            }
          }
        }
      }
      if (add) {
        upMap['serviceId'] = widget.serviceId;
        upMap['serviceName'] = widget.serviceName;
        upMap['shopId'] = widget.shopId;
        upMap['secondaryService'] = '其他配件';
        upMap['price'] = '/';
        upMap['count'] = '/';
        upData.add(upMap);
        SharedManager.saveString(
            json.encode({'receiveCarServiceList': upData}).toString(),
            'receiveCarServiceList');
      }
    } else {
      if (SynchronizePreferences.getCarMap() == null) {
        doneBool = false;
      } else {
        var value = SynchronizePreferences.getCarMap();
        if (value.containsKey('receiveCarServiceList')) {
          for (var i = 0; i < value['receiveCarServiceList'].length; i++) {
            if (value['receiveCarServiceList'][i]['serviceName'] ==
                widget.serviceName) {
              doneBool = true;
              upData = value['receiveCarServiceList'];
              break;
            } else {
              doneBool = false;
            }
          }
        }
      }
    }

    //焦点监听
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        print('失去焦点');
        setState(() {
          print('--->');
          dataList.clear();
          _isReplce(1);
        });
      } else {
        print('得到焦点');
      }
    });
  }

  //检测 二级服务 是否重复
  _isReplce(int type) {
    var value = SynchronizePreferences.getCarMap();
    if (value == null) {
    } else {
      if (value.containsKey('receiveCarServiceList')) {
        if (names == '') {
          //_showAlartDialog('已重复，请重新输入');
        } else {
          //遍历
          for (var i = 0; i < value['receiveCarServiceList'].length; i++) {
            if (value['receiveCarServiceList'][i]['secondaryService'] ==
                names) {
              if (type == 1) {
                //保存时
                Alart.showAlartDialog('已重复，请重新输入', 1);
                names = '';
                _namecontroller.text = '';
              } else {
                //修改时
                if (_namecontroller.text == names) {
                } else {
                  Alart.showAlartDialog('已重复，请重新输入', 1);
                  names = '';
                  _namecontroller.text = '';
                }
              }
              return;
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        editBool
            ? Container()
            : upData.length > 0
                ? CarServeMenu(
                    indexs: widget.indexs,
                    servceId: widget.serviceId,
                    secendSerNames: names,
                    carBrand: widget.brand,
                    carModel: widget.model,
                    dataList: upData,
                    peiBool: orBool,
                    showVlues: values == 999
                        ? addBool
                            ? 0
                            : 999
                        : addBool
                            ? values
                            : 999, // addBool ? values == 999 ? 0 : values : values,
                    materInt: widget.materInt,

                    onChangedSer: (value) {
                      setState(() {
                        doneBool = value;
                      });
                    },
                    onChangedEdit: (value) {
                      setState(() {
                        doneBool = value;
                      });
                    },
                    onChangedStr: (value) {
                      setState(() {
                        values = value;
                      });
                    },
                    onChangedMap: (value) {
                      setState(() {
                        if (value.containsKey('secondaryService')) {
                          editBool = true;
                          _namecontroller.text = value['secondaryService'];
                          upMap['secondaryService'] = value['secondaryService'];
                          names = value['secondaryService'];
                          editName = value['secondaryService'];
                          _pricecontroller.text =
                              value['price'] == 'null' ? 0.0 : value['price'];
                          upMap['price'] = value['price'];
                          price = double.parse(value['price']);
                          _countcontroller.text = value['count'];
                          upMap['count'] =
                              value['count'] == 'null' ? 0 : value['count'];
                          proNum = double.parse(value['count']);
                          sumPrice = price * proNum;
                          _sumcontroller.text = sumPrice.toStringAsFixed(1);
                        }
                      });
                    },
                  )
                : Container(),
        doneBool
            ? Container()
            : Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  // doneBool
                  //     ? /*  服务清单，配件数据传输*/
                  //     CarServeMenu(
                  //         indexs: widget.indexs,
                  //         servceId: widget.serviceId,
                  //         secendSerNames: names,
                  //         carBrand: widget.brand,
                  //         carModel: widget.model,
                  //         dataList: upData,
                  //         peiBool: orBool,
                  //         showVlues: values == 999
                  //             ? addBool
                  //                 ? 0
                  //                 : 999
                  //             : addBool
                  //                 ? values
                  //                 : 999, // addBool ? values == 999 ? 0 : values : values,
                  //         materInt: widget.materInt,
                  //         onChangedSer: (value) {
                  //           setState(() {
                  //             doneBool = value;
                  //           });
                  //         },
                  //         onChangedEdit: (value) {
                  //           setState(() {
                  //             doneBool = value;
                  //           });
                  //         },
                  //         onChangedStr: (value) {
                  //           setState(() {
                  //             values = value;
                  //           });
                  //         },
                  //         onChangedMap: (value) {
                  //           setState(() {
                  //             if (value.containsKey('secondaryService')) {
                  //               editBool = true;
                  //               _namecontroller.text = value['secondaryService'];
                  //               upMap['secondaryService'] = value['secondaryService'];
                  //               names = value['secondaryService'];
                  //               editName = value['secondaryService'];
                  //               _pricecontroller.text =
                  //                   value['price'] == 'null' ? 0.0 : value['price'];
                  //               upMap['price'] = value['price'];
                  //               price = double.parse(value['price']);
                  //               _countcontroller.text = value['count'];
                  //               upMap['count'] =
                  //                   value['count'] == 'null' ? 0 : value['count'];
                  //               proNum = double.parse(value['count']);
                  //               sumPrice = price * proNum;
                  //               _sumcontroller.text = sumPrice.toStringAsFixed(1);
                  //             }
                  //           });
                  //         },
                  //       )
                  //     :
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        //添加服务
                        ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                                titles.length,
                                (index) => InkWell(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                ' ',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 42, 42, 1),
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                titles[index],
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        30, 30, 30, 1),
                                                    fontSize: 15),
                                              ),
                                              Expanded(
                                                  child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxHeight: 20,
                                                      maxWidth: 100),
                                                  child: TextFormField(
                                                    keyboardType: titles[
                                                                    index] ==
                                                                '单价' ||
                                                            titles[index] ==
                                                                '数量'
                                                        ? TextInputType
                                                            .numberWithOptions(
                                                                decimal: true)
                                                        : null,
                                                    inputFormatters:
                                                        titles[index] == '单价' ||
                                                                titles[index] ==
                                                                    '数量'
                                                            ? [KeyboardLimit(1)]
                                                            : null,
                                                    focusNode: titles[index] ==
                                                            '名称'
                                                        ? _nameFocusNode
                                                        : titles[index] == '单价'
                                                            ? _priceFocusNode
                                                            : titles[index] ==
                                                                    '数量'
                                                                ? _countFocusNode
                                                                : null,
                                                    controller: titles[index] ==
                                                            '名称'
                                                        ? _namecontroller
                                                        : titles[index] == '总价'
                                                            ? _sumcontroller
                                                            : titles[index] ==
                                                                    '单价'
                                                                ? _pricecontroller
                                                                : titles[index] ==
                                                                        '数量'
                                                                    ? _countcontroller
                                                                    : null,
                                                    enabled:
                                                        titles[index] == '总价'
                                                            ? false
                                                            : true,
                                                    onEditingComplete: () {
                                                      switch (titles[index]) {
                                                        case '名称':
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  _priceFocusNode);

                                                          break;
                                                        case '单价':
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  _countFocusNode);

                                                          break;

                                                        default:
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  FocusNode());
                                                      }
                                                    },

                                                    onChanged: (value) {
                                                      print('名称== >:$value');
                                                      /*  针对 名称 做模糊 搜索*/
                                                      if (titles[index] ==
                                                          '名称') {
                                                        names = value;
                                                        price = 0.0;
                                                        proNum = 1.0;
                                                        sumPrice = 0.0;
                                                        _pricecontroller.text =
                                                            '';
                                                        _countcontroller.text =
                                                            '';
                                                        _sumcontroller.text =
                                                            '';
                                                        //输入变动时
                                                        upMap.remove(
                                                            'secondaryId'); //先删除 id

                                                        // _isReplce(1);
                                                        // 模糊 查询
                                                        _searchSecondaryList(
                                                            value);
                                                      } else if (titles[
                                                              index] ==
                                                          '单价') {
                                                        // if (value != '') {
                                                        //   if (RegExpQs.isNum(
                                                        //       value)) {
                                                        price =
                                                            double.parse(value);
                                                        if (price > 0) {
                                                          sumPrice =
                                                              price * proNum;
                                                          //总价联动
                                                          _sumcontroller.text =
                                                              sumPrice
                                                                  .toStringAsFixed(
                                                                      1);
                                                        }
                                                      } else if (titles[
                                                              index] ==
                                                          '数量') {
                                                        proNum =
                                                            double.parse(value);
                                                        if (price > 0) {
                                                          sumPrice =
                                                              price * proNum;
                                                          //总价联动
                                                          _sumcontroller.text =
                                                              sumPrice
                                                                  .toStringAsFixed(
                                                                      1);
                                                        }
                                                      }

                                                      upMap['secondaryService'] =
                                                          names;
                                                      upMap['count'] =
                                                          proNum.toString();
                                                      upMap['price'] =
                                                          price.toString();
                                                    },

                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 0,
                                                              horizontal: 0),
                                                      hintText:
                                                          titles[index] == '数量'
                                                              ? 'x1'
                                                              : titles[index] ==
                                                                      '总价'
                                                                  ? '¥0.0'
                                                                  : '请输入',
                                                      hintStyle: TextStyle(
                                                          color: Color.fromRGBO(
                                                              164, 164, 164, 1),
                                                          fontSize: 14),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                    ),
                                                    // keyboardType: TextInputType.multiline,
                                                  ),
                                                ),
                                              )),
                                              SizedBox(
                                                width: 30,
                                              )
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
                                          /*
                                        展示 模糊搜索 结果
                                      */
                                          titles[index] == '名称'
                                              ? CarNameList(
                                                  type: 2,
                                                  dataList: dataList,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      /*  传来的 二级项目名 ID*/
                                                      upMap['secondaryService'] =
                                                          RecCarModel.fromJson(
                                                                  value)
                                                              .dictName
                                                              .toString();
                                                      upMap['secondaryId'] =
                                                          RecCarModel.fromJson(
                                                                  value)
                                                              .id
                                                              .toString();

                                                      names =
                                                          RecCarModel.fromJson(
                                                                  value)
                                                              .dictName
                                                              .toString();
                                                      // price = double.parse(
                                                      //     RecCarModel.fromJson(
                                                      //             value)
                                                      //         .cost
                                                      //         .toString());
                                                      // sumPrice = price * proNum;
                                                      upMap['count'] =
                                                          proNum.toString();
                                                      // upMap['price'] =
                                                      //     sumPrice.toString();

                                                      // upMap['price'] =
                                                      //     price.toString();
                                                      /*  赋值*/
                                                      _namecontroller.text =
                                                          names;
                                                      _pricecontroller.text =
                                                          ''; // price.toString();
                                                      // _countcontroller.text =
                                                      //     proNum.toString();
                                                      _sumcontroller.text =
                                                          sumPrice
                                                              .toStringAsFixed(
                                                                  1);

                                                      dataList.clear();
                                                    });

                                                    print(upMap);
                                                  },
                                                )
                                              : Container(),
                                          dataList.length > 0
                                              ? titles[index] == '名称'
                                                  ? SizedBox(
                                                      height: 5,
                                                    )
                                                  : SizedBox()
                                              : SizedBox(),
                                          dataList.length > 0
                                              ? titles[index] == '名称'
                                                  ? Container(
                                                      height: 3,
                                                      color: Color.fromRGBO(
                                                          229, 229, 229, 1),
                                                    )
                                                  : Container()
                                              : Container(),
                                        ],
                                      ),
                                    ))),

                        //服务 保存 添加配件
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 40,
                            ),
                            Container(
                              width: 90,
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
                                    print('保存');
                                    setState(() {
                                      //检测 二级服务是否重复
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      upMap['serviceId'] = widget.serviceId;
                                      upMap['serviceName'] = widget.serviceName;
                                      upMap['shopId'] = widget.shopId;
                                      if (names == '') {
                                        //可以提示请填写服务名称
                                      } else {
                                        if (editBool) {
                                          _isReplce(2);
                                          orBool = false;
                                          doneBool
                                              ? doneBool = false
                                              : doneBool = true;

                                          // upData.replaceRange(i, i + 1, [upMap]);
                                          var value = SynchronizePreferences
                                              .getCarMap();
                                          //    遍历
                                          for (var i = 0;
                                              i <
                                                  value['receiveCarServiceList']
                                                      .length;
                                              i++) {
                                            if (value['receiveCarServiceList']
                                                    [i]['secondaryService'] ==
                                                editName) {
                                              //    修改 缓存中的数据
                                              value['receiveCarServiceList'][i]
                                                      ['secondaryService'] =
                                                  upMap['secondaryService'];
                                              value['receiveCarServiceList'][i]
                                                  ['count'] = upMap['count'];
                                              value['receiveCarServiceList'][i]
                                                  ['price'] = upMap['price'];
                                              if (upMap
                                                  .containsKey('secondaryId')) {
                                                value['receiveCarServiceList']
                                                        [i]['secondaryId'] =
                                                    upMap['secondaryId'];
                                              }
                                              //本地存储
                                              SharedManager.saveString(
                                                  json.encode(value).toString(),
                                                  'receiveCarServiceList');
                                            }
                                          }
                                          editBool = false;
                                          print('保存 二级服务 数据:$value');
                                          //公共 归档
                                          names = '';
                                          price = 0.00;
                                          proNum = 1.0;
                                          sumPrice = 0.00;
                                          upMap = Map(); //需将对象初始化
                                          _namecontroller.text = '';
                                          _pricecontroller.text = '';
                                          _countcontroller.text = '';
                                          _sumcontroller.text = '';
                                          //   }
                                          // }
                                        } else {
                                          /* 保存 二级服务 数据*/

                                          orBool = false;
                                          doneBool
                                              ? doneBool = false
                                              : doneBool = true;
                                          upData.add(upMap);
                                          widget.onChanged(upData);
                                          //
                                          var value = SynchronizePreferences
                                              .getCarMap();
                                          if (value == null) {
                                            SharedManager.saveString(
                                                json.encode({
                                                  'receiveCarServiceList':
                                                      upData
                                                }).toString(),
                                                'receiveCarServiceList');
                                          } else {
                                            value['receiveCarServiceList']
                                                .add(upMap);
                                            SharedManager.saveString(
                                                json.encode(value).toString(),
                                                'receiveCarServiceList');
                                          }
                                          addBool = false;
                                          print('保存 二级服务 数据:$value');
                                          //公共 归档
                                          names = '';
                                          price = 0.00;
                                          proNum = 1.0;
                                          sumPrice = 0.00;
                                          upMap = Map(); //需将对象初始化
                                          _namecontroller.text = '';
                                          _pricecontroller.text = '';
                                          _countcontroller.text = '';
                                          _sumcontroller.text = '';
                                        }
                                      }
                                      valueMap['receiveCarServiceList'] =
                                          upData;
                                    });
                                  },
                                  child: Text(editBool ? '完成' : '保存',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  80 -
                                  180 -
                                  30,
                            ),
                            GestureDetector(
                              onTap: () {
                                print('-->添加修改配件');
                                if (names == '') {
                                  //可以提示请填写服务名称
                                  Alart.showAlartDialog('请填写服务名称', 1);
                                } else {
                                  setState(() {
                                    orBool = true;
                                    /** 
                                       删除
                                      */
                                    if (editBool) {
                                      addBool = false;
                                      var value =
                                          SynchronizePreferences.getCarMap();
                                      //    遍历
                                      for (var i = 0;
                                          i <
                                              value['receiveCarServiceList']
                                                  .length;
                                          i++) {
                                        //先判断是否存在 一级服务
                                        if (value['receiveCarServiceList'][i]
                                                ['serviceId'] ==
                                            widget.serviceId) {
                                          //再判断是否存在 二级服务
                                          if (value['receiveCarServiceList'][i]
                                                  ['secondaryService'] ==
                                              editName) {
                                            //    修改 缓存中的数据
                                            value['receiveCarServiceList']
                                                .removeAt(i);

                                            if (value['receiveCarServiceList']
                                                    .length >
                                                0) {
                                              doneBool = true;
                                            } else {
                                              doneBool = false;
                                              //公共 归档
                                              names = '';
                                              price = 0.00;
                                              proNum = 1.0;
                                              sumPrice = 0.00;
                                              upMap = Map(); //需将对象初始化
                                              _namecontroller.text = '';
                                              _pricecontroller.text = '';
                                              _countcontroller.text = '';
                                              _sumcontroller.text = '';
                                            }
                                            for (var j = 0;
                                                j <
                                                    value['receiveCarServiceList']
                                                        .length;
                                                j++) {
                                              if (value['receiveCarServiceList']
                                                      [j]['serviceId'] ==
                                                  widget.serviceId) {
                                                print('>>>>>>>qwer');
                                                doneBool = true;
                                              } else {
                                                print('<<<<<<<<qwer');
                                                doneBool = false;
                                                //公共 归档
                                                names = '';
                                                price = 0.00;
                                                proNum = 1.0;
                                                sumPrice = 0.00;
                                                upMap = Map(); //需将对象初始化
                                                _namecontroller.text = '';
                                                _pricecontroller.text = '';
                                                _countcontroller.text = '';
                                                _sumcontroller.text = '';
                                              }
                                            }
                                            //本地存储
                                            SharedManager.saveString(
                                                json.encode(value).toString(),
                                                'receiveCarServiceList');
                                            editBool = false;
                                          }
                                        }
                                      }
                                    } else {
                                      /** 
                                        保存 二级服务 并添加配件
                                      */

                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      upMap['serviceId'] = widget.serviceId;
                                      upMap['serviceName'] = widget.serviceName;
                                      upMap['shopId'] = widget.shopId;
                                      if (names == '') {
                                        //可以提示请填写服务名称
                                        Alart.showAlartDialog('请填写服务名称', 1);
                                      } else {
                                        orBool = false;
                                        doneBool
                                            ? doneBool = false
                                            : doneBool = true;
                                        upData.add(upMap);
                                        widget.onChanged(upData);
                                        //
                                        var value =
                                            SynchronizePreferences.getCarMap();
                                        if (value == null) {
                                          SharedManager.saveString(
                                              json.encode({
                                                'receiveCarServiceList': upData
                                              }).toString(),
                                              'receiveCarServiceList');
                                        } else {
                                          value['receiveCarServiceList']
                                              .add(upMap);
                                          SharedManager.saveString(
                                              json.encode(value).toString(),
                                              'receiveCarServiceList');
                                        }
                                        addBool = true;
                                        print('保存 二级服务 数据:$value');
                                        //公共 归档
                                        //names = '';
                                        price = 0.00;
                                        proNum = 1.0;
                                        sumPrice = 0.00;
                                        upMap = Map(); //需将对象初始化
                                        _namecontroller.text = '';
                                        _pricecontroller.text = '';
                                        _countcontroller.text = '';
                                        _sumcontroller.text = '';
                                      }
                                    }
                                    valueMap['receiveCarServiceList'] = upData;
                                  });
                                }
                              },
                              child: Container(
                                  width: 90,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(39, 153, 93, 1),
                                  ),
                                  child: Text(editBool ? '删除' : '添加配件',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14

                                          // loginVisible
                                          //     ? Colors.white
                                          //     : Colors.white70,
                                          ))),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
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
  }
}
