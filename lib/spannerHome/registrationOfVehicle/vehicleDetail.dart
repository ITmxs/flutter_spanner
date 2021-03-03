import 'package:flutter/material.dart';
import 'package:spanners/cTools/callIphone.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/publicView/pub_Maintenance.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/members/view/addCar.dart';
import 'package:spanners/spannerHome/members/view/memberDetail.dart';

import 'package:spanners/spannerHome/newOrder/carCheckAll.dart';
import 'package:spanners/spannerHome/registrationOfVehicle/apiRequst.dart';

class VehicleDetail extends StatefulWidget {
  final vehicleId;
  final vehicleLicence;
  final isVip;

  const VehicleDetail(
      {Key key, this.vehicleId, this.vehicleLicence, this.isVip})
      : super(key: key);
  @override
  _VehicleDetailState createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  List companyOtherList = [
    '被授权人',
    '被授权人账号',
  ];
  List alartList = [
    '商业险到期日',
    '交强险到期日',
    '下次检车日期',
    '驾驶证到期日',
  ];
  List companyList = List();
  Map vehicle = Map();
  List serviceList = List(); //服务历史
  List campaign = List(); //卡劵
  //时间返回截取到年月日
  String _returnDatetime(timeVule) {
    return timeVule == null ? '' : timeVule.substring(0, timeVule.length - 8);
  }

  //List serviceList = List();//智能提醒
  //获取车辆详情
  _getDetail() {
    ApiDio.vehicleDetailListRequest(
      param: {
        'vehicleLicence': widget.vehicleLicence,
        'vehicleId': widget.vehicleId
      },
      onSuccess: (data) {
        setState(() {
          print(data);
          serviceList = data['serviceList'];
          campaign = data['campaign'];
          vehicle = data['vehicle'];
          vehicle['type'].toString() == '0'
              ? companyList = [
                  '车牌号',
                  '车辆品牌',
                  '车辆型号',
                  '车主姓名',
                  '手机号',
                  'VIN码',
                  '车辆颜色',
                  '发动机型号',
                ]
              : companyList = [
                  '车牌号',
                  '车辆品牌',
                  '车辆型号',
                  '企业名称',
                  '手机号',
                  '管理员姓名',
                  'VIN码',
                  '车辆颜色',
                  '发动机型号',
                ];
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDetail();
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
            '车辆管理',
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
              SizedBox(
                height: 18,
              ),
//修改 按钮
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 3,
                    height: 14,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(39, 153, 93, 1)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '车辆信息',
                    style: TextStyle(
                        color: Color.fromRGBO(27, 30, 29, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCar(
                                    title: '修改车辆',
                                    vehicleId: vehicle['vehicleId'],
                                  ))).then((value) => _getDetail());
                    },
                    child: Text(
                      '修改',
                      style: TextStyle(
                          color: Color.fromRGBO(39, 153, 93, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
//company  person
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
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: companyList.length,
                        itemBuilder: (BuildContext context, int item) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    companyList[item],
                                    style: TextStyle(
                                        color: Color.fromRGBO(30, 30, 30, 1),
                                        fontSize: 15),
                                  ),
                                  Expanded(child: SizedBox()),
                                  companyList[item] == '手机号'
                                      ? InkWell(
                                          onTap: () {
                                            CallIphone.callPhone(
                                                vehicle['mobile'] ??
                                                    ''.toString());
                                          },
                                          child: Text(
                                            vehicle['mobile'] ?? ''.toString(),
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    39, 153, 93, 1),
                                                fontSize: 15),
                                          ),
                                        )
                                      : companyList[item] == '车主姓名'
                                          ? InkWell(
                                              onTap: () {
                                                vehicle["isMember"] == '0'
                                                    ? print('')
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MemberDetail(
                                                                  userId: vehicle[
                                                                      "memberid"],
                                                                ))).then(
                                                        (value) =>
                                                            _getDetail());
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    vehicle['vehicleOwners'] ??
                                                        ''.toString(),
                                                    style: TextStyle(
                                                        color: vehicle[
                                                                    "isMember"] ==
                                                                '0'
                                                            ? Colors.black
                                                            : Color.fromRGBO(
                                                                39, 153, 93, 1),
                                                        fontSize: 15),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Visibility(
                                                    child: Image.asset(
                                                      "Assets/members/vip.png",
                                                      width: 24,
                                                      height: 19,
                                                    ),
                                                    visible:
                                                        ((vehicle["accountBalances"] ??
                                                                    0) >
                                                                0) ||
                                                            vehicle["trhId"] !=
                                                                null,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : companyList[item] == '企业名称'
                                              ? InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MemberDetail(
                                                                  userId: vehicle[
                                                                      "memberid"],
                                                                ))).then(
                                                        (value) =>
                                                            _getDetail());
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        vehicle['company'] ??
                                                            ''.toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    39,
                                                                    153,
                                                                    93,
                                                                    1),
                                                            fontSize: 15),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Visibility(
                                                        child: Image.asset(
                                                          "Assets/members/vip.png",
                                                          width: 24,
                                                          height: 19,
                                                        ),
                                                        visible: widget.isVip,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : companyList[item] == '车牌号'
                                                  ? Text(
                                                      vehicle['vehicleLicence'] ??
                                                          ''.toString(),
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              30, 30, 30, 1),
                                                          fontSize: 15),
                                                    )
                                                  : companyList[item] == '车辆品牌'
                                                      ? Text(
                                                          vehicle['brand'] ??
                                                              ''.toString(),
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      30,
                                                                      30,
                                                                      30,
                                                                      1),
                                                              fontSize: 15),
                                                        )
                                                      : companyList[item] ==
                                                              '车辆型号'
                                                          ? Text(
                                                              vehicle['model'] ??
                                                                  ''.toString(),
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          30,
                                                                          30,
                                                                          30,
                                                                          1),
                                                                  fontSize: 15),
                                                            )
                                                          : companyList[item] ==
                                                                  '管理员姓名'
                                                              ? Text(
                                                                  vehicle['vehicleOwners'] ??
                                                                      ''.toString(),
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              30,
                                                                              30,
                                                                              30,
                                                                              1),
                                                                      fontSize:
                                                                          15),
                                                                )
                                                              : companyList[
                                                                          item] ==
                                                                      'VIN码'
                                                                  ? Text(
                                                                      vehicle['carVin'] ??
                                                                          ''.toString(),
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              30,
                                                                              30,
                                                                              30,
                                                                              1),
                                                                          fontSize:
                                                                              15),
                                                                    )
                                                                  : companyList[
                                                                              item] ==
                                                                          '车辆颜色'
                                                                      ? Text(
                                                                          vehicle['carColor'] ??
                                                                              ''.toString(),
                                                                          style: TextStyle(
                                                                              color: Color.fromRGBO(30, 30, 30, 1),
                                                                              fontSize: 15),
                                                                        )
                                                                      : companyList[item] ==
                                                                              '发动机型号'
                                                                          ? Text(
                                                                              vehicle['carEngine'] ?? ''.toString(),
                                                                              style: TextStyle(color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                                                                            )
                                                                          : Container(),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              companyList.length - 1 == item
                                  ? Container()
                                  : Container(
                                      height: 1,
                                      color: Color.fromRGBO(229, 229, 229, 1)),
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
//授权人 只有企业有
              vehicle['type'].toString() == '0'
                  ? Container()
                  : Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: companyOtherList.length,
                              itemBuilder: (BuildContext context, int item) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          companyOtherList[item],
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(30, 30, 30, 1),
                                              fontSize: 15),
                                        ),
                                        Expanded(child: SizedBox()),
                                        companyOtherList[item] == '被授权人'
                                            ? Text(
                                                vehicle['assignUser'] ??
                                                    ''.toString(),
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        30, 30, 30, 1),
                                                    fontSize: 15),
                                              )
                                            : companyOtherList[item] == '被授权人账号'
                                                ? Text(
                                                    vehicle['assignMobile'] ??
                                                        ''.toString(),
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            30, 30, 30, 1),
                                                        fontSize: 15),
                                                  )
                                                : Container(),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    companyList.length - 1 == item
                                        ? Container()
                                        : Container(
                                            height: 1,
                                            color: Color.fromRGBO(
                                                229, 229, 229, 1)),
                                  ],
                                );
                              }),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),

              SizedBox(
                height: 15,
              ),
//保养手册 全车检查 配置详情
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 14,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 28,
                    height: 84,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Maintenance(
                                          showSure: '0',
                                          vehicleLicence:
                                              vehicle['vehicleLicence'],
                                        )));
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 9,
                                ),
                                Image.asset(
                                  'Assets/Home/books.png',
                                  fit: BoxFit.fill,
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '保养手册',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllCheck(
                                          vehicleLicence:
                                              vehicle['vehicleLicence'],
                                        )));
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 9,
                                ),
                                Image.asset(
                                  'Assets/Home/checkCar.png',
                                  fit: BoxFit.fill,
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '全车检查',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Container(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 9,
                              ),
                              Image.asset(
                                'Assets/Home/toVip.png',
                                fit: BoxFit.fill,
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '配置详情',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40,
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
                height: 15,
              ),
// 备注
              Container(
                  child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '备注',
                        style: TextStyle(
                            color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
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
                        //height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            vehicle['remark'] ?? '未备注',
                            style: TextStyle(
                                color: Color.fromRGBO(30, 30, 30, 1),
                                fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  )
                ],
              )),
              SizedBox(
                height: 15,
              ),
//可用卡劵
              campaign == null
                  ? Container()
                  : Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 3,
                                height: 14,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(39, 153, 93, 1)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '可用卡劵',
                                style: TextStyle(
                                    color: Color.fromRGBO(27, 30, 29, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: campaign.length,
                              itemBuilder: (BuildContext context, int item) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
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
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color.fromRGBO(
                                                  233, 245, 238, 1)),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                campaign[item]
                                                        ['campaignName'] ??
                                                    ''.toString(),
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        39, 153, 93, 1)),
                                              ),
                                              Expanded(child: SizedBox()),
                                              Text(
                                                '剩余${campaign[item]['count'] ?? 0}次',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        39, 153, 93, 1)),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              )
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
                              })
                        ],
                      ),
                    ),

//智能提醒
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 3,
                          height: 14,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(39, 153, 93, 1)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '智能提醒',
                          style: TextStyle(
                              color: Color.fromRGBO(27, 30, 29, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
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
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: alartList.length,
                              itemBuilder: (BuildContext context, int item) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          alartList[item],
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(30, 30, 30, 1),
                                              fontSize: 15),
                                        ),
                                        Expanded(child: SizedBox()),
                                        item == 0
                                            ? Text(
                                                _returnDatetime(vehicle[
                                                    'commercialInsurance']),
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        30, 30, 30, 1),
                                                    fontSize: 15),
                                              )
                                            : item == 1
                                                ? Text(
                                                    _returnDatetime(vehicle[
                                                        'compulsoryDate']),
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            30, 30, 30, 1),
                                                        fontSize: 15),
                                                  )
                                                : item == 2
                                                    ? Text(
                                                        _returnDatetime(vehicle[
                                                            'annualExpiryDate']),
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    30,
                                                                    30,
                                                                    30,
                                                                    1),
                                                            fontSize: 15),
                                                      )
                                                    : item == 3
                                                        ? Text(
                                                            _returnDatetime(vehicle[
                                                                'verificationDate']),
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        30,
                                                                        30,
                                                                        30,
                                                                        1),
                                                                fontSize: 15),
                                                          )
                                                        : Container(),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    companyList.length - 1 == item
                                        ? Container()
                                        : Container(
                                            height: 1,
                                            color: Color.fromRGBO(
                                                229, 229, 229, 1)),
                                  ],
                                );
                              }),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    )
                  ],
                ),
              ),

//服务历史
              serviceList == null
                  ? Container()
                  : Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 3,
                                height: 14,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(39, 153, 93, 1)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '服务历史',
                                style: TextStyle(
                                    color: Color.fromRGBO(27, 30, 29, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
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
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: serviceList.length,
                                    itemBuilder:
                                        (BuildContext context, int item) {
                                      return GestureDetector(
                                          onTap: () {
                                            //跳转 结算详情
                                            //  dataList[index]['memberId'] == null
                                            //     ? Navigator.push(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //             builder: (context) => SettlementNonmemberPage(
                                            //                 dataList[index]['workOrderId'].toString(),
                                            //                 dataList[index]['vehicleLicence'],
                                            //                 true)),
                                            //       )
                                            //     : Navigator.push(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //             builder: (context) => SettlementDetailsPage(
                                            //                 dataList[index]['workOrderId'].toString(),
                                            //                 dataList[index]['vehicleLicence'],
                                            //                 true)),
                                            //       );
                                          },
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    serviceList[item]
                                                            ['serviceDate'] ??
                                                        ''.toString(),
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            30, 30, 30, 1),
                                                        fontSize: 15),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  Text(
                                                    '¥${serviceList[item]['price'] ?? ''.toString()}',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            30, 30, 30, 1),
                                                        fontSize: 15),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    serviceList[item]
                                                            ['serviceName'] ??
                                                        ''.toString(),
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            30, 30, 30, 1),
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              companyList.length - 1 == item
                                                  ? Container()
                                                  : Container(
                                                      height: 1,
                                                      color: Color.fromRGBO(
                                                          229, 229, 229, 1)),
                                            ],
                                          ));
                                    }),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }
}
