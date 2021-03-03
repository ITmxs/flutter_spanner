import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/AfNetworking/requestDio.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/common/commonTools.dart';

import '../employeeRequestApi.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  //分组列表
  List groupData = [];

  //删除显示标志
  bool showDeleteFlag = false;

  @override
  void initState() {
    initData();
  }
  //初始化数据
  initData()  {
     EmployeeRequestApi.getGroupListRequest(
        param: {"": ""},
        onSuccess: (data) {
          groupData = data;
          for (int i = 0; i < groupData.length; i++) {
            groupData[i]["checkFlag"] = false;
          }
          for (int i = 0; i < groupData.length; i++) {
            if (groupData[i]["groupName"] == null) {
              groupData[i]["groupName"] = "未分组";
              Map tempList = groupData[i];
              groupData.removeAt(i);
              groupData.add(tempList);
            }
          }
          setState(() {});
        });
  }
  //删除分组
  deleteGroup() async {
    List deleteGroupId = [];
    for (int i = 0; i < groupData.length; i++) {
      if (groupData[i]["checkFlag"] == true && groupData[i]["groupId"] != null)
        deleteGroupId.add(groupData[i]["groupId"]);
    }
    if (deleteGroupId.isEmpty) return;
    print(deleteGroupId);
    //调试临时添加
    String url = "${DioUtils.baseURL}apiv2/employees/deleteGroup";
    ///创建Dio
    Dio dio = Dio();
    ///创建Map 封装参数
    Map<String, dynamic> map = Map();
    map['groupId'] = deleteGroupId;
    map['shopId'] = await SharedManager.getShopIdString();
    print(map);
    dio.interceptors.add(CookieManager((await Cook.cookieJar)));
    ///发起post请求
    Response response = await dio.post(url, data: map);
    var data = response.data;
    initData();
  }
  //全选
  allChoose() {
    for (int i = 0; i < groupData.length; i++) {
      groupData[i]["checkFlag"] = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.iconAppBar(context, "分组管理",
          rIcon: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 30.s, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    RouterUtil.push(context,routerName: "addGroup",pushThen:(value){
                      initData();
                      print("回调执行");
                    } );
                  },
                  child: Image.asset(
                    "Assets/employee/add.png",
                    width: 23.s,
                    height: 23.s,
                  ),
                ),
              ],
            ),
          )),
      body: Stack(
        children: [
         ScrollConfiguration(
            behavior: NeverScrollBehavior(),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDeleteFlag = !showDeleteFlag;
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 15.s, 30.s, 15.s),
                        child: CommonWidget.font(
                            text: showDeleteFlag?"完成":"编辑", fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 600.s,
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(15.s, 0, 15.s, 0),
                  child: Column(
                    children: [
                      Container(
                        width: 345.s,
                        child: Column(
                          children: [
                            CommonWidget.simpleList(
                                onTapCheck: (flag, index) {
                                  groupData[index]["checkFlag"] = flag;
                                  print(groupData);
                                  setState(() {});
                                },
                                keyList: [
                                  for (int i = 0; i < groupData.length; i++)
                                    '${groupData[i]["groupName"]}'
                                ],
                                valueList: [
                                  for (int i = 0; i < groupData.length; i++)
                                    '${groupData[i]["peopleNum"]}'
                                ],
                                valueColor: Color.fromRGBO(165, 165, 165, 1),
                                mustFlag: false,
                                chooseFlag: showDeleteFlag,
                                chooseFlagList: [
                                  for (int i = 0; i < groupData.length; i++)
                                    groupData[i]["checkFlag"],
                                ],
                            bottomLineFlag: true)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: showDeleteFlag,
            child: Positioned(
              bottom: 0,
              child: Container(
                width: 375.s,
                height: 85.s,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(25.s, 15.s, 30.s, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        allChoose();
                      },
                      child: CommonWidget.font(text: "全选"),
                    ),
                    GestureDetector(
                      onTap: () {
                        deleteGroup();
                      },
                      child: CommonWidget.customButton(
                          text: "删除",
                          width: 90.s,
                          height: 30.s,
                          textColor: Colors.white,
                          buttonColor: Color.fromRGBO(255, 77, 76, 1)),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
