import 'package:flutter/material.dart';
import 'package:spanners/cModel/workingModel.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/notificationCenter.dart';
import 'package:spanners/cTools/sharedPreferences.dart';

import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/newOrder/newOrder.dart';
import './workingRequstApi.dart';

class WorkingView extends StatefulWidget {
  final List<int> _showList = List();
  @override
  _WorkingViewState createState() => _WorkingViewState();
}

class _WorkingViewState extends State<WorkingView> {
  List dataList = List();
  List titles = ['施工人员', '施工状态', '服务项目', '项目配件', '派工时间', '开始时间'];
  String serch = '';

  List materilList = List();
  double number;
  Map upMap = Map();
  List mList = List();
  Map showMap = Map(); // 修改

  // ignore: missing_return
  int _comparayBool(int index) {
    for (var i = 0; i < widget._showList.length; i++) {
      if (widget._showList[i] == index) {
        print('=====================');
        return 1;
      }
    }
  }

//获取施工看板一览数据
  _getWorkingData() {
    WorkingDio.workingListRequest(
      onSuccess: (data) {
        setState(() {
          dataList = data;
        });
      },
    );
  }

  //获取施工看板搜索数据
  _serchWorkingData(String value) {
    WorkingDio.workingSerchRequest(
      param: {'searchKey': value},
      onSuccess: (data) {
        setState(() {
          dataList = data;
          print('>>>>$dataList');
        });
      },
    );
  }

  //获取施工看板修改
  _editWorkingData(Map value) {
    WorkingDio.workingEditRequest(
      param: value,
      onSuccess: (data) {
        setState(() {
          if (data) {
            _getWorkingData();
          }
        });
      },
    );
  }

  //获取施工看板状态
  _stutsWorkingData(Map value) {
    WorkingDio.workingStutsRequest(
      param: value,
      onSuccess: (data) {
        setState(() {
          if (data) {
            if (upMap['flag']) {
              _getWorkingData();
            }
            if (!upMap['flag']) {
              _getWorkingData();
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => DeliveryCheckPage()));
            }
          }
        });
      },
    );
  }

/*
下拉刷新
*/
  Future _toRefresh() async {
    _getWorkingData();
    return null;
  }

//判断是否存在项目配件或者服务项目
  List _isReturn(Map map) {
    if (WorkingModel.fromJson(map).serviceName == '其他') {
      titles.remove('服务项目');
      return titles;
    } else {
      if (map['receiveCarMaterialList'].length == 0) {
        titles.remove('项目配件');
        return titles;
      } else {
        if (titles.contains('服务项目')) {
        } else {
          titles.insert(2, '服务项目');
        }
        if (titles.contains('项目配件')) {
        } else {
          titles.insert(3, '项目配件');
        }

        return titles;
      }
    }
  }

  //封装配件 规格
  _addMaterilList(List materil) {
    materilList.clear();
    for (var i = 0; i < materil.length; i++) {
      materilList.insert(i, WorkingMaterModel.fromJson(materil[i]).itemNumber);
    }
    print('配件 规格 list$materilList');
  }

  //状态展示
  String _returnStuts(String stuts) {
    switch (stuts) {
      case '2':
        return '施工';
        break;
      case '3':
        return '施工中';
        break;
      case '4':
        return '待交验';
        break;
      case '5':
        return '交验拒绝过';
        break;
      case '6':
        return '交验完成';
        break;
      default:
    }
  }

  static Future _showTokenEorrDialog(String warn) async {
    await showDialog(
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ShowWarnAlart(
          warn: warn,
        );
      },
    );
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
    // TODO: implement initState
    super.initState();
    _getWorkingData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          // 点击返回键的操作
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
            brightness: Brightness.light,
            elevation: 0,
            title: Text(
              '施工看板',
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
          body: isNull(dataList) == 0
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
                  child: RefreshIndicator(
                    child: ScrollConfiguration(
                      behavior: NeverScrollBehavior(),
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
                    ),
                    onRefresh: _toRefresh,
                  ))
              : Stack(
                  children: [
                    //搜索栏
                    Padding(
                        padding: EdgeInsets.fromLTRB(23, 10, 23, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 46,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: 33,
                                maxWidth:
                                    MediaQuery.of(context).size.width - 46),
                            child: TextFormField(
                              onFieldSubmitted: (value) {
                                _serchWorkingData(serch);
                              },
                              onChanged: (value) {
                                setState(() {
                                  //搜索 值
                                  serch = value;
                                });
                              },
                              maxLines: 1,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    //更���状态控制密码显示或隐藏
                                    setState(() {
                                      _serchWorkingData(serch);
                                    });
                                  },
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 20),
                                hintText: '搜索员工姓名/车牌号',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                                fillColor: Color.fromRGBO(255, 255, 255, 1),
                                filled: true,
                                border: new OutlineInputBorder(
                                    //添加边框
                                    gapPadding: 10.0,
                                    borderRadius: BorderRadius.circular(17.0),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        )),
                    //看板展示部分
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 57, 0, 0),
                      child: RefreshIndicator(
                        child: ListView(
                          shrinkWrap: true,
                          children: List.generate(
                              dataList.length,
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
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              children: [
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
                                                                  .circular(5),
                                                          color: Color.fromRGBO(
                                                              39, 153, 93, 1),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 7,
                                                            ),

                                                            ///头部视图
                                                            //收回展开
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  print(widget
                                                                      ._showList
                                                                      .length);
                                                                  if (widget
                                                                          ._showList
                                                                          .length ==
                                                                      0) {
                                                                    widget
                                                                        ._showList
                                                                        .add(
                                                                            index);
                                                                    print(widget
                                                                        ._showList);
                                                                  } else {
                                                                    _comparayBool(index) ==
                                                                            1
                                                                        ? widget
                                                                            ._showList
                                                                            .remove(
                                                                                index)
                                                                        : widget
                                                                            ._showList
                                                                            .add(index);
                                                                  }
                                                                });
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  _comparayBool(
                                                                              index) ==
                                                                          1
                                                                      ? Image
                                                                          .asset(
                                                                          'Assets/atwork/atowrkdown.png',
                                                                          width:
                                                                              17,
                                                                          height:
                                                                              10,
                                                                          color:
                                                                              Colors.white,
                                                                        )
                                                                      : Image
                                                                          .asset(
                                                                          'Assets/atwork/atworkup.png',
                                                                          width:
                                                                              17,
                                                                          height:
                                                                              10,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      dataList[
                                                                              index]
                                                                          [
                                                                          'vehicleLicence'],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            Expanded(
                                                                child:
                                                                    SizedBox()),
                                                            //跳转接车
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            NewOrder(
                                                                              type: 'NO',
                                                                              workOrderId: dataList[index]['workOrderId'],
                                                                            )));
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'Assets/working/add.png',
                                                                width: 24,
                                                                height: 18,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 12,
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),

                                                //row list
                                                _comparayBool(index) == 1
                                                    ? Container()
                                                    : ListView(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        children: List.generate(
                                                          dataList[index][
                                                                  'itemTypeList']
                                                              .length,
                                                          (indexs) => Column(
                                                            children: [
                                                              Container(
                                                                color: Colors
                                                                    .white,
                                                                child: Column(
                                                                  children: [
                                                                    ListView(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      children: List.generate(
                                                                          _isReturn(dataList[index]['itemTypeList'][indexs]).length,
                                                                          (indext) => Column(
                                                                                children: [
                                                                                  Column(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      Column(
                                                                                        children: [
                                                                                          //绿条 行
                                                                                          Row(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                width: 22,
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
                                                                                                  titles[indext],
                                                                                                  style: TextStyle(color: Color.fromRGBO(38, 38, 38, 1), fontSize: 15, fontWeight: FontWeight.w400),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(child: SizedBox()),
                                                                                              //显示值
                                                                                              Align(
                                                                                                alignment: Alignment.centerRight,
                                                                                                child: Text(
                                                                                                  titles[indext] == '施工人员'
                                                                                                      ? WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).executor
                                                                                                      : titles[indext] == '施工状态'
                                                                                                          ? _returnStuts(WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status)
                                                                                                          : titles[indext] == '服务项目'
                                                                                                              ? ''
                                                                                                              : titles[indext] == '项目配件'
                                                                                                                  ? ''
                                                                                                                  : titles[indext] == '派工时间'
                                                                                                                      ? WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).assignjobTime == 'null'
                                                                                                                          ? ''
                                                                                                                          : WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).assignjobTime
                                                                                                                      : titles[indext] == '开始时间'
                                                                                                                          ? WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).createDate == 'null'
                                                                                                                              ? '暂未开始'
                                                                                                                              : WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).createDate
                                                                                                                          : '', // '辽B12345',
                                                                                                  style: TextStyle(
                                                                                                    color: Color.fromRGBO(38, 38, 30, 1),
                                                                                                    fontSize: 13,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 20,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          //显示服务项目与配件 用于修改
                                                                                          titles[indext] == '服务项目' || titles[indext] == '项目配件'
                                                                                              ? SizedBox(
                                                                                                  height: 15,
                                                                                                )
                                                                                              : SizedBox(
                                                                                                  height: 0,
                                                                                                ),
                                                                                          titles[indext] == '服务项目' || titles[indext] == '项目配件'
                                                                                              ? ListView(
                                                                                                  shrinkWrap: true,
                                                                                                  physics: NeverScrollableScrollPhysics(),
                                                                                                  children: List.generate(
                                                                                                      titles[indext] == '服务项目'
                                                                                                          ? 1
                                                                                                          : titles[indext] == '项目配件'
                                                                                                              ? dataList[index]['itemTypeList'][indexs]['receiveCarMaterialList'] == null
                                                                                                                  ? 0
                                                                                                                  : dataList[index]['itemTypeList'][indexs]['receiveCarMaterialList'].length
                                                                                                              : 0,
                                                                                                      (indexh) => Column(
                                                                                                            children: [
                                                                                                              Row(
                                                                                                                children: [
                                                                                                                  SizedBox(
                                                                                                                    width: 30,
                                                                                                                  ),
                                                                                                                  Align(
                                                                                                                    alignment: Alignment.centerLeft,
                                                                                                                    child: Text(
                                                                                                                      titles[indext] == '服务项目'
                                                                                                                          ? WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).serviceName
                                                                                                                          : titles[indext] == '项目配件'
                                                                                                                              ? WorkingMaterModel.fromJson(dataList[index]['itemTypeList'][indexs]['receiveCarMaterialList'][indexh]).itemMaterial
                                                                                                                              : '',
                                                                                                                      style: TextStyle(color: Color.fromRGBO(41, 39, 39, 1), fontSize: 13),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  Expanded(child: SizedBox()),
                                                                                                                  //这里做修改 更换UI操作
                                                                                                                  showMap.containsKey(index.toString())
                                                                                                                      ? showMap[index.toString()].contains(indexs)
                                                                                                                          ?
                                                                                                                          //修改界面
                                                                                                                          Container(
                                                                                                                              child: titles[indext] == '服务项目'
                                                                                                                                  ? Container(
                                                                                                                                      width: 90,
                                                                                                                                      height: 22,
                                                                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white, border: Border.all(width: 1, color: Color.fromRGBO(98, 98, 98, 1))),
                                                                                                                                      child: Row(
                                                                                                                                        children: [
                                                                                                                                          InkWell(
                                                                                                                                              onTap: () {
                                                                                                                                                setState(() {
                                                                                                                                                  number--;
                                                                                                                                                  if (number == 0) {
                                                                                                                                                    number = 0.0;
                                                                                                                                                    _showTokenEorrDialog('服务为零，修改后将删除服务及其配件');
                                                                                                                                                  }
                                                                                                                                                  //服务项目封装上传数据
                                                                                                                                                  upMap['serviceId'] = WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).id;
                                                                                                                                                  upMap['serviceNum'] = number.toString();
                                                                                                                                                });
                                                                                                                                              },
                                                                                                                                              child: Container(
                                                                                                                                                width: 20,
                                                                                                                                                child: Text(
                                                                                                                                                  '-',
                                                                                                                                                  textAlign: TextAlign.center,
                                                                                                                                                  style: TextStyle(color: Color.fromRGBO(41, 39, 39, 1), fontSize: 16),
                                                                                                                                                ),
                                                                                                                                              )),
                                                                                                                                          Container(
                                                                                                                                            width: 1,
                                                                                                                                            color: Color.fromRGBO(41, 39, 39, 1),
                                                                                                                                          ),
                                                                                                                                          Container(
                                                                                                                                            width: 40,
                                                                                                                                            child: Text(
                                                                                                                                              number.toString(),
                                                                                                                                              textAlign: TextAlign.center,
                                                                                                                                              style: TextStyle(color: Color.fromRGBO(41, 39, 39, 1), fontSize: 13),
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Container(
                                                                                                                                            width: 1,
                                                                                                                                            color: Color.fromRGBO(41, 39, 39, 1),
                                                                                                                                          ),
                                                                                                                                          InkWell(
                                                                                                                                              onTap: () {
                                                                                                                                                setState(() {
                                                                                                                                                  number++;
                                                                                                                                                  //服务项目封装上传数据
                                                                                                                                                  upMap['serviceId'] = WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).id;
                                                                                                                                                  upMap['serviceNum'] = number.toString();
                                                                                                                                                });
                                                                                                                                              },
                                                                                                                                              child: Container(
                                                                                                                                                width: 20,
                                                                                                                                                child: Text(
                                                                                                                                                  '+',
                                                                                                                                                  textAlign: TextAlign.center,
                                                                                                                                                  style: TextStyle(color: Color.fromRGBO(41, 39, 39, 1), fontSize: 15),
                                                                                                                                                ),
                                                                                                                                              )),
                                                                                                                                        ],
                                                                                                                                      ),
                                                                                                                                    )
                                                                                                                                  : Align(
                                                                                                                                      alignment: Alignment.center,
                                                                                                                                      child: ConstrainedBox(
                                                                                                                                          constraints: BoxConstraints(maxHeight: 20, maxWidth: 50),
                                                                                                                                          child: TextFormField(
                                                                                                                                            textAlign: TextAlign.center,
                                                                                                                                            /* 默认值逻辑*/
                                                                                                                                            controller: TextEditingController.fromValue(TextEditingValue(
                                                                                                                                                text: titles[indext] == '服务项目'
                                                                                                                                                    ? 'x' + WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).number
                                                                                                                                                    : titles[indext] == '项目配件'
                                                                                                                                                        ? materilList.length == 0
                                                                                                                                                            ? ''
                                                                                                                                                            : materilList[indexh]
                                                                                                                                                        : '')),
                                                                                                                                            style: TextStyle(fontSize: 13, color: Color.fromRGBO(41, 39, 39, 1)),
                                                                                                                                            onChanged: (value) {
                                                                                                                                              materilList.removeAt(indexh);
                                                                                                                                              materilList.insert(indexh, value);
                                                                                                                                              if (mList.length > 0) {
                                                                                                                                                for (var i = 0; i < mList.length; i++) {
                                                                                                                                                  if (mList[i]['materialId'] == WorkingMaterModel.fromJson(dataList[index]['itemTypeList'][indexs]['receiveCarMaterialList'][indexh]).id) {
                                                                                                                                                    //数组中存在 相同的配件
                                                                                                                                                    mList[i]['materialNum'] = value;
                                                                                                                                                    mList.removeAt(i);
                                                                                                                                                    break;
                                                                                                                                                  }
                                                                                                                                                }
                                                                                                                                              }
                                                                                                                                              // 封装上传的配件list
                                                                                                                                              Map map = Map();

                                                                                                                                              map['materialId'] = WorkingMaterModel.fromJson(dataList[index]['itemTypeList'][indexs]['receiveCarMaterialList'][indexh]).id;
                                                                                                                                              map['materialNum'] = value;
                                                                                                                                              mList.add(map);

                                                                                                                                              upMap['receiveCarMaterialList'] = mList;

                                                                                                                                              upMap['serviceId'] = WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).id;
                                                                                                                                            },
                                                                                                                                            keyboardType: TextInputType.number,
                                                                                                                                          ))),
                                                                                                                            )
                                                                                                                          : Align(
                                                                                                                              alignment: Alignment.centerLeft,
                                                                                                                              child: Text(
                                                                                                                                titles[indext] == '服务项目'
                                                                                                                                    ? 'x' + WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).number
                                                                                                                                    : titles[indext] == '项目配件'
                                                                                                                                        ? WorkingMaterModel.fromJson(dataList[index]['itemTypeList'][indexs]['receiveCarMaterialList'][indexh]).itemNumber
                                                                                                                                        : '',
                                                                                                                                style: TextStyle(color: Color.fromRGBO(41, 39, 39, 1), fontSize: 13),
                                                                                                                              ),
                                                                                                                            )
                                                                                                                      : Align(
                                                                                                                          alignment: Alignment.centerLeft,
                                                                                                                          child: Text(
                                                                                                                            titles[indext] == '服务项目'
                                                                                                                                ? 'x' + WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).number
                                                                                                                                : titles[indext] == '项目配件'
                                                                                                                                    ? WorkingMaterModel.fromJson(dataList[index]['itemTypeList'][indexs]['receiveCarMaterialList'][indexh]).itemNumber
                                                                                                                                    : '',
                                                                                                                            style: TextStyle(color: Color.fromRGBO(41, 39, 39, 1), fontSize: 13),
                                                                                                                          ),
                                                                                                                        ),

                                                                                                                  Text(
                                                                                                                    titles[indext] == '服务项目' ? '' : WorkingMaterModel.fromJson(dataList[index]['itemTypeList'][indexs]['receiveCarMaterialList'][indexh]).itemUnit,
                                                                                                                    style: TextStyle(color: Color.fromRGBO(41, 39, 39, 1), fontSize: 13),
                                                                                                                  ),

                                                                                                                  SizedBox(
                                                                                                                    width: 20,
                                                                                                                  )
                                                                                                                ],
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                height: 10,
                                                                                                              ),
                                                                                                            ],
                                                                                                          )),
                                                                                                )
                                                                                              : Container()
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                    ),
                                                                    WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status ==
                                                                            '5'
                                                                        ? Column(
                                                                            children: [
                                                                              Row(children: [
                                                                                SizedBox(
                                                                                  width: 22,
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
                                                                                    '返工原因',
                                                                                    style: TextStyle(color: Color.fromRGBO(38, 38, 38, 1), fontSize: 15, fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                              //娇艳拒绝过的有备注
                                                                              Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: 15,
                                                                                  ),
                                                                                  Container(
                                                                                    width: MediaQuery.of(context).size.width - 60,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                      border: new Border.all(width: 1, color: Color.fromRGBO(238, 238, 238, 1)),
                                                                                    ),
                                                                                    child: Text(
                                                                                      WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).remark == 'null'
                                                                                          ? '未填返工原因'
                                                                                          : WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).remark == ''
                                                                                              ? '未填返工原因'
                                                                                              : WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).remark,
                                                                                      // widget.dataList[title[9]] == null
                                                                                      //     ? '无备注'
                                                                                      //     : widget.dataList[title[9]].toString(),
                                                                                      style: TextStyle(color: Color.fromRGBO(30, 30, 30, 1), fontSize: 13),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 15,
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          )
                                                                        : Container(),
                                                                    SizedBox(
                                                                      height:
                                                                          50,
                                                                    ),
                                                                    //按钮操作
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              50,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              if (WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '6' || WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '4') {
                                                                              } else {
                                                                                showMap.containsKey(index.toString())
                                                                                    ? showMap[index.toString()].contains(indexs)
                                                                                        ? showMap[index.toString()].remove(indexs)
                                                                                        : showMap[index.toString()].add(indexs)
                                                                                    : showMap[index.toString()] = [indexs];

                                                                                _addMaterilList(dataList[index]['itemTypeList'][indexs]['receiveCarMaterialList']);

                                                                                if (showMap.containsKey(index.toString())) {
                                                                                  if (showMap[index.toString()].contains(indexs)) {
                                                                                    //上传数据初始化
                                                                                    //点击修改
                                                                                    upMap.clear();
                                                                                    mList.clear();
                                                                                    number = double.parse(WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).number);
                                                                                  } else {
                                                                                    //点击保存
                                                                                    if (upMap.containsKey('serviceId') || upMap.containsKey('materialList')) {
                                                                                      upMap['serviceNum'] = number.toString();
                                                                                      upMap['materialList'] = mList;
                                                                                      _editWorkingData(upMap);
                                                                                    }
                                                                                  }
                                                                                } else {
                                                                                  //点击保存
                                                                                  if (upMap.containsKey('serviceId') || upMap.containsKey('materialList')) {
                                                                                    upMap['serviceNum'] = number.toString();
                                                                                    upMap['materialList'] = mList;
                                                                                    _editWorkingData(upMap);
                                                                                  }
                                                                                }

                                                                                FocusScope.of(context).requestFocus(FocusNode());
                                                                              }
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                50,
                                                                            height:
                                                                                25,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(5), color: WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '6' || WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '4' ? Color.fromRGBO(139, 139, 139, 1) : Color.fromRGBO(39, 153, 93, 1)),
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Text(
                                                                                showMap.containsKey(index.toString())
                                                                                    ? showMap[index.toString()].contains(indexs)
                                                                                        ? '保存'
                                                                                        : '修改'
                                                                                    : '修改',
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: MediaQuery.of(context).size.width / 2 -
                                                                              100 / 2 -
                                                                              150 / 2 -
                                                                              30 / 2,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '3' ||
                                                                                WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '4' ||
                                                                                WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '6') {
                                                                            } else {
                                                                              upMap.clear();
                                                                              upMap['flag'] = true;
                                                                              upMap['serviceId'] = WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).id;

                                                                              _stutsWorkingData(upMap);
                                                                              FocusScope.of(context).requestFocus(FocusNode());
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                50,
                                                                            height:
                                                                                25,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(5), color: WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '3' || WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '4' || WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '6' ? Color.fromRGBO(139, 139, 139, 1) : Color.fromRGBO(39, 153, 93, 1)),
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Text(
                                                                                '开始',
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: MediaQuery.of(context).size.width / 2 -
                                                                              100 / 2 -
                                                                              150 / 2 -
                                                                              30 / 2,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            //stuts == 3 施工中 可以点击
                                                                            if (WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status ==
                                                                                '3') {
                                                                              upMap.clear();
                                                                              upMap['flag'] = false;
                                                                              upMap['serviceId'] = WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).id;

                                                                              _stutsWorkingData(upMap);
                                                                              FocusScope.of(context).requestFocus(FocusNode());
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                50,
                                                                            height:
                                                                                25,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(5), color: WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '2' || WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '6' || WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '5' || WorkingModel.fromJson(dataList[index]['itemTypeList'][indexs]).status == '4' ? Color.fromRGBO(139, 139, 139, 1) : Color.fromRGBO(39, 153, 93, 1)),
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Text(
                                                                                '完成',
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              50,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          25,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
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
                        onRefresh: _toRefresh,
                      ),
                    ),
                  ],
                ),
        ));
  }
}
