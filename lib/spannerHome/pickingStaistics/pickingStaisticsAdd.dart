import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/atwork/atWorkRequestApi.dart';
import 'package:spanners/spannerHome/pickingStaistics/apickingStaisticsApi.dart';
import 'package:spanners/spannerHome/pickingStaistics/goodsList.dart';
import 'dart:convert' as convert;

class AddPicking extends StatefulWidget {
  @override
  _AddPickingState createState() => _AddPickingState();
}

class _AddPickingState extends State<AddPicking> {
  int number = 1;
  List goodsData = List();
  List peopleList = List();
  String names = ''; //员工名
  String userId = ''; //员工id
  String textinfo = ''; //记录
  Map upMap = Map();
  /* 获取 派工人员 列表*/
  _getPeopleList() {
    UntilApi.atworkPeopleRequest(
      onSuccess: (data) {
        peopleList = data;
      },
    );
  }

  // 获取 外部 key 搜索value
  _postData() {
    PackingDio.pickingSaveRequest(
      param: upMap,
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
    _getPeopleList();
    var mapstr = SynchronizePreferences.Get('userInfo');
    Map<String, dynamic> dataMap = convert.jsonDecode(mapstr);
    textinfo = dataMap['realName'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 1,
          title: Text(
            '领料管理',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 23,
                  ),
                  Text(
                    '内部领料单',
                    style: TextStyle(
                      color: Color.fromRGBO(39, 153, 93, 1),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 23,
                  ),
                  Text(
                    '添加商品',
                    style: TextStyle(
                      color: Color.fromRGBO(30, 30, 30, 1),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              /* 
          商品展示区域 
          */
              goodsData.length == 0 ? Container() : goodsList(),
              SizedBox(
                height: 21,
              ),
              //添加商品 按钮
              Row(
                children: [
                  SizedBox(
                    width: 23,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GoodsListPage(
                                    onChanged: (value) {
                                      setState(() {
                                        goodsData.addAll(value);
                                      });
                                    },
                                  )));
                    },
                    child: Text(
                      '添加商品+',
                      style: TextStyle(
                        color: Color.fromRGBO(39, 153, 93, 1),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              //领料人
              Row(
                children: [
                  SizedBox(
                    width: 23,
                  ),
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isDismissible: true,
                          enableDrag: false,
                          context: context,
                          builder: (BuildContext context) {
                            return new Container(
                              height: 300.0,
                              child: ShowBottomSheet(
                                type: 13,
                                dataList: peopleList,
                                onChanges: (name, id) {
                                  setState(() {
                                    names = name;
                                    userId = id;
                                    print('员工名$name,员工id$id');
                                    upMap['userId'] = userId;
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 46,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '领料人',
                              style: TextStyle(
                                color: Color.fromRGBO(30, 30, 30, 1),
                                fontSize: 15,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              names == '' ? '请选择' : names,
                              style: TextStyle(
                                color: names == ''
                                    ? Color.fromRGBO(168, 168, 168, 1)
                                    : Color.fromRGBO(30, 30, 30, 1),
                                fontSize: 14,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: names == ''
                                  ? Color.fromRGBO(168, 168, 168, 1)
                                  : Color.fromRGBO(30, 30, 30, 1),
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    width: 23,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              //领料原因
              Row(
                children: [
                  SizedBox(
                    width: 26,
                  ),
                  Text(
                    '领料原因',
                    style: TextStyle(
                      color: Color.fromRGBO(30, 30, 30, 1),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 11,
              ),
              //填写领料原因
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 30),
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                                hintText: '  请填写您需要备注的信息......',
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(164, 164, 164, 1),
                                    fontSize: 14),
                                border: new OutlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                              onChanged: (value) {
                                upMap['reason'] = value;
                              },
                            ))),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 27,
              ),
              //记录人
              Row(
                children: [
                  SizedBox(
                    width: 26,
                  ),
                  Text(
                    '记录人：$textinfo',
                    style: TextStyle(
                      color: Color.fromRGBO(30, 30, 30, 1),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 80,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (goodsData.length == 0) {
                      Alart.showAlartDialog('未添加商品', 1);
                      return;
                    }
                    if (userId == '') {
                      Alart.showAlartDialog('未选择领料人', 1);
                      return;
                    }
                    upMap['pickingGoodsList'] = goodsData;
                    upMap['recorder'] = textinfo;
                    _postData();
                  },
                  child: Container(
                    width: 105,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(39, 153, 93, 1)),
                    child: Text(
                      '确认出库',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 180,
              ),
            ],
          ),
        ));
  }

  //商品
  goodsList() {
    return ScrollConfiguration(
      behavior: NeverScrollBehavior(),
      child: ListView(
          shrinkWrap: true,
          children: List.generate(
              goodsData.length,
              (index) => InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                goodsData.removeAt(index);
                              });
                            },
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: Color.fromRGBO(255, 77, 76, 1),
                              size: 24,
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Container(
                            //height: 130,
                            width: MediaQuery.of(context).size.width - 30 - 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromRGBO(255, 255, 255, 1)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      width: 90,
                                      height: 90,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          goodsData[index]['img'],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 11,
                                    ),
                                    Expanded(
                                        child: Column(
                                      children: [
                                        Container(
                                          height: 35,
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              goodsData[index]['goodsName'],
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            goodsData[index]['applyTo'],
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  151, 151, 151, 1),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '库存数：${goodsData[index]['stock']}',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    151, 151, 151, 1),
                                                fontSize: 13,
                                              ),
                                            ),
                                            Expanded(child: SizedBox()),
                                            Container(
                                              width: 80,
                                              height: 22,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Color.fromRGBO(
                                                          229, 229, 229, 1))),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          number--;
                                                          if (number == 0) {
                                                            number = 1;
                                                          }
                                                          //服务项目封装上传数据
                                                          goodsData[index]
                                                                  ['count'] =
                                                              number;
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 20,
                                                        child: Text(
                                                          '-',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      41,
                                                                      39,
                                                                      39,
                                                                      1),
                                                              fontSize: 16),
                                                        ),
                                                      )),
                                                  Container(
                                                    width: 1,
                                                    color: Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                  ),
                                                  Container(
                                                    width: 30,
                                                    child: Text(
                                                      goodsData[index]['count']
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              41, 39, 39, 1),
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    color: Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          number++;
                                                          //服务项目封装上传数据
                                                          goodsData[index]
                                                                  ['count'] =
                                                              number;
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 20,
                                                        child: Text(
                                                          '+',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      41,
                                                                      39,
                                                                      39,
                                                                      1),
                                                              fontSize: 15),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          30 -
                                          30,
                                      height: 1,
                                      color: Color.fromRGBO(238, 238, 238, 1),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )))),
    );
  }
}
