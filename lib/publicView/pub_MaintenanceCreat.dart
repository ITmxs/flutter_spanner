import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spanners/cModel/pubModel.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/publicView/pub_ApiDio.dart';
import 'package:spanners/publicView/pub_Maintenance.dart';

class MaintenanceCareat extends StatefulWidget {
  final String workOrderId;

  const MaintenanceCareat({Key key, this.workOrderId}) : super(key: key);
  @override
  _MaintenanceCareatState createState() => _MaintenanceCareatState();
}

class _MaintenanceCareatState extends State<MaintenanceCareat> {
  List selectSer = List(); //选中服务
  Map selectMater = Map(); //选中配件
  List dataList = List(); //
  List loadList = List(); //传输 数据list
  Map map = Map();
  //  获取保养手册 list
  _getMaintenanceSerList() {
    PubDio.pubMainterRequest(
      param: widget.workOrderId,
      onSuccess: (data) {
        setState(() {
          dataList = data;
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
    _getMaintenanceSerList();
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
              // shrinkWrap: true,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(children: [
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
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromRGBO(39, 153, 93, 1),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 17,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  dataList[0]['vehicleLicence'],
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              )
                            ],
                          ),
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                            dataList.length,
                            (indexs) => Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
//服务项目
                                      SizedBox(
                                        height: 5,
                                      ),
                                      //判断二级服务项目 是否为空
                                      // AtworkTwoModel.fromJson(datas[index]
                                      //                 ['itemTypeList'][indexs])
                                      //             .secondaryService
                                      //             .toString() ==
                                      //         ''
                                      //     ? Container()
                                      //     :
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 32,
                                          ),
                                          Container(
                                            width: 3,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              color: Color.fromRGBO(
                                                  39, 153, 93, 1),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '服务项目',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      38, 38, 38, 1),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
//二级服务
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      /*
                                                单选添加服务项目 
                                                */
                                                      setState(() {
                                                        selectSer.contains(
                                                                indexs)
                                                            ? selectSer
                                                                .remove(indexs)
                                                            : selectSer
                                                                .add(indexs);

                                                        map['serviceName'] =
                                                            PublicMainfenceSerModel
                                                                    .fromJson(
                                                                        dataList[
                                                                            indexs])
                                                                .secondaryService;
                                                        map['receiveTime'] =
                                                            PublicMainfenceSerModel
                                                                    .fromJson(
                                                                        dataList[
                                                                            indexs])
                                                                .receiveTime;
                                                        map['vehicleLicence'] =
                                                            PublicMainfenceSerModel
                                                                    .fromJson(
                                                                        dataList[
                                                                            0])
                                                                .vehicleLicence;
                                                        map['workOrderId'] =
                                                            PublicMainfenceSerModel
                                                                    .fromJson(
                                                                        dataList[
                                                                            0])
                                                                .workOrderId;
                                                        map['type'] = '0';

                                                        if (loadList.length >
                                                            0) {
                                                          if (loadList.contains(
                                                              json
                                                                  .encode(map)
                                                                  .toString())) {
                                                            loadList.remove(json
                                                                .encode(map)
                                                                .toString());
                                                          } else {
                                                            loadList.add(json
                                                                .encode(map)
                                                                .toString());
                                                          }
                                                        } else {
                                                          loadList.add(json
                                                              .encode(map)
                                                              .toString());
                                                        }
                                                      });
                                                    },
                                                    child: Icon(
                                                      selectSer.contains(indexs)
                                                          ? Icons
                                                              .check_circle_outline
                                                          : Icons
                                                              .panorama_fish_eye,
                                                      color: Color.fromRGBO(
                                                          112, 112, 112, 1),
                                                      size: 20,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      PublicMainfenceSerModel
                                                              .fromJson(
                                                                  dataList[
                                                                      indexs])
                                                          .secondaryService,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            38, 38, 38, 1),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 39,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    30 -
                                                    39,
                                                height: 1,
                                                color: Color.fromRGBO(
                                                    234, 234, 234, 1),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),

//配件
                                      SizedBox(
                                        height: 5,
                                      ),
                                      //判断是否 有配件
                                      isNull(dataList[indexs]
                                                  ['receiveCarMaterialList']) ==
                                              0
                                          ? Container()
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  width: 32,
                                                ),
                                                Container(
                                                  width: 3,
                                                  height: 14,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    color: Color.fromRGBO(
                                                        39, 153, 93, 1),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '配件',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            38, 38, 38, 1),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
//服务 配件 选择   用于派工
                                      ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                          dataList[indexs]
                                                  ['receiveCarMaterialList']
                                              .length,
                                          (indexes) => Column(
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          /*
                                                      单选添加服务项目 
                                                    */

                                                          setState(() {
                                                            if (selectMater
                                                                .containsKey(
                                                                    '$indexs')) {
                                                              if (selectMater[
                                                                      '$indexs']
                                                                  .contains(
                                                                      indexes)) {
                                                                selectMater[
                                                                        '$indexs']
                                                                    .remove(
                                                                        indexes);
                                                              } else {
                                                                selectMater[
                                                                        '$indexs']
                                                                    .add(
                                                                        indexes);
                                                              }
                                                            } else {
                                                              selectMater[
                                                                  '$indexs'] = [
                                                                indexes
                                                              ];
                                                            }
                                                            print(selectMater);

                                                            //配件数据添加

                                                            map['serviceName'] =
                                                                PublicMainfenceMaterialModel.fromJson(dataList[indexs]
                                                                            [
                                                                            'receiveCarMaterialList']
                                                                        [
                                                                        indexes])
                                                                    .itemMaterial;

                                                            map['receiveTime'] =
                                                                PublicMainfenceSerModel
                                                                        .fromJson(
                                                                            dataList[indexs])
                                                                    .receiveTime;
                                                            map['vehicleLicence'] =
                                                                PublicMainfenceSerModel
                                                                        .fromJson(
                                                                            dataList[0])
                                                                    .vehicleLicence;
                                                            map['workOrderId'] =
                                                                PublicMainfenceSerModel
                                                                        .fromJson(
                                                                            dataList[0])
                                                                    .workOrderId;
                                                            map['type'] = '1';

                                                            if (loadList
                                                                    .length >
                                                                0) {
                                                              if (loadList
                                                                  .contains(json
                                                                      .encode(
                                                                          map)
                                                                      .toString())) {
                                                                loadList.remove(json
                                                                    .encode(map)
                                                                    .toString());
                                                              } else {
                                                                loadList.add(json
                                                                    .encode(map)
                                                                    .toString());
                                                              }
                                                            } else {
                                                              loadList.add(json
                                                                  .encode(map)
                                                                  .toString());
                                                            }
                                                          });
                                                        },
                                                        child: Icon(
                                                          selectMater
                                                                  .containsKey(
                                                                      '$indexs')
                                                              ? selectMater[
                                                                          '$indexs']
                                                                      .contains(
                                                                          indexes)
                                                                  ? Icons
                                                                      .check_circle_outline
                                                                  : Icons
                                                                      .panorama_fish_eye
                                                              : Icons
                                                                  .panorama_fish_eye,
                                                          color: Color.fromRGBO(
                                                              112, 112, 112, 1),
                                                          size: 20,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          PublicMainfenceMaterialModel
                                                                  .fromJson(dataList[
                                                                              indexs]
                                                                          [
                                                                          'receiveCarMaterialList']
                                                                      [indexes])
                                                              .itemMaterial,
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    38,
                                                                    38,
                                                                    38,
                                                                    1),
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    width: indexes == 2 - 1
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            30 -
                                                            8 -
                                                            8
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            30 -
                                                            39 -
                                                            8,
                                                    height: indexes == 2 - 1
                                                        ? isNull(dataList[
                                                                        indexs][
                                                                    'receiveCarMaterialList']) ==
                                                                0
                                                            ? 0
                                                            : 5
                                                        : 1,
                                                    color: Color.fromRGBO(
                                                        234, 234, 234, 1),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ]),
                Column(
                  children: [
                    SizedBox(
                      height: 46,
                    ),
                    InkWell(
                      onTap: () {
                        if (loadList.length > 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Maintenance(
                                        paramList: loadList,
                                        showSure: '1',
                                      )));
                        }
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
              ],
            ),
    );
  }
}
