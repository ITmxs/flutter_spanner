import 'package:flutter/material.dart';
import 'package:spanners/cModel/pubModel.dart';
import 'package:spanners/publicView/pub_ApiDio.dart';

class CostPriceView extends StatefulWidget {
  final String workOrderId;
  final Map dataMap;
  const CostPriceView({Key key, this.workOrderId, this.dataMap})
      : super(key: key);
  @override
  _CostPriceViewState createState() => _CostPriceViewState();
}

class _CostPriceViewState extends State<CostPriceView>
    with SingleTickerProviderStateMixin {
  bool isActive = false;
  List showList = List();
  List dioDataList = List();
  double sums = 0; // 本地计算总和
  double width = 0;
  double summation = 0; // 接口获取计算总和
  //单算总价
  double _getSumPrice(String count, String price) {
    var c = double.parse(count);
    var p = double.parse(price);
    var s = c * p;
    sums = sums + s;
    return s;
  }

  //  成本总价
  String _getAllPrice(String count, String price) {
    var c = int.parse(count);
    var p = double.parse(price);
    var s = c * p;

    return '¥$s';
  }

  //通过接口 获取的 成本清单
  _getCostList() {
    PubDio.pubCostRequest(
        param: widget.workOrderId,
        onSuccess: (data) {
          setState(() {
            dioDataList = data;
            for (var i = 0; i < dioDataList.length; i++) {
              summation += dioDataList[i]['summation'];
            }
          });
        });
  }

  //通过 本地数据 组装的 成本清单
  _getShareCostList() {
    setState(() {
      for (var i = 0; i < widget.dataMap['receiveCarServiceList'].length; i++) {
        if (widget.dataMap['receiveCarServiceList'][i]['receiveCarMaterialList']
                .length >
            0) {
          //   for (int l = 0;
          //       l <
          //           widget
          //               .dataMap['receiveCarServiceList'][i]
          //                   ['receiveCarMaterialList']
          //               .length;
          //       l++) {
          //     if (widget.dataMap['receiveCarServiceList'][i]
          //             ['receiveCarMaterialList'][l]['partsSource'] ==
          //         '1') {
          //     } else {
          //       dioDataList.add(widget.dataMap['receiveCarServiceList'][i]);
          //     }
          //   }
          dioDataList.add(widget.dataMap['receiveCarServiceList'][i]);
        } else {
          print(widget
              .dataMap['receiveCarServiceList'][i]['receiveCarMaterialList']
              .length);
        }
      }
      //dioDataList = widget.dataMap['receiveCarServiceList'];
    });
  }

  //初始化数据
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 判断走接口还是本地
    if (widget.workOrderId == null) {
      _getShareCostList();
    } else {
      _getCostList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text('查看成本',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: dioDataList == null
            ? Container()
            : Column(
                children: [
                  SizedBox(
                    height: 22,
                  ),
                  //服务清单
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
                        '成本清单',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        textAlign: TextAlign.left,
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                              dioDataList.length,
                              (index) => Container(
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white),
                                    child: Column(
                                      children: [
                                        ListView(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            children: List.generate(
                                                widget.workOrderId == null
                                                    ? dioDataList[index]
                                                            .containsKey(
                                                                'receiveCarMaterialList')
                                                        ?
                                                        // dioDataList[index][
                                                        //                 'receiveCarMaterialList']
                                                        //             .length >
                                                        //         0
                                                        //     ?
                                                        dioDataList[index][
                                                                    'receiveCarMaterialList']
                                                                .length +
                                                            1
                                                        // : 0
                                                        : 0
                                                    :
                                                    //接口获取成本
                                                    1 +
                                                        dioDataList[index]
                                                                ['costList']
                                                            .length,
                                                (indexs) => InkWell(
                                                    onTap: () {},
                                                    child: Stack(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child: //服务  清单  列表
                                                              Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 1,
                                                                child:
                                                                    Container(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          238,
                                                                          238,
                                                                          238,
                                                                          1),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap:
                                                                        () {},
                                                                    child: Container(
                                                                        width: MediaQuery.of(context).size.width / 5 - 30 / 5,
                                                                        height: 40,
                                                                        child: Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Expanded(
                                                                              child: Align(
                                                                                alignment: Alignment.center,
                                                                                child: Text(
                                                                                  indexs == 0
                                                                                      ? '名称'
                                                                                      : widget.workOrderId == null
                                                                                          ?
                                                                                          //本地处理成本清单
                                                                                          PublicShareCostListModel.fromJson(dioDataList[index]['receiveCarMaterialList'][indexs - 1]).name
                                                                                          :
                                                                                          //接口获取成本
                                                                                          PublicCostListModel.fromJson(dioDataList[index]['costList'][indexs - 1]).name,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(color: indexs == 0 ? Color.fromRGBO(0, 0, 0, 1) : Color.fromRGBO(39, 153, 93, 1), fontSize: 12),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )),
                                                                  ),
                                                                  //
                                                                  Container(
                                                                    width: MediaQuery.of(context).size.width /
                                                                            5 -
                                                                        30 / 5,
                                                                    height: 40,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        indexs ==
                                                                                0
                                                                            ? '规格'
                                                                            : widget.workOrderId == null
                                                                                ?
                                                                                //本地处理成本清单
                                                                                PublicShareCostListModel.fromJson(dioDataList[index]['receiveCarMaterialList'][indexs - 1]).spec
                                                                                :
                                                                                //接口获取成本
                                                                                PublicCostListModel.fromJson(dioDataList[index]['costList'][indexs - 1]).spec,
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                1),
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  //
                                                                  Container(
                                                                    width: MediaQuery.of(context).size.width /
                                                                            5 -
                                                                        30 / 5,
                                                                    height: 40,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        indexs ==
                                                                                0
                                                                            ? '成本'
                                                                            : widget.workOrderId == null
                                                                                ?
                                                                                //本地处理成本清单
                                                                                PublicShareCostListModel.fromJson(dioDataList[index]['receiveCarMaterialList'][indexs - 1]).cost == 'null'
                                                                                    ? '¥' + '0'
                                                                                    : '¥' + PublicShareCostListModel.fromJson(dioDataList[index]['receiveCarMaterialList'][indexs - 1]).cost
                                                                                :
                                                                                //接口获取成本
                                                                                '¥' + PublicCostListModel.fromJson(dioDataList[index]['costList'][indexs - 1]).cost,
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                1),
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  //
                                                                  Container(
                                                                    width: MediaQuery.of(context).size.width /
                                                                            5 -
                                                                        30 / 5,
                                                                    height: 40,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        indexs ==
                                                                                0
                                                                            ? '数量'
                                                                            : widget.workOrderId == null
                                                                                ?
                                                                                //本地处理成本清单
                                                                                'x${PublicShareCostListModel.fromJson(dioDataList[index]['receiveCarMaterialList'][indexs - 1]).number}'
                                                                                :
                                                                                //接口获取成本
                                                                                'x' + PublicCostListModel.fromJson(dioDataList[index]['costList'][indexs - 1]).number.toString(),
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                1),
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  //
                                                                  Container(
                                                                    width: MediaQuery.of(context).size.width /
                                                                            5 -
                                                                        30 / 5,
                                                                    height: 40,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        indexs ==
                                                                                0
                                                                            ? '总成本'
                                                                            : widget.workOrderId == null
                                                                                ?
                                                                                //本地处理成本清单
                                                                                '¥' + _getSumPrice(PublicShareCostListModel.fromJson(dioDataList[index]['receiveCarMaterialList'][indexs - 1]).number, PublicShareCostListModel.fromJson(dioDataList[index]['receiveCarMaterialList'][indexs - 1]).cost == 'null' ? '0' : PublicShareCostListModel.fromJson(dioDataList[index]['receiveCarMaterialList'][indexs - 1]).cost).toString()
                                                                                :
                                                                                //接口获取成本
                                                                                '¥' + PublicCostListModel.fromJson(dioDataList[index]['costList'][indexs - 1]).totalCost,
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                1),
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // 点击 展示 配件 详细
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child:
                                                              AnimatedContainer(
                                                            curve: Curves
                                                                .linearToEaseOut,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    1000),
                                                            width: indexs == 0
                                                                ? 60
                                                                : showList.length ==
                                                                        0
                                                                    ? 60
                                                                    : showList[0] ==
                                                                            index
                                                                        ? showList[1] ==
                                                                                indexs
                                                                            ? isActive
                                                                                ? 200
                                                                                : 60
                                                                            : 60
                                                                        : 60,
                                                            decoration: BoxDecoration(
                                                                color: indexs == 0
                                                                    ? Colors.transparent
                                                                    : showList.length == 0
                                                                        ? Colors.transparent
                                                                        : showList[0] == index
                                                                            ? showList[1] == indexs
                                                                                ? isActive
                                                                                    ? Color.fromRGBO(39, 153, 93, 1)
                                                                                    : Colors.transparent
                                                                                : Colors.transparent
                                                                            : Colors.transparent,
                                                                borderRadius: BorderRadius.circular(5)),
                                                            onEnd: () {},
                                                            child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  sums = 0;
                                                                  if (showList
                                                                          .length >
                                                                      0) {
                                                                    showList
                                                                        .clear();
                                                                  } else {
                                                                    showList = [
                                                                      index,
                                                                      indexs
                                                                    ];
                                                                  }
                                                                  isActive =
                                                                      !isActive;
                                                                });
                                                              },
                                                              child: Container(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 40,
                                                                height: 40,
                                                                child: indexs ==
                                                                        0
                                                                    ? Container()
                                                                    : showList.length ==
                                                                            0
                                                                        ? Container()
                                                                        : showList[0] ==
                                                                                index
                                                                            ? showList[1] == indexs
                                                                                ? Row(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.close,
                                                                                        color: Colors.white,
                                                                                        size: 20,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Expanded(
                                                                                          child: Align(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: Text(
                                                                                          widget.workOrderId == null ? PublicShareCostListModel.fromJson(dioDataList[index]['receiveCarMaterialList'][indexs - 1]).name + '/' + PublicShareCostListModel.fromJson(dioDataList[index]['receiveCarMaterialList'][indexs - 1]).spec : PublicCostListModel.fromJson(dioDataList[index]['costList'][indexs - 1]).name + '/' + PublicCostListModel.fromJson(dioDataList[index]['costList'][indexs - 1]).spec,
                                                                                          maxLines: 2,
                                                                                          softWrap: false,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                                                                        ),
                                                                                      )),
                                                                                    ],
                                                                                  )
                                                                                : Container()
                                                                            : Container(),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )))),
                                        SizedBox(
                                          height: 10,
                                          child: Container(
                                            color: Color.fromRGBO(
                                                238, 238, 238, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
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
                  //消费金额
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
                        '成本合计',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        textAlign: TextAlign.left,
                      ),
                      Expanded(child: SizedBox()),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.workOrderId == null
                              ? '¥' + sums.toString()
                              : '¥' + summation.toString(),
                          style: TextStyle(
                              color: Color.fromRGBO(255, 51, 51, 1),
                              fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          height: 30,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(39, 153, 93, 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('确定',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          )),
                    ),
                  )
                ],
              ));
  }
}
