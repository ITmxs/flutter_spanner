import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/pickingStaistics/apickingStaisticsApi.dart';
import 'package:spanners/spannerHome/pickingStaistics/pickingStaisticsAdd.dart';

class PickingPage extends StatefulWidget {
  final List<int> _showList = List();
  @override
  _PickingPageState createState() => _PickingPageState();
}

class _PickingPageState extends State<PickingPage> {
  int page = 1;
  bool showIn = true; //默认展示外部领料
  List recordsList = List(); //外部
  String key = ''; //搜索
  ScrollController scrollController = ScrollController();
  // ignore: missing_return
  int _comparayBool(int index) {
    for (var i = 0; i < widget._showList.length; i++) {
      if (widget._showList[i] == index) {
        print('=====================');
        return 1;
      }
    }
  }

  // 获取 外部 key 搜索value
  _getWaiList() {
    PackingDio.pickingListRequest(
      param: {'key': key, 'type': '', 'current': page, 'size': 10},
      onSuccess: (data) {
        setState(() {
          if (page == 1) {
            recordsList = data['records'];
          } else {
            if (data['records'].length == 0) {
              Alart.showAlartDialog('没有更多了', 1);
              return;
            }
            recordsList.addAll(data['records']);
          }
        });
      },
    );
  }

  // 获取 内部 key 搜索value
  _getNeiList() {
    PackingDio.pickingListNeiRequest(
      param: {'key': key, 'current': page, 'size': 10},
      onSuccess: (data) {
        setState(() {
          if (page == 1) {
            recordsList = data['records'];
          } else {
            if (data['records'].length == 0) {
              Alart.showAlartDialog('没有更多了', 1);
              return;
            }
            recordsList.addAll(data['records']);
          }
        });
      },
    );
  }

/*
下拉刷新
*/
  Future _toRefresh() async {
    page = 1;
    showIn ? _getWaiList() : _getNeiList();
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
        page++;
        showIn ? _getWaiList() : _getNeiList();
      }
    });
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
    _getWaiList();
    _loadMore();
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
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                //搜索
                Row(
                  children: [
                    SizedBox(
                      width: 23,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(238, 238, 238, 1),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: 33,
                            maxWidth: MediaQuery.of(context).size.width - 46),
                        child: TextFormField(
                          onFieldSubmitted: (value) {
                            showIn ? _getWaiList() : _getNeiList();
                          },
                          onChanged: (value) {
                            setState(() {
                              //搜索 值
                              key = value;
                              page = 1;
                            });
                          },
                          maxLines: 1,
                          style: TextStyle(fontSize: 13, color: Colors.black),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 20,
                              ),
                              onPressed: () {
                                //更���状态控制密码显示或隐藏
                                setState(() {
                                  showIn ? _getWaiList() : _getNeiList();
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20),
                            hintText: showIn ? '请搜索车牌号/手机号/人员' : '请搜索人员',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            fillColor: Color.fromRGBO(238, 238, 238, 1),
                            filled: true,
                            border: new OutlineInputBorder(
                                //添加边框
                                gapPadding: 10.0,
                                borderRadius: BorderRadius.circular(17.0),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 23,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                //外部领料  内部领料
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        setState(() {
                          page = 1;
                          showIn = true;
                          recordsList.clear();
                          _getWaiList();
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            '外部领料',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: showIn ? 16 : 15,
                                fontWeight: showIn ? FontWeight.bold : null),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 25,
                            height: 3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color: showIn
                                    ? Color.fromRGBO(39, 153, 93, 1)
                                    : Color.fromRGBO(255, 255, 255, 1)),
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        setState(() {
                          page = 1;
                          showIn = false;
                          recordsList.clear();
                          _getNeiList();
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            '内部领料',
                            style: TextStyle(
                              fontSize: showIn ? 15 : 16,
                              fontWeight: showIn ? null : FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 25,
                            height: 3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color: showIn
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(39, 153, 93, 1)),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
                showIn
                    ? Container()
                    : Column(
                        children: [
                          SizedBox(
                            height: 13,
                          ),
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                              GestureDetector(
                                onTap: () {
                                  page = 1;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddPicking())).then((value) =>
                                      showIn ? _getWaiList() : _getNeiList());
                                },
                                child: Container(
                                  width: 58,
                                  height: 26,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromRGBO(39, 153, 93, 1)),
                                  child: Text(
                                    '添加',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 24,
                              )
                            ],
                          )
                        ],
                      ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Expanded(child: list())
        ],
      ),
    );
  }

  list() {
    return RefreshIndicator(
        onRefresh: _toRefresh,
        child: isNull(recordsList) == 0
            ? ScrollConfiguration(
                behavior: NeverScrollBehavior(),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: ShowNullDataAlart(
                        alartText: '当前无数据',
                      ),
                    )
                  ],
                ))
            : ScrollConfiguration(
                behavior: NeverScrollBehavior(),
                child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: recordsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  children: [
                                    ///头部视图
                                    //收回展开
                                    Row(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color.fromRGBO(
                                                  39, 153, 93, 1),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      print(widget
                                                          ._showList.length);
                                                      if (widget._showList
                                                              .length ==
                                                          0) {
                                                        widget._showList
                                                            .add(index);
                                                        print(widget._showList);
                                                      } else {
                                                        _comparayBool(index) ==
                                                                1
                                                            ? widget._showList
                                                                .remove(index)
                                                            : widget._showList
                                                                .add(index);
                                                      }
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      _comparayBool(index) == 1
                                                          ? Image.asset(
                                                              'Assets/atwork/atowrkdown.png',
                                                              width: 17,
                                                              height: 10,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Image.asset(
                                                              'Assets/atwork/atworkup.png',
                                                              width: 17,
                                                              height: 10,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          showIn
                                                              ? recordsList[
                                                                      index][
                                                                  'vehicleLicence']
                                                              : recordsList[
                                                                      index]
                                                                  ['executor'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    //row list
                                    _comparayBool(index) == 1
                                        ? Container()
                                        :
                                        // 模块 个数
                                        ListView(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: List.generate(
                                              showIn
                                                  ? recordsList[index][
                                                          'receiveCarServiceList']
                                                      .length
                                                  : 1,
                                              (indext) => Column(
                                                children: [
                                                  //订单编号
                                                  showIn
                                                      ? indext == 0
                                                          ? Row(
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      30,
                                                                  color: Colors
                                                                      .white,
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                20,
                                                                          ),
                                                                          Text(
                                                                            '订单编号',
                                                                            style: TextStyle(
                                                                                color: Color.fromRGBO(38, 38, 38, 1),
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Expanded(
                                                                              child: SizedBox()),
                                                                          Text(
                                                                            recordsList[index]['orderSn'],
                                                                            style: TextStyle(
                                                                                color: Color.fromRGBO(38, 38, 38, 1),
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                20,
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width -
                                                                            30,
                                                                        height:
                                                                            10,
                                                                        color: Color.fromRGBO(
                                                                            238,
                                                                            238,
                                                                            238,
                                                                            1),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container()
                                                      : Container(),
                                                  //领料人员
                                                  showIn
                                                      ? Row(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  30,
                                                              color:
                                                                  Colors.white,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            3,
                                                                        height:
                                                                            14,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(
                                                                                2),
                                                                            color: Color.fromRGBO(
                                                                                39,
                                                                                153,
                                                                                93,
                                                                                1)),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        '领料人员',
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                38,
                                                                                38,
                                                                                38,
                                                                                1),
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              SizedBox()),
                                                                      Text(
                                                                        showIn
                                                                            ? recordsList[index]['receiveCarServiceList'][indext]['realName'] ??
                                                                                ''
                                                                            : '李明',
                                                                        style:
                                                                            TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              38,
                                                                              38,
                                                                              38,
                                                                              1),
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        30,
                                                                    height: 1,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            238,
                                                                            238,
                                                                            238,
                                                                            1),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(),
                                                  //领料状态
                                                  showIn
                                                      ? Row(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  30,
                                                              color:
                                                                  Colors.white,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            3,
                                                                        height:
                                                                            14,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(
                                                                                2),
                                                                            color: Color.fromRGBO(
                                                                                39,
                                                                                153,
                                                                                93,
                                                                                1)),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        '领料状态',
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                38,
                                                                                38,
                                                                                38,
                                                                                1),
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              SizedBox()),
                                                                      Text(
                                                                        recordsList[index]['receiveCarServiceList'][indext]['status'].toString() ==
                                                                                '6'
                                                                            ? '已领料'
                                                                            : '待领料',
                                                                        style:
                                                                            TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              38,
                                                                              38,
                                                                              38,
                                                                              1),
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        30,
                                                                    height: 1,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            238,
                                                                            238,
                                                                            238,
                                                                            1),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(),
                                                  //项目配件
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            30,
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                  width: 3,
                                                                  height: 14,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              2),
                                                                      color: Color.fromRGBO(
                                                                          39,
                                                                          153,
                                                                          93,
                                                                          1)),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  '项目配件',
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              38,
                                                                              38,
                                                                              38,
                                                                              1),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        SizedBox()),
                                                                Text(
                                                                  '数量',
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              38,
                                                                              38,
                                                                              38,
                                                                              1),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            // Container(
                                                            //   width: MediaQuery.of(
                                                            //               context)
                                                            //           .size
                                                            //           .width -
                                                            //       30,
                                                            //   height: 1,
                                                            //   color: Color.fromRGBO(
                                                            //       238, 238, 238, 1),
                                                            // )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //项目配件展示
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: showIn
                                                          ? recordsList[index][
                                                                          'receiveCarServiceList']
                                                                      [indext][
                                                                  'receiveCarMaterialList']
                                                              .length
                                                          : recordsList[index][
                                                                  'pickingGoodsList']
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int item) {
                                                        return Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                30,
                                                            color: Colors.white,
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 30,
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          140,
                                                                      child:
                                                                          Text(
                                                                        showIn
                                                                            ? recordsList[index]['receiveCarServiceList'][indext]['receiveCarMaterialList'][item]['itemMaterial'] +
                                                                                recordsList[index]['receiveCarServiceList'][indext]['receiveCarMaterialList'][item]['itemModel'] +
                                                                                recordsList[index]['receiveCarServiceList'][indext]['receiveCarMaterialList'][item]['spec']
                                                                            : recordsList[index]['pickingGoodsList'][item]['goodsName'],
                                                                        style:
                                                                            TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              38,
                                                                              38,
                                                                              38,
                                                                              1),
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            SizedBox()),
                                                                    Text(
                                                                      'x${showIn ? recordsList[index]['receiveCarServiceList'][indext]['receiveCarMaterialList'][item]['itemNumber'] : recordsList[index]['pickingGoodsList'][item]['count']}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            38,
                                                                            38,
                                                                            38,
                                                                            1),
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    )
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
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          60,
                                                                      height: 1,
                                                                      color: Color.fromRGBO(
                                                                          238,
                                                                          238,
                                                                          238,
                                                                          1),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ));
                                                      }),
                                                  //出库时间
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            30,
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                  width: 3,
                                                                  height: 14,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              2),
                                                                      color: Color.fromRGBO(
                                                                          39,
                                                                          153,
                                                                          93,
                                                                          1)),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  '出库时间',
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              38,
                                                                              38,
                                                                              38,
                                                                              1),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        SizedBox()),
                                                                Text(
                                                                  showIn
                                                                      ? recordsList[index]['receiveCarServiceList'][indext]['updateDate'] ==
                                                                              null
                                                                          ? '--'
                                                                          : recordsList[index]['receiveCarServiceList'][indext]
                                                                              [
                                                                              'updateDate']
                                                                      : recordsList[index]['createTime'] ==
                                                                              null
                                                                          ? '--'
                                                                          : recordsList[index]
                                                                              [
                                                                              'createTime'], // --
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            38,
                                                                            38,
                                                                            38,
                                                                            1),
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  30,
                                                              height: 1,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      238,
                                                                      238,
                                                                      238,
                                                                      1),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //记录人
                                                  showIn
                                                      ? Container()
                                                      : Row(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  30,
                                                              color:
                                                                  Colors.white,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            3,
                                                                        height:
                                                                            14,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(
                                                                                2),
                                                                            color: Color.fromRGBO(
                                                                                39,
                                                                                153,
                                                                                93,
                                                                                1)),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        '记录人',
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                38,
                                                                                38,
                                                                                38,
                                                                                1),
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width -
                                                                            70,
                                                                        child:
                                                                            Text(
                                                                          recordsList[index]
                                                                              [
                                                                              'recorder'],
                                                                          style:
                                                                              TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                38,
                                                                                38,
                                                                                38,
                                                                                1),
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        30,
                                                                    height: 10,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            238,
                                                                            238,
                                                                            238,
                                                                            1),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                  //领料原因
                                                  showIn
                                                      ? Container()
                                                      : Row(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  30,
                                                              color:
                                                                  Colors.white,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            3,
                                                                        height:
                                                                            14,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(
                                                                                2),
                                                                            color: Color.fromRGBO(
                                                                                39,
                                                                                153,
                                                                                93,
                                                                                1)),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        '领料原因',
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                38,
                                                                                38,
                                                                                38,
                                                                                1),
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width -
                                                                            70,
                                                                        child:
                                                                            Text(
                                                                          recordsList[index]['reason'] == null
                                                                              ? '未填领料原因'
                                                                              : recordsList[index]['reason'],
                                                                          style:
                                                                              TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                38,
                                                                                38,
                                                                                38,
                                                                                1),
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        30,
                                                                    height: 10,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            238,
                                                                            238,
                                                                            238,
                                                                            1),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
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
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    })));
  }
}
