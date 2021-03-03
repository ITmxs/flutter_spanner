import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spanners/cModel/recCarModel.dart';
import 'package:spanners/cTools/keyboardLimit.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/spannerHome/newOrder/carName.dart';
import './carARquestApi.dart';
import '../../publicView/pub_GoodsList.dart';

class CarServeMenu extends StatefulWidget {
  final ValueChanged<bool> onChangedSer;
  final ValueChanged<int> onChangedStr;
  final ValueChanged<bool> onChangedEdit;
  final ValueChanged<Map> onChangedMap;
  final List dataList;
  //模糊搜索配件时需要用的 车辆匹配
  final String carBrand;
  final String carModel;
  final String servceId;
  final int indexs;
  final int showVlues;
  final int materInt; // == 1 其他配件项目

  final String secendSerNames;
  bool peiBool;
  CarServeMenu(
      {Key key,
      this.onChangedSer,
      this.onChangedEdit,
      this.peiBool,
      this.dataList,
      this.onChangedMap,
      this.carBrand,
      this.carModel,
      this.servceId,
      this.indexs,
      this.onChangedStr,
      this.showVlues,
      this.materInt,
      this.secendSerNames})
      : super(key: key);
  @override
  _CarServeMenuState createState() => _CarServeMenuState();
}

class _CarServeMenuState extends State<CarServeMenu> {
  bool peiBools;
  String pjType = '';
  List titles = [
    '来源',
    '名称',
    '型号',
    '规格',
    '单价',
    '数量',
    '总价',
    '采购来源',
    '成本单价',
  ];
  //配件 list
  List materList = List();
  //配件 map
  Map materMap = Map();
  // map
  Map valueMap = Map();
  //上传配件 List
  List upData = List();
  // List
  List valueData = List();
  // 二级服务 list
  List datasList = List();

  //取 点击的 二级服务
  String secendSerName;
  //用于标示 哪一行展示添加配件
  int showValue = 9999;
  //配件 修改
  bool editBool = false;
  int editIndex;

  String nameMaterial;
  String _getSumPrice(String count, String price) {
    if (price == 'null') {
      return '¥0';
    } else {
      var c = double.parse(count);
      var p = double.parse(price);
      var s = c * p;

      print(c);
      print(p);
      print(s);
      return '¥${s.toStringAsFixed(1)}';
    }
  }

  String names = ''; //服务名称
  String mode = ''; //型号
  String spec = ''; //规格
  double proNum = 1.0; //服务数量
  double price = 0.00; //单价
  double sumPrice = 0.00; //总价
  /* */
  var _fromcontroller = TextEditingController();
  var _namecontroller = TextEditingController();
  var _brankcontroller = TextEditingController();
  var _modelcontroller = TextEditingController();
  var _pricecontroller = TextEditingController();
  var _countcontroller = TextEditingController();
  var _sumpricecontroller = TextEditingController();
  var _purchaseSourcecontroller = TextEditingController();
  var _partsCostcontroller = TextEditingController();
  /* 配件；联想*/
  _getMaterialList(String value) {
    String params;
    if (widget.carBrand == '' && widget.carModel == '') {
      params = 'null' + '/' + 'null' + '/' + value;
    } else if (widget.carBrand != '' && widget.carModel == '') {
      params = widget.carBrand + '/' + 'null' + '/' + value;
    } else if (widget.carBrand == '' && widget.carModel != '') {
      params = 'null' + '/' + widget.carModel + '/' + value;
    } else {
      params = widget.carBrand + '/' + widget.carModel + '/' + value;
    }

    RecCarDio.materialListRequest(
      param: params,
      onSuccess: (data) {
        setState(() {
          materList.clear();
          materList.addAll(data);
        });
      },
    );
  }

  //归档
  _insertData() {
    pjType = '';
    _fromcontroller.text = '';
    _namecontroller.text = '';
    names = '';
    _modelcontroller.text = '';
    mode = '';
    _brankcontroller.text = '';
    spec = '';
    _pricecontroller.text = '';
    price = 0.00;
    _countcontroller.text = '';
    _sumpricecontroller.text = '';
    _purchaseSourcecontroller.text = '';
    _partsCostcontroller.text = '';
    proNum = 1.0;
    sumPrice = 0.00;
  }

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _specFocusNode = FocusNode();
  FocusNode _modelFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _countFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //继续添加配件时传来的二级服务名称
    secendSerName = widget.secendSerNames;
    //用于判断 其他配件项目展示 形式 过程很复杂 得慢慢 理（目前ListView 嵌套textfeild 有许多地方编写的不是很成熟，后期需要 从新梳理优化）
    if (widget.materInt == 1) {
      var value = SynchronizePreferences.getCarMap();
      if (value != null) {
        bool add = true;

        if (value.containsKey('receiveCarServiceList')) {
          for (var i = 0; i < value['receiveCarServiceList'].length; i++) {
            if (value['receiveCarServiceList'][i]['serviceName'] == '其他配件项目') {
              add = false;
            }
          }
          if (add) {
            datasList = [
              {
                'secondaryService': '其他配件服务子分类',
                'count': '1.0',
                'price': '0.0',
                'serviceId': '8ea74f34d2f243e9af1660e7bd8c6e32',
                'serviceName': '其他配件项目',
                'shopId': '93794b2d12ee48108df2dba21910276f'
              }
            ];
            value['receiveCarServiceList'].add(datasList[0]);
            SharedManager.saveString(
                json.encode(value).toString(), 'receiveCarServiceList');
          }
        }
      } else {
        datasList = [
          {
            'secondaryService': '其他配件服务子分类',
            'count': '1.0',
            'price': '0.0',
            'serviceId': '8ea74f34d2f243e9af1660e7bd8c6e32',
            'serviceName': '其他配件项目',
            'shopId': '93794b2d12ee48108df2dba21910276f'
          }
        ];
        SharedManager.saveString(
            json.encode({'receiveCarServiceList': datasList}).toString(),
            'receiveCarServiceList');
      }
    }
    //}

    if (widget.showVlues != 999) showValue = widget.showVlues;
    //
    _returnOneNum();
    // datasList = widget.dataList;
    //焦点监听
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        print('失去焦点');
      } else {
        print('得到焦点');
      }
    });
    //焦点监听
    _specFocusNode.addListener(() {
      if (!_specFocusNode.hasFocus) {
        print('失去焦点');
        // /**
        //   对规格 做 数字 单位 检测
        //  */
        // List items = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'];
        // List itemt = [
        //   '零',
        //   '一',
        //   '二',
        //   '三',
        //   '四',
        //   '五',
        //   '六',
        //   '七',
        //   '八',
        //   '九',
        //   '十',
        //   '点'
        // ];
        // List itema = [
        //   '个',
        //   '件',
        //   '升',
        //   '毫升',
        //   '公升',
        //   '顿',
        //   '盒',
        //   '张',
        //   '双',
        //   '只',
        //   '面',
        //   '套',
        //   '对',
        //   '头',
        //   '克',
        //   '斤',
        //   '千克',
        //   '吨',
        //   '千米',
        //   '米',
        //   '厘米',
        // ];
        // List iteme = [
        //   'L',
        //   'g',
        //   'kg',
        //   'm',
        //   'M',
        //   'KG',
        //   'G',
        //   'l',
        //   'cm',
        //   'CM',
        //   'km',
        //   'KM',
        // ];
        // int showInt = 0;
        // for (var i = 0; i < spec.length; i++) {
        //   if (items.contains(spec[i])) {
        //   } else if (itemt.contains(spec[i])) {
        //     //非数字填写
        //     showInt = 2;
        //   } else if (itema.contains(spec[i])) {
        //     //除了数字规格外有单位
        //     showInt = 1;
        //     //-->配件规格
        //     materMap['itemUnit'] = spec[i];
        //   } else if (iteme.contains(spec[i])) {
        //     //除了数字规格外有单位
        //     showInt = 1;
        //     //-->配件规格
        //     materMap['itemUnit'] = spec[i];
        //   } else {
        //     //除了数字规格外没有单位
        //     showInt = 3;
        //   }
        // }
        // if (showInt == 3) {
        //   //提示单位不正确
        //   _showAlartDialog('请填写正确单位');
        // }
        // if (showInt == 2) {
        //   //提示请填写数字规格
        //   _showAlartDialog('请填写数字规格');
        // }
      } else {
        print('得到焦点');
      }
    });
  }

//服务  刷新
  _returnOneNum() {
    if (SynchronizePreferences.getCarMap() == null) {
      print('SynchronizePreferences-->null');
    } else {
      _intoSerData();
      print('-->${datasList.length}');
    }
  }

//整理 相同 一级服务 数据
//展示多个 本地share存在的服务
  _intoSerData() {
    var value = SynchronizePreferences.getCarMap();
    if (value != null) {
      if (value.containsKey('receiveCarServiceList')) {
        datasList.clear();
        //遍历
        for (var i = 0; i < value['receiveCarServiceList'].length; i++) {
          if (value['receiveCarServiceList'][i]['serviceId'] ==
              widget.servceId) {
            if (widget.materInt == 1) {
              if (value['receiveCarServiceList'][i]['serviceName'] ==
                  '其他配件项目') {
                datasList.add(value['receiveCarServiceList'][i]);
              }
            } else {
              datasList.add(value['receiveCarServiceList'][i]);
            }
          }
        }
        print('一级服务封装数据:$datasList');
      }
    }
  }

//配件
  int _returnMater(Map value) {
    if (value.containsKey('receiveCarMaterialList')) {
      print('配件-->${value['receiveCarMaterialList']}');

      if (value['receiveCarMaterialList'] == null) {
        return 0;
      } else {
        int number = value['receiveCarMaterialList'].length;
        return number;
      }
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('datasList-->${datasList.length}');
    _intoSerData();
    return Column(
      children: [
//服务清单

        Container(
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 3,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      color: Color.fromRGBO(39, 153, 93, 1),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '服务清单',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: Color.fromRGBO(229, 229, 229, 1),
              ),
              Row(
                children: [
                  Container(
                    width:
                        MediaQuery.of(context).size.width / 5 - 30 / 5 - 50 / 5,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '名称',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1), fontSize: 12),
                      ),
                    ),
                  ),
                  //
                  Container(
                    width:
                        MediaQuery.of(context).size.width / 5 - 30 / 5 - 50 / 5,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '规格',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1), fontSize: 12),
                      ),
                    ),
                  ),
                  //
                  Container(
                    width:
                        MediaQuery.of(context).size.width / 5 - 30 / 5 - 50 / 5,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '单价',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1), fontSize: 12),
                      ),
                    ),
                  ),
                  //
                  Container(
                    width:
                        MediaQuery.of(context).size.width / 5 - 30 / 5 - 50 / 5,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '数量',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1), fontSize: 12),
                      ),
                    ),
                  ),
                  //
                  Container(
                    width:
                        MediaQuery.of(context).size.width / 5 - 30 / 5 - 50 / 5,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '总价',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1), fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 1,
                color: Color.fromRGBO(229, 229, 229, 1),
              ),
              /** 
                     二级服务  展示 修改list
                     */
              ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(
                      datasList.length,
                      (index) => InkWell(
                          onTap: () {},
                          child:
                              //服务  清单  列表
                              Column(
                            children: [
                              Container(
                                color: Color.fromRGBO(233, 245, 238, 1),
                                child: Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    5 -
                                                30 / 5 -
                                                50 / 5,
                                        height: 40,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  datasList[index]
                                                          ['secondaryService']
                                                      .toString(),
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    //
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              5 -
                                          30 / 5 -
                                          50 / 5,
                                      height: 40,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '/',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    //
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              5 -
                                          30 / 5 -
                                          50 / 5,
                                      height: 40,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          widget.materInt == 1
                                              ? '/'
                                              : datasList[index]['price']
                                                          .toString() ==
                                                      'null'
                                                  ? '¥0'
                                                  : '¥' +
                                                      datasList[index]['price']
                                                          .toString(),
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    //
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              5 -
                                          30 / 5 -
                                          50 / 5,
                                      height: 40,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          widget.materInt == 1
                                              ? '/'
                                              : 'x' +
                                                  datasList[index]['count']
                                                      .toString(),
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    //
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              5 -
                                          30 / 5 -
                                          50 / 5,
                                      height: 40,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          widget.materInt == 1
                                              ? '/'
                                              : _getSumPrice(
                                                  datasList[index]['count']
                                                      .toString(),
                                                  datasList[index]['price']
                                                      .toString()),
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    //修改按钮
                                    Expanded(child: SizedBox()),

                                    datasList[index]['secondaryService']
                                                .toString() ==
                                            '其他配件服务子分类'
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              /**  
                                        这里可进行 数据传递 修改 操作
                                        服务修改  
                                     */
                                              widget.onChangedEdit(false);
                                              widget.onChangedMap(
                                                  datasList[index]);
                                            },
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '修改',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        43, 92, 255, 1),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),

                                    SizedBox(
                                      width: 14,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Color.fromRGBO(229, 229, 229, 1),
                              ),
                              /** 
                               配件  展示 修改list
                               */
                              ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                      _returnMater(datasList[index]),
                                      (indexs) => Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                  5 -
                                                              30 / 5 -
                                                              50 / 5,
                                                      height: 40,
                                                      child: Row(children: [
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              datasList[index][
                                                                              'receiveCarMaterialList']
                                                                          [
                                                                          indexs]
                                                                      [
                                                                      'itemMaterial']
                                                                  .toString(),
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          1),
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ),
                                                      ])),

                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                5 -
                                                            30 / 5 -
                                                            50 / 5,
                                                    height: 40,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        datasList[index][
                                                                    'receiveCarMaterialList']
                                                                [indexs]['spec']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                  //
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                5 -
                                                            30 / 5 -
                                                            50 / 5,
                                                    height: 40,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        '¥' +
                                                            datasList[index][
                                                                            'receiveCarMaterialList']
                                                                        [indexs]
                                                                    [
                                                                    'itemPrice']
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                5 -
                                                            30 / 5 -
                                                            50 / 5,
                                                    height: 40,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'x' +
                                                            datasList[index][
                                                                            'receiveCarMaterialList']
                                                                        [indexs]
                                                                    [
                                                                    'itemNumber']
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                5 -
                                                            30 / 5 -
                                                            50 / 5,
                                                    height: 40,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        _getSumPrice(
                                                            datasList[index][
                                                                            'receiveCarMaterialList']
                                                                        [indexs]
                                                                    [
                                                                    'itemNumber']
                                                                .toString(),
                                                            datasList[index][
                                                                            'receiveCarMaterialList']
                                                                        [indexs]
                                                                    [
                                                                    'itemPrice']
                                                                .toString()),
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                  //修改按钮
                                                  Expanded(child: SizedBox()),

                                                  InkWell(
                                                    onTap: () {
                                                      /**  
                                                       这里可进行 数据传递 修改 操作
                                                       配件修改  
                                                       */
                                                      setState(() {
                                                        showValue = index;
                                                        editBool = true;
                                                        editIndex = indexs;
                                                        secendSerName = datasList[
                                                                    index][
                                                                'secondaryService']
                                                            .toString();
                                                        nameMaterial = datasList[
                                                                        index][
                                                                    'receiveCarMaterialList']
                                                                [indexs]
                                                            ['itemMaterial'];
                                                        names = datasList[index]
                                                                    [
                                                                    'receiveCarMaterialList']
                                                                [indexs]
                                                            ['itemMaterial'];
                                                        pjType = datasList[
                                                                    index][
                                                                'receiveCarMaterialList']
                                                            [
                                                            indexs]['partsSource'];

                                                        /*
                                                          修改配件时 的 赋值
                                                        */
                                                        //-->配件来源

                                                        _fromcontroller
                                                            .text = datasList[
                                                                    index][
                                                                'receiveCarMaterialList']
                                                            [
                                                            indexs]['partsSource'];
                                                        //-->配件名称
                                                        _namecontroller
                                                            .text = datasList[
                                                                        index][
                                                                    'receiveCarMaterialList']
                                                                [indexs]
                                                            ['itemMaterial'];
                                                        //-->配件型号
                                                        _modelcontroller
                                                            .text = datasList[
                                                                    index][
                                                                'receiveCarMaterialList']
                                                            [
                                                            indexs]['itemModel'];
                                                        //-->配件规格
                                                        _brankcontroller
                                                            .text = datasList[
                                                                    index][
                                                                'receiveCarMaterialList']
                                                            [indexs]['spec'];
                                                        //-->配件单价
                                                        _pricecontroller
                                                            .text = datasList[
                                                                        index][
                                                                    'receiveCarMaterialList']
                                                                [
                                                                indexs]['itemPrice']
                                                            .toString();
                                                        //-->配件数量
                                                        _countcontroller
                                                            .text = datasList[
                                                                        index][
                                                                    'receiveCarMaterialList']
                                                                [
                                                                indexs]['itemNumber']
                                                            .toString();
                                                        //-->采购来源
                                                        if (datasList[index][
                                                                    'receiveCarMaterialList']
                                                                [indexs]
                                                            .containsKey(
                                                                'purchaseSource')) {
                                                          _purchaseSourcecontroller
                                                              .text = datasList[
                                                                          index]
                                                                      [
                                                                      'receiveCarMaterialList']
                                                                  [indexs][
                                                              'purchaseSource'];
                                                          //-->采购来源
                                                          materMap[
                                                              'purchaseSource'] = datasList[
                                                                          index]
                                                                      [
                                                                      'receiveCarMaterialList']
                                                                  [indexs][
                                                              'purchaseSource'];
                                                        }
                                                        //-->成本单价
                                                        if (datasList[index][
                                                                    'receiveCarMaterialList']
                                                                [indexs]
                                                            .containsKey(
                                                                'partsCost')) {
                                                          _partsCostcontroller
                                                              .text = datasList[
                                                                          index]
                                                                      [
                                                                      'receiveCarMaterialList']
                                                                  [
                                                                  indexs]['partsCost']
                                                              .toString();
                                                          //-->成本单价
                                                          materMap[
                                                                  'partsCost'] =
                                                              datasList[index]
                                                                              [
                                                                              'receiveCarMaterialList']
                                                                          [
                                                                          indexs]
                                                                      [
                                                                      'partsCost']
                                                                  .toString();
                                                        }
                                                        //-->来源
                                                        materMap[
                                                                'partsSource'] =
                                                            pjType;
                                                        //-->配件名称
                                                        materMap[
                                                                'itemMaterial'] =
                                                            datasList[index][
                                                                        'receiveCarMaterialList']
                                                                    [indexs][
                                                                'itemMaterial'];
                                                        //-->配件型号
                                                        materMap[
                                                            'itemModel'] = datasList[
                                                                    index][
                                                                'receiveCarMaterialList']
                                                            [
                                                            indexs]['itemModel'];
                                                        //-->配件规格

                                                        materMap[
                                                            'spec'] = datasList[
                                                                    index][
                                                                'receiveCarMaterialList']
                                                            [indexs]['spec'];

                                                        //-->配件单价
                                                        materMap['itemPrice'] =
                                                            datasList[index][
                                                                            'receiveCarMaterialList']
                                                                        [indexs]
                                                                    [
                                                                    'itemPrice']
                                                                .toString();
                                                        //-->配件数量
                                                        materMap['itemNumber'] =
                                                            datasList[index][
                                                                            'receiveCarMaterialList']
                                                                        [indexs]
                                                                    [
                                                                    'itemNumber']
                                                                .toString();
                                                      });
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        '修改',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    43,
                                                                    92,
                                                                    255,
                                                                    1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 14,
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 1,
                                                color: Color.fromRGBO(
                                                    229, 229, 229, 1),
                                              ),
                                            ],
                                          ))),
                              SizedBox(
                                height: 10,
                              ),
//  配件  添加
                              // widget.peiBool
                              showValue == index
                                  ? Container(
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: Column(children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  30 / 2,
                                              height: 50,
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '添加配件',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              58, 57, 57, 1),
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            30 / 2,
                                                    height: 3,
                                                    color: Color.fromRGBO(
                                                        39, 153, 93, 1),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Container(
                                                      width: 90,
                                                      height: 20,
                                                      child: FlatButton(
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      5)),
                                                          color: Color.fromRGBO(
                                                              255, 255, 255, 1),
                                                          onPressed: () {
                                                            print('添加配件');
                                                            setState(() {
                                                              if (showValue ==
                                                                  9999) {
                                                                //添加配件
                                                                // widget.peiBool = true;
                                                                showValue =
                                                                    index;
                                                                secendSerName =
                                                                    datasList[index]
                                                                            [
                                                                            'secondaryService']
                                                                        .toString();
                                                                _insertData();
                                                              } else {
                                                                //取消
                                                                editBool =
                                                                    false;
                                                                // widget.peiBool = true;
                                                                secendSerName =
                                                                    datasList[index]
                                                                            [
                                                                            'secondaryService']
                                                                        .toString();
                                                                showValue =
                                                                    9999;
                                                              }
                                                            });
                                                          },
                                                          child: Text(
                                                              showValue == 9999
                                                                  ? '添加配件'
                                                                  : '取消',
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          39,
                                                                          153,
                                                                          93,
                                                                          1),
                                                                  fontSize:
                                                                      16))),
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                    Container(
                                                        height: 3,
                                                        color: Color.fromRGBO(
                                                            220, 220, 220, 1))
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        //添加配件
                                        ListView(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            children: List.generate(
                                                pjType == '采购'
                                                    ? titles.length
                                                    : titles.length - 2,
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
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            42,
                                                                            42,
                                                                            1),
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              Text(
                                                                titles[index],
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            30,
                                                                            30,
                                                                            30,
                                                                            1),
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              titles[index] ==
                                                                      '来源'
                                                                  ? Expanded(
                                                                      child:
                                                                          SizedBox())
                                                                  : Container(),
                                                              titles[index] ==
                                                                      '来源'
                                                                  ?
                                                                  //选择
                                                                  InkWell(
                                                                      onTap:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .requestFocus(FocusNode());
                                                                        /* 选择配件 来源*/
                                                                        showModalBottomSheet(
                                                                            isDismissible:
                                                                                true,
                                                                            enableDrag:
                                                                                false,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return Container(
                                                                                height: 300.0,
                                                                                child: ShowBottomSheet(
                                                                                  type: 5,
                                                                                  dataList: [
                                                                                    '采购',
                                                                                    '库存'
                                                                                  ],
                                                                                  onChanged: (value) {
                                                                                    setState(() {
                                                                                      /*  来源选取   清空当前配件 信息*/
                                                                                      _namecontroller.text = '';
                                                                                      _brankcontroller.text = '';
                                                                                      _modelcontroller.text = '';
                                                                                      _pricecontroller.text = '';

                                                                                      price = 0;

                                                                                      sumPrice = 0;
                                                                                      _sumpricecontroller.text = '';

                                                                                      materList.clear();

                                                                                      pjType = value;
                                                                                      _fromcontroller.text = value;
                                                                                      print(value);
                                                                                      //封装 上传 map
                                                                                      //-->来源
                                                                                      materMap.clear();
                                                                                      materMap['partsSource'] = value;
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              );
                                                                            });
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          ConstrainedBox(
                                                                            constraints:
                                                                                BoxConstraints(maxHeight: 20, maxWidth: 100),
                                                                            child:
                                                                                TextFormField(
                                                                              enabled: false,
                                                                              controller: _fromcontroller,
                                                                              textAlign: TextAlign.right,
                                                                              style: TextStyle(fontSize: 14, color: Colors.black),
                                                                              decoration: InputDecoration(
                                                                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                                                                hintText: '请输入',
                                                                                hintStyle: TextStyle(color: pjType == '' ? Color.fromRGBO(164, 164, 164, 1) : Colors.black, fontSize: 14),
                                                                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Icon(
                                                                            Icons.chevron_right,
                                                                            color: pjType == ''
                                                                                ? Color.fromRGBO(164, 164, 164, 1)
                                                                                : Colors.black,
                                                                          )
                                                                        ],
                                                                      ))
                                                                  :
                                                                  //输入
                                                                  Expanded(
                                                                      child: InkWell(
                                                                          onTap: () {
                                                                            if (pjType ==
                                                                                '库存') {
                                                                              if (titles[index] == '名称') {
                                                                                setState(() {
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (context) => GoodsList(
                                                                                                type: 1,
                                                                                                carBrand: widget.carBrand,
                                                                                                carModel: widget.carModel,
                                                                                                onChangedCarMater: (value) {
                                                                                                  _namecontroller.text = MaterCarModel.fromJson(value).itemMaterial;
                                                                                                  _brankcontroller.text = MaterCarModel.fromJson(value).itemModel;
                                                                                                  _modelcontroller.text = MaterCarModel.fromJson(value).spec;
                                                                                                  _pricecontroller.text = '¥' + MaterCarModel.fromJson(value).itemPrice;

                                                                                                  price = double.parse(MaterCarModel.fromJson(value).itemPrice);

                                                                                                  sumPrice = proNum * double.parse(MaterCarModel.fromJson(value).itemPrice);
                                                                                                  _sumpricecontroller.text = '¥' + sumPrice.toStringAsFixed(1);

                                                                                                  materList.clear();
                                                                                                  //封装 上传 map
                                                                                                  //-->配件名称
                                                                                                  materMap['itemMaterial'] = MaterCarModel.fromJson(value).itemMaterial;
                                                                                                  //-->配件id
                                                                                                  materMap['shopGoodsId'] = MaterCarModel.fromJson(value).itemGoodsId;
                                                                                                  //-->配件型号
                                                                                                  materMap['itemModel'] = MaterCarModel.fromJson(value).itemModel;
                                                                                                  //-->配件规格
                                                                                                  materMap['spec'] = MaterCarModel.fromJson(value).spec;
                                                                                                  //-->配件单价
                                                                                                  materMap['itemPrice'] = MaterCarModel.fromJson(value).itemPrice;
                                                                                                  //-->配件数量
                                                                                                  materMap['itemNumber'] = '1';
                                                                                                  //-->成本单价
                                                                                                  materMap['partsCost'] = MaterCarModel.fromJson(value).partsCost;
                                                                                                },
                                                                                              )));
                                                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                                                });
                                                                              }
                                                                            }
                                                                          },
                                                                          child: Align(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child:
                                                                                ConstrainedBox(
                                                                              constraints: BoxConstraints(maxHeight: 20, maxWidth: 150),
                                                                              child: TextFormField(
                                                                                inputFormatters: titles[index] == '单价' || titles[index] == '数量'
                                                                                    ? [
                                                                                        KeyboardLimit(1)
                                                                                      ]
                                                                                    : null,
                                                                                keyboardType: titles[index] == '单价' || titles[index] == '数量' ? TextInputType.numberWithOptions(decimal: true) : null,
                                                                                focusNode: titles[index] == '名称'
                                                                                    ? _nameFocusNode
                                                                                    : titles[index] == '型号'
                                                                                        ? _modelFocusNode
                                                                                        : titles[index] == '规格'
                                                                                            ? _specFocusNode
                                                                                            : titles[index] == '单价'
                                                                                                ? _priceFocusNode
                                                                                                : titles[index] == '数量'
                                                                                                    ? _countFocusNode
                                                                                                    : null,
                                                                                controller:
                                                                                    /* textfiled 值变化*/
                                                                                    titles[index] == '名称'
                                                                                        ? _namecontroller
                                                                                        : titles[index] == '型号'
                                                                                            ? _modelcontroller
                                                                                            : titles[index] == '规格'
                                                                                                ? _brankcontroller
                                                                                                : titles[index] == '单价'
                                                                                                    ? _pricecontroller
                                                                                                    : titles[index] == '数量'
                                                                                                        ? _countcontroller
                                                                                                        : titles[index] == '总价'
                                                                                                            ? _sumpricecontroller
                                                                                                            : titles[index] == '采购来源'
                                                                                                                ? _purchaseSourcecontroller
                                                                                                                : titles[index] == '成本单价'
                                                                                                                    ? _partsCostcontroller
                                                                                                                    : null,
                                                                                enabled: titles[index] == '总价'
                                                                                    ? false
                                                                                    : pjType == '库存'
                                                                                        ? titles[index] == '数量'
                                                                                            ? true
                                                                                            : false
                                                                                        : true,
                                                                                onEditingComplete: () {
                                                                                  switch (titles[index]) {
                                                                                    case '名称':
                                                                                      FocusScope.of(context).requestFocus(_modelFocusNode);

                                                                                      break;
                                                                                    case '型号':
                                                                                      FocusScope.of(context).requestFocus(_specFocusNode);

                                                                                      break;
                                                                                    case '规格':
                                                                                      FocusScope.of(context).requestFocus(_priceFocusNode);

                                                                                      break;
                                                                                    case '单价':
                                                                                      FocusScope.of(context).requestFocus(_countFocusNode);

                                                                                      break;
                                                                                    case '数量':
                                                                                      FocusScope.of(context).requestFocus(FocusNode());

                                                                                      break;

                                                                                    default:
                                                                                      FocusScope.of(context).requestFocus(FocusNode());
                                                                                  }
                                                                                },
                                                                                onChanged: (value) {
                                                                                  if (titles[index] == '名称') {
                                                                                    names = value;
                                                                                    price = 0.0;
                                                                                    proNum = 1.0;
                                                                                    sumPrice = 0.0;
                                                                                    // if (value.length < 2) {
                                                                                    // } else {
                                                                                    //   if (pjType == '库存') {
                                                                                    //     //跳转模糊搜索
                                                                                    //     //_getMaterialList(value);
                                                                                    //     Navigator.push(context, MaterialPageRoute(builder: (context) => GoodsList()));
                                                                                    //   }
                                                                                    // }
                                                                                  } else if (titles[index] == '型号') {
                                                                                    mode = value;
                                                                                  } else if (titles[index] == '规格') {
                                                                                    spec = value;
                                                                                  } else if (titles[index] == '单价') {
                                                                                    price = double.parse(value);

                                                                                    if (price > 0) {
                                                                                      sumPrice = price * proNum;
                                                                                      //总价联动
                                                                                      _sumpricecontroller.text = '¥' + sumPrice.toStringAsFixed(1);
                                                                                    }
                                                                                  } else if (titles[index] == '数量') {
                                                                                    print('$value');
                                                                                    proNum = double.parse(value);
                                                                                    sumPrice = price * proNum;
                                                                                    print('--->$price,$proNum,$sumPrice');
                                                                                    _sumpricecontroller.text = '¥' + sumPrice.toStringAsFixed(1);
                                                                                    //封装 上传 map
                                                                                    //-->配件数量
                                                                                    materMap['itemNumber'] = proNum.toString();
                                                                                  } else if (titles[index] == '采购来源') {
                                                                                    //封装 上传 map
                                                                                    //-->采购来源
                                                                                    materMap['purchaseSource'] = value;
                                                                                  } else if (titles[index] == '成本单价') {
                                                                                    //封装 上传 map
                                                                                    //-->成本单价
                                                                                    materMap['partsCost'] = value;
                                                                                  }
                                                                                  //封装 上传 map

                                                                                  //-->配件名称
                                                                                  materMap['itemMaterial'] = names;
                                                                                  //-->配件型号
                                                                                  materMap['itemModel'] = mode;

                                                                                  //-->配件单价
                                                                                  materMap['itemPrice'] = price.toString();
                                                                                  //-->配件数量
                                                                                  materMap['itemNumber'] = proNum.toString();

                                                                                  //-->配件规格

                                                                                  materMap['spec'] = spec;
                                                                                },
                                                                                textAlign: TextAlign.right,
                                                                                style: TextStyle(fontSize: 14, color: Colors.black),
                                                                                decoration: InputDecoration(
                                                                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                                                                  hintText: titles[index] == '数量'
                                                                                      ? 'x1'
                                                                                      : titles[index] == '总价'
                                                                                          ? '¥0.0'
                                                                                          : titles[index] == '规格'
                                                                                              ? '请输入规格与单位'
                                                                                              : '请输入',
                                                                                  hintStyle: TextStyle(color: Color.fromRGBO(164, 164, 164, 1), fontSize: 14),
                                                                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )),
                                                                    ),
                                                              titles[index] ==
                                                                      '来源'
                                                                  ? SizedBox(
                                                                      width: 10,
                                                                    )
                                                                  : SizedBox(
                                                                      width: 30,
                                                                    )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            height: 1,
                                                            color:
                                                                Color.fromRGBO(
                                                                    229,
                                                                    229,
                                                                    229,
                                                                    1),
                                                          ),
                                                          /*
                                                           展示 模糊搜索 结果
                                                          */
                                                          titles[index] == '名称'
                                                              ? CarNameList(
                                                                  type:
                                                                      1, //此处传 1 代表展示配件列表 传入其他代表的是二级服务列表
                                                                  dataList:
                                                                      materList,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      /*  传来的 配件 */
                                                                      print(
                                                                          value);
                                                                      FocusScope.of(
                                                                              context)
                                                                          .requestFocus(
                                                                              FocusNode());
                                                                      _namecontroller
                                                                          .text = MaterCarModel.fromJson(
                                                                              value)
                                                                          .itemMaterial;
                                                                      _brankcontroller
                                                                          .text = MaterCarModel.fromJson(
                                                                              value)
                                                                          .itemModel;
                                                                      _modelcontroller
                                                                          .text = MaterCarModel.fromJson(
                                                                              value)
                                                                          .spec;
                                                                      _pricecontroller
                                                                              .text =
                                                                          '¥' +
                                                                              MaterCarModel.fromJson(value).itemPrice;

                                                                      price = double.parse(
                                                                          MaterCarModel.fromJson(value)
                                                                              .itemPrice);

                                                                      sumPrice =
                                                                          proNum *
                                                                              double.parse(MaterCarModel.fromJson(value).itemPrice);
                                                                      _sumpricecontroller
                                                                              .text =
                                                                          '¥' +
                                                                              sumPrice.toStringAsFixed(1);

                                                                      materList
                                                                          .clear();
                                                                      //封装 上传 map
                                                                      //-->配件名称
                                                                      materMap[
                                                                          'itemMaterial'] = MaterCarModel.fromJson(
                                                                              value)
                                                                          .itemMaterial;
                                                                      //-->配件型号
                                                                      materMap[
                                                                          'itemModel'] = MaterCarModel.fromJson(
                                                                              value)
                                                                          .itemModel;
                                                                      //-->配件规格
                                                                      materMap[
                                                                          'spec'] = MaterCarModel.fromJson(
                                                                              value)
                                                                          .spec;
                                                                      //-->配件单价
                                                                      materMap[
                                                                          'itemPrice'] = MaterCarModel.fromJson(
                                                                              value)
                                                                          .itemPrice;
                                                                      //-->配件数量
                                                                      materMap[
                                                                              'itemNumber'] =
                                                                          '1';
                                                                    });
                                                                  },
                                                                )
                                                              : Container(),
                                                          materList.length > 0
                                                              ? titles[index] ==
                                                                      '名称'
                                                                  ? SizedBox(
                                                                      height: 5,
                                                                    )
                                                                  : SizedBox()
                                                              : SizedBox(),
                                                          materList.length > 0
                                                              ? titles[index] ==
                                                                      '名称'
                                                                  ? Container(
                                                                      height: 3,
                                                                      color: Color.fromRGBO(
                                                                          229,
                                                                          229,
                                                                          229,
                                                                          1),
                                                                    )
                                                                  : Container()
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ))),
                                        SizedBox(
                                          height: 40,
                                        ),
//底部按钮
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 40,
                                            ),
                                            Container(
                                              width: 90,
                                              height: 30,
                                              child: FlatButton(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  color: Color.fromRGBO(
                                                      39, 153, 93, 1),
                                                  onPressed: () {
                                                    print('修改保存');
                                                    setState(() {
                                                      if (pjType == '') {
                                                      } else {
                                                        if (editBool) {
                                                          //  修改
                                                          var value =
                                                              SynchronizePreferences
                                                                  .getCarMap();
                                                          //遍历
                                                          for (var i = 0;
                                                              i <
                                                                  value['receiveCarServiceList']
                                                                      .length;
                                                              i++) {
                                                            //判断 是否存在同一个一级服务
                                                            if (value['receiveCarServiceList']
                                                                        [i][
                                                                    'serviceId'] ==
                                                                widget
                                                                    .servceId) {
                                                              //判断是否存在二级服务
                                                              if (value['receiveCarServiceList']
                                                                          [i][
                                                                      'secondaryService'] ==
                                                                  secendSerName) {
                                                                print('存在');
                                                                //在判断 有配件
                                                                if (value['receiveCarServiceList']
                                                                        [i]
                                                                    .containsKey(
                                                                        'receiveCarMaterialList')) {
                                                                  /** 
                                                                     修改后的 配件赋值
                                                                  */
                                                                  //-->配件来源
                                                                  value['receiveCarServiceList'][i]['receiveCarMaterialList']
                                                                              [
                                                                              editIndex]
                                                                          [
                                                                          'partsSource'] =
                                                                      materMap[
                                                                          'partsSource'];
                                                                  //-->配件名称
                                                                  value['receiveCarServiceList'][i]['receiveCarMaterialList']
                                                                              [
                                                                              editIndex]
                                                                          [
                                                                          'itemMaterial'] =
                                                                      materMap[
                                                                          'itemMaterial'];
                                                                  //-->配件型号
                                                                  value['receiveCarServiceList'][i]['receiveCarMaterialList']
                                                                              [
                                                                              editIndex]
                                                                          [
                                                                          'itemModel'] =
                                                                      materMap[
                                                                          'itemModel'];
                                                                  //-->配件规格
                                                                  value['receiveCarServiceList'][i]['receiveCarMaterialList']
                                                                              [
                                                                              editIndex]
                                                                          [
                                                                          'spec'] =
                                                                      materMap[
                                                                          'spec'];
                                                                  //-->配件单价
                                                                  value['receiveCarServiceList'][i]['receiveCarMaterialList']
                                                                              [
                                                                              editIndex]
                                                                          [
                                                                          'itemPrice'] =
                                                                      materMap[
                                                                          'itemPrice'];
                                                                  //-->配件数量
                                                                  value['receiveCarServiceList'][i]['receiveCarMaterialList']
                                                                              [
                                                                              editIndex]
                                                                          [
                                                                          'itemNumber'] =
                                                                      materMap[
                                                                          'itemNumber'];
                                                                  //-->采购来源
                                                                  if (value['receiveCarServiceList'][i]
                                                                              [
                                                                              'receiveCarMaterialList']
                                                                          [
                                                                          editIndex]
                                                                      .containsKey(
                                                                          'purchaseSource')) {
                                                                    value['receiveCarServiceList'][i]['receiveCarMaterialList'][editIndex]
                                                                            [
                                                                            'purchaseSource'] =
                                                                        materMap[
                                                                            'purchaseSource'];
                                                                  }
                                                                  //-->成本单价
                                                                  if (value['receiveCarServiceList'][i]
                                                                              [
                                                                              'receiveCarMaterialList']
                                                                          [
                                                                          editIndex]
                                                                      .containsKey(
                                                                          'partsCost')) {
                                                                    value['receiveCarServiceList'][i]['receiveCarMaterialList'][editIndex]
                                                                            [
                                                                            'partsCost'] =
                                                                        materMap[
                                                                            'partsCost'];
                                                                  }

                                                                  SharedManager.saveString(
                                                                      json
                                                                          .encode(
                                                                              value)
                                                                          .toString(),
                                                                      'receiveCarServiceList'); //<---

                                                                  datasList
                                                                      .clear();

                                                                  for (var a =
                                                                          0;
                                                                      a <
                                                                          value['receiveCarServiceList']
                                                                              .length;
                                                                      a++) {
                                                                    if (value['receiveCarServiceList'][a]
                                                                            [
                                                                            'serviceId'] ==
                                                                        widget
                                                                            .servceId) {
                                                                      datasList.add(
                                                                          value['receiveCarServiceList']
                                                                              [
                                                                              a]);
                                                                    }
                                                                  }
                                                                  print(
                                                                      '一级服务封装数据:$datasList');

                                                                  print(
                                                                      '>>>>>>>>>$value');
                                                                }
                                                              }
                                                            }
                                                          }
                                                          widget.peiBool =
                                                              false;
                                                          showValue = 9999;

                                                          editBool = false;
                                                        } else {
                                                          //  保存
                                                          widget.peiBool =
                                                              false;
                                                          showValue = 9999;
                                                          upData.add(materMap);
                                                          valueMap.clear();
                                                          valueMap[
                                                                  'receiveCarMaterialList'] =
                                                              upData;
                                                          valueData.clear();
                                                          valueData
                                                              .add(materMap);

                                                          var value =
                                                              SynchronizePreferences
                                                                  .getCarMap();
                                                          //先判断 有二级服务
                                                          if (value == null) {
                                                          } else {
                                                            if (value.containsKey(
                                                                'receiveCarServiceList')) {
                                                              //遍历
                                                              for (var i = 0;
                                                                  i <
                                                                      value['receiveCarServiceList']
                                                                          .length;
                                                                  i++) {
                                                                //判断 是否存在同一个一级服务
                                                                if (value['receiveCarServiceList']
                                                                            [i][
                                                                        'serviceId'] ==
                                                                    widget
                                                                        .servceId) {
                                                                  //判断是否存在二级服务
                                                                  if (value['receiveCarServiceList']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'secondaryService'] ==
                                                                      secendSerName) {
                                                                    print('存在');
                                                                    //在判断 有配件
                                                                    if (value['receiveCarServiceList']
                                                                            [i]
                                                                        .containsKey(
                                                                            'receiveCarMaterialList')) {
                                                                      value['receiveCarServiceList'][i]
                                                                              [
                                                                              'receiveCarMaterialList']
                                                                          .add(
                                                                              materMap);
                                                                      SharedManager.saveString(
                                                                          json
                                                                              .encode(value)
                                                                              .toString(),
                                                                          'receiveCarServiceList'); //<---
                                                                      datasList
                                                                          .clear();
                                                                      for (var a =
                                                                              0;
                                                                          a < value['receiveCarServiceList'].length;
                                                                          a++) {
                                                                        if (value['receiveCarServiceList'][a]['serviceId'] ==
                                                                            widget.servceId) {
                                                                          datasList.add(value['receiveCarServiceList']
                                                                              [
                                                                              a]);
                                                                        }
                                                                      }
                                                                      print(
                                                                          '一级服务封装数据:$datasList');
                                                                      print(
                                                                          '====>$datasList');
                                                                      print(
                                                                          '有配件用于存储的:$value');
                                                                    } else {
                                                                      //无配件
                                                                      value['receiveCarServiceList'][i]
                                                                              [
                                                                              'receiveCarMaterialList'] =
                                                                          valueData; //<---
                                                                      SharedManager.saveString(
                                                                          json
                                                                              .encode(value)
                                                                              .toString(),
                                                                          'receiveCarServiceList');
                                                                      datasList
                                                                          .clear();
                                                                      for (var a =
                                                                              0;
                                                                          a < value['receiveCarServiceList'].length;
                                                                          a++) {
                                                                        if (value['receiveCarServiceList'][a]['serviceId'] ==
                                                                            widget.servceId) {
                                                                          datasList.add(value['receiveCarServiceList']
                                                                              [
                                                                              a]);
                                                                        }
                                                                      }
                                                                      print(
                                                                          '用于存储的:$value');
                                                                    }
                                                                  } else {
                                                                    print(
                                                                        '不存在');
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        }
                                                      }
                                                      editBool = false;
                                                    });
                                                  },
                                                  child: Text(
                                                      editBool ? '完成' : '保存',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ))),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  80 -
                                                  180 -
                                                  30,
                                            ),
                                            Container(
                                              width: 90,
                                              height: 30,
                                              child: FlatButton(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  color: Color.fromRGBO(
                                                      39, 153, 93, 1),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (pjType == '') {
                                                      } else {
                                                        print('--->添加配件');
                                                        widget.peiBool = true;
                                                        if (editBool) {
                                                          /** 
                                                           删除
                                                          */
                                                          //  修改
                                                          var value =
                                                              SynchronizePreferences
                                                                  .getCarMap();
                                                          //遍历
                                                          for (var i = 0;
                                                              i <
                                                                  value['receiveCarServiceList']
                                                                      .length;
                                                              i++) {
                                                            //判断 是否存在同一个一级服务
                                                            if (value['receiveCarServiceList']
                                                                        [i][
                                                                    'serviceId'] ==
                                                                widget
                                                                    .servceId) {
                                                              //判断是否存在二级服务
                                                              if (value['receiveCarServiceList']
                                                                          [i][
                                                                      'secondaryService'] ==
                                                                  secendSerName) {
                                                                print('存在');
                                                                //在判断 有配件
                                                                if (value['receiveCarServiceList']
                                                                        [i]
                                                                    .containsKey(
                                                                        'receiveCarMaterialList')) {
                                                                  //遍历 配件
                                                                  for (var j =
                                                                          0;
                                                                      j <
                                                                          value['receiveCarServiceList'][i]['receiveCarMaterialList']
                                                                              .length;
                                                                      j++) {
                                                                    //找到相同配件删除
                                                                    if (value['receiveCarServiceList'][i]['receiveCarMaterialList'][j]
                                                                            [
                                                                            'itemMaterial'] ==
                                                                        nameMaterial) {
                                                                      value['receiveCarServiceList'][i]
                                                                              [
                                                                              'receiveCarMaterialList']
                                                                          .removeAt(
                                                                              j);
                                                                      SharedManager.saveString(
                                                                          json
                                                                              .encode(value)
                                                                              .toString(),
                                                                          'receiveCarServiceList');

                                                                      datasList
                                                                          .clear();
                                                                      for (var a =
                                                                              0;
                                                                          a < value['receiveCarServiceList'].length;
                                                                          a++) {
                                                                        if (value['receiveCarServiceList'][a]['serviceId'] ==
                                                                            widget.servceId) {
                                                                          datasList.add(value['receiveCarServiceList']
                                                                              [
                                                                              a]);
                                                                        }
                                                                      }

                                                                      widget.peiBool =
                                                                          false;
                                                                      showValue =
                                                                          9999;

                                                                      editBool =
                                                                          false;

                                                                      break;
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        } else {
                                                          /**
                                                           继续添加配件
                                                          */
                                                          //  保存
                                                          // widget.peiBool =
                                                          //     false;
                                                          // showValue = 9999;
                                                          _insertData();
                                                          upData.add(materMap);
                                                          valueMap.clear();
                                                          valueMap[
                                                                  'receiveCarMaterialList'] =
                                                              upData;
                                                          valueData.clear();
                                                          valueData
                                                              .add(materMap);

                                                          var value =
                                                              SynchronizePreferences
                                                                  .getCarMap();
                                                          //先判断 有二级服务
                                                          if (value == null) {
                                                          } else {
                                                            if (value.containsKey(
                                                                'receiveCarServiceList')) {
                                                              //遍历
                                                              for (var i = 0;
                                                                  i <
                                                                      value['receiveCarServiceList']
                                                                          .length;
                                                                  i++) {
                                                                //判断 是否存在同一个一级服务
                                                                if (value['receiveCarServiceList']
                                                                            [i][
                                                                        'serviceId'] ==
                                                                    widget
                                                                        .servceId) {
                                                                  //判断是否存在二级服务
                                                                  if (value['receiveCarServiceList']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'secondaryService'] ==
                                                                      secendSerName) {
                                                                    print('存在');
                                                                    //在判断 有配件
                                                                    if (value['receiveCarServiceList']
                                                                            [i]
                                                                        .containsKey(
                                                                            'receiveCarMaterialList')) {
                                                                      value['receiveCarServiceList'][i]
                                                                              [
                                                                              'receiveCarMaterialList']
                                                                          .add(
                                                                              materMap);
                                                                      SharedManager.saveString(
                                                                          json
                                                                              .encode(value)
                                                                              .toString(),
                                                                          'receiveCarServiceList'); //<---
                                                                      datasList
                                                                          .clear();
                                                                      for (var a =
                                                                              0;
                                                                          a < value['receiveCarServiceList'].length;
                                                                          a++) {
                                                                        if (value['receiveCarServiceList'][a]['serviceId'] ==
                                                                            widget.servceId) {
                                                                          datasList.add(value['receiveCarServiceList']
                                                                              [
                                                                              a]);
                                                                        }
                                                                      }
                                                                      print(
                                                                          '一级服务封装数据:$datasList');
                                                                      print(
                                                                          '====>$datasList');
                                                                      print(
                                                                          '有配件用于存储的:$value');
                                                                    } else {
                                                                      //无配件
                                                                      value['receiveCarServiceList'][i]
                                                                              [
                                                                              'receiveCarMaterialList'] =
                                                                          valueData; //<---
                                                                      SharedManager.saveString(
                                                                          json
                                                                              .encode(value)
                                                                              .toString(),
                                                                          'receiveCarServiceList');
                                                                      datasList
                                                                          .clear();
                                                                      for (var a =
                                                                              0;
                                                                          a < value['receiveCarServiceList'].length;
                                                                          a++) {
                                                                        if (value['receiveCarServiceList'][a]['serviceId'] ==
                                                                            widget.servceId) {
                                                                          datasList.add(value['receiveCarServiceList']
                                                                              [
                                                                              a]);
                                                                        }
                                                                      }
                                                                      print(
                                                                          '用于存储的:$value');
                                                                    }
                                                                  } else {
                                                                    print(
                                                                        '不存在');
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                      editBool ? '删除' : '添加配件',
                                                      style: TextStyle(
                                                        color: Colors.white,
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
                                      ]))
                                  : Container(),

                              SizedBox(
                                height: 30,
                              ),
                              /** 
                                 添加服务 配件  添加按钮
                               */
                              showValue == index
                                  ? Container()
                                  : Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                        ),
                                        index == datasList.length - 1
                                            ? datasList[index]
                                                            ['secondaryService']
                                                        .toString() ==
                                                    '其他配件服务子分类'
                                                ? Container()
                                                : GestureDetector(
                                                    onTap: () {
                                                      print('添加服务');
                                                      setState(() {
                                                        widget.onChangedSer(
                                                            false);
                                                        widget.onChangedStr(
                                                            index + 1);
                                                      });
                                                    },
                                                    child: Container(
                                                        width: 90,
                                                        height: 30,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Color.fromRGBO(
                                                              39, 153, 93, 1),
                                                        ),
                                                        child: Text('添加服务',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ))),
                                                  )
                                            : SizedBox(
                                                width: 90,
                                              ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              80 -
                                              180 -
                                              30,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print('添加配件');
                                            setState(() {
                                              // if (showValue == 9999) {
                                              //添加配件
                                              // widget.peiBool = true;
                                              showValue = index;
                                              secendSerName = datasList[index]
                                                      ['secondaryService']
                                                  .toString();
                                              _insertData();
                                              // if (widget.materInt == 1) {

                                              //   upMap['serviceId'] =
                                              //       widget.serviceId;
                                              //   upMap['serviceName'] =
                                              //       widget.serviceName;
                                              //   upMap['shopId'] = widget.shopId;
                                              //   upMap['secondaryService'] =
                                              //       '其他配件';
                                              //   upMap['price'] = '/';
                                              //   upMap['count'] = '/';

                                              //   upData.add(upMap);
                                              //   SharedManager.saveString(
                                              //       json.encode({
                                              //         'receiveCarServiceList':
                                              //             upData
                                              //       }).toString(),
                                              //       'receiveCarServiceList');
                                              // }
                                              // } else {
                                              //   //取消
                                              //   editBool = false;
                                              //   // widget.peiBool = true;
                                              //   secendSerName = datasList[
                                              //               index]
                                              //           ['secondaryService']
                                              //       .toString();
                                              //   showValue = 9999;
                                              // }
                                            });
                                          },
                                          child: Container(
                                              width: 90,
                                              height: 30,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color.fromRGBO(
                                                    39, 153, 93, 1),
                                              ),
                                              child: Text(
                                                  // showValue == 9999
                                                  //?
                                                  '添加配件',
                                                  // : '取消',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ))),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                      ],
                                    ),
                              showValue == index
                                  ? SizedBox(
                                      height: 0,
                                    )
                                  : SizedBox(
                                      height: 20,
                                    ),
                            ],
                          )))),
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),
        //----------------⬇️
      ],
    );
  }
}
