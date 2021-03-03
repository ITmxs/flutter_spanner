import 'package:flutter/material.dart';
import 'package:spanners/cModel/recCarModel.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/notificationCenter.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/newOrder/newOrder.dart';
import 'package:spanners/spannerHome/receiveCar/reciveCarDio.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_details_page.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_nonmember_page.dart';

class ReceiveCar extends StatefulWidget {
  @override
  _ReceiveCarState createState() => _ReceiveCarState();
}

class _ReceiveCarState extends State<ReceiveCar> {
  bool indexBool = true;
  String flags = '0';

  List dataList = List();
//获取数据
  _getData() {
    dataList.clear();
    ReciveDio.secondaryListRequest(
      flag: flags,
      onSuccess: (data) {
        setState(() {
          if (data['type'] == 'other') {
            indexBool = false;
            dataList = data['otherList'];
          }
          if (data['type'] == 'wash') {
            indexBool = true;
            dataList = data['washCarList'];
          }
        });
      },
    );
  }

//删除操作
  _delete(String value) {
    ReciveDio.deleteListRequest(
      workOrderId: value,
      onSuccess: (data) {
        _getData();
      },
    );
  }

/*
下拉刷新
*/
  Future _toRefresh() async {
    _getData();
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
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
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
                '接车看板',
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
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewOrder()));
                  },
                  child: Image.asset(
                    'Assets/Home/appointadd.png',
                    width: 26,
                    height: 26,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            body: RefreshIndicator(
                child:
                    // isNull(dataList) == 0
                    //     ? Padding(
                    //         padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
                    //         child: ListView(
                    //           children: [
                    //             SizedBox(
                    //               height: 50,
                    //             ),
                    //             ShowNullDataAlart(
                    //               alartText: '亲，当前数据为空呦~',
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     :
                    ScrollConfiguration(
                  behavior: NeverScrollBehavior(),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexBool = true;
                                flags = '0';
                                _getData();
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '洗车',
                                      style: indexBool
                                          ? TextStyle(
                                              color:
                                                  Color.fromRGBO(35, 33, 33, 1),
                                              fontSize: 19,
                                              fontWeight: FontWeight.w500)
                                          : TextStyle(
                                              color:
                                                  Color.fromRGBO(35, 33, 33, 1),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  indexBool
                                      ? Container(
                                          width: 60,
                                          height: 3,
                                          color: Color.fromRGBO(39, 153, 93, 1),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexBool = false;
                                flags = '1';
                                _getData();
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '其他',
                                      style: indexBool
                                          ? TextStyle(
                                              color:
                                                  Color.fromRGBO(35, 33, 33, 1),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300)
                                          : TextStyle(
                                              color:
                                                  Color.fromRGBO(35, 33, 33, 1),
                                              fontSize: 19,
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  indexBool
                                      ? Container()
                                      : Container(
                                          width: 60,
                                          height: 3,
                                          color: Color.fromRGBO(39, 153, 93, 1),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      //主 list
                      isNull(dataList) == 0
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                              child: ShowNullDataAlart(
                                alartText: '亲，当前数据为空呦~',
                              ),
                            )
                          : ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
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
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.white),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    // 客户确认  状态 车辆展示
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    SizedBox()),
                                                            Text(
                                                              RecCarListModel.fromJson(dataList
                                                                      //['receiveCarServiceList'][0]
                                                                      [index]).status == '2'
                                                                  ? '客户确认中'
                                                                  : '',
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        255,
                                                                        77,
                                                                        76,
                                                                        1),
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 22,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 22,
                                                            ),
                                                            Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  RecCarListModel
                                                                          .fromJson(
                                                                              dataList[index])
                                                                      .vehicleLicence,
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              48,
                                                                              48,
                                                                              50,
                                                                              1),
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                )),
                                                            Expanded(
                                                                child:
                                                                    SizedBox()),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                RecCarListModel.fromJson(
                                                                        dataList[
                                                                            index])
                                                                    .createDate,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          38,
                                                                          38,
                                                                          30,
                                                                          1),
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              30,
                                                          height: 1,
                                                          color: Color.fromRGBO(
                                                              238, 238, 238, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    //车辆下 服务 个数 展示
                                                    ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      children: List.generate(
                                                          dataList[index][
                                                                      'receiveCarServiceList'] ==
                                                                  null
                                                              ? 0
                                                              : dataList[index][
                                                                      'receiveCarServiceList']
                                                                  .length,
                                                          (serIndex) =>
                                                              Container(
                                                                child:
                                                                    //row list
                                                                    ListView(
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  children: List.generate(
                                                                      RecCarSerModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]).serviceName == 'null'
                                                                          ? dataList[index]['receiveCarServiceList'][serIndex]['receiveCarMaterialList'].length
                                                                          : isNull(dataList[index]['receiveCarServiceList'][serIndex]['receiveCarMaterialList']) == 0
                                                                              ? 1
                                                                              : 1 + dataList[index]['receiveCarServiceList'][serIndex]['receiveCarMaterialList'].length,
                                                                      (indexs) => Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 22,
                                                                                      ),
                                                                                      RecCarSerModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]).serviceName == 'null'
                                                                                          ? Container()
                                                                                          : indexs == 0
                                                                                              ? Container(
                                                                                                  width: 3,
                                                                                                  height: 14,
                                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(1), color: Color.fromRGBO(39, 153, 93, 1)),
                                                                                                )
                                                                                              : Container(),
                                                                                      SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                      Container(
                                                                                        width: 130,
                                                                                        child: Align(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          child: Text(
                                                                                            //  配件展示
                                                                                            RecCarSerModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]).serviceName == 'null'
                                                                                                ? RecCarMaterilModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]['receiveCarMaterialList'][indexs]).itemName
                                                                                                : indexs == 0
                                                                                                    ? RecCarSerModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]).serviceName
                                                                                                    : RecCarMaterilModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]['receiveCarMaterialList'][indexs - 1]).itemName,
                                                                                            style: TextStyle(
                                                                                              color: Color.fromRGBO(38, 38, 38, 1),
                                                                                              fontSize: RecCarSerModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]).serviceName == 'null'
                                                                                                  ? 14
                                                                                                  : indexs == 0
                                                                                                      ? 16
                                                                                                      : 14,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(child: SizedBox()),
                                                                                      Align(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: Text(
                                                                                          RecCarSerModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]).serviceName == 'null'
                                                                                              ? RecCarMaterilModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]['receiveCarMaterialList'][indexs]).itemNum + '* ' + '¥' + RecCarMaterilModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]['receiveCarMaterialList'][indexs]).itemPrice
                                                                                              : indexs == 0
                                                                                                  ? RecCarSerModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]).nums + '* ' + '¥' + RecCarSerModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]).price
                                                                                                  : RecCarMaterilModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]['receiveCarMaterialList'][indexs - 1]).itemNum + '* ' + '¥' + RecCarMaterilModel.fromJson(dataList[index]['receiveCarServiceList'][serIndex]['receiveCarMaterialList'][indexs - 1]).itemPrice,
                                                                                          style: TextStyle(
                                                                                            color: Color.fromRGBO(38, 38, 30, 1),
                                                                                            fontSize: 15,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 20,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Container(
                                                                                    width: MediaQuery.of(context).size.width - 30,
                                                                                    height: 1,
                                                                                    color: Color.fromRGBO(238, 238, 238, 1),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                            ],
                                                                          )),
                                                                ),
                                                              )),
                                                    ),

                                                    SizedBox(
                                                      height: 36,
                                                    ),
                                                    //按钮操作
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2 -
                                                              30 / 2 -
                                                              200 / 2,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context: Routers
                                                                    .navigatorState
                                                                    .currentState
                                                                    .context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                      content: Container(
                                                                          width: 100,
                                                                          height: 90,
                                                                          child: Column(
                                                                            children: [
                                                                              Text(
                                                                                '确定删除当前接车单？',
                                                                                style: TextStyle(color: Colors.black, fontSize: 15),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                              Container(
                                                                                height: 1,
                                                                                color: Color.fromRGBO(41, 39, 39, 1),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                      child: InkWell(
                                                                                          onTap: () {
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          child: Align(
                                                                                            alignment: Alignment.center,
                                                                                            child: Text(
                                                                                              '取消',
                                                                                              style: TextStyle(color: Color.fromRGBO(41, 39, 39, 1), fontSize: 14),
                                                                                            ),
                                                                                          ))),
                                                                                  Container(
                                                                                    width: 1,
                                                                                    height: 20,
                                                                                    color: Color.fromRGBO(41, 39, 39, 1),
                                                                                  ),
                                                                                  Expanded(
                                                                                      child: InkWell(
                                                                                          onTap: () {
                                                                                            Navigator.pop(context);
                                                                                            _delete(dataList[index]['workOrderId']);
                                                                                          },
                                                                                          child: Align(
                                                                                            alignment: Alignment.center,
                                                                                            child: Text(
                                                                                              '确定',
                                                                                              style: TextStyle(color: Color.fromRGBO(41, 39, 39, 1), fontSize: 14),
                                                                                            ),
                                                                                          )))
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          )));
                                                                });
                                                          },
                                                          child: Container(
                                                            width: 50,
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        255,
                                                                        77,
                                                                        76,
                                                                        1)),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                '删除',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 25,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            //  dataList[index]['memberId'] == null?
                                                            //  Navigator.push(context,MaterialPageRoute(
                                                            //   builder: (context) => SettlementNonmemberPage(
                                                            //   dataList[index]['workOrderId'].toString(),
                                                            //   dataList[index]['vehicleLicence'].toString(),
                                                            //    true)),
                                                            //   )

                                                            //  :

                                                            // Navigator.push(
                                                            //   context,
                                                            //   MaterialPageRoute(
                                                            //       builder: (context) => SettlementDetailsPage(
                                                            //           dataList[
                                                            //                   index]
                                                            //               [
                                                            //               'workOrderId'],
                                                            //           RecCarListModel.fromJson(
                                                            //                   dataList[index])
                                                            //               .vehicleLicence,
                                                            //           true)),
                                                            // );
                                                            //权限处理 详细参考 后台Excel
                                                            PermissionApi
                                                                    .whetherContain(
                                                                        'receive_car_opt_check')
                                                                ? print('')
                                                                : dataList[index]
                                                                            [
                                                                            'memberId'] ==
                                                                        null
                                                                    ? Navigator
                                                                        .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => SettlementNonmemberPage(
                                                                                dataList[index]['workOrderId'].toString(),
                                                                                dataList[index]['vehicleLicence'].toString(),
                                                                                false)),
                                                                      ).then(
                                                                        (value) =>
                                                                            _getData())
                                                                    : Navigator
                                                                        .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => SettlementDetailsPage(
                                                                                dataList[index]['workOrderId'],
                                                                                RecCarListModel.fromJson(dataList[index]).vehicleLicence,
                                                                                false)),
                                                                      ).then(
                                                                        (value) =>
                                                                            _getData());
                                                          },
                                                          child: Container(
                                                            width: 50,
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        39,
                                                                        153,
                                                                        93,
                                                                        1)),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                '结算',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 25,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            NewOrder(
                                                                              workOrderId: dataList[index]['workOrderId'],
                                                                            )));
                                                          },
                                                          child: Container(
                                                            width: 50,
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        39,
                                                                        153,
                                                                        93,
                                                                        1)),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                '接车',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 50,
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
                    ],
                  ),
                ),
                onRefresh: _toRefresh)));
  }
}
