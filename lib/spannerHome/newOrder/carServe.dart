import 'package:flutter/material.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/publicView/pub_Maintenance.dart';
import 'package:spanners/spannerHome/newOrder/carCheckAll.dart';
import './carServeChildView.dart';

class CarServe extends StatefulWidget {
  final List serList;
  final String brands;
  final String vehicleLicence;
  final String models;
  const CarServe({
    Key key,
    this.serList,
    this.brands,
    this.models,
    this.vehicleLicence,
  }) : super(key: key);
  @override
  _CarServeState createState() => _CarServeState();
}

class _CarServeState extends State<CarServe> {
  List upData = List(); //一二级服务相关集合
  List showValue = List();
  bool indexBool = false; //false为直接展示，true是点击取消
  bool elseBool = false; //存在 其他配件项目 之外的二级服务
  int materInt;
  var shopId;
  _insertShopId() async {
    shopId = await SharedManager.getShopIdString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _insertShopId();
  }

  @override
  Widget build(BuildContext context) {
    if (indexBool) {
    } else {
      var value = SynchronizePreferences.getCarMap();
      if (widget.serList != null) {
        //将存在的二级服务，展示出来
        if (value == null) {
        } else {
          if (value.containsKey('receiveCarServiceList')) {
            for (var j = 0; j < widget.serList.length; j++) {
              for (var h = 0; h < value['receiveCarServiceList'].length; h++) {
                if (value['receiveCarServiceList'][h]['serviceName'] ==
                    '其他配件项目') {
                } else {
                  elseBool = true;
                }
                if (value['receiveCarServiceList'][h]['serviceName'] ==
                    widget.serList[j]['dictName']) {
                  if (showValue.contains(j)) {
                  } else {
                    showValue.add(j);
                  }
                }
              }
            }
          }
        }
      }
    }

    return widget.serList == null
        ? Container()
        : Column(
            children: <Widget>[
// 全⻋车检查 保养⼿手册
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
                          width: 60,
                        ),
                        InkWell(
                          onTap: () {
                            if (widget.vehicleLicence == null) {
                              print('没有车牌号');
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Maintenance(
                                            showSure: '0',
                                            vehicleLicence:
                                                widget.vehicleLicence,
                                          ) //
                                      ));
                            }
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
                            if (widget.vehicleLicence == null) {
                              print('没有车牌号');
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllCheck(
                                            vehicleLicence:
                                                widget.vehicleLicence,
                                          )));
                            }
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
                        // Expanded(child: SizedBox()),
                        // Container(
                        //   child: Column(
                        //     children: <Widget>[
                        //       SizedBox(
                        //         height: 9,
                        //       ),
                        //       Image.asset(
                        //         'Assets/Home/toVip.png',
                        //         fit: BoxFit.fill,
                        //         width: 40,
                        //         height: 40,
                        //       ),
                        //       SizedBox(
                        //         height: 6,
                        //       ),
                        //       Align(
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           '成为会员',
                        //           style: TextStyle(
                        //               color: Colors.black, fontSize: 15),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          width: 60,
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
                height: 19,
              ),
//汽⻋车服务
              Container(
                child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      widget.serList == null ? 0 : widget.serList.length,
                      (index) => Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: <Widget>[
                            SizedBox(
                              width: 19,
                            ),
                            Image.asset(
                              'Assets/apointMent/apointcar.png',
                              width: 19,
                              height: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.serList[index]['dictName'].toString(),
                                style: TextStyle(
                                    color: Color.fromRGBO(39, 153, 93, 1),
                                    fontSize: 18),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                indexBool = true;
                                print('=====>$index');
                                setState(() {
                                  if (showValue.length == 0) {
                                    if (showValue.contains(index)) {
                                    } else {
                                      showValue.add(index);
                                    }
                                  } else {
                                    if (showValue.contains(index)) {
                                      showValue.remove(index);
                                      print('=====>1--$index--$showValue');
                                    } else {
                                      if (showValue.contains(index)) {
                                      } else {
                                        showValue.add(index);
                                      }
                                      print('=====>2');
                                    }
                                  }
                                  // var value =
                                  //     SynchronizePreferences.getCarMap();
                                  // if (widget.serList != null) {
                                  //   //将存在的二级服务，展示出来
                                  //   if (value == null) {
                                  //   } else {
                                  //     if (value.containsKey(
                                  //         'receiveCarServiceList')) {
                                  //       for (var h = 0;
                                  //           h <
                                  //               value['receiveCarServiceList']
                                  //                   .length;
                                  //           h++) {
                                  //         if (value['receiveCarServiceList'][h]
                                  //                 ['serviceName'] ==
                                  //             '其他配件项目') {
                                  //         } else {
                                  //           elseBool = true;
                                  //         }
                                  //       }
                                  //     }
                                  //   }
                                  // }

                                  // if (elseBool) {
                                  //   materInt = 0;
                                  // } else {
                                  //   widget.serList[index]['dictName'] ==
                                  //           '其他配件项目'
                                  //       ? showValue.contains(index)
                                  //           ? materInt = 1
                                  //           : materInt = 0
                                  //       : materInt = 2;
                                  // }
                                  widget.serList[index]['dictName'] == '其他配件项目'
                                      ? showValue.contains(index)
                                          ? materInt = 1
                                          : materInt = 0
                                      : materInt = 2;
                                });
                              },
                              child: Container(
                                width: 75,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(39, 153, 93, 1)),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    showValue.contains(index) ? '收起' : '添加',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          showValue.contains(index)
                              ? CarServeChildView(
                                  materInt: materInt,
                                  serviceList: widget.serList,
                                  indexs: index,
                                  shopId: shopId,
                                  brand: widget.brands,
                                  model: widget.models,
                                  serviceId:
                                      widget.serList[index]['id'].toString(),
                                  serviceName: widget.serList[index]['dictName']
                                      .toString(),
                                  onChanged: (value) {
                                    print('传到上一级的数据:$value');
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    )),
              ),
            ],
          );
  }
}
