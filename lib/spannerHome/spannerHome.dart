import 'dart:convert' as convert;
import 'dart:ui';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/dLoginOrOther/login.dart';
import 'package:spanners/em_manager/em_manager.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/callIphone.dart';
import 'package:spanners/cTools/getGDLocation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/inventory_manager/page/inventory_manage_page.dart';
import 'package:spanners/spannerHome/attendance/attendancePage.dart';
import 'package:spanners/spannerHome/budgetStatistical.dart/budgetStatisticalView.dart';
import 'package:spanners/spannerHome/delivery_check/view/delivery_check_page.dart';
import 'package:spanners/common/commonRouter.dart';
import 'package:spanners/spannerHome/operationStatistics/operationStatistics.dart';
import 'package:spanners/spannerHome/performanceStatistics/view/individualPerformance.dart';
import 'package:spanners/spannerHome/performanceStatistics/view/monthlyPerformance.dart';
import 'package:spanners/spannerHome/pickingStaistics/pickingStaistics.dart';
import 'package:spanners/spannerHome/registrationOfVehicle/registrationOfVehicle.dart';
import 'package:spanners/spannerHome/saleTask/saleTask.dart';
import 'package:spanners/spannerHome/serviceManager/serviceManagerPage.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_page.dart';
import 'package:spanners/spannerHome/share_shop/page/share_shop_page.dart';
import 'package:spanners/spannerHome/spannerHelp.dart/spannerHelpPage.dart';
import 'package:spanners/spannerHome/spanner_store/page/spanner_goods_details_page.dart';
import 'package:spanners/spannerHome/spanner_store/page/spanner_store_page.dart';
import 'package:spanners/spannerHome/storeActivity/storeActivity.dart';
import 'package:spanners/spannerHome/weather/provide/weather_provide.dart';
import 'package:spanners/spannerHome/weather/view/weather_page.dart';
import 'package:spanners/spannerHome/warningPage.dart';
import 'package:spanners/weCenter/weCenterRequestApi.dart';
import './homeRequestApi.dart';
import 'package:spanners/cModel/homeModel.dart';
import 'package:spanners/spannerHome/newOrder/newOrder.dart';
import 'package:spanners/spannerHome/appointment/carAppointment.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/spannerHome/insurance/insurance.dart';
import 'members/view/memberManagement.dart';

class SpannerHome extends StatefulWidget {
  final shopId;
  final userId;

  const SpannerHome({Key key, this.shopId, this.userId}) : super(key: key);

  @override
  _SpannerHomeState createState() => _SpannerHomeState();
}

// ignore: camel_case_types
class _SpannerHomeState extends State<SpannerHome>
    implements EMMessageListener, EMConnectionListener {
  var _dataModel;
  String location = '';
  int _msWarningValue = 0;
  List _msWarniingList;
  int _goodsValue;
  List _goodsList;
  List shopList = [];
  List _serveImages = [
    'Assets/Home/spannerhelp.png',
    'Assets/Home/active.png',
    'Assets/Home/share.png',
    'Assets/Home/insurance.png',
  ];

  List _mdTitles = [
    '收支统计',
    '绩效统计',
    '运营统计',
    '考勤分析',
    '客户管理',
    '领料管理',
    '服务管理',
    '销售任务',
    '采购管理',
    '库存管理',
    '车辆管理',
    '员工管理',
    '考勤打卡',
    '个人绩效',
    '物品储存',
  ];
  List _mdimages = [
    'Assets/Home/recivemany.png',
    'Assets/Home/achievement.png',
    'Assets/Home/runimage.png',
    'Assets/Home/records.png',
    'Assets/Home/vipimage.png',
    'Assets/Home/tools.png',
    'Assets/Home/serveimage.png',
    'Assets/Home/sales.png',
    'Assets/Home/shoping.png',
    'Assets/Home/stock.png',
    'Assets/Home/carsimage.png',
    'Assets/Home/historyimage.png',
    'Assets/Home/mdrecordimage.png',
    'Assets/Home/peoples.png',
    'Assets/Home/articleimage.png',
  ];

  WeatherProvide _provide = WeatherProvide();
  String weather = '';
  /*
  首页信息获取  dio
  */
  _getHomeLoading() {
    HomeDio.homeRequest(
        param: {
          'shopId': SynchronizePreferences.Get('shopId'),
          'userId': SynchronizePreferences.Get('userid'),
        },
        onSuccess: (data) {
          setState(() {
            _dataModel = HomeWorkModel.fromJson(data);
            _msWarningValue = _dataModel.mstWarningEntities.length;
            _msWarniingList = _dataModel.mstWarningEntities;
            _goodsValue = _dataModel.goodsList.length;
            _goodsList = _dataModel.goodsList;
            print('首页List：--->$data');
          });
        },
        onError: (error) {});
  }

  /*
   获取门店列表
 */
  _getShopList() {
    HomeDio.shopRequest(
        param: {
          '': '',
        },
        onSuccess: (data) {
          setState(() {
            shopList = data;
            var mapstr = SynchronizePreferences.Get('shopname');
            if (mapstr == null) {
              SharedManager.saveString(
                  shopList[0]['shopname'].toString(), 'shopname');
              SharedManager.saveString(
                  shopList[0]['shopId'].toString(), 'shopId');
            }
            _getHomeLoading();
          });
        });
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

  //获取天气
  _getWeather(String city) {
    city == null ? city = "" : city = city;
    _provide.getWeatherInfo(city).doOnListen(() {}).doOnCancel(() {}).listen(
        (event) {
      setState(() {
        Map parsed = convert.jsonDecode(event.toString());
        weather = parsed['result']['temp'].toString();
        print('获取天气的' + weather);
      });
    }, onError: (e) {});
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    //_getHomeLoading();
    _getShopList();
    _getLocation();
    EMClient.getInstance().chatManager().addMessageListener(this);
    EMClient.getInstance().addConnectionListener(this);
  }

  DateTime lastPopTime;
  static Future _showDialog(String message, int value) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowAlart(
          title: message,
          backLart: value,
        );
      },
    );
  }

  /* 获取定位位置*/
  _getLocation() {
    GetLocation.getlocations(
      onValue: (value) {
        setState(() {
          location = value.city.toString();
          //location = '大连市';
          _getWeather(location);
        });
      },
    );
  }

  /*
下拉刷新
*/
  Future _toRefresh() async {
    _getHomeLoading();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _toRefresh,
        child: WillPopScope(
          // ignore: missing_return
          onWillPop: () async {
            // 点击返回键的操作
            // if (lastPopTime == null ||
            //     DateTime.now().difference(lastPopTime) > Duration(seconds: 1)) {
            //   lastPopTime = DateTime.now();
            //   _showDialog('双击将返回应用桌面～', 1);
            // } else {
            lastPopTime = DateTime.now();
            // 退出app
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            // }
          },
          child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: _dataModel == null
                  ? Stack(
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Container(
                                height: 105,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'Assets/Home/homeback.png'),
                                        fit: BoxFit.fill)),
                                child: Column(children: [
                                  SizedBox(
                                    height: 42,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 25,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          shopList.length < 2
                                              ? print('')
                                              : showModalBottomSheet(
                                                  isDismissible: true,
                                                  enableDrag: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      height: 300.0,
                                                      child: ShowBottomSheet(
                                                        type: 14,
                                                        dataList: shopList,
                                                        onChanges:
                                                            (shopname, shapid) {
                                                          setState(() {
                                                            print(
                                                                '门店$shopname$shapid');
                                                            SharedManager
                                                                .saveString(
                                                                    shopname,
                                                                    'shopname');
                                                            SharedManager
                                                                .saveString(
                                                                    shapid,
                                                                    'shopId');
                                                            _getHomeLoading();
                                                          });
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50 -
                                              25 -
                                              60 -
                                              25 -
                                              20,
                                          child: Text(
                                            SynchronizePreferences.Get(
                                                'shopname'),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                child: Container(
                                                  width: 60,
                                                  // height: 24,
                                                  child: Text(
                                                    location,
                                                    textAlign: TextAlign.right,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  _gotoPage(
                                                      Pages.PagesWeatherPage);
                                                },
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                      Text(
                                        '$weather℃',
                                        textAlign: TextAlign.right,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      )
                                    ],
                                  )
                                ]))),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 105, 0, 0),
                            // child: RefreshIndicator(
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: 90,
                                ),
                                ShowNullDataAlart(
                                  alartText: '亲，当前数据为空呦~',
                                ),
                              ],
                              // ),
                              // onRefresh: _toRefresh,
                            ))
                      ],
                    )
                  : Container(
                      color: Color.fromRGBO(238, 238, 238, 1),
                      child: ScrollConfiguration(
                        behavior: NeverScrollBehavior(),
                        child: ListView(
                          controller: ScrollController(keepScrollOffset: false),
                          children: [
//--> top
                            Container(
                              // height: 539,
                              child: Stack(
                                children: [
//--> 门店切换
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Container(
                                        height: 121,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'Assets/Home/homeback.png'),
                                                fit: BoxFit.fill)),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 42,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 25,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    shopList.length == 0
                                                        ? print('')
                                                        : showModalBottomSheet(
                                                            isDismissible: true,
                                                            enableDrag: false,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                height: 300.0,
                                                                child:
                                                                    ShowBottomSheet(
                                                                  type: 14,
                                                                  dataList:
                                                                      shopList,
                                                                  onChanges:
                                                                      (shopname,
                                                                          shapid) {
                                                                    setState(
                                                                        () {
                                                                      print(
                                                                          '门店$shopname$shapid');
                                                                      SharedManager.saveString(
                                                                          shopname,
                                                                          'shopname');
                                                                      SharedManager.saveString(
                                                                          shapid,
                                                                          'shopId');
                                                                      _getHomeLoading();
                                                                    });
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          );
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50 -
                                                            25 -
                                                            60 -
                                                            25 -
                                                            20,
                                                    child: Text(
                                                      SynchronizePreferences
                                                          .Get('shopname'),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.white,
                                                  size: 25,
                                                ),
                                                Expanded(
                                                  child: SizedBox(),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          child: Container(
                                                            width: 60,
                                                            // height: 24,
                                                            child: Text(
                                                              location,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            _gotoPage(Pages
                                                                .PagesWeatherPage);
                                                          },
                                                        ),
                                                        Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(),
                                                ),
                                                Text(
                                                  '$weather℃',
                                                  textAlign: TextAlign.right,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
//--> 工单代办
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 94, 0, 0),
                                    child: Container(
                                      // height: 350,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromRGBO(49, 59, 67, 1),
                                      ),
                                      child: Stack(
                                        children: [
                                          //--> 洗车 派工
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                40, 40, 0, 240),
                                            child: Row(
                                              children: [
                                                //--> 待洗车
                                                Container(
                                                  width: 70,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '待洗车',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        '${_dataModel.washCarNum.toString()}辆',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      40 -
                                                      70 -
                                                      37.5,
                                                ),
//--> 新建工单
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NewOrder()),
                                                    ).then((value) =>
                                                        _getHomeLoading());
                                                  },
                                                  child: Container(
                                                    width: 75,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Color.fromRGBO(
                                                          39, 153, 93, 1),
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('新建工单',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13)),
                                                    ),
                                                  ),
                                                ),

                                                Expanded(child: SizedBox()),
                                                //--> 待派工
                                                Container(
                                                  width: 70,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '待派工',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        '${_dataModel.dispatchingNum.toString()}辆',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 40,
                                                ),
                                              ],
                                            ),
                                          ),
//-->工作流
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                40, 123, 30, 10),
                                            child: Stack(
                                              children: [
//  第一行
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: InkWell(
                                                      onTap: () {
                                                        //权限处理 详细参考 后台Excel
                                                        PermissionApi
                                                                .whetherContain(
                                                                    'appointment_view')
                                                            ? print('')
                                                            : Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            CarAppoin())).then(
                                                                (value) =>
                                                                    _getHomeLoading());
                                                      },
                                                      child: Image.asset(
                                                        'Assets/Home/topyy.png',
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.fill,
                                                      )),
                                                ),
                                                //预约未读消息
                                                _dataModel.appointmentNum == '0'
                                                    ? Container()
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                32, 0, 0, 0),
                                                        child: Container(
                                                            width: 18,
                                                            height: 18,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      77,
                                                                      76,
                                                                      1),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                _dataModel
                                                                    .appointmentNum
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            )),
                                                      ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 60, 0, 0),
                                                  child: Container(
                                                      width: 50,
                                                      height: 17,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '预约',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13),
                                                        ),
                                                      )),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      50, 0, 0, 0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            70 / 2 -
                                                            150 / 2 +
                                                            10,
                                                    height: 50,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        '--------------------------------------',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    39,
                                                                    153,
                                                                    93,
                                                                    1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
//接车
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2 -
                                                          25 -
                                                          40,
                                                      0,
                                                      0,
                                                      0),
                                                  child: InkWell(
                                                      onTap: () {
                                                        //权限处理 详细参考 后台Excel
                                                        PermissionApi
                                                                .whetherContain(
                                                                    'receive_car_view')
                                                            ? print('')
                                                            : Navigator
                                                                    .pushNamed(
                                                                        context,
                                                                        '/rec')
                                                                .then((value) =>
                                                                    _getHomeLoading());
                                                      },
                                                      child: Image.asset(
                                                        'Assets/Home/topjc.png',
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.fill,
                                                      )),
                                                ),
                                                //接车未读消息
                                                _dataModel.receptionNum == '0'
                                                    ? Container()
                                                    : Padding(
                                                        padding: EdgeInsets.fromLTRB(
                                                            MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    2 -
                                                                25 -
                                                                40 +
                                                                32,
                                                            0,
                                                            0,
                                                            0),
                                                        child: Container(
                                                            width: 18,
                                                            height: 18,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      77,
                                                                      76,
                                                                      1),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                _dataModel
                                                                    .receptionNum
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            )),
                                                      ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2 -
                                                          35 -
                                                          25,
                                                      60,
                                                      0,
                                                      0),
                                                  child: Container(
                                                      width: 50,
                                                      height: 17,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '接车',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13),
                                                        ),
                                                      )),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2 -
                                                          70 / 2 +
                                                          20,
                                                      0,
                                                      0,
                                                      0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            70 / 2 -
                                                            150 / 2 +
                                                            10,
                                                    height: 50,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        '--------------------------------------',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    39,
                                                                    153,
                                                                    93,
                                                                    1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          70 -
                                                          60,
                                                      0,
                                                      10,
                                                      0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      //权限处理 详细参考 后台Excel
                                                      PermissionApi
                                                              .whetherContain(
                                                                  'dispatch_view')
                                                          ? print('')
                                                          : Navigator.pushNamed(
                                                                  context,
                                                                  '/atwork')
                                                              .then((value) =>
                                                                  _getHomeLoading());
                                                    },
                                                    child: Image.asset(
                                                      'Assets/Home/toppg.png',
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                //派工未读消���
                                                _dataModel.dispatchingNum == '0'
                                                    ? Container()
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    70 -
                                                                    60 +
                                                                    32,
                                                                0,
                                                                0,
                                                                0),
                                                        child: Container(
                                                            width: 18,
                                                            height: 18,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      77,
                                                                      76,
                                                                      1),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                _dataModel
                                                                    .dispatchingNum
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            )),
                                                      ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          70 -
                                                          60,
                                                      60,
                                                      0,
                                                      0),
                                                  child: Container(
                                                      width: 50,
                                                      height: 17,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '派工',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13),
                                                        ),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          70 -
                                                          10,
                                                      0,
                                                      0,
                                                      0),
                                                  child: Container(
                                                    width: 10,
                                                    height: 50,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        '--------------------------------------',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    39,
                                                                    153,
                                                                    93,
                                                                    1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                //
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          70 -
                                                          2,
                                                      25,
                                                      0,
                                                      0),
                                                  child: Container(
                                                    width: 2,
                                                    height: 100,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        '||||||||||||||||||||||||||',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    39,
                                                                    153,
                                                                    93,
                                                                    1),
                                                            fontSize: 5,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                    ),
                                                  ),
                                                ),

//------第二行
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 101, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      //权限处理 详细参考 后台Excel
                                                      PermissionApi.whetherContain(
                                                              'check_opt_view')
                                                          ? print('')
                                                          : _gotoPage(Pages
                                                              .PagesSettlementPage);
                                                    },
                                                    child: Image.asset(
                                                      'Assets/Home/topjs.png',
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                //结算未读消息
                                                _dataModel.accountNum == '0'
                                                    ? Container()
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                32, 101, 0, 0),
                                                        child: Container(
                                                            width: 18,
                                                            height: 18,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      77,
                                                                      76,
                                                                      1),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                _dataModel
                                                                    .accountNum
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            )),
                                                      ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 60 + 101.0, 0, 10),
                                                  child: Container(
                                                      width: 50,
                                                      height: 17,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '结算',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13),
                                                        ),
                                                      )),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      50, 101, 0, 0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            70 / 2 -
                                                            150 / 2 +
                                                            10,
                                                    height: 50,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        '--------------------------------------',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    39,
                                                                    153,
                                                                    93,
                                                                    1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2 -
                                                          25 -
                                                          40,
                                                      101,
                                                      0,
                                                      0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      //权限处理 详细参考 后台Excel
                                                      PermissionApi
                                                              .whetherContain(
                                                                  'exam_view')
                                                          ? print('')
                                                          : _gotoPage(Pages
                                                              .PagesDeliveryCheckPage);
                                                    },
                                                    child: Image.asset(
                                                      'Assets/Home/topjy.png',
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                //交验未读消息
                                                _dataModel.examinationNum == '0'
                                                    ? Container()
                                                    : Padding(
                                                        padding: EdgeInsets.fromLTRB(
                                                            MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    2 -
                                                                25 -
                                                                40 +
                                                                32,
                                                            101,
                                                            0,
                                                            0),
                                                        child: Container(
                                                            width: 18,
                                                            height: 18,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      77,
                                                                      76,
                                                                      1),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                _dataModel
                                                                    .examinationNum
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            )),
                                                      ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2 -
                                                          35 -
                                                          25,
                                                      60 + 101.0,
                                                      0,
                                                      0),
                                                  child: Container(
                                                      width: 50,
                                                      height: 17,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '交验',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13),
                                                        ),
                                                      )),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2 -
                                                          70 / 2 +
                                                          20,
                                                      101,
                                                      0,
                                                      0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            70 / 2 -
                                                            150 / 2 +
                                                            10,
                                                    height: 50,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        '--------------------------------------',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    39,
                                                                    153,
                                                                    93,
                                                                    1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          70 -
                                                          60,
                                                      101,
                                                      10,
                                                      0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                              context,
                                                              '/working')
                                                          .then((value) =>
                                                              _getHomeLoading());
                                                    },
                                                    child: Image.asset(
                                                      'Assets/Home/topsg.png',
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                //施工未读消息
                                                _dataModel.inspectionNum == '0'
                                                    ? Container()
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    70 -
                                                                    60 +
                                                                    32,
                                                                101,
                                                                0,
                                                                0),
                                                        child: Container(
                                                            width: 18,
                                                            height: 18,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      77,
                                                                      76,
                                                                      1),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                _dataModel
                                                                    .inspectionNum
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            )),
                                                      ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          70 -
                                                          60,
                                                      60 + 101.0,
                                                      0,
                                                      0),
                                                  child: Container(
                                                      width: 50,
                                                      height: 17,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '施工',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13),
                                                        ),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          70 -
                                                          10,
                                                      101,
                                                      0,
                                                      0),
                                                  child: Container(
                                                    width: 10,
                                                    height: 50,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        '--------------------------------------',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    39,
                                                                    153,
                                                                    93,
                                                                    1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),

//工作流结束
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

//--> 特色服务
                            Container(
                                width: MediaQuery.of(context).size.width,
                                //height: 190,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          width: 3,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2)),
                                            color:
                                                Color.fromRGBO(39, 153, 93, 1),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '特色服务',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 19),
                                          textAlign: TextAlign.left,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
//--> 特色服务相关 选项
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                                height: 110,
                                                child: ScrollConfiguration(
                                                  behavior:
                                                      NeverScrollBehavior(),
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: List.generate(
                                                        4,
                                                        (index) => InkWell(
                                                              onTap: () {},
                                                              child: Row(
                                                                children: [
                                                                  index == 0
                                                                      ? SizedBox(
                                                                          width:
                                                                              10,
                                                                        )
                                                                      : SizedBox(
                                                                          width:
                                                                              0,
                                                                        ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      index == 2
                                                                          ? //权限处理 详细参考 后台Excel
                                                                          PermissionApi.whetherContain('share_view')
                                                                              ? print('')
                                                                              : Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(builder: (context) => ShareShopPage()),
                                                                                ).then((value) => _getHomeLoading())
                                                                          : index == 3
                                                                              ? //权限处理 详细参考 后台Excel
                                                                              PermissionApi.whetherContain('insurance_view')
                                                                                  ? print('')
                                                                                  : Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(builder: (context) => InsurancePage()),
                                                                                    ).then((value) => _getHomeLoading())
                                                                              : index == 1
                                                                                  ? //权限处理 详细参考 后台Excel
                                                                                  PermissionApi.whetherContain('campaign_view')
                                                                                      ? print('')
                                                                                      : Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(builder: (context) => StoreActivityPage()),
                                                                                        ).then((value) => _getHomeLoading())
                                                                                  : index == 0
                                                                                      ? //权限处理 详细参考 后台Excel
                                                                                      PermissionApi.whetherContain('rescue_view')
                                                                                          ? print('')
                                                                                          : Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage()))
                                                                                      : print('跳转其他非特色服务功能区域');
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5)),
                                                                        image: DecorationImage(
                                                                            image:
                                                                                AssetImage(_serveImages[index])),
                                                                      ),
                                                                      width: MediaQuery.of(context).size.width /
                                                                              3 -
                                                                          30 /
                                                                              3,
                                                                      height: MediaQuery.of(context).size.width /
                                                                              3 -
                                                                          30 /
                                                                              3,
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: index ==
                                                                              0
                                                                          ? _dataModel.rescueNum == '0'
                                                                              ? Container()
                                                                              : Container(
                                                                                  width: 18,
                                                                                  height: 18,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(9),
                                                                                    color: Color.fromRGBO(255, 77, 76, 1),
                                                                                  ),
                                                                                  child: Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Text(
                                                                                      _dataModel.rescueNum.toString(),
                                                                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                                                                    ),
                                                                                  ))
                                                                          : Container(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                  ),
                                                ))),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),

                            SizedBox(
                              height: 7,
                              child: Container(
                                color: Color.fromRGBO(238, 238, 238, 1),
                              ),
                            ),

//--> 商品推荐
                            Container(
                                width: MediaQuery.of(context).size.width,
                                // height: 338,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          width: 3,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2)),
                                            color:
                                                Color.fromRGBO(39, 153, 93, 1),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '扳手商城',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 19),
                                          textAlign: TextAlign.left,
                                        ),
                                        Expanded(child: SizedBox()),
                                        InkWell(
                                          onTap: () {
                                            //权限处理 详细参考 后台Excel
                                            PermissionApi.whetherContain(
                                                    'mall_view')
                                                ? print('')
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SpannerStorePage(),
                                                    ),
                                                  );
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                '查看更多',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        37, 35, 35, 1),
                                                    fontSize: 15),
                                                textAlign: TextAlign.right,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.chevron_right,
                                                color: Color.fromRGBO(
                                                    181, 181, 181, 1),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
//--> 推荐商品
                                    Container(
                                      height: 245,
                                      child: ScrollConfiguration(
                                          behavior: NeverScrollBehavior(),
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true, //解决无线高度问题
                                            //physics: new NeverScrollableScrollPhysics(),
                                            children: List.generate(
                                              _goodsValue,
                                              (index) => InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SpannerGoodsDetailsPage(
                                                        shopGoodsId:
                                                            GoodsModel.fromJson(
                                                                    _goodsList[
                                                                        index])
                                                                .shopGoodsId,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        border: Border.all(
                                                            // 颜色
                                                            color:
                                                                Color.fromRGBO(
                                                                    191,
                                                                    191,
                                                                    191,
                                                                    1),
                                                            // 线条宽度
                                                            width: 1.0),
                                                        //color: Colors.white,
                                                      ),
                                                      width: 140,
                                                      height: 245,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: 140,
                                                            height: 140,
                                                            child:
                                                                Image.network(
                                                              GoodsModel.fromJson(
                                                                      _goodsList[
                                                                          index])
                                                                  .primaryPicUrl,
                                                              fit: BoxFit.fill,
                                                            ), //'${GoodsModel.fromJson(goodsList[index]).primaryPicUrl.toString()}'
                                                          ),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              Container(
                                                                height: 103,
                                                                width: 126,
                                                                child: Column(
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        GoodsModel.fromJson(_goodsList[index]).goodsName +
                                                                            GoodsModel.fromJson(_goodsList[index]).specName +
                                                                            GoodsModel.fromJson(_goodsList[index]).model,
                                                                        maxLines:
                                                                            4,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                42,
                                                                                42,
                                                                                42,
                                                                                1),
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            SizedBox()),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        '¥ ${GoodsModel.fromJson(_goodsList[index]).retailPrice}',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                203,
                                                                                39,
                                                                                39,
                                                                                1),
                                                                            fontSize:
                                                                                15),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 9,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 6,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )),

//--> 门店管理
                            Container(
                                width: MediaQuery.of(context).size.width,
                                //其中 14 是返回个数
                                //   height:
                                //  160 + 50.0 * (14 % 5 > 0 ? 14 ~/ 5 + 1 : 14 / 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Column(children: [
                                  SizedBox(
                                    height: 10,
                                    child: Container(
                                      height: 10,
                                      color: Color.fromRGBO(238, 238, 238, 1),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        width: 3,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2)),
                                          color: Color.fromRGBO(39, 153, 93, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '门店管理',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 19),
                                        textAlign: TextAlign.left,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            //禁止滑动
                                            itemCount: _mdTitles.length,
                                            //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    //横轴元素个数
                                                    crossAxisCount: 5,
                                                    //纵��间距
                                                    mainAxisSpacing: 19.0,
                                                    //横轴间距
                                                    crossAxisSpacing: 19.0,
                                                    //子组件宽高长度比例
                                                    childAspectRatio: 1.0),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              //Widget Function(BuildContext context, int index)
                                              return InkWell(
                                                onTap: () {
                                                  if (_mdTitles[index] ==
                                                      '库存管理') {
                                                    //权限处理 详细参考 后台Excel
                                                    PermissionApi.whetherContain(
                                                            'stock_management_view')
                                                        ? print('')
                                                        : _gotoPage(Pages
                                                            .PagesInventoryManagePage);
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '收支统计') {
                                                    //权限处理 详细参考 后台Excel
                                                    PermissionApi.whetherContain(
                                                            'accountant_view')
                                                        ? print('')
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BudgetStatisticalView())).then(
                                                            (value) =>
                                                                _getHomeLoading());
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '绩效统计') {
                                                    //权限处理 详细参考 后台Excel
                                                    PermissionApi.whetherContain(
                                                            'performance_view')
                                                        ? print('')
                                                        : _gotoPage(Pages
                                                            .PagesPerformanceStatisticsPage);
                                                  }

                                                  if (_mdTitles[index] ==
                                                      '个人绩效') {
                                                    //权限处理 详细参考 后台Excel
                                                    PermissionApi.whetherContain(
                                                            'employee_performance_view')
                                                        ? print('')
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        IndividualPerformance())).then(
                                                            (value) =>
                                                                _getHomeLoading());
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '考勤分析') {
                                                    //权限处理 详细参考 后台Excel
                                                    PermissionApi.whetherContain(
                                                            'attendance_view')
                                                        ? print('')
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AttendancePage())).then(
                                                            (value) =>
                                                                _getHomeLoading());
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '客户管理') {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MemberManagement())).then(
                                                        (value) =>
                                                            _getHomeLoading());
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '车辆管理') {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                RegistrationOfVehicle())).then(
                                                        (value) =>
                                                            _getHomeLoading());
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '服务管理') {
                                                    //权限处理 详细参考 后台Excel
                                                    PermissionApi.whetherContain(
                                                            'service_management_view')
                                                        ? print('')
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ServiceManagePage())).then(
                                                            (value) =>
                                                                _getHomeLoading());
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '运营统计') {
                                                    //权限处理 详细参考 后台Excel
                                                    PermissionApi.whetherContain(
                                                            'operation_view')
                                                        ? print('')
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        OperationStatistics())).then(
                                                            (value) =>
                                                                _getHomeLoading());
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '领料管理') {
                                                    //权限处理 详细参考 后台Excel
                                                    PermissionApi
                                                            .whetherContain(
                                                                'picking_view')
                                                        ? print('')
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PickingPage())).then(
                                                            (value) =>
                                                                _getHomeLoading());
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '销售任务') {
                                                    //权限处理 详细参考 后台Excel
                                                    PermissionApi.whetherContain(
                                                            'sales_task_view')
                                                        ? print('')
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        SaleTask())).then(
                                                            (value) =>
                                                                _getHomeLoading());
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '绩效管理') {
                                                    CommonRouter.push(context,
                                                        widget:
                                                            MemberManagement());
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '员工管理') {
                                                    RouterUtil.push(context,
                                                        routerName:
                                                            "employeeManagement");
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '物品储存') {
                                                    RouterUtil.push(context,
                                                        routerName:
                                                            "storageList");
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '考勤打卡') {
                                                    RouterUtil.push(context,
                                                        routerName:
                                                            "attendanceClock");
                                                  }
                                                  if (_mdTitles[index] ==
                                                      '采购管理') {
                                                    //权限处理 详细参考 后台Excel
                                                    PermissionApi.whetherContain(
                                                            'purchasing_management_view')
                                                        ? print('')
                                                        : RouterUtil.push(
                                                            context,
                                                            routerName:
                                                                "purchaseManage");
                                                  }
                                                },
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
                                                        child: Image.asset(
                                                          _mdimages[index]
                                                              .toString(),
                                                          width: 26,
                                                          height: 26,
                                                        ),
                                                      ),
                                                      Text(
                                                        _mdTitles[index]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ])),
//--> 智能提醒
                            SizedBox(
                              height: 10,
                              child: Container(
                                height: 10,
                                color: Color.fromRGBO(238, 238, 238, 1),
                              ),
                            ),

                            Container(
                                width: MediaQuery.of(context).size.width,
                                //其中 msWarningValue 是返��个数

                                // height:
                                //     _msWarningValue * 75 + _msWarningValue * 20 + 90.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Column(children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        width: 3,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2)),
                                          color: Color.fromRGBO(39, 153, 93, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '智能提醒',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 19),
                                        textAlign: TextAlign.left,
                                      ),
                                      Expanded(child: SizedBox()),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WarningPage(
                                                warningList: _msWarniingList,
                                              ),
                                            ),
                                          ).then((value) => _getHomeLoading());
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              '查看更多',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      37, 35, 35, 1),
                                                  fontSize: 15),
                                              textAlign: TextAlign.right,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              color: Color.fromRGBO(
                                                  181, 181, 181, 1),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      _msWarningValue == 0
                                          ? Container(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    '当前暂无提醒～',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Expanded(
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  //禁止滑动
                                                  itemCount: _msWarningValue > 3
                                                      ? 3
                                                      : _msWarningValue,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Slidable(
                                                      actionPane:
                                                          SlidableDrawerActionPane(), //滑出选项的面板 动画
                                                      actionExtentRatio: 0.25,
                                                      child: listView(index),
                                                      secondaryActions: <
                                                          Widget>[
                                                        //右侧按钮列表
                                                        GestureDetector(
                                                          onTap: () {
                                                            _deleteWaring(
                                                                _msWarniingList[
                                                                        index]
                                                                    ['id']);
                                                          },
                                                          child: Container(
                                                            width: 102,
                                                            height: 102,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .black54),
                                                            child: Text(
                                                              '删 除',
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          1),
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                ])),
                          ],
                        ),
                      ))),
        ));
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

  _gotoPage(Pages page) {
    switch (page) {
      case Pages.PagesDeliveryCheckPage:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DeliveryCheckPage()),
        ).then((value) => _getHomeLoading());
        break;
      case Pages.PagesSettlementPage:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettlementPage()),
        ).then((value) => _getHomeLoading());
        break;
      case Pages.PagesWeatherPage:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WeatherPage()),
        ).then((value) => _getHomeLoading());
        break;
      case Pages.PagesInventoryManagePage:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InventoryManagePage()),
        ).then((value) => _getHomeLoading());
        break;
      case Pages.PagesPerformanceStatisticsPage:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PerformanceStatisticsPage()),
        ).then((value) => _getHomeLoading());
        break;
      default:
    }
  }

  @override
  void onCmdMessageReceived(List<EMMessage> messages) {
    // TODO: implement onCmdMessageReceived
  }

  @override
  void onConnected() {
    // TODO: implement onConnected
  }

  @override
  void onDisconnected(int errorCode) {
    // TODO: implement onDisconnected

    if (errorCode == 206) {
      em_logout(() {
        _logOut();
      }, () {
        _logOut();
      });
    }
  }

  @override
  void onMessageChanged(EMMessage message) {
    // TODO: implement onMessageChanged
  }

  @override
  void onMessageDelivered(List<EMMessage> messages) {
    // TODO: implement onMessageDelivered
  }

  @override
  void onMessageRead(List<EMMessage> messages) {
    // TODO: implement onMessageRead
  }

  @override
  void onMessageRecalled(List<EMMessage> messages) {
    // TODO: implement onMessageRecalled
  }

  @override
  void onMessageReceived(List<EMMessage> messages) {
    // TODO: implement onMessageReceived
  }

  //退出登录
  _logOut() {
    // WeCenterDio.logOutRequest(
    //   onSuccess: (data) {
    //     _alert();
    //   },
    // );
    _alert();
  }

  _alert() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('提醒'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Text('当前账号已经在其他设备上登录'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(Routers.navigatorState.currentState.context,
                    MaterialPageRoute(builder: (context) => LoginView()));
              },
            ),
          ],
        );
      },
    ).then((val) {
      print(val);
    });
  }
}
