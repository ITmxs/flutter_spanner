import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cModel/atWorkModel.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/publicView/pud_permission.dart';
import './atWorkRequestApi.dart';

class AtWorkView extends StatefulWidget {
  final List<int> _showList = List(); // 收缩 展开
  @override
  _AtWorkViewState createState() => _AtWorkViewState();
}

class _AtWorkViewState extends State<AtWorkView> {
  bool deleltBool = false; // 管理 点击 变换
  bool allBool = false; // 点击全选
  String names = ''; //员工名
  String ids = ''; //员工id
  String userId;
  List upDatas = List(); // 用于 数据处理的 集合
  List peopleList = List(); // 派工人员列表
  List datas = List(); //数据集
  List list = List();
  List selectCarAll = List(); //选中的车牌号集合
  Map selectCarSers = Map(); //全选中的车牌号服务集合
  Map angleSelectCarSer = Map(); //单选中的车牌号服务集合
  Map allIndexMap = Map(); //  全选
  // ignore: missing_return
  int _comparayBool(int index) {
    for (var i = 0; i < widget._showList.length; i++) {
      if (widget._showList[i] == index) {
        print('=====================');
        return 1;
      }
    }
  }

  /* 获取派工看板列表*/
  _getdata() {
    UntilApi.atworkRequest(
      param: {'': ''},
      onSuccess: (data) {
        setState(() {
          datas = data; //['tbWorkOrderWebEntities']
          print('派工数据-->:$datas');
        });
      },
      onError: (error) {},
    );
  }

  /* 判断 车牌号 是否选中*/
  // ignore: missing_return
  int _isOk(int index) {
    if (allIndexMap['$index'] == 101) {
      return 0;
    } else {
      for (var i = 0; i < selectCarAll.length; i++) {
        if (selectCarAll[i] == index) {
          return 1;
        }
      }
    }
  }

  /* 判断 车牌号 是否选中*/
  // ignore: missing_return
  int _isAngleOk(int index, int indexs) {
    if (angleSelectCarSer.containsKey('$index')) {
      for (var i = 0; i < angleSelectCarSer['$index'].length; i++) {
        if (angleSelectCarSer['$index'][i] == indexs) {
          return 1;
        }
      }
    }
  }

  /* 判断 配件 是否选中*/
  // ignore: missing_return
  int _isPJOk(int index, int indexs) {
    print(angleSelectCarSer);
    if (angleSelectCarSer.containsKey('$index')) {
      for (var i = 0; i < angleSelectCarSer['$index'].length; i++) {
        if (angleSelectCarSer['$index'][i] == indexs) {
          return 0;
        }
      }
    }
  }

  /*  用于整合 最后 使用的 数据 合集*/
  _makeUpData() {
    upDatas.clear();
    for (var i = 0; i < datas.length; i++) {
      if (angleSelectCarSer.containsKey('$i')) {
        for (var j = 0; j < datas[i]['itemTypeList'].length; j++) {
          for (var l = 0; l < angleSelectCarSer['$i'].length; l++) {
            if (j == angleSelectCarSer['$i'][l]) {
              /*取出 对应 数据*/
              var id = datas[i]['itemTypeList'][j]['id'].toString();
              var workOrderId =
                  datas[i]['itemTypeList'][j]['workOrderId'].toString();
              if (deleltBool) {
                /* 用于删除 操作*/
                Map map = Map();
                map['id'] = id;
                upDatas.add(id);
                print('ids------->$upDatas');
              } else {
                /* 用于派工 操作*/
                Map map = Map();
                map['id'] = id;
                map['userId'] = userId;
                map['workOrderId'] = workOrderId;
                upDatas.add(map);
                print('ids------->$upDatas');
              }
            }
          }
        }
      }
    }
  }

  /* 获取 派工人员 列表*/
  _getPeopleList() {
    UntilApi.atworkPeopleRequest(
      onSuccess: (data) {
        peopleList = data;
      },
    );
  }

  /* 派工*/
  _postDat() {
    UntilApi.atworkPostRequest(
      param: {'data': upDatas.toString()},
      onSuccess: (data) {
        selectCarAll.clear();
        angleSelectCarSer.clear();
        _getdata();
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => WorkingView()));
      },
    );
  }

  /* 删除*/
  _delDat() {
    UntilApi.atworkDeletRequest(
      param: {'data': upDatas.toString()},
      onSuccess: (data) {
        selectCarAll.clear();
        angleSelectCarSer.clear();
        _getdata();
      },
    );
  }

/*
下拉刷新
*/
  Future _toRefresh() async {
    selectCarAll.clear();
    angleSelectCarSer.clear();
    _getdata();
    return null;
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
    _getdata();
    super.initState();
    _getPeopleList();
  }

  @override
  Widget build(BuildContext context) {
    //  print('配件-->:${datas[0]['itemTypeList'][0]['materialList']}');
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          Navigator.popUntil(
              context,
              ModalRoute.withName(
                  SynchronizePreferences.Get('autoLogin') == null
                      ? '/'
                      : '/home'));
        },
        child: Scaffold(
            backgroundColor: Color.fromRGBO(238, 238, 238, 1),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              // elevation: 0,
              brightness: Brightness.light,
              title: Text(
                '派工看板',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.popUntil(
                        context,
                        ModalRoute.withName(
                            SynchronizePreferences.Get('autoLogin') == null
                                ? '/'
                                : '/home'));
                  }),
            ),
            body: isNull(datas) == 0
                ? Padding(
                    padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
                    child: RefreshIndicator(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          ShowNullDataAlart(
                            alartText: '亲，当前数据为空呦~',
                          ),
                        ],
                      ),
                      onRefresh: _toRefresh,
                    ))
                : Stack(
                    children: [
                      // 车辆  管理
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            23,
                            0,
                            23,
                            MediaQuery.of(context).size.height -
                                (MediaQueryData.fromWindow(window).padding.top +
                                    56 +
                                    57)),
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '共${datas.length}辆车',
                                style: TextStyle(
                                    color: Color.fromRGBO(51, 49, 49, 1),
                                    fontSize: 12),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            //管理
                            InkWell(
                              onTap: () {
                                setState(() {
                                  //权限处理 详细参考 后台Excel
                                  PermissionApi.whetherContain('dispatch_view')
                                      ? print('')
                                      : deleltBool
                                          ? deleltBool = false
                                          : deleltBool = true;
                                });
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  deleltBool ? '完成' : '管理',
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 49, 49, 1),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //车辆管理列表
                      RefreshIndicator(
                        onRefresh: _toRefresh,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 57, 0, 84),
                            child: ScrollConfiguration(
                              behavior: NeverScrollBehavior(),
                              child: ListView(
                                shrinkWrap: true,
                                children: List.generate(
                                    datas.length,
                                    (index) => Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      30,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Column(
                                                    children: [
// 车牌
                                                      Row(
                                                        children: [
                                                          Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        39,
                                                                        153,
                                                                        93,
                                                                        1),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  ///头部视图
                                                                  //车辆内内容全部选择
                                                                  InkWell(
                                                                    onTap: () {
                                                                      /*  
                                                             选中车辆 包含车辆内服务项目 进行派工和 删除操作
                                                            */
                                                                      setState(
                                                                          () {
                                                                        if (_isOk(index) ==
                                                                            1) {
                                                                          allBool =
                                                                              false;

                                                                          allIndexMap['$index'] =
                                                                              101;
                                                                          selectCarAll
                                                                              .remove(index);
                                                                          angleSelectCarSer
                                                                              .remove('$index');
                                                                          list.clear();
                                                                          print(
                                                                              '清空');
                                                                        } else {
                                                                          allIndexMap['$index'] =
                                                                              100;
                                                                          selectCarAll
                                                                              .add(index);
                                                                          if (selectCarAll.length ==
                                                                              datas.length) {
                                                                            allBool =
                                                                                true;
                                                                          }
                                                                          /* 添加全部 选中服务  ⬇️*/
                                                                          List
                                                                              list =
                                                                              List();
                                                                          for (var i = 0;
                                                                              i < datas[index]['itemTypeList'].length;
                                                                              i++) {
                                                                            list.add(i);
                                                                          }
                                                                          angleSelectCarSer['$index'] =
                                                                              list;
                                                                          print(
                                                                              'angleSelectCarSer--->$angleSelectCarSer');
                                                                          /* 添加全部 选中服务  ⬆️*/
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Icon(
                                                                          _isOk(index) == 1
                                                                              ? Icons.check_circle
                                                                              : Icons.lens,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            AtworkFirstModel.fromJson(datas[index]).vehicleLicence.toString(),
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 15),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  Expanded(
                                                                      child:
                                                                          SizedBox()),
                                                                  //收回展开
                                                                  InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          print(widget
                                                                              ._showList
                                                                              .length);
                                                                          if (widget._showList.length ==
                                                                              0) {
                                                                            widget._showList.add(index);
                                                                            print(widget._showList);
                                                                          } else {
                                                                            _comparayBool(index) == 1
                                                                                ? widget._showList.remove(index)
                                                                                : widget._showList.add(index);
                                                                          }
                                                                        });
                                                                      },
                                                                      child: Container(
                                                                          width: 50,
                                                                          height: 30,
                                                                          child: Row(
                                                                            children: [
                                                                              Expanded(child: SizedBox()),
                                                                              _comparayBool(index) == 1
                                                                                  ? Image.asset(
                                                                                      'Assets/atwork/atowrkdown.png',
                                                                                      width: 17,
                                                                                      height: 10,
                                                                                      color: Colors.white,
                                                                                    )
                                                                                  : Image.asset(
                                                                                      'Assets/atwork/atworkup.png',
                                                                                      width: 17,
                                                                                      height: 10,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                            ],
                                                                          ))),
                                                                  SizedBox(
                                                                    width: 22,
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      ),

                                                      //row list
                                                      _comparayBool(index) == 1
                                                          ? Container()
                                                          :
// 有多少个服务项目
                                                          ListView(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              children:
                                                                  List.generate(
                                                                datas[index][
                                                                        'itemTypeList']
                                                                    .length,
                                                                (indexs) =>
                                                                    Column(
                                                                  children: [
                                                                    Container(
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          Column(
                                                                        children: [
//服务项目
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          //判断二级服务项目 是否为空
                                                                          AtworkTwoModel.fromJson(datas[index]['itemTypeList'][indexs]).secondaryService.toString() == ''
                                                                              ? Container()
                                                                              : Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 32,
                                                                                    ),
                                                                                    Container(
                                                                                      width: 3,
                                                                                      height: 14,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(2),
                                                                                        color: Color.fromRGBO(39, 153, 93, 1),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        '服务项目',
                                                                                        style: TextStyle(color: Color.fromRGBO(38, 38, 38, 1), fontSize: 15, fontWeight: FontWeight.w500),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
//二级服务
                                                                          AtworkTwoModel.fromJson(datas[index]['itemTypeList'][indexs]).secondaryService.toString() == ''
                                                                              ? Container()
                                                                              : Column(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Column(
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            InkWell(
                                                                                              onTap: () {
                                                                                                /*
                                                                                          单选添加服务项目 
                                                                                        */
                                                                                                setState(() {
                                                                                                  if (_isAngleOk(index, indexs) == 1) {
                                                                                                    allBool = false;
                                                                                                    allIndexMap['$index'] = 101; //取消单独车牌号全选
                                                                                                    List list = angleSelectCarSer['$index'];
                                                                                                    list.remove(indexs);
                                                                                                    print('===>1$list$indexs');
                                                                                                    angleSelectCarSer.remove('$index');
                                                                                                    angleSelectCarSer['$index'] = list;
                                                                                                    selectCarAll.remove(index);
                                                                                                  } else {
                                                                                                    print('===>2:$indexs');
                                                                                                    if (angleSelectCarSer.containsKey('$index')) {
                                                                                                      List list = angleSelectCarSer['$index'];
                                                                                                      list.add(indexs);
                                                                                                      angleSelectCarSer['$index'] = list;
                                                                                                    } else {
                                                                                                      angleSelectCarSer['$index'] = [indexs];
                                                                                                    }
// =========>         <==========//
                                                                                                    if (angleSelectCarSer['$index'].length == datas[index]['itemTypeList'].length) {
                                                                                                      allIndexMap['$index'] = 100; //单独车牌号全选
                                                                                                      selectCarAll.add(index);
                                                                                                      print('全选了$selectCarAll;');
                                                                                                      if (selectCarAll.length == datas.length) {
                                                                                                        allBool = true;
                                                                                                      }
                                                                                                    }
                                                                                                  }
                                                                                                });
                                                                                              },
                                                                                              child: Icon(
                                                                                                _isPJOk(index, indexs) == 0 ? Icons.check_circle_outline : Icons.panorama_fish_eye,
                                                                                                color: Color.fromRGBO(112, 112, 112, 1),
                                                                                                size: 20,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            Align(
                                                                                              alignment: Alignment.centerLeft,
                                                                                              child: Text(
                                                                                                AtworkTwoModel.fromJson(datas[index]['itemTypeList'][indexs]).secondaryService.toString(),
                                                                                                style: TextStyle(
                                                                                                  color: Color.fromRGBO(38, 38, 38, 1),
                                                                                                  fontSize: 13,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(child: SizedBox()),
                                                                                            Align(
                                                                                              alignment: Alignment.centerRight,
                                                                                              child: Text(
                                                                                                'x${AtworkTwoModel.fromJson(datas[index]['itemTypeList'][indexs]).nums.toString()}',
                                                                                                style: TextStyle(
                                                                                                  color: Color.fromRGBO(38, 38, 30, 1),
                                                                                                  fontSize: 13,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 45,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          width: 39,
                                                                                        ),
                                                                                        Container(
                                                                                          width: MediaQuery.of(context).size.width - 30 - 39,
                                                                                          height: 1,
                                                                                          color: Color.fromRGBO(234, 234, 234, 1),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 15,
                                                                                    ),
                                                                                  ],
                                                                                ),

//配件
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          //判断是否 有配件
                                                                          isNull(datas[index]['itemTypeList'][indexs]['materialList']) == 0
                                                                              ? Container()
                                                                              : Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 32,
                                                                                    ),
                                                                                    Container(
                                                                                      width: 3,
                                                                                      height: 14,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(2),
                                                                                        color: Color.fromRGBO(39, 153, 93, 1),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        '配件',
                                                                                        style: TextStyle(color: Color.fromRGBO(38, 38, 38, 1), fontSize: 15, fontWeight: FontWeight.w500),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
//服务 配件 选择   用于派工
                                                                          ListView(
                                                                            shrinkWrap:
                                                                                true,
                                                                            physics:
                                                                                NeverScrollableScrollPhysics(),
                                                                            children:
                                                                                List.generate(
                                                                              isNull(datas[index]['itemTypeList'][indexs]['materialList']) == 0 ? 0 : datas[index]['itemTypeList'][indexs]['materialList'].length,
                                                                              (indexes) => Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Column(
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: 30,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 5,
                                                                                          ),
                                                                                          Align(
                                                                                            alignment: Alignment.centerLeft,
                                                                                            child: Text(
                                                                                              AtworkThreeModel.fromJson(datas[index]['itemTypeList'][indexs]['materialList'][indexes]).goodsName.toString(),
                                                                                              style: TextStyle(
                                                                                                color: Color.fromRGBO(38, 38, 38, 1),
                                                                                                fontSize: 13,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(child: SizedBox()),
                                                                                          Align(
                                                                                            alignment: Alignment.centerRight,
                                                                                            child: Text(
                                                                                              'x${AtworkThreeModel.fromJson(datas[index]['itemTypeList'][indexs]['materialList'][indexes]).itemNumber.toString()}',
                                                                                              style: TextStyle(
                                                                                                color: Color.fromRGBO(38, 38, 30, 1),
                                                                                                fontSize: 13,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 45,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 39,
                                                                                      ),
                                                                                      Container(
                                                                                        width: MediaQuery.of(context).size.width - 30 - 39,
                                                                                        height: 1,
                                                                                        color: Color.fromRGBO(234, 234, 234, 1),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 15,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
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
                                          ],
                                        )),
                              ),
                            )),
                      ),
                      //底部施工人员选择
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.height -
                                84 -
                                MediaQueryData.fromWindow(window).padding.top -
                                54,
                            0,
                            0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 84,
                          color: Colors.white,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 23,
                                  ),
                                  deleltBool
                                      ? Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  allBool
                                                      ? allBool = false
                                                      : allBool = true;
                                                  if (allBool) {
                                                    //全选时 全部添加
                                                    for (var i = 0;
                                                        i < datas.length;
                                                        i++) {
                                                      List list = List();
                                                      //为每个车牌号添加 服务
                                                      for (var j = 0;
                                                          j <
                                                              datas[i][
                                                                      'itemTypeList']
                                                                  .length;
                                                          j++) {
                                                        list.add(j);
                                                      }
                                                      selectCarAll.add(i);
                                                      angleSelectCarSer['$i'] =
                                                          list;
                                                    }
                                                  } else {
                                                    selectCarAll.clear();
                                                    angleSelectCarSer.clear();
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                allBool
                                                    ? Icons.check_circle_outline
                                                    : Icons.panorama_fish_eye,
                                                color: Color.fromRGBO(
                                                    112, 112, 112, 1),
                                                size: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '全选',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        )
                                      : InkWell(
                                          onTap: () {
                                            // _showAtWork();
                                            // showDialog(
                                            //   context: Router.navigatorState
                                            //       .currentState.context,
                                            //   barrierDismissible: true,
                                            //   builder: (BuildContext context) {
                                            //     return AtWorkAlart(
                                            //       atList: peopleList,
                                            //       onChanges: (name, id) {
                                            //         setState(() {
                                            //           names = name;
                                            //           userId = id;
                                            //           print('员工名$name,员工id$id');
                                            //         });
                                            //       },
                                            //     );
                                            //   },
                                            // );
                                            if (PermissionApi.whetherContain(
                                                'dispatch_view')) {
                                            } else {
                                              showModalBottomSheet(
                                                isDismissible: true,
                                                enableDrag: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return new Container(
                                                    height: 300.0,
                                                    child: ShowBottomSheet(
                                                      type: 3,
                                                      dataList: peopleList,
                                                      onChanges: (name, id) {
                                                        setState(() {
                                                          names = name;
                                                          userId = id;
                                                          print(
                                                              '员工名$name,员工id$id');
                                                        });
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                23 -
                                                31 -
                                                10 -
                                                92,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color.fromRGBO(
                                                  238, 238, 238, 1),
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                names == ''
                                                    ? '  请选择施工人员'
                                                    : '  $names',
                                                style: TextStyle(
                                                    color: names == ''
                                                        ? Color.fromRGBO(
                                                            136, 141, 138, 1)
                                                        : Color.fromRGBO(
                                                            41, 39, 39, 1),
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ),
                                  deleltBool
                                      ? Expanded(child: SizedBox())
                                      : SizedBox(
                                          width: 10,
                                        ),
                                  deleltBool
                                      ? InkWell(
                                          onTap: () {
                                            print('删除');
                                            setState(() {
                                              _makeUpData();
                                              if (upDatas.length == 0) {
                                                Alart.showAlartDialog(
                                                    '未选择服务项目', 1);
                                              } else {
                                                _delDat();
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: 92,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color.fromRGBO(
                                                  255, 77, 76, 1),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '确认删除',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            //权限处理 详细参考 后台Excel

                                            if (PermissionApi.whetherContain(
                                                'dispatch_view')) {
                                            } else {
                                              //upData 封装
                                              _makeUpData();
                                              if (upDatas.length == 0) {
                                                Alart.showAlartDialog(
                                                    '未选择服务项目', 1);
                                              } else if (names == '') {
                                                Alart.showAlartDialog(
                                                    '未选择派工人员', 1);
                                              } else {
                                                /* 派工 post*/
                                                _postDat();
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: 92,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color.fromRGBO(
                                                  39, 153, 93, 1),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '派工',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ),
                                  deleltBool
                                      ? SizedBox(
                                          width: 30,
                                        )
                                      : SizedBox(
                                          width: 30,
                                        ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )));
  }
}
