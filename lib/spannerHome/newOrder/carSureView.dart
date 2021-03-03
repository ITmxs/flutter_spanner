import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/keyboardLimit.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/atwork/atWorkView.dart';
import 'package:spanners/spannerHome/newOrder/carARquestApi.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import './carSureUserMessage.dart';
import './carSureUserServe.dart';
import '../../publicView/pub_CostPriceView.dart';
import 'package:spanners/publicView/pud_permission.dart';

class CarSureView extends StatefulWidget {
  final Map dataMap;
  final int type;
  final Map vipMap;
  final int working; // ==1 施工过来的

  const CarSureView({
    Key key,
    this.dataMap,
    this.type,
    this.vipMap,
    this.working,
  }) : super(key: key);
  @override
  _CarSureViewState createState() => _CarSureViewState();
}

class _CarSureViewState extends State<CarSureView> {
  String prepaymentAmount = '';
  double totalAmounts = 0;
  Map pirceMap = Map();

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
            '接车确认',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                print('点击了返回');
                Navigator.pop(context);
              }),
        ),
        body: ScrollConfiguration(
            behavior: NeverScrollBehavior(),
            child: ListView(children: [
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 3,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      color: Color.fromRGBO(39, 153, 93, 1),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '用户信息',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //车辆信息
              // widget.type == 0
              //     ?
              CarSureUserMessage(
                vipMap: widget.vipMap,
                carMap: widget.dataMap,
                types: widget.type,
              ),
              // :
              // //会员
              // VipTopView(
              //     type: widget.type,
              //     vipMap: widget.vipMap,
              //   ),
              SizedBox(
                height: 24,
              ),
              //服务清单
              widget.dataMap.containsKey('receiveCarServiceList')
                  ? Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 3,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            color: Color.fromRGBO(39, 153, 93, 1),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '服务清单',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                        Expanded(child: SizedBox()),
                        InkWell(
                          onTap: () {
                            //做是否可以跳转 查看成本
                            print('查看成本-->${widget.dataMap}');
                            bool yeah = true;
                            // for (var i = 0;
                            //     i < widget.dataMap['receiveCarServiceList'].length;
                            //     i++) {
                            //   if (widget.dataMap['receiveCarServiceList'][i]
                            //       .containsKey('receiveCarMaterialList')) {
                            //     for (var l = 0;
                            //         l <
                            //             widget
                            //                 .dataMap['receiveCarServiceList'][i]
                            //                     ['receiveCarMaterialList']
                            //                 .length;
                            //         l++) {
                            //       // if (widget.dataMap['receiveCarServiceList'][i]
                            //       //             ['receiveCarMaterialList'][l]
                            //       //         ['partsSource'] ==
                            //       //     '1') {
                            //       //   // widget.dataMap['receiveCarServiceList'][i]
                            //       //   //         ['receiveCarMaterialList']
                            //       //   //     .removeAt(l);
                            //       // } else {
                            //       //   yeah = true;
                            //       // }
                            //     }
                            //     // if (pirceMap['receiveCarServiceList'][i]
                            //     //             ['receiveCarMaterialList']
                            //     //         .length >
                            //     //     0) {
                            //     //   yeah = true;
                            //     // }
                            //   }
                            //}
                            if (yeah) {
                              //权限处理 详细参考 后台Excel
                              PermissionApi.whetherContain(
                                      'receive_car_opt_view_price')
                                  ? print('')
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CostPriceView(
                                                dataMap: widget.dataMap,
                                              )));
                            } else {
                              Alart.showAlartDialog('无成本清单', 1);
                            }
                          },
                          child: Container(
                            width: 86,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color.fromRGBO(39, 153, 93, 1),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '查看成本',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    )
                  : Container(),
              widget.dataMap.containsKey('receiveCarServiceList')
                  ? SizedBox(
                      height: 10,
                    )
                  : SizedBox(
                      height: 0,
                    ),
              //服务清单
              widget.dataMap.containsKey('receiveCarServiceList')
                  ? CarSureUserServe(
                      onChanged: (value) {
                        totalAmounts = value;
                        print('回调消费金额$value');
                      },
                      serMap: widget.dataMap,
                    )
                  : Container(),

              SizedBox(
                height: 50,
              ),
              //定金金额
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 46,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                ' ',
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 42, 42, 1),
                                    fontSize: 15),
                              ),
                              Text(
                                '定金金额',
                                style: TextStyle(
                                    color: Color.fromRGBO(30, 30, 30, 1),
                                    fontSize: 15),
                              ),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight: 20, maxWidth: 100),
                                  child: TextFormField(
                                    onChanged: (value) {
                                      prepaymentAmount = value;
                                    },
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [KeyboardLimit(1)],
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                      hintText: '0',
                                      hintStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(164, 164, 164, 1),
                                          fontSize: 14),
                                      border: new OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    // keyboardType: TextInputType.multiline,
                                  ),
                                ),
                              )),
                              SizedBox(
                                width: 30,
                              )
                            ],
                          ),
                        ],
                      )),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 75,
              ),
              //按钮 点击  事件 区域   其中 2  是 按钮个数
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / (2 + 1) -
                        70 * 2 / (2 + 1),
                  ),
                  Expanded(
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(), //禁止滑动
                        itemCount: widget.working == 1 ? 2 : 3,
                        //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            //横轴元素个数
                            crossAxisCount: widget.working == 1 ? 2 : 3,
                            //纵轴间距
                            mainAxisSpacing: widget.working == 1 ? 30 : 10.0,
                            //横轴间距
                            crossAxisSpacing: widget.working == 1 ? 50 : 25,
                            //子组件宽高长度比例
                            childAspectRatio: 7 / 3.0),
                        itemBuilder: (BuildContext context, int index) {
                          //Widget Function(BuildContext context, int index)
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWell(
                                    onTap: () {
                                      if (prepaymentAmount == '') {
                                      } else if (prepaymentAmount
                                          .contains('.')) {
                                        if (double.parse(prepaymentAmount) >
                                            totalAmounts) {
                                          Alart.showAlartDialog(
                                              '定金金额不能超过消费金额', 1);
                                          return;
                                        }
                                      } else {
                                        if (int.parse(prepaymentAmount) >
                                            totalAmounts) {
                                          Alart.showAlartDialog(
                                              '定金金额不能超过消费金额', 1);
                                          return;
                                        }
                                      }
                                      if (prepaymentAmount == '') {
                                      } else {
                                        widget.dataMap['prepaymentAmount'] =
                                            prepaymentAmount;
                                      }
                                      widget.dataMap['totalAmounts'] =
                                          totalAmounts;
                                      if (index == 0) {
                                        widget.dataMap['statusFlag'] = '3';
                                        //报价 去接车看板
                                        RecCarDio.postNewOrderRequest(
                                          param: widget.dataMap,
                                          onSuccess: (data) {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ReceiveCar()));
                                            Navigator.pushNamed(
                                                context, '/rec');
                                            //返回时清除接车工单缓存
                                            SharedManager.removeString(
                                                'receiveCarServiceList');
                                            SharedManager.removeString(
                                                'upCarMap');
                                            SharedManager.removeString(
                                                'CommentUpmap');
                                          },
                                          onError: (error) {},
                                        );
                                      } else if (index == 1) {
                                        //派工 去派工
                                        widget.dataMap['statusFlag'] = '4';
                                        widget.working == 1
                                            ? RecCarDio.addNewOrderRequest(
                                                param: widget.dataMap,
                                                onSuccess: (data) {
                                                  //if (data == '添加成功') {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             ReceiveCar()));
                                                  // } else {
                                                  //   print('新建工单有问题');
                                                  // }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AtWorkView()));
                                                  //返回时清除接车工单缓存
                                                  SharedManager.removeString(
                                                      'receiveCarServiceList');
                                                  SharedManager.removeString(
                                                      'upCarMap');
                                                  SharedManager.removeString(
                                                      'CommentUpmap');
                                                },
                                                onError: (error) {},
                                              )
                                            : RecCarDio.postNewOrderRequest(
                                                param: widget.dataMap,
                                                onSuccess: (data) {
                                                  // if (data == '添加成功') {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AtWorkView()));
                                                  //返回时清除接车工单缓存
                                                  SharedManager.removeString(
                                                      'receiveCarServiceList');
                                                  SharedManager.removeString(
                                                      'upCarMap');
                                                  SharedManager.removeString(
                                                      'CommentUpmap');
                                                  //  } else {}
                                                },
                                                onError: (error) {
                                                  print('新建工单有问题');
                                                },
                                              );
                                      } else {
                                        //保存 去接车看板
                                        widget.working == 1
                                            ? print('')
                                            : widget.dataMap['statusFlag'] =
                                                '3';
                                        RecCarDio.postNewOrderRequest(
                                          param: widget.dataMap,
                                          onSuccess: (data) {
                                            //if (data == '添加成功') {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ReceiveCar()));
                                            // } else {
                                            //   print('新建工单有问题');
                                            // }
                                            Navigator.pushNamed(
                                                context, '/rec');
                                            //返回时清除接车工单缓存
                                            SharedManager.removeString(
                                                'receiveCarServiceList');
                                            SharedManager.removeString(
                                                'upCarMap');
                                            SharedManager.removeString(
                                                'CommentUpmap');
                                          },
                                          onError: (error) {},
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              Color.fromRGBO(39, 153, 93, 1)),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          index == 0
                                              ? '报价'
                                              : index == 1
                                                  ? '派工'
                                                  : '保存',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    width: 66,
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
            ])));
  }
}
