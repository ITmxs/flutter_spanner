import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:spanners/cModel/pubModel.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/publicView/pub_ApiDio.dart';

class Maintenance extends StatefulWidget {
  final String showSure; // 1 创建  0 展示
  final String vehicleLicence;
  final List paramList;
  const Maintenance(
      {Key key, this.showSure, this.vehicleLicence, this.paramList})
      : super(key: key);
  @override
  _MaintenanceState createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  List dataList = List();
  List upDataList = List();
  //  获取保养手册 list
  _getMaintenanceList() {
    PubDio.pubMainterListRequest(
      param: widget.vehicleLicence,
      onSuccess: (data) {
        setState(() {
          dataList = data;
        });
      },
    );
  }

  //  创建保养手册
  _creatMaintenance() {
    PubDio.pubMainterCreatRequest(
      param: {'manual': upDataList}, //widget.vehicleLicence//
      onSuccess: (data) {
        setState(() {
          if (data) {
            //跳转结算页面
            Navigator.pop(context);
          }
        });
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
    if (widget.showSure == '1') {
      dataList = widget.paramList;
    } else {
      _getMaintenanceList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        centerTitle: true,
        title: Text('保养手册',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500)),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: isNull(dataList) == 0
          ? Padding(
              padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
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
            )
          : ListView(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                        dataList.length,
                        (index) => Column(
                              children: [
                                //服务
                                Container(
                                  child: MaintenanceList(
                                    showEdit: widget.showSure,
                                    titleList: widget.showSure == '1'
                                        ? convert.jsonDecode(
                                                    dataList[index])['type'] ==
                                                '0'
                                            ? [
                                                '服务名称',
                                                '上次服务时间',
                                                '下次服务时间',
                                                '下次服务公里数'
                                              ]
                                            : ['配件名称', '上次服务时间', '保修期', '保修公里数']
                                        : dataList[index]['type'] == '0'
                                            ? [
                                                '服务名称',
                                                '上次服务时间',
                                                '下次服务时间',
                                                '下次服务公里数'
                                              ]
                                            : [
                                                '配件名称',
                                                '上次服务时间',
                                                '保修期',
                                                '保修公里数'
                                              ],
                                    dataMap: widget.showSure == '1'
                                        ? convert.jsonDecode(dataList[index])
                                        : dataList[index],
                                    onChanged: (value) {
                                      print('传来的datalist:$value');
                                      int type = 9999;
                                      if (upDataList.length > 0) {
                                        for (var i = 0;
                                            i < upDataList.length;
                                            i++) {
                                          if (value[0]['serviceName'] ==
                                              upDataList[i]['serviceName']) {
                                            type = i;
                                            break;
                                          } else {
                                            type = 9999;
                                          }
                                        }
                                        if (type == 9999) {
                                          upDataList.addAll(value);
                                        } else {
                                          upDataList.removeAt(type);
                                          upDataList.addAll(value);
                                        }

                                        print('封装的的datalist:$upDataList');
                                      } else {
                                        upDataList.addAll(value);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                // //配件
                                // ListView(
                                //   shrinkWrap: true,
                                //   physics: NeverScrollableScrollPhysics(),
                                //   children: List.generate(
                                //       2,
                                //       (item) => Column(
                                //             children: [
                                //               MaintenanceList(
                                //                 titleList: [
                                //                   '配件名称',
                                //                   '上次服务时间',
                                //                   '保修期',
                                //                   '保修公里数'
                                //                 ],
                                //               ),
                                //               SizedBox(
                                //                 height: 10,
                                //               )
                                //             ],
                                //           )),
                                // ),
                              ],
                            )),
                  ),
                ),
                widget.showSure == '1'
                    ? Column(
                        children: [
                          SizedBox(
                            height: 46,
                          ),
                          InkWell(
                            onTap: () {
                              _creatMaintenance();
                            },
                            child: Container(
                              width: 63,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromRGBO(39, 153, 93, 1),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '确定',
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 23,
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
    );
  }
}

class MaintenanceList extends StatefulWidget {
  final int index;
  final List titleList;
  final Map<String, dynamic> dataMap;
  final String showEdit; // 1 展示备注 else 填写备注
  final ValueChanged<List> onChanged;
  const MaintenanceList(
      {Key key,
      this.titleList,
      this.showEdit,
      this.dataMap,
      this.index,
      this.onChanged})
      : super(key: key);
  @override
  _MaintenanceListState createState() => _MaintenanceListState();
}

class _MaintenanceListState extends State<MaintenanceList> {
  List updata = List();
  String times = '';
  Map itemMap = Map();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemMap['serviceName'] =
        PublicMainfenceModel.fromJson(widget.dataMap).serviceName;
    itemMap['receiveTime'] =
        PublicMainfenceModel.fromJson(widget.dataMap).receiveTime;
    itemMap['vehicleLicence'] = widget.dataMap['vehicleLicence'];
    itemMap['workOrderId'] = widget.dataMap['workOrderId'];
    itemMap['type'] = widget.dataMap['type'];
    updata.add(itemMap);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Container(
            width: MediaQuery.of(context).size.width - 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(255, 255, 255, 1)),
            child: Column(
              children: [
                Container(
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                      4,
                      (number) => Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              number == 0
                                  ? SizedBox(
                                      width: 10,
                                    )
                                  : SizedBox(
                                      width: 20,
                                    ),
                              number == 0
                                  ? Container(
                                      width: 3,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: Color.fromRGBO(39, 153, 93, 1),
                                      ),
                                    )
                                  : Container(),
                              number == 0
                                  ? SizedBox(
                                      width: 7,
                                    )
                                  : SizedBox(
                                      width: 0,
                                    ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  number == 0
                                      ? PublicMainfenceModel.fromJson(
                                              widget.dataMap)
                                          .serviceName
                                      : widget.titleList[number],
                                  style: TextStyle(
                                      color: Color.fromRGBO(38, 38, 38, 1),
                                      fontSize: 15,
                                      fontWeight: number == 0
                                          ? FontWeight.w500
                                          : FontWeight.normal),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              widget.showEdit == '1'
                                  ? number == 0
                                      ? Container()
                                      : number == 1
                                          ? Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                PublicMainfenceModel.fromJson(
                                                        widget.dataMap)
                                                    .receiveTime,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        38, 38, 38, 1),
                                                    fontSize: 15,
                                                    fontWeight: number == 0
                                                        ? FontWeight.w500
                                                        : FontWeight.normal),
                                              ),
                                            )
                                          : number == 2
                                              ? InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      isDismissible: true,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return DatePickerView(
                                                          onChanged: (value) {
                                                            setState(() {
                                                              times = value;
                                                              updata[0][
                                                                      'nextService'] =
                                                                  value;
                                                              widget.onChanged(
                                                                  updata);
                                                            });
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      times == ''
                                                          ? '请选择'
                                                          : times,
                                                      style: TextStyle(
                                                        color: times == ''
                                                            ? Color.fromRGBO(
                                                                180,
                                                                180,
                                                                180,
                                                                1)
                                                            : Color.fromRGBO(
                                                                45, 45, 45, 1),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : number == 3
                                                  ? Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxHeight: 17,
                                                                  maxWidth:
                                                                      100),
                                                          child: TextFormField(
                                                              onChanged:
                                                                  (value) {
                                                                updata[0][
                                                                        'nextServiceKm'] =
                                                                    value;
                                                                widget
                                                                    .onChanged(
                                                                        updata);
                                                              },
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                                hintText: '请输入',
                                                                hintStyle: TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            164,
                                                                            164,
                                                                            164,
                                                                            1),
                                                                    fontSize:
                                                                        14),
                                                                border: OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none),
                                                              ))))
                                                  : Container()
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        number == 0
                                            ? ''
                                            : number == 1
                                                ? PublicMainfenceModel.fromJson(
                                                        widget.dataMap)
                                                    .receiveTime
                                                : number == 2
                                                    ? PublicMainfenceModel
                                                            .fromJson(
                                                                widget.dataMap)
                                                        .nextService
                                                    : number == 3
                                                        ? PublicMainfenceModel
                                                                .fromJson(widget
                                                                    .dataMap)
                                                            .nextServiceKm
                                                        : number == 4
                                                            ? PublicMainfenceModel
                                                                    .fromJson(widget
                                                                        .dataMap)
                                                                .remark
                                                            : '',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(38, 38, 38, 1),
                                            fontSize: 15,
                                            fontWeight: number == 0
                                                ? FontWeight.w500
                                                : FontWeight.normal),
                                      ),
                                    ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          Container(
                            height: 1,
                            color: Color.fromRGBO(238, 238, 238, 1),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //备注
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '建议备注',
                            style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        widget.showEdit == '1'
                            ? //修改备注被容

                            //输入备注内容
                            Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width - 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight: 200,
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                              60),
                                  child: TextFormField(
                                    maxLines: 6,
                                    onChanged: (value) {
                                      setState(() {
                                        updata[0]['remark'] = value;
                                        widget.onChanged(updata);
                                      });
                                    },
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                      hintText: '备注内容',
                                      hintStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(136, 133, 133, 1),
                                          fontSize: 15),
                                      enabledBorder: OutlineInputBorder(
                                        //未选中时候的颜色
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(238, 238, 238, 1),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        //选中时外边框颜色
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(238, 238, 238, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width - 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(238, 238, 238, 1)),
                                ),
                                child: Text(
                                  PublicMainfenceModel.fromJson(widget.dataMap)
                                              .remark ==
                                          'null'
                                      ? '无备注'
                                      : PublicMainfenceModel.fromJson(
                                              widget.dataMap)
                                          .remark,
                                  style: TextStyle(
                                      color: Color.fromRGBO(30, 30, 30, 1),
                                      fontSize: 13),
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
                )
              ],
            )),
        SizedBox(
          width: 15,
        )
      ],
    );
  }
}
