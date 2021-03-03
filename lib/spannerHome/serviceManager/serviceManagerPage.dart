import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/appointment/appointmentRequestApi.dart';
import 'package:spanners/spannerHome/serviceManager/serviceApiRequst.dart';
import 'package:spanners/spannerHome/serviceManager/serviceEditPage.dart';

class ServiceManagePage extends StatefulWidget {
  @override
  _ServiceManagePageState createState() => _ServiceManagePageState();
}

class _ServiceManagePageState extends State<ServiceManagePage> {
  int selectIndex = 0; //siwtch
  //搜索有无结果
  bool serchBool = false;
  //服务性质  服务状态
  int shareIndex = 0;
  int openIndex = 0;
  //一二级总 数据
  List projectList = List();
  //二级 数据 集
  List secondryList = List();
  Map selectMap = Map();

  TextEditingController textController = TextEditingController();

  /*  获取一二级分类 */
  _getTypeList() {
    ApiDio.getServiceDict(
      pragm: {'flag': '0'},
      onSuccess: (data) {
        setState(() {
          for (var i = 0; i < data.length; i++) {
            if (data[i]['dictName'] == '其他配件项目') {
              data.removeAt(i);
            }
          }
          projectList = data;

          secondryList = projectList[selectIndex]['secondaryList'];
          //展示 按钮状态
          for (var i = 0; i < projectList.length; i++) {
            for (var j = 0; j < projectList[i]['secondaryList'].length; j++) {
              if (projectList[i]['secondaryList'][j]['delFlag'] == 1) {
                if (selectMap.containsKey(i.toString())) {
                  if (selectMap[i.toString()].contains(j)) {
                  } else {
                    //做 添加  操作
                    selectMap[i.toString()].add(j);
                  }
                } else {
                  //做 添加  操作
                  selectMap[i.toString()] = [j];
                }
              }
            }
          }
        });
      },
    );
  }

  /*  搜索 */
  _serch(String key) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (key == '') {
      serchBool = false;
      _getTypeList();
    } else {
      setState(() {
        ServiceApi.serchServiceListRequest(
            param: {'secondaryDictName': key},
            onSuccess: (data) {
              print(data);
              if (data == null) {
                print('搜索结果为空');
                serchBool = false;
              } else {
                serchBool = true;
                secondryList = data;
              }
            });
      });
    }
  }

  //筛选组合 二级服务
  _recombinationList() {
    List addlist = List();
    if (shareIndex == 0) {
      addlist = projectList[selectIndex]['secondaryList'];
    }
    if (shareIndex == 1) {
      //共享
      for (var i = 0;
          i < projectList[selectIndex]['secondaryList'].length;
          i++) {
        if (projectList[selectIndex]['secondaryList'][i]['isShare'] == 1) {
          addlist.add(projectList[selectIndex]['secondaryList'][i]);
        }
      }
    }
    if (shareIndex == 2) {
      //未共享
      for (var i = 0;
          i < projectList[selectIndex]['secondaryList'].length;
          i++) {
        if (projectList[selectIndex]['secondaryList'][i]['isShare'] != 1) {
          addlist.add(projectList[selectIndex]['secondaryList'][i]);
        }
      }
    }
    List openlist = List();
    openlist.addAll(addlist);
    if (openIndex == 0) {}
    if (openIndex == 1) {
      openlist.clear();
      //开启
      for (var i = 0; i < addlist.length; i++) {
        if (addlist[i]['delFlag'] == 0) {
          openlist.add(addlist[i]);
        }
      }
    }
    if (openIndex == 2) {
      openlist.clear();
      //关闭
      for (var i = 0; i < addlist.length; i++) {
        if (addlist[i]['delFlag'] == 1) {
          openlist.add(addlist[i]);
        }
      }
    }
    openlist.length > 0 ? secondryList = openlist : secondryList = openlist;
  }

  bool _returnOff(int index) {
    if (selectMap.containsKey(selectIndex.toString())) {
      if (selectMap[selectIndex.toString()].contains(index)) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
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
    _getTypeList();
  }

//开启关闭
  _open(Map upMap, int item) {
    ServiceApi.isOpenRequest(
      param: upMap,
      onSuccess: (data) {
        setState(() {
          _change(upMap, item);
        });
      },
    );
  }

  _change(Map value, int item) {
    if (value['delFlag'] == 0) {
      // 为 false 做 删除操作
      if (selectMap.containsKey(selectIndex.toString())) {
        if (selectMap[selectIndex.toString()].contains(item)) {
          //做 删除  操作
          selectMap[selectIndex.toString()].remove(item);
        }
      }
    } else {
      // 为 true 做 添加操作
      if (selectMap.containsKey(selectIndex.toString())) {
        if (selectMap[selectIndex.toString()].contains(item)) {
        } else {
          selectMap[selectIndex.toString()].add(item);
        }
      } else {
        selectMap[selectIndex.toString()] = [item];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        centerTitle: true,
        title: Text('服务管理',
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
        actions: [
          InkWell(
            onTap: () {
              //权限处理 详细参考 后台Excel
              PermissionApi.whetherContain('service_management_opt')
                  ? print('')
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServiceEditePage(
                                title: '添加服务',
                              ))).then((value) => _getTypeList());
            },
            child: Image.asset(
              'Assets/Home/appointadd.png',
              width: 26,
              height: 26,
            ),
          ),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
//搜索
          Container(
              color: Color.fromRGBO(255, 255, 255, 1),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 22,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width - 44,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(238, 238, 238, 1)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: TextField(
                                    controller: textController,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    onEditingComplete: () {
                                      _serch(textController.text);
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                        hintText: '快速搜索',
                                        hintStyle: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromRGBO(10, 10, 10, 1))),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _serch(textController.text);
                                },
                                child: Image.asset(
                                  "Assets/members/search.png",
                                  width: 17,
                                  height: 17,
                                ),
                              ),
                              SizedBox(
                                width: 22,
                              ),
                            ],
                          )),
                      SizedBox(
                        width: 22,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
//分类子项
          serchBool
              ? Container()
              : isNull(projectList) == 0
                  ? Container()
                  : Container(
                      height: 55,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      child: ScrollConfiguration(
                        behavior: NeverScrollBehavior(),
                        child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                                projectList.length,
                                (index) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectIndex = index;
                                        shareIndex = 0;
                                        openIndex = 0;
                                        secondryList = projectList[selectIndex]
                                            ['secondaryList'];
                                      });
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 18,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  projectList[index]['dictName']
                                                      .toString(),
                                                  style: selectIndex == index
                                                      ? TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)
                                                      : TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                        ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          selectIndex == index
                                              ? Container(
                                                  width: 50,
                                                  height: 3,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                      color: Color.fromRGBO(
                                                          39, 153, 93, 1)),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    )))),
                      )),
          SizedBox(
            height: 1,
          ),

//筛选
          serchBool
              ? Container()
              : Container(
                  height: 65,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '服务性质',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      shareIndex = 0;
                                      _recombinationList();
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    width:
                                        (MediaQuery.of(context).size.width / 2 -
                                                15 -
                                                21) /
                                            3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: shareIndex == 0
                                            ? Color.fromRGBO(233, 245, 238, 1)
                                            : Color.fromRGBO(238, 238, 238, 1)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '全部',
                                        style: TextStyle(
                                            color: shareIndex == 0
                                                ? Color.fromRGBO(39, 153, 93, 1)
                                                : Color.fromRGBO(67, 67, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      shareIndex = 1;
                                      _recombinationList();
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    width:
                                        (MediaQuery.of(context).size.width / 2 -
                                                15 -
                                                21) /
                                            3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: shareIndex == 1
                                            ? Color.fromRGBO(233, 245, 238, 1)
                                            : Color.fromRGBO(238, 238, 238, 1)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '已共享',
                                        style: TextStyle(
                                            color: shareIndex == 1
                                                ? Color.fromRGBO(39, 153, 93, 1)
                                                : Color.fromRGBO(67, 67, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      shareIndex = 2;
                                      _recombinationList();
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    width:
                                        (MediaQuery.of(context).size.width / 2 -
                                                15 -
                                                21) /
                                            3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: shareIndex == 2
                                            ? Color.fromRGBO(233, 245, 238, 1)
                                            : Color.fromRGBO(238, 238, 238, 1)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '未共享',
                                        style: TextStyle(
                                            color: shareIndex == 2
                                                ? Color.fromRGBO(39, 153, 93, 1)
                                                : Color.fromRGBO(67, 67, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '服务状态',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      openIndex = 0;
                                      _recombinationList();
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    width:
                                        (MediaQuery.of(context).size.width / 2 -
                                                15 -
                                                21) /
                                            3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: openIndex == 0
                                            ? Color.fromRGBO(233, 245, 238, 1)
                                            : Color.fromRGBO(238, 238, 238, 1)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '全部',
                                        style: TextStyle(
                                            color: openIndex == 0
                                                ? Color.fromRGBO(39, 153, 93, 1)
                                                : Color.fromRGBO(67, 67, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      openIndex = 1;
                                      _recombinationList();
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    width:
                                        (MediaQuery.of(context).size.width / 2 -
                                                15 -
                                                21) /
                                            3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: openIndex == 1
                                            ? Color.fromRGBO(233, 245, 238, 1)
                                            : Color.fromRGBO(238, 238, 238, 1)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '开启',
                                        style: TextStyle(
                                            color: openIndex == 1
                                                ? Color.fromRGBO(39, 153, 93, 1)
                                                : Color.fromRGBO(67, 67, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      openIndex = 2;
                                      _recombinationList();
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    width:
                                        (MediaQuery.of(context).size.width / 2 -
                                                15 -
                                                21) /
                                            3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: openIndex == 3
                                            ? Color.fromRGBO(233, 245, 238, 1)
                                            : Color.fromRGBO(238, 238, 238, 1)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '未开启',
                                        style: TextStyle(
                                            color: openIndex == 2
                                                ? Color.fromRGBO(39, 153, 93, 1)
                                                : Color.fromRGBO(67, 67, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
//项目列表展示区域
          SizedBox(
            height: 10,
          ),
          isNull(projectList) == 0
              ? Container()
              : Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: MediaQuery.of(context).size.height -
                          16 -
                          MediaQuery.of(context).padding.top -
                          56 -
                          75 -
                          100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: secondryList.length,
                          itemBuilder: (BuildContext context, int item) {
                            return InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 23,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Container(
                                        width: 120,
                                        child: Text(
                                            secondryList[item]
                                                    ['secondaryDictName']
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15)),
                                      ),
                                      Expanded(child: SizedBox()),
                                      //开关
                                      CupertinoSwitch(
                                        value: _returnOff(item),
                                        activeColor:
                                            Color.fromRGBO(39, 153, 93, 1),
                                        onChanged: (bool value) {
                                          setState(() {
                                            print(value);

                                            Map map = Map();
                                            map['id'] = secondryList[item]['id']
                                                .toString();
                                            map['delFlag'] = value ? 0 : 1;
                                            //权限处理 详细参考 后台Excel
                                            PermissionApi.whetherContain(
                                                    'service_management_opt')
                                                ? print('')
                                                : _open(map, item);
                                          });
                                        },
                                      ),

                                      SizedBox(
                                        width: 25,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ServiceEditePage(
                                                        title: '服务详情',
                                                        dictId:
                                                            secondryList[item]
                                                                    ['id']
                                                                .toString(),
                                                      ))).then(
                                              (value) => _getTypeList());
                                        },
                                        child: Text(
                                          '详细',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  39, 153, 93, 1),
                                              fontSize: 13),
                                        ),
                                      ),

                                      SizedBox(
                                        width: 15,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 18,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                48,
                                        height: 1,
                                        color: Color.fromRGBO(238, 238, 238, 1),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
