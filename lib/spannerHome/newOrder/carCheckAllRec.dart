import 'package:flutter/material.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/imageChange.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/newOrder/carARquestApi.dart';
import 'package:spanners/spannerHome/receiveCar/receiveCar.dart';
import 'package:spanners/talkingOnline/about/imageView.dart';

class CheckAllRec extends StatefulWidget {
  final String grandId;
  final String vehicleLicence;

  const CheckAllRec({Key key, this.grandId, this.vehicleLicence})
      : super(key: key);
  @override
  _CheckAllRecState createState() => _CheckAllRecState();
}

class _CheckAllRecState extends State<CheckAllRec> {
  //必须维修项目与建议维修项目 选中
  Map indexMap = Map();
  //上传数据
  Map serMap = Map();
  List serlist = List();
  bool allBool = false;
  int a;
  int b;
  int sum;
  //获取的map
  Map dataMap = Map();
  List mustServiceList = List();
  List mustCheck = List();
  List recommendServiceList = List();
  List recommendCheck = List();
  static Future _showAlartDialog(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowAlart(
          backLart: 1,
          title: message,
        );
      },
    );
  }

  //获取 信息
  _getCheckMessage() {
    RecCarDio.getCheckMessageRequest(
      param: {
        'grandId': widget.grandId,
        'vehicleLicence': widget.vehicleLicence,
      },
      onSuccess: (data) {
        setState(() {
          dataMap = data;
          mustServiceList = data['mustServiceList'];
          mustCheck = data['mustCheck'];
          recommendServiceList = data['recommendServiceList"'];
          recommendCheck = data['recommendCheck'];
          recommendServiceList == null
              ? a = 0
              : a = recommendServiceList.length;
          mustServiceList == null ? b = 0 : b = mustServiceList.length;
          sum = b + a;
        });
      },
    );
  }

//创建接车单
  _creatReciveMenu() {
    RecCarDio.postCheckMenuRequest(
      param: {'vehicleLicence': widget.vehicleLicence, 'serviceList': serlist},
      onSuccess: (data) {
        if (data) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ReceiveCar()));
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCheckMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text('全车检查',
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
        body: dataMap.length == 0
            ? Container()
            : ScrollConfiguration(
                behavior: NeverScrollBehavior(),
                child: ScrollConfiguration(
                  behavior: NeverScrollBehavior(),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      //维修项目列表
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
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 17,
                                ),
                                Text(
                                  '维修项目列表',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                mustServiceList.length == 0
                                    ? Container()
                                    : Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            '必须维修项目',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(child: SizedBox()),
                                          InkWell(
                                            onTap: () {
                                              /*
                                   全选处理
                                  */
                                              setState(() {
                                                allBool
                                                    ? allBool = false
                                                    : allBool = true;
                                                if (allBool) {
                                                  //全部选中
                                                  indexMap.clear();
                                                  serlist.clear();

                                                  for (var i = 0; i < b; i++) {
                                                    if (indexMap
                                                        .containsKey('0')) {
                                                      indexMap['0'].add(i);
                                                    } else {
                                                      indexMap['0'] = [i];
                                                    }
                                                    //添加必须服务
                                                    Map map = Map();
                                                    map['serviceName'] =
                                                        mustServiceList[i]
                                                            ['serviceName'];
                                                    map['serviceId'] =
                                                        mustServiceList[i]
                                                            ['serviceId'];
                                                    map['secondaryService'] =
                                                        mustServiceList[i][
                                                            'secondaryService'];
                                                    map['secondaryId'] =
                                                        mustServiceList[i]
                                                            ['secondaryId'];
                                                    serlist.add(map);
                                                  }

                                                  for (var i = 0; i < a; i++) {
                                                    if (indexMap
                                                        .containsKey('1')) {
                                                      indexMap['1'].add(i);
                                                    } else {
                                                      indexMap['1'] = [i];
                                                    }
                                                    //添加建议服务
                                                    Map map = Map();
                                                    map['serviceName'] =
                                                        recommendServiceList[i]
                                                            ['serviceName'];
                                                    map['serviceId'] =
                                                        recommendServiceList[i]
                                                            ['serviceId'];
                                                    map['secondaryService'] =
                                                        recommendServiceList[i][
                                                            'secondaryService'];
                                                    map['secondaryId'] =
                                                        recommendServiceList[i]
                                                            ['secondaryId'];
                                                    serlist.add(map);
                                                  }
                                                } else {
                                                  //全部删除 服务
                                                  indexMap.clear();
                                                  serlist.clear();
                                                }
                                              });
                                            },
                                            child: Icon(
                                              allBool
                                                  ? Icons.check_circle_outline
                                                  : Icons.panorama_fish_eye,
                                              color: Color.fromRGBO(
                                                  112, 112, 112, 1),
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '全选',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 26,
                                          )
                                        ],
                                      ),
                                SizedBox(
                                  height: 20,
                                ),
                                //必须维修项目
                                mustServiceList == null
                                    ? Container()
                                    : ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                            mustServiceList.length,
                                            (index) => Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            /*
                                                 单选添加服务项目
                                                */
                                                            setState(() {
                                                              if (indexMap
                                                                  .containsKey(
                                                                      '0')) {
                                                                if (indexMap[
                                                                        '0']
                                                                    .contains(
                                                                        index)) {
                                                                  indexMap['0']
                                                                      .remove(
                                                                          index);
                                                                  allBool =
                                                                      false;
                                                                  // 删除服务 操作
                                                                  serlist
                                                                      .removeAt(
                                                                          index);
                                                                } else {
                                                                  indexMap['0']
                                                                      .add(
                                                                          index);
                                                                  // 添加服务 操作
                                                                  Map map =
                                                                      Map();
                                                                  map['serviceName'] =
                                                                      mustServiceList[
                                                                              index]
                                                                          [
                                                                          'serviceName'];
                                                                  map['serviceId'] =
                                                                      mustServiceList[
                                                                              index]
                                                                          [
                                                                          'serviceId'];
                                                                  map['secondaryService'] =
                                                                      mustServiceList[
                                                                              index]
                                                                          [
                                                                          'secondaryService'];
                                                                  map['secondaryId'] =
                                                                      mustServiceList[
                                                                              index]
                                                                          [
                                                                          'secondaryId'];
                                                                  serlist
                                                                      .add(map);
                                                                }
                                                                //判断丹铅是否都选中了
                                                                if (indexMap
                                                                    .containsKey(
                                                                        '1')) {
                                                                  int sum = indexMap[
                                                                              '0']
                                                                          .length +
                                                                      indexMap[
                                                                              '1']
                                                                          .length;
                                                                  if (sum ==
                                                                      (3 + 2)) {
                                                                    allBool =
                                                                        true;
                                                                  }
                                                                }
                                                              } else {
                                                                indexMap['0'] =
                                                                    [index];
                                                                Map map = Map();
                                                                map['serviceName'] =
                                                                    mustServiceList[
                                                                            index]
                                                                        [
                                                                        'serviceName'];
                                                                map['serviceId'] =
                                                                    mustServiceList[
                                                                            index]
                                                                        [
                                                                        'serviceId'];
                                                                map['secondaryService'] =
                                                                    mustServiceList[
                                                                            index]
                                                                        [
                                                                        'secondaryService'];
                                                                map['secondaryId'] =
                                                                    mustServiceList[
                                                                            index]
                                                                        [
                                                                        'secondaryId'];
                                                                serlist
                                                                    .add(map);
                                                              }
                                                            });
                                                          },
                                                          child: Icon(
                                                            indexMap.containsKey(
                                                                    '0')
                                                                ? indexMap['0']
                                                                        .contains(
                                                                            index)
                                                                    ? Icons
                                                                        .check_circle_outline
                                                                    : Icons
                                                                        .panorama_fish_eye
                                                                : Icons
                                                                    .panorama_fish_eye,
                                                            color:
                                                                Color.fromRGBO(
                                                                    112,
                                                                    112,
                                                                    112,
                                                                    1),
                                                            size: 20,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2 -
                                                              40 / 2 -
                                                              30 / 2,
                                                          height: 30,
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
                                                                      0.1)),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  mustServiceList[
                                                                          index]
                                                                      [
                                                                      'serviceName'],
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              52,
                                                                              52,
                                                                              52,
                                                                              1),
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2 -
                                                              40 / 2 -
                                                              30 / 2,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      5),
                                                              border: Border.all(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          39,
                                                                          153,
                                                                          93,
                                                                          0.1),
                                                                  width: 1.0),
                                                              color:
                                                                  Colors.white),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  mustServiceList[
                                                                          index]
                                                                      [
                                                                      'secondaryService'],
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              52,
                                                                              52,
                                                                              52,
                                                                              1),
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                )),
                                      ),
                                SizedBox(
                                  height: 20,
                                ),
                                //建议维修项目
                                recommendServiceList == null
                                    ? Container()
                                    : Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            '建议维修项目',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // Expanded(child: SizedBox()),
                                          // InkWell(
                                          //   onTap: () {
                                          //     /*
                                          //       单选添加服务项目
                                          //     */
                                          //     setState(() {});
                                          //   },
                                          //   child: Icon(
                                          //     // selectSer.contains(indexs)
                                          //     //     ? Icons
                                          //     //         .check_circle_outline
                                          //     //     :
                                          //     Icons.panorama_fish_eye,
                                          //     color: Color.fromRGBO(112, 112, 112, 1),
                                          //     size: 20,
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   width: 5,
                                          // ),
                                          // Align(
                                          //   alignment: Alignment.centerLeft,
                                          //   child: Text(
                                          //     '全选',
                                          //     style: TextStyle(
                                          //         color: Colors.black,
                                          //         fontSize: 15,
                                          //         fontWeight: FontWeight.bold),
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   width: 26,
                                          // )
                                        ],
                                      ),
                                recommendServiceList == null
                                    ? Container()
                                    : ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                            recommendServiceList.length,
                                            (index) => Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            /*
                                            单选添加服务项目
                                            */
                                                            setState(() {
                                                              if (indexMap
                                                                  .containsKey(
                                                                      '1')) {
                                                                if (indexMap[
                                                                        '1']
                                                                    .contains(
                                                                        index)) {
                                                                  indexMap['1']
                                                                      .remove(
                                                                          index);
                                                                  allBool =
                                                                      false;
                                                                } else {
                                                                  indexMap['1']
                                                                      .add(
                                                                          index);
                                                                }
                                                                //判断丹铅是否都选中了
                                                                if (indexMap
                                                                    .containsKey(
                                                                        '0')) {
                                                                  int sum = indexMap[
                                                                              '0']
                                                                          .length +
                                                                      indexMap[
                                                                              '1']
                                                                          .length;
                                                                  if (sum ==
                                                                      (3 + 2)) {
                                                                    allBool =
                                                                        true;
                                                                  }
                                                                }
                                                              } else {
                                                                indexMap['1'] =
                                                                    [index];
                                                              }
                                                            });
                                                          },
                                                          child: Icon(
                                                            indexMap.containsKey(
                                                                    '1')
                                                                ? indexMap['1']
                                                                        .contains(
                                                                            index)
                                                                    ? Icons
                                                                        .check_circle_outline
                                                                    : Icons
                                                                        .panorama_fish_eye
                                                                : Icons
                                                                    .panorama_fish_eye,
                                                            color:
                                                                Color.fromRGBO(
                                                                    112,
                                                                    112,
                                                                    112,
                                                                    1),
                                                            size: 20,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2 -
                                                              40 / 2 -
                                                              30 / 2,
                                                          height: 30,
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
                                                                      0.1)),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  recommendServiceList[
                                                                          index]
                                                                      [
                                                                      'serviceName'],
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              52,
                                                                              52,
                                                                              52,
                                                                              1),
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2 -
                                                              40 / 2 -
                                                              30 / 2,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      5),
                                                              border: Border.all(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          39,
                                                                          153,
                                                                          93,
                                                                          0.1),
                                                                  width: 1.0),
                                                              color:
                                                                  Colors.white),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  recommendServiceList[
                                                                          index]
                                                                      [
                                                                      'secondaryService'],
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              52,
                                                                              52,
                                                                              52,
                                                                              1),
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                )),
                                      ),

                                Column(
                                  children: [
                                    SizedBox(
                                      height: 41,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (serlist.length == 0) {
                                          _showAlartDialog('请选择服务');
                                        } else {
                                          _creatReciveMenu();
                                        }
                                      },
                                      child: Container(
                                        width: 135,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Color.fromRGBO(39, 153, 93, 1),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '自动生成接车单',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //车辆检查单 展示
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
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(child: SizedBox()),
                                    Text(
                                      '', //2020/08/17
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(145, 145, 145, 1),
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                Text(
                                  '车辆检查单',
                                  style: TextStyle(
                                      color: Color.fromRGBO(10, 10, 10, 1),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '全车检查共包含${dataMap['inspectionCount']}项，正常项目${dataMap['inspectionCount'] - sum}项',
                                      style: TextStyle(
                                          color: Color.fromRGBO(12, 12, 12, 1),
                                          fontSize: 15),
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
                                      width: MediaQuery.of(context).size.width -
                                          60,
                                      height: 1,
                                      color: Color.fromRGBO(238, 238, 238, 1),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 19,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '$sum 项异常，具体形况如下',
                                      style: TextStyle(
                                          color: Color.fromRGBO(255, 77, 76, 1),
                                          fontSize: 15),
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
                                      width: MediaQuery.of(context).size.width -
                                          60,
                                      height: 1,
                                      color: Color.fromRGBO(238, 238, 238, 1),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                //必须维修项目
                                mustCheck == null
                                    ? Container()
                                    : Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            '必须维修项目',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    12, 12, 12, 1),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                mustCheck == null
                                    ? Container()
                                    : SizedBox(
                                        height: 35,
                                      ),
                                mustCheck == null
                                    ? Container()
                                    : ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                            mustCheck.length,
                                            (index) => Container(
                                                  child: Column(
                                                    children: [
                                                      //
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              mustCheck[index][
                                                                  'inspectionItem'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 50,
                                                          ),
                                                          Expanded(
                                                              child: Container(
                                                            width: 96,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                mustCheck[index]
                                                                    [
                                                                    'checkStandard'],
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
//-->   不良    做 添加  操作
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Container(
                                                              width: 40,
                                                              height: 28,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            238,
                                                                            238,
                                                                            238,
                                                                            0),
                                                                    width: 1.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        255,
                                                                        219,
                                                                        219,
                                                                        1),
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  '不良',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            77,
                                                                            76,
                                                                            1),
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
//-->  不良   做 删除  操作

                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                        ],
                                                      ),

                                                      SizedBox(
                                                        height: 25,
                                                      ),
                                                      //补充说明
                                                      Stack(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(
                                                                16,
                                                                0,
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    30 -
                                                                    40 -
                                                                    16,
                                                                0),
                                                            child: mustCheck[
                                                                            index]
                                                                        [
                                                                        'type'] ==
                                                                    0
                                                                ? Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: 40,
                                                                    height: 20,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        color: Color.fromRGBO(
                                                                            255,
                                                                            183,
                                                                            0,
                                                                            1)),
                                                                    child: Text(
                                                                      '建议',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              1),
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  )
                                                                :
                                                                //用户根据不同 展示不同
                                                                Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: 40,
                                                                    height: 20,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        color: Color.fromRGBO(
                                                                            255,
                                                                            77,
                                                                            76,
                                                                            1)),
                                                                    child: Text(
                                                                      '必须',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              1),
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(68, 0,
                                                                    61, 0),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  129 -
                                                                  30,
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  mustCheck[
                                                                          index]
                                                                      [
                                                                      'remark'],
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              10,
                                                                              10,
                                                                              10,
                                                                              1)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      mustCheck[index]
                                                                  ['imgList'] ==
                                                              null
                                                          ? Container()
                                                          : SizedBox(
                                                              height: 25,
                                                            ),
                                                      //照片区域
                                                      mustCheck[index]
                                                                  ['imgList'] ==
                                                              null
                                                          ? Container()
                                                          : Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Expanded(
                                                                  child: GridView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: new NeverScrollableScrollPhysics(), //禁止滑动
                                                                      itemCount: mustCheck[index]['imgList'] == null ? 0 : mustCheck[index]['imgList'].length, //
                                                                      //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                          //横轴元素个数
                                                                          crossAxisCount: 4,
                                                                          //纵轴间距
                                                                          mainAxisSpacing: 10.0,
                                                                          //横轴间距
                                                                          crossAxisSpacing: 15.0,
                                                                          //子组件宽高长度比例
                                                                          childAspectRatio: 1.0),
                                                                      itemBuilder: (BuildContext context, int indexs) {
                                                                        //Widget Function(BuildContext context, int index)
                                                                        return InkWell(
                                                                          onTap:
                                                                              () {
                                                                            //_takePhoto();
                                                                            setState(() {
                                                                              Navigator.of(context).push(FadeRoute(
                                                                                  page: PhotoViewSimpleScreen(
                                                                                imageProvider: NetworkImage(mustCheck[index]['imgList'][indexs]),
                                                                                heroTag: 'simple',
                                                                              )));
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 3 - 50 / 3,
                                                                            height:
                                                                                MediaQuery.of(context).size.width / 3 - 50 / 3,
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Padding(
                                                                                        padding: EdgeInsets.all(0),
                                                                                        child: ConstrainedBox(
                                                                                          constraints: BoxConstraints.expand(),
                                                                                          child: Image.network(
                                                                                            mustCheck[index]['imgList'][indexs],
                                                                                            fit: BoxFit.fill,
                                                                                          ),
                                                                                        )),
                                                                                  ],
                                                                                )),
                                                                          ),
                                                                        );
                                                                      }),
                                                                ),
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                              ],
                                                            ),
                                                      Container(
                                                          height: 1,
                                                          color: Color.fromRGBO(
                                                              238,
                                                              238,
                                                              238,
                                                              1)),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                      ),
                                //建议维修项目
                                SizedBox(
                                  height: 30,
                                ),
                                //建议维修项目
                                recommendCheck == null
                                    ? Container()
                                    : Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            '建议维修项目',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    12, 12, 12, 1),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                recommendCheck == null
                                    ? Container()
                                    : SizedBox(
                                        height: 35,
                                      ),
                                recommendCheck == null
                                    ? Container()
                                    : ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                            recommendCheck.length,
                                            (index) => Container(
                                                  child: Column(
                                                    children: [
                                                      //
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              recommendCheck[
                                                                      index][
                                                                  'inspectionItem'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 50,
                                                          ),
                                                          Expanded(
                                                              child: Container(
                                                            width: 96,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                recommendCheck[
                                                                        index][
                                                                    'checkStandard'],
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
//-->   不良    做 添加  操作
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Container(
                                                              width: 40,
                                                              height: 28,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            238,
                                                                            238,
                                                                            238,
                                                                            0),
                                                                    width: 1.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        255,
                                                                        219,
                                                                        219,
                                                                        1),
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  '不良',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            77,
                                                                            76,
                                                                            1),
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
//-->  不良   做 删除  操作

                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                        ],
                                                      ),

                                                      SizedBox(
                                                        height: 25,
                                                      ),
                                                      //补充说明
                                                      Stack(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(
                                                                16,
                                                                0,
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    30 -
                                                                    40 -
                                                                    16,
                                                                0),
                                                            child: recommendCheck[
                                                                            index]
                                                                        [
                                                                        'type'] ==
                                                                    0
                                                                ? Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: 40,
                                                                    height: 20,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        color: Color.fromRGBO(
                                                                            255,
                                                                            183,
                                                                            0,
                                                                            1)),
                                                                    child: Text(
                                                                      '建议',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              1),
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  )
                                                                :
                                                                //用户根据不同 展示不同
                                                                Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: 40,
                                                                    height: 20,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        color: Color.fromRGBO(
                                                                            255,
                                                                            77,
                                                                            76,
                                                                            1)),
                                                                    child: Text(
                                                                      '必须',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              1),
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(68, 0,
                                                                    61, 0),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  129 -
                                                                  30,
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  recommendCheck[index]
                                                                              [
                                                                              'remark'] ==
                                                                          null
                                                                      ? ''
                                                                      : recommendCheck[
                                                                              index]
                                                                          [
                                                                          'remark'],
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              10,
                                                                              10,
                                                                              10,
                                                                              1)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    75,
                                                                0,
                                                                16,
                                                                0),
                                                            child: Image.asset(
                                                              '',
                                                              width: 19,
                                                              height: 19,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      recommendCheck[index]
                                                                  ['imgList'] ==
                                                              null
                                                          ? Container()
                                                          : SizedBox(
                                                              height: 25,
                                                            ),
                                                      //照片区域
                                                      recommendCheck[index]
                                                                  ['imgList'] ==
                                                              null
                                                          ? Container()
                                                          : Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Expanded(
                                                                  child: GridView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: new NeverScrollableScrollPhysics(), //禁止滑动
                                                                      itemCount: recommendCheck[index]['imgList'] == null ? 0 : mustCheck[index]['imgList'].length, //
                                                                      //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                          //横轴元素个数
                                                                          crossAxisCount: 4,
                                                                          //纵轴间距
                                                                          mainAxisSpacing: 10.0,
                                                                          //横轴间距
                                                                          crossAxisSpacing: 15.0,
                                                                          //子组件宽高长度比例
                                                                          childAspectRatio: 1.0),
                                                                      itemBuilder: (BuildContext context, int indexs) {
                                                                        //Widget Function(BuildContext context, int index)
                                                                        return InkWell(
                                                                          onTap:
                                                                              () {
                                                                            //_takePhoto();
                                                                            setState(() {
                                                                              Navigator.of(context).push(FadeRoute(
                                                                                  page: PhotoViewSimpleScreen(
                                                                                imageProvider: NetworkImage(recommendCheck[index]['imgList'][indexs]),
                                                                                heroTag: 'simple',
                                                                              )));
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 3 - 50 / 3,
                                                                            height:
                                                                                MediaQuery.of(context).size.width / 3 - 50 / 3,
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Padding(
                                                                                        padding: EdgeInsets.all(0),
                                                                                        child: ConstrainedBox(
                                                                                          constraints: BoxConstraints.expand(),
                                                                                          child: Image.network(
                                                                                            recommendCheck[index]['imgList'][indexs],
                                                                                            fit: BoxFit.fill,
                                                                                          ),
                                                                                        )),
                                                                                  ],
                                                                                )),
                                                                          ),
                                                                        );
                                                                      }),
                                                                ),
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                              ],
                                                            ),
                                                      Container(
                                                          height: 1,
                                                          color: Color.fromRGBO(
                                                              238,
                                                              238,
                                                              238,
                                                              1)),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                )),
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
                  ),
                )));
  }
}
