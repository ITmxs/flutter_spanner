import 'package:flutter/material.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/publicView/pud_permission.dart';

import 'package:spanners/spannerHome/newOrder/newOrder.dart';
import './carAppointmentDeilt.dart';
import './appointmentRequestApi.dart';
import 'package:spanners/cModel/appointmentModel.dart';

class CarAppointmentList extends StatefulWidget {
  final data;
  final ValueChanged<int> onChanged; // 1成功 刷新
  const CarAppointmentList({Key key, this.data, this.onChanged})
      : super(key: key);
  @override
  _CarAppointmentListState createState() => _CarAppointmentListState();
}

class _CarAppointmentListState extends State<CarAppointmentList> {
  /*
  接车处理  暂时废弃
  */
  _getCarData(String vehicleLicence, String shopId) {
    ApiDio.getCarRequest(
      param: {'vehicleLicence': vehicleLicence, 'shopId': shopId},
      onSuccess: (data) {},
      onError: (error) {},
    );
  }

/*
  删除处理
  */
  _deleteCarData(String workOrderId) {
    ApiDio.detailEditTimeRequests(
      pragm: {'id': workOrderId, 'delFlag': 1},
      onSuccess: (data) {
        setState(() {
          widget.onChanged(1);
        });
      },
      onError: (error) {},
    );
  }

  var now = DateTime.now();
  /*  计算 30分钟 时间间隔*/
  int _differenceTime(String times) {
    DateTime date3 = DateTime.parse(times);
    var difference = now.difference(date3).inMinutes;
    print('相差-->$difference');
    if (difference < 0 && difference > -30) {
      return difference * (-1);
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.data == null
        ? Container()
        : Container(
            child: Row(
            children: [
              SizedBox(
                width: 24,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    color: Colors.white),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(
                      widget.data.length,
                      (index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CarAppointmenDeilt(
                                            workorderid: AppointUserMessageModel
                                                    .fromJson(
                                                        widget.data[index])
                                                .workOrderId
                                                .toString(),
                                            id: AppointUserMessageModel
                                                    .fromJson(
                                                        widget.data[index])
                                                .id
                                                .toString(),
                                          )));
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width -
                                          44 -
                                          32,
                                      34,
                                      18,
                                      30),
                                  child: Image.asset(
                                    'Assets/Home/appointrigth.png',
                                    width: 11,
                                    height: 19,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 19,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  /*
                                                    人名
                                                    */
                                                  AppointUserMessageModel
                                                          .fromJson(widget
                                                              .data[index])
                                                      .appointmentName
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          48, 48, 50, 1),
                                                      fontSize: 15),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 44,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Color.fromRGBO(
                                                            30, 141, 255, 1),
                                                        width: 1)),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    /*
                                                    stuts 状态
                                                    */
                                                    AppointUserMessageModel
                                                            .fromJson(widget
                                                                .data[index])
                                                        .appointmentStatusName
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            30, 141, 255, 1),
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            _differenceTime(
                                                      AppointUserMessageModel
                                                              .fromJson(widget
                                                                  .data[index])
                                                          .appointmentTime
                                                          .toString(),
                                                    ) ==
                                                    0
                                                ? ''
                                                : '倒计时${_differenceTime(AppointUserMessageModel.fromJson(widget.data[index]).appointmentTime)}分钟',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Container(
                                          width: 130,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              /*
                                            类别
                                            */
                                              AppointUserMessageModel.fromJson(
                                                      widget.data[index])
                                                  .secondaryService
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      48, 48, 50, 1),
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            /*
                                             日期
                                            */
                                            AppointUserMessageModel.fromJson(
                                                    widget.data[index])
                                                .appointmentTime
                                                .toString(),
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    48, 48, 50, 1),
                                                fontSize: 13),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 18,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            /*
                                            车牌号
                                            */
                                            AppointUserMessageModel.fromJson(
                                                    widget.data[index])
                                                .vehicleLicence
                                                .toString(),
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    48, 48, 50, 1),
                                                fontSize: 20),
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        InkWell(
                                          onTap: () {
                                            /*
                                            接车按钮
                                            */
                                            // _getCarData(
                                            //     AppointUserMessageModel
                                            //             .fromJson(
                                            //                 widget.data[index])
                                            //         .vehicleLicence
                                            //         .toString(),
                                            //     AppointUserMessageModel
                                            //             .fromJson(
                                            //                 widget.data[index])
                                            //         .shopId
                                            //         .toString());
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewOrder(
                                                          workOrderId: widget
                                                                  .data[index]
                                                              ['workOrderId'],
                                                        )));
                                          },
                                          child: Container(
                                              width: 50,
                                              height: 22,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color.fromRGBO(
                                                    39, 153, 93, 1),
                                              ),
                                              child: Text('接车',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300))),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              /*
                                            删除
                                            */
                                              // _showDeleteDialog(
                                              //     AppointUserMessageModel
                                              //             .fromJson(widget
                                              //                 .data[index])
                                              //         .id
                                              //         .toString());
                                              showDialog(
                                                  context: Routers
                                                      .navigatorState
                                                      .currentState
                                                      .context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        content: Container(
                                                            width: 100,
                                                            height: 90,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  '确定删除当前预约单？',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Container(
                                                                  height: 1,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          41,
                                                                          39,
                                                                          39,
                                                                          1),
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
                                                                      height:
                                                                          20,
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              41,
                                                                              39,
                                                                              39,
                                                                              1),
                                                                    ),
                                                                    Expanded(
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              Navigator.pop(context);
                                                                              _deleteCarData(AppointUserMessageModel.fromJson(widget.data[index]).id);
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
                                            });
                                          },
                                          child: Container(
                                              width: 40,
                                              height: 20,
                                              alignment: Alignment.center,
                                              child: Text('删除',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          48, 48, 50, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300))),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          height: 1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              48 -
                                              30,
                                          color:
                                              Color.fromRGBO(229, 229, 229, 1),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                ),
              ),
              SizedBox(
                width: 24,
              ),
            ],
          ));
  }
}
