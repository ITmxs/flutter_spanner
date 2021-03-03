import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spanners/cModel/spannerHelpModel.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/callIphone.dart';
import 'package:spanners/cTools/imageChange.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/spannerHelp.dart/aaspannerHelpApi.dart';
import 'package:spanners/spannerHome/spannerHelp.dart/amapGD.dart';
import 'package:spanners/talkingOnline/about/imageView.dart';
// import 'package:getuiflut/getuiflut.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  bool showIn = true; //默认展示 待处理
  List dataList = List();
  String type = '0'; //默认 待处理
  int page = 1;
  ScrollController scrollController = ScrollController();

  //获取列表   type 跟 status 不一样
  _getList(String status) {
    //0 待处理 1 已处理
    AescueDio.rescueListRequest(
      param: {'status': status, 'current': page, 'size': 10},
      onSuccess: (data) {
        setState(() {
          if (page == 1) {
            dataList = data['list'];
          } else {
            if (data['list'].length == 0) {
              Alart.showAlartDialog('没有更多了', 1);
            } else {
              dataList.addAll(data['list']);
            }
          }
        });
      },
    );
  }

  //更新
  _updata(String status, id) {
    // 1 已处理  2 一救援  3 已拒绝
    //权限处理 详细参考 后台Excel
    PermissionApi.whetherContain('rescue_opt')
        ? print('')
        : AescueDio.rescueUpdateRequest(
            param: {
              'status': status,
              'id': id,
            },
            onSuccess: (data) {
              setState(() {
                page = 1;
                _getList(type);
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
    _loadMore();
    _getList(type);
  }

/*
下拉刷新
*/
  Future _toRefresh() async {
    page = 1;
    _getList(type);
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
        _getList(type);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        brightness: Brightness.light,
        title: Text(
          '扳手救援',
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
          // 状态 切换
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30 - 110,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      showIn = true;
                      type = '0';
                      page = 1;
                      _getList(type);
                    });
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '待处理',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: showIn ? FontWeight.bold : null),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 110,
                        height: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: showIn
                                ? Color.fromRGBO(39, 153, 93, 1)
                                : Colors.transparent),
                      ),
                    ],
                  )),
              SizedBox(
                width: 60,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      showIn = false;
                      type = '1';
                      page = 1;
                      _getList(type);
                    });
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '已处理',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: showIn ? null : FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 110,
                        height: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: showIn
                                ? Colors.transparent
                                : Color.fromRGBO(39, 153, 93, 1)),
                      )
                    ],
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30 - 110,
              ),
            ],
          ),
          isNull(dataList) == 0
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: ShowNullDataAlart(
                    alartText: '亲，当前数据为空呦~',
                  ),
                )
              : Expanded(child: list())
        ],
      ),
    );
  }

  //待处理 list
  list() {
    return RefreshIndicator(
        onRefresh: _toRefresh,
        child: ScrollConfiguration(
            behavior: NeverScrollBehavior(),
            child: ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int item) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 7,
                      ),
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
                                  height: 20,
                                ),
                                //车牌号  状态
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      HelpModel.fromJson(dataList[item])
                                          .vehicleLicence,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(child: SizedBox()),
                                    HelpModel.fromJson(dataList[item]).status ==
                                            0
                                        ? Container()
                                        : Container(
                                            width: 65,
                                            height: 25,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: HelpModel.fromJson(
                                                                    dataList[
                                                                        item])
                                                                .status ==
                                                            3
                                                        ? Color.fromRGBO(
                                                            255, 77, 76, 1)
                                                        : Color.fromRGBO(
                                                            39, 153, 93, 1),
                                                    width: 1)),
                                            child: Text(
                                              HelpModel.fromJson(dataList[item])
                                                          .status ==
                                                      1
                                                  ? '处理中'
                                                  : HelpModel.fromJson(dataList[
                                                                  item])
                                                              .status ==
                                                          2
                                                      ? '已救援'
                                                      : HelpModel.fromJson(
                                                                      dataList[
                                                                          item])
                                                                  .status ==
                                                              3
                                                          ? '已拒绝'
                                                          : '',
                                              style: TextStyle(
                                                  color: HelpModel.fromJson(
                                                                  dataList[
                                                                      item])
                                                              .status ==
                                                          3
                                                      ? Color.fromRGBO(
                                                          255, 77, 76, 1)
                                                      : Color.fromRGBO(
                                                          39, 153, 93, 1),
                                                  fontSize: 15),
                                            ),
                                          ),
                                    SizedBox(
                                      width: 15,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '故障图片',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                //图片展示
                                HelpModel.fromJson(dataList[item])
                                            .picList
                                            .length ==
                                        0
                                    ? Container()
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: GridView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        new NeverScrollableScrollPhysics(), //禁止滑动
                                                    itemCount:
                                                        HelpModel.fromJson(
                                                                dataList[item])
                                                            .picList
                                                            .length,
                                                    //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            //横轴元素个数
                                                            crossAxisCount: 3,
                                                            //纵轴间距
                                                            mainAxisSpacing:
                                                                10.0,
                                                            //横轴间距
                                                            crossAxisSpacing:
                                                                11.0,
                                                            //子组件宽高长度比例
                                                            childAspectRatio:
                                                                1.0),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      //Widget Function(BuildContext context, int index)
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(FadeRoute(
                                                                  page:
                                                                      PhotoViewSimpleScreen(
                                                            imageProvider:
                                                                NetworkImage(
                                                              HelpModel.fromJson(
                                                                          dataList[
                                                                              item])
                                                                      .picList[
                                                                  index]['picUrl'],
                                                            ),
                                                            heroTag: 'simple',
                                                          )));
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3 -
                                                              50 / 3,
                                                          height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3 -
                                                              50 / 3,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child:
                                                                Image.network(
                                                              HelpModel.fromJson(
                                                                          dataList[
                                                                              item])
                                                                      .picList[
                                                                  index]['picUrl'],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                SizedBox(
                                  height: 20,
                                ),
                                //问题描述
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '描述：${HelpModel.fromJson(dataList[item]).description}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 30,
                                  height: 1,
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                //品牌型号
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '品牌型号：${HelpModel.fromJson(dataList[item]).brand}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 30,
                                  height: 1,
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                //申请时间
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '申请时间：${HelpModel.fromJson(dataList[item]).createTime}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 30,
                                  height: 1,
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                ),
                                //接受时间
                                HelpModel.fromJson(dataList[item]).status == 3
                                    ? Container()
                                    : HelpModel.fromJson(dataList[item])
                                                .status ==
                                            1
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    '接受时间：${HelpModel.fromJson(dataList[item]).updateTime}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                    ),
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
                                                height: 1,
                                                color: Color.fromRGBO(
                                                    238, 238, 238, 1),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                //完成时间
                                HelpModel.fromJson(dataList[item]).status == 3
                                    ? Container()
                                    : HelpModel.fromJson(dataList[item])
                                                .status ==
                                            2
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    '完成时间：${HelpModel.fromJson(dataList[item]).arriveTime}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                    ),
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
                                                height: 1,
                                                color: Color.fromRGBO(
                                                    238, 238, 238, 1),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                //拒绝原因
                                HelpModel.fromJson(dataList[item]).status == 3
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                '拒绝原因${HelpModel.fromJson(dataList[item]).reason}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
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
                                            height: 1,
                                            color: Color.fromRGBO(
                                                238, 238, 238, 1),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 25,
                                ),
                                //地址 联系
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          110 -
                                          30 -
                                          15 -
                                          5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            HelpModel.fromJson(dataList[item])
                                                .address,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            '距离您门店${HelpModel.fromJson(dataList[item]).distance}km',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  149, 149, 149, 1),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Loadingmap(
                                                      endAddress:
                                                          HelpModel.fromJson(
                                                                  dataList[
                                                                      item])
                                                              .address,
                                                      endLatLng: LatLng(
                                                          HelpModel.fromJson(
                                                                  dataList[
                                                                      item])
                                                              .latitude,
                                                          HelpModel.fromJson(
                                                                  dataList[
                                                                      item])
                                                              .longitude),
                                                    )));
                                      },
                                      child: Image.asset(
                                        'Assets/share_shop/shop_map.png',
                                        width: 35,
                                        height: 35,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        CallIphone.callPhone(
                                            HelpModel.fromJson(dataList[item])
                                                .mobile
                                                .toString());
                                      },
                                      child: Image.asset(
                                        'Assets/help/iphonecall.png',
                                        width: 35,
                                        height: 35,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 30,
                                  height: 1,
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //功能按钮
                                Column(
                                  children: [
                                    HelpModel.fromJson(dataList[item]).status ==
                                                2 ||
                                            HelpModel.fromJson(dataList[item])
                                                    .status ==
                                                3
                                        ? SizedBox(
                                            height: 20,
                                          )
                                        : SizedBox(
                                            height: 40,
                                          ),
                                    //派遣
                                    HelpModel.fromJson(dataList[item]).status ==
                                            1
                                        ? GestureDetector(
                                            onTap: () {
                                              _updata(
                                                '2',
                                                HelpModel.fromJson(
                                                        dataList[item])
                                                    .id,
                                              );
                                            },
                                            child: Container(
                                              width: 92,
                                              height: 28,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color.fromRGBO(
                                                      39, 153, 93, 1)),
                                              child: Text(
                                                '已到达',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          )
                                        : HelpModel.fromJson(dataList[item])
                                                    .status ==
                                                0
                                            ? Row(
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _updata(
                                                        '1',
                                                        HelpModel.fromJson(
                                                                dataList[item])
                                                            .id,
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 92,
                                                      height: 28,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Color.fromRGBO(
                                                              39, 153, 93, 1)),
                                                      child: Text(
                                                        '派遣救援',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _updata(
                                                        '3',
                                                        HelpModel.fromJson(
                                                                dataList[item])
                                                            .id,
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 92,
                                                      height: 28,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Color.fromRGBO(
                                                              39, 153, 93, 1)),
                                                      child: Text(
                                                        '不派遣',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                    HelpModel.fromJson(dataList[item]).status ==
                                                2 ||
                                            HelpModel.fromJson(dataList[item])
                                                    .status ==
                                                3
                                        ? SizedBox(
                                            height: 0,
                                          )
                                        : SizedBox(
                                            height: 50,
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
                      )
                    ],
                  );
                })));
  }
}
