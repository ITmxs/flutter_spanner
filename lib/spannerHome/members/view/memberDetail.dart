import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/notificationCenter.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/members/membersRequestApi.dart';
import 'package:spanners/spannerHome/members/view/addMember.dart';
import 'package:spanners/spannerHome/members/view/balanceRecharge.dart';
import 'package:spanners/spannerHome/members/view/carroll.dart';
import 'package:spanners/spannerHome/members/view/editCar.dart';
import 'package:spanners/spannerHome/registrationOfVehicle/vehicleDetail.dart';

class MemberDetail extends StatefulWidget {
  final String userId;
  final isVips;
  const MemberDetail({Key key, this.userId, this.isVips}) : super(key: key);
  @override
  _MemberDetailState createState() => _MemberDetailState();
}

class _MemberDetailState extends State<MemberDetail> {
  Map member = Map();
  List vehicle = List();
  List recordList = List();
  //获取详细
  _memberDetailRequst() {
    MembersDio.memberDetailRequest(
      param: {'userId': widget.userId},
      onSuccess: (data) {
        setState(() {
          member = data['member'];
          vehicle = data['vehicle'];
          recordList = data['recordList'];
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _memberDetailRequst();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonWidget.simpleAppBar(context, title: "客户详情"),
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: [
              Container(
                width: 345.s,
                margin: EdgeInsets.fromLTRB(15.s, 15.s, 15.s, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.s),
                    color: Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.s, 10.s, 15.s, 15.s),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonWidget.greenFont(
                              text: member['type'].toString() == '1'
                                  ? "企业资料"
                                  : '客户资料'),
                          InkWell(
                              onTap: () {
                                //权限处理 详细参考 后台Excel
                                PermissionApi.whetherContain('member_opt_add')
                                    ? print('')
                                    : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddMember(
                                                      memmber: member,
                                                    )))
                                        .then((value) => _memberDetailRequst());
                              },
                              child: Image.asset(
                                'Assets/members/edit.png',
                                width: 20,
                                height: 20,
                              ))
                        ],
                      ),
                    ),
                    member['type'].toString() == '1'
                        ? CommonWidget.simpleList(mustFlag: false, keyList: [
                            '企业性质',
                            '企业名称',
                            '手机号',
                            '管理员姓名'
                          ], valueList: [
                            member['companyType'].toString(),
                            member['company'].toString(),
                            member['mobile'].toString(),
                            member['realName'].toString()
                          ])
                        : CommonWidget.simpleList(mustFlag: false, keyList: [
                            '车主姓名',
                            '手机号',
                          ], valueList: [
                            member['realName'].toString(),
                            member['mobile'].toString(),
                          ]),
                    Container(
                      decoration: CommonWidget.grayTopBorder(),
                      padding: EdgeInsets.fromLTRB(0, 20.s, 0, 10.s),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 25.s,
                              ),
                              CommonWidget.font(text: "账户余额")
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
                            child: Row(
                              children: [
                                CommonWidget.font(
                                    text: member['accountBalances'].toString()),
                                SizedBox(
                                  width: 10.s,
                                ),
                                InkWell(
                                  onTap: () {
                                    //权限处理 详细参考 后台Excel
                                    PermissionApi.whetherContain(
                                            'member_opt_recharge')
                                        ? print('')
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BalanceRecharge(
                                                      userId: widget.userId,
                                                      member: member,
                                                    ))).then(
                                            (value) => _memberDetailRequst());
                                  },
                                  child: CommonWidget.customButton(
                                      text: "余额充值",
                                      textColor: Colors.white,
                                      fontSize: 13.s,
                                      buttonColor:
                                          Color.fromRGBO(255, 183, 0, 1),
                                      width: 67.s,
                                      height: 25.s),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 345.s,
                margin: EdgeInsets.fromLTRB(15.s, 15.s, 15.s, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.s),
                    color: Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.s, 10.s, 15.s, 15.s),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonWidget.greenFont(text: "会员车辆"),
                          InkWell(
                            onTap: () {
                              //权限处理 详细参考 后台Excel
                              PermissionApi.whetherContain('member_opt_add')
                                  ? print('')
                                  : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditCar(
                                                    userId: widget.userId,
                                                  )))
                                      .then((value) => _memberDetailRequst());
                            },
                            child: Image.asset(
                              'Assets/members/edit.png',
                              width: 20,
                              height: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: vehicle.length,
                        itemBuilder: (BuildContext context, int a) {
                          return Container(
                            decoration: CommonWidget.grayBottomBorder(),
                            padding: EdgeInsets.fromLTRB(0, 15.s, 0, 10.s),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VehicleDetail(
                                                  vehicleId: vehicle[a]
                                                      ['vehicleId'],
                                                  vehicleLicence: vehicle[a]
                                                      ['vehicleLicence'],
                                                  isVip: widget.isVips,
                                                ))).then(
                                        (value) => _memberDetailRequst());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20.s, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonWidget.font(
                                          text: vehicle[a]['vehicleLicence'] +
                                              ' ' +
                                              vehicle[a]['model'] +
                                              ' ' +
                                              vehicle[a]['brand'],
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(255, 77, 76, 1),
                                        ),
                                        SizedBox(
                                          height: 5.s,
                                        ),
                                        Container(
                                          width: 200.s,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: vehicle[a]
                                                      ['ownServiceList']
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int b) {
                                                return Text(
                                                    '${vehicle[a]['ownServiceList'][b]['dictName']}剩余${vehicle[a]['ownServiceList'][b]['count']}次',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            163, 163, 163, 1),
                                                        fontSize: 13));
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    //权限处理 详细参考 后台Excel
                                    PermissionApi.whetherContain(
                                            'member_opt_recharge')
                                        ? print('')
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Carroll(
                                                      memmberId:
                                                          member['memberId'],
                                                      vehicleId: vehicle[a]
                                                          ['vehicleId'],
                                                      userId: widget.userId,
                                                    ))).then(
                                            (value) => _memberDetailRequst());
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
                                    child: Row(
                                      children: [
                                        CommonWidget.customButton(
                                            text: "充值次卡",
                                            textColor: Colors.white,
                                            fontSize: 13.s,
                                            buttonColor:
                                                Color.fromRGBO(255, 77, 76, 1),
                                            width: 67.s,
                                            height: 25.s)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
              Container(
                width: 345.s,
                margin: EdgeInsets.fromLTRB(15.s, 15.s, 15.s, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.s),
                    color: Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.s, 10.s, 15.s, 15.s),
                      child: CommonWidget.greenFont(text: "充值历史"),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: recordList.length,
                        itemBuilder: (BuildContext context, int a) {
                          return Container(
                            decoration: CommonWidget.grayBottomBorder(),
                            padding: EdgeInsets.fromLTRB(0, 15.s, 0, 10.s),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 200,
                                      padding:
                                          EdgeInsets.fromLTRB(20.s, 0, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonWidget.font(
                                            text: recordList[a]['name']
                                                .toString(),
                                            color:
                                                Color.fromRGBO(39, 39, 39, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
                                      child: Column(
                                        children: [
                                          CommonWidget.font(
                                              text: recordList[a]['amount']
                                                  .toString()),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CommonWidget.font(
                                        text: recordList[a]['createTime']
                                            .toString(),
                                        size: 13,
                                        color:
                                            Color.fromRGBO(163, 163, 163, 1)),
                                    SizedBox(
                                      width: 20.s,
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 30.s,
              )
            ],
          ),
        ));
  }
}
