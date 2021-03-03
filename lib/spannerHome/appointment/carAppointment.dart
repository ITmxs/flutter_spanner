import 'package:flutter/material.dart';
import 'package:spanners/cModel/appointmentModel.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import './carAppointmentList.dart';
import './carAddAppointment.dart';
import './appointmentRequestApi.dart';

class CarAppoin extends StatefulWidget {
  final List<int> _showList = List();
  int page = 1;
  @override
  _CarAppoinState createState() => _CarAppoinState();
}

class _CarAppoinState extends State<CarAppoin> {
  var _dataList;
  int _nameValue;

  // ignore: missing_return
  int _comparayBool(int index) {
    for (var i = 0; i < widget._showList.length; i++) {
      if (widget._showList[i] == index) {
        print('=====================');
        return 1;
      }
    }
  }

/*  刷新 加载  操作  */
  ScrollController scrollController = ScrollController();
  String errors = '亲，当前数据为空呦~';
/*
下拉刷新
*/
  Future _toRefresh() async {
    _getListData(1);
    return null;
  }

/*
加载更多
*/
  _loadMore() {
    //滑动到底部监听
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        widget.page++;
        print('滑动到了最底部${scrollController.position.pixels}');
        _getListData(widget.page);
      }
    });
  }

  /*
  预约看板一览
  */
  _getListData(int page) async {
    ApiDio.appointRequest(onSuccess: (data) {
      setState(() {
        _dataList = data;
        print('--->$_dataList');
        _nameValue = _dataList == null ? 0 : _dataList.length;
      });
    }, onError: (error) {
      setState(() {
        //errors = error;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getListData(1);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
            backgroundColor: Color.fromRGBO(238, 238, 238, 1),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              // elevation: 0,
              brightness: Brightness.light,
              title: Text(
                '预约看板',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CarAddAppointment(
                                  onChanged: (value) {
                                    if (value == 1) {
                                      //页面返回时 刷新操作
                                      _getListData(1);
                                    }
                                  },
                                )));
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
            body: _dataList == null
                ? Container(
                    child: RefreshIndicator(
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        ShowNullDataAlart(
                          alartText: '当前没有预约订单～',
                        ),
                      ],
                    ),
                    onRefresh: _toRefresh,
                  ))
                : Container(
                    child: RefreshIndicator(
                        child: ScrollConfiguration(
                            behavior: NeverScrollBehavior(), child: list()),
                        onRefresh: _toRefresh))));
  }

  list() {
    return ListView(
      shrinkWrap: true,
      controller: scrollController,
      children: List.generate(
          _nameValue,
          (index) => InkWell(
                onTap: () {
                  setState(() {
                    print(widget._showList.length);
                    if (widget._showList.length == 0) {
                      widget._showList.add(index);
                      print(widget._showList);
                    } else {
                      _comparayBool(index) == 1
                          ? widget._showList.remove(index)
                          : widget._showList.add(index);
                    }
                  });
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 14,
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
                            color: Color.fromRGBO(39, 153, 93, 1),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppointTitleNameModel.fromJson(
                                          _dataList[index])
                                      .dictName
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppointTitleNameModel.fromJson(
                                                  _dataList[index])
                                              .appointmentVOList ==
                                          null
                                      ? '待接待0位'
                                      : '待接待${AppointTitleNameModel.fromJson(_dataList[index]).appointmentVOList.length.toString()}位',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 22,
                        ),
                      ],
                    ),
                    widget._showList.length == 0
                        ? CarAppointmentList(
                            onChanged: (value) {
                              if (value == 1) {
                                setState(() {
                                  _getListData(1);
                                });
                              }
                            },
                            data:
                                AppointTitleNameModel.fromJson(_dataList[index])
                                    .appointmentVOList,
                          )
                        : _comparayBool(index) == 1
                            ? Container()
                            : CarAppointmentList(
                                onChanged: (value) {
                                  if (value == 1) {
                                    setState(() {
                                      _getListData(1);
                                    });
                                  }
                                },
                                data: AppointTitleNameModel.fromJson(
                                        _dataList[index])
                                    .appointmentVOList,
                              ),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              )),
    );
  }
}
