import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/members/membersRequestApi.dart';

class BalanceRecharge extends StatefulWidget {
  final Map member;
  final userId;
  const BalanceRecharge({Key key, this.member, this.userId}) : super(key: key);
  @override
  _BalanceRechargeState createState() => _BalanceRechargeState();
}

class _BalanceRechargeState extends State<BalanceRecharge> {
  int showInt = 999;
  List itemList = List();
  String buyPrice = '';
  String valuePrice = '';
  String accountBalances;
  String campaignId;
  String remarks;

  //获取详细
  _memberDetailRequst() {
    MembersDio.topupRequest(
      param: {
        'type': '0',
      },
      onSuccess: (data) {
        setState(() {
          itemList = data;
        });
      },
    );
  }

  //充值
  _recharge() {
    MembersDio.rechargeRequest(
      param: {
        'amount': showInt == 999 ? valuePrice : buyPrice,
        'campaignId': campaignId.toString(),
        'userId': widget.userId,
        'accountBalances': accountBalances,
        'memberId': widget.member['memberId']
      },
      onSuccess: (data) {
        print(data);
        Navigator.pop(context);
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
    return GestureDetector(
        onTap: () {
          //点击空白处隐藏键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(238, 238, 238, 1),
            appBar: CommonWidget.simpleAppBar(context,
                title: "余额充值", elevationInt: 1),
            body: ScrollConfiguration(
              behavior: NeverScrollBehavior(),
              child: ListView(
                children: [
                  Container(
                    width: 375.s,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 345.s,
                          height: 85.s,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10.s),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("Assets/members/backimg.png"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(5.s),
                              color: Colors.greenAccent),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(30.s, 20.s, 30.s, 0.s),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonWidget.font(
                                        text:
                                            widget.member['mobile'].toString(),
                                        color: Colors.white),
                                    CommonWidget.font(
                                        text: "账户余额", color: Colors.white),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.s,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonWidget.font(
                                        text:
                                            widget.member['type'].toString() ==
                                                    '1'
                                                ? widget.member['company']
                                                    .toString()
                                                : widget.member['realName']
                                                    .toString(),
                                        color: Colors.white),
                                    CommonWidget.font(
                                        text: widget.member['accountBalances']
                                            .toString(),
                                        color: Colors.white),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // //自定义充值
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(15.s, 25.s, 15.s, 20.s),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Padding(
                  //         padding: EdgeInsets.fromLTRB(15.s, 0, 0, 10.s),
                  //         child: CommonWidget.font(
                  //             text: "充值金额", fontWeight: FontWeight.bold),
                  //       ),
                  //       Container(
                  //         width: 345.s,
                  //         height: 40.s,
                  //         padding: EdgeInsets.fromLTRB(10.s, 10.s, 0, 0),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(5.s),
                  //             color: Colors.white),
                  //         child: TextFormField(
                  //           // controller: //priceController,
                  //           inputFormatters: [KeyboardLimit(1)],
                  //           keyboardType:
                  //               TextInputType.numberWithOptions(decimal: true),
                  //           controller: TextEditingController.fromValue(
                  //               TextEditingValue(
                  //                   // 设置内容
                  //                   text: valuePrice,
                  //                   // 保持光标在最后
                  //                   selection: TextSelection.fromPosition(
                  //                       TextPosition(
                  //                           affinity: TextAffinity.downstream,
                  //                           offset: valuePrice.length)))),

                  //           textAlign: TextAlign.left,
                  //           style: TextStyle(fontSize: 14, color: Colors.black),
                  //           decoration: InputDecoration(
                  //             contentPadding: const EdgeInsets.symmetric(
                  //                 vertical: 0, horizontal: 0),
                  //             hintText: '自定义充值金额',
                  //             hintStyle: TextStyle(
                  //                 color: Color.fromRGBO(164, 164, 164, 1),
                  //                 fontSize: 14),
                  //             border:
                  //                 OutlineInputBorder(borderSide: BorderSide.none),
                  //           ),
                  //           onChanged: (value) {
                  //             setState(() {
                  //               valuePrice = value;
                  //               showInt = 999;
                  //             });
                  //           },
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  //优惠卡 充值
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      itemBuilder: (BuildContext context, int a) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              showInt == a ? showInt = 999 : showInt = a;
                              valuePrice = '';
                              buyPrice = itemList[a]['buyPrice'].toString();
                              accountBalances =
                                  itemList[a]['accountPrice'].toString();
                              campaignId = itemList[a]['id'].toString();
                              remarks = itemList[a]['remarks'].toString();
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                  width: 345.s,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20.s),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.s),
                                      color: Color.fromRGBO(254, 245, 240, 1)),
                                  child: Stack(children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CommonWidget.customButton(
                                                      text: "优惠卡",
                                                      width: 105.s,
                                                      height: 15.s,
                                                      textColor: Color.fromRGBO(
                                                          255, 77, 75, 1),
                                                      buttonColor:
                                                          Color.fromRGBO(
                                                              255, 229, 230, 1),
                                                      fontSize: 11.s,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.s,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 15.s,
                                                ),
                                                CommonWidget.font(
                                                    text: "充¥",
                                                    color: Color.fromRGBO(
                                                        255, 77, 76, 1)),
                                                CommonWidget.font(
                                                    text: itemList[a]
                                                            ['buyPrice']
                                                        .toString(),
                                                    color: Color.fromRGBO(
                                                        255, 77, 76, 1),
                                                    fontWeight: FontWeight.bold,
                                                    size: 25),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 15.s,
                                                ),
                                                CommonWidget.font(
                                                    text: "赠¥",
                                                    color: Color.fromRGBO(
                                                        255, 77, 76, 1)),
                                                CommonWidget.font(
                                                    text: itemList[a]
                                                            ['discountPrice']
                                                        .toString(),
                                                    color: Color.fromRGBO(
                                                        255, 77, 76, 1),
                                                    fontWeight: FontWeight.bold,
                                                    size: 25),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5.s,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 10.s),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            30 -
                                                            40 -
                                                            105 -
                                                            20,
                                                        child:
                                                            CommonWidget.font(
                                                          number: 1,
                                                          text: itemList[a][
                                                                  'campaignName']
                                                              .toString(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              255, 77, 75, 1),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                //yuan
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.s,
                                            ),
                                            CommonWidget.font(
                                              fontWeight: FontWeight.w400,
                                              text:
                                                  "有效期至${itemList[a]['endTime']}",
                                              color: Color.fromRGBO(
                                                  255, 77, 75, 1),
                                            ),
                                            CommonWidget.font(
                                              fontWeight: FontWeight.w400,
                                              text: itemList[a]['remarks']
                                                  .toString(),
                                              color: Color.fromRGBO(
                                                  255, 77, 75, 1),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    //选中 状态展示
                                    showInt == a
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    30 -
                                                    40,
                                                0,
                                                0,
                                                0),
                                            child: Image.asset(
                                              'Assets/members/select.png',
                                              width: 40,
                                              height: 30,
                                            ),
                                          )
                                        : Container(),
                                  ])),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      }),

                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        if (showInt == 999 && valuePrice == '') {
                          Alart.showAlartDialog('未选择充值卡', 1);
                          return;
                        }
                        showDialog(
                            context:
                                Routers.navigatorState.currentState.context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  content: Container(
                                      width: 100,
                                      height: showInt == 999 ? 90 : 120,
                                      child: Column(
                                        children: [
                                          Text(
                                            showInt == 999
                                                ? '当前充值金额为$valuePrice'
                                                : '当前选中优惠$remarks',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          showInt == 999
                                              ? Container()
                                              : SizedBox(
                                                  height: 10,
                                                ),
                                          showInt == 999
                                              ? Container()
                                              : Text(
                                                  '实际支付金额$buyPrice',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            height: 1,
                                            color:
                                                Color.fromRGBO(41, 39, 39, 1),
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
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '取消',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      41,
                                                                      39,
                                                                      39,
                                                                      1),
                                                              fontSize: 14),
                                                        ),
                                                      ))),
                                              Container(
                                                width: 1,
                                                height: 20,
                                                color: Color.fromRGBO(
                                                    41, 39, 39, 1),
                                              ),
                                              Expanded(
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        _recharge();
                                                      },
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '确定',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      41,
                                                                      39,
                                                                      39,
                                                                      1),
                                                              fontSize: 14),
                                                        ),
                                                      )))
                                            ],
                                          ),
                                        ],
                                      )));
                            });
                      },
                      child: Container(
                        width: 109,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromRGBO(39, 153, 93, 1)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '确认充值',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            )));
  }
}
