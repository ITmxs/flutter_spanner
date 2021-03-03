import 'package:flutter/material.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/members/membersRequestApi.dart';

class Carroll extends StatefulWidget {
  final vehicleId;
  final userId;
  final memmberId;
  const Carroll({Key key, this.vehicleId, this.userId, this.memmberId})
      : super(key: key);
  @override
  _CarrollState createState() => _CarrollState();
}

class _CarrollState extends State<Carroll> {
  int showInt;
  List dataList = List();
  String remarks;
  String buyPrice = '';
  String campaignId;
  //获取详细
  _memberDetailRequst() {
    MembersDio.countRequest(
      param: {'type': '1'},
      onSuccess: (data) {
        setState(() {
          dataList = data;
        });
      },
    );
  }

  //充值
  _postRequst() {
    MembersDio.cardRechargeRequest(
      param: {
        'memberId': widget.memmberId,
        'vehicleId': widget.vehicleId,
        'campaignId': campaignId,
        'amount': buyPrice,
        'userId': widget.userId
      },
      onSuccess: (data) {
        setState(() {
          Navigator.pop(context);
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
        appBar: CommonWidget.simpleAppBar(context, title: "卡劵列表"),
        body: ScrollConfiguration(
            behavior: NeverScrollBehavior(),
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                //优惠卡 充值
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dataList == null ? 0 : dataList.length,
                    itemBuilder: (BuildContext context, int a) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (showInt == a) {
                              showInt = 999;
                              buyPrice = '';
                              campaignId = '';
                            } else {
                              showInt = a;
                              buyPrice = dataList[a]['buyPrice'].toString();
                              remarks = dataList[a]['remarks'].toString();
                              campaignId = dataList[a]['campaignId'].toString();
                            }
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
                                          Container(
                                            width: 105,
                                            height: 1,
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
                                                  text: "¥",
                                                  color: Color.fromRGBO(
                                                      255, 77, 76, 1)),
                                              CommonWidget.font(
                                                  text: dataList[a]['buyPrice']
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              30 -
                                                              40 -
                                                              105 -
                                                              20,
                                                      child: CommonWidget.font(
                                                        text: dataList[a]
                                                                ['campaignName']
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
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.s,
                                          ),
                                          CommonWidget.font(
                                            text:
                                                "有效期至${dataList[a]['endTime'].toString()}",
                                            color:
                                                Color.fromRGBO(255, 77, 75, 1),
                                          ),
                                          CommonWidget.font(
                                            text: dataList[a]['remarks']
                                                .toString(),
                                            color:
                                                Color.fromRGBO(255, 77, 75, 1),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonWidget.customButton(
                                              text: "优惠次卡",
                                              width: 105,
                                              height: 15.s,
                                              textColor: Color.fromRGBO(
                                                  255, 77, 75, 1),
                                              buttonColor: Color.fromRGBO(
                                                  255, 229, 230, 1),
                                              fontSize: 11.s,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
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
                      if (buyPrice == '') {
                        Alart.showAlartDialog('未选择充值卡', 1);
                        return;
                      }
                      showDialog(
                          context: Routers.navigatorState.currentState.context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                content: Container(
                                    width: 100,
                                    height: 120,
                                    child: Column(
                                      children: [
                                        Text(
                                          '当前选中优惠$remarks',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        '取消',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
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
                                              color:
                                                  Color.fromRGBO(41, 39, 39, 1),
                                            ),
                                            Expanded(
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _postRequst();
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        '确定',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
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
            )));
  }
}
