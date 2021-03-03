import 'package:flutter/material.dart';
import 'package:spanners/cModel/homeModel.dart';
import 'package:spanners/cTools/callIphone.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'dart:convert' as convert;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:spanners/spannerHome/homeRequestApi.dart';

class WarningPage extends StatefulWidget {
  final List warningList;

  const WarningPage({Key key, this.warningList}) : super(key: key);
  @override
  _WarningPageState createState() => _WarningPageState();
}

class _WarningPageState extends State<WarningPage> {
  var _dataModel;
  String location = '';
  List _msWarniingList;
  /*
  首页信息获取  dio
  */
  _getHomeLoading() async {
    HomeDio.homeRequest(
        param: {
          'shopId': await SharedManager.getString('shopId'),
          'userId': await SharedManager.getString('userid'),
        },
        onSuccess: (data) {
          setState(() {
            _dataModel = HomeWorkModel.fromJson(data);
            _msWarniingList = _dataModel.mstWarningEntities;
            print('智能提醒' + '$_msWarniingList');
          });
        },
        onError: (error) {});
  }

  /*
 删除只能提醒
 */
  _deleteWaring(String id) {
    HomeDio.deleteWarning(
        param: {'id': id},
        onSuccess: (data) {
          _getHomeLoading();
        });
  }

/*
下拉刷新
*/
  Future _toRefresh() async {
    _getHomeLoading();
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _msWarniingList = widget.warningList;
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
          '智能提醒',
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
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: RefreshIndicator(
                    onRefresh: _toRefresh,
                    child: ListView.builder(
                        shrinkWrap: true,
                        //禁止滑动
                        itemCount: _msWarniingList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(), //滑出选项的面板 动画
                            actionExtentRatio: 0.25,
                            child: listView(index),
                            secondaryActions: <Widget>[
                              //右侧按钮列表
                              GestureDetector(
                                onTap: () {
                                  _deleteWaring(_msWarniingList[index]['id']);
                                },
                                child: Container(
                                  width: 102,
                                  height: 102,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black54),
                                  child: Text(
                                    '删 除',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          );
                        })),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          )
        ],
      ),
    );
  }

  listView(int index) {
    return Column(children: [
      Container(
        margin: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black54,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0,
                spreadRadius: 1.0)
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '  ${WarningModel.fromJson(_msWarniingList[index]).userName.toString()}   ${WarningModel.fromJson(_msWarniingList[index]).vehicleLicence.toString()}',
                style: TextStyle(
                    color: Color.fromRGBO(70, 70, 70, 1),
                    fontSize: 15,
                    fontFamily: 'PingFang SC Medium'),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
                onTap: () {
                  CallIphone.callPhone(
                      WarningModel.fromJson(_msWarniingList[index])
                          .moblie
                          .toString());
                },
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '  ${WarningModel.fromJson(_msWarniingList[index]).moblie.toString()}',
                        style: TextStyle(
                            color: Color.fromRGBO(39, 153, 93, 1),
                            fontSize: 15,
                            fontFamily: 'PingFang SC Medium'),
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '  ${WarningModel.fromJson(_msWarniingList[index]).commont.toString()}',
                    style: TextStyle(
                        color: Color.fromRGBO(70, 70, 70, 1),
                        fontSize: 16,
                        fontFamily: 'PingFang SC Bold'),
                  ),
                ),
                Expanded(child: SizedBox()),
                GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 60,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(39, 153, 93, 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '去提醒',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'PingFang SC Bold'),
                        ),
                      ),
                    )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      // SizedBox(
      //   height: 10,
      // ),
    ]);
  }
}
