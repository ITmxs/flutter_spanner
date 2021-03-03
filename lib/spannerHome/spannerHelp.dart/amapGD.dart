import 'package:flutter/material.dart';
import 'package:amap_base/amap_base.dart';
import 'package:flutter/services.dart';
import 'package:spanners/cTools/gotoOtherMap.dart';
import 'package:spanners/cTools/getGDLocation.dart';
import './mapLoading.dart';

const markerList = const [
  LatLng(38.858448, 121.519633),
  LatLng(38.858448, 121.519633),
];

class Loadingmap extends StatefulWidget {
  final LatLng endLatLng; //目的地
  final LatLng startLatLng; //起始地
  final String startAddress; //起始地 名称
  final String endAddress; //目的地 名称
  const Loadingmap(
      {Key key,
      this.endLatLng,
      this.startLatLng,
      this.startAddress,
      this.endAddress})
      : super(key: key);
  @override
  _LoadingmapState createState() => _LoadingmapState();
}

class _LoadingmapState extends State<Loadingmap> {
  AMapController _controller;
  String distance;
  Location location = Location();
  final _amapLocation = AMapLocation();
  var _result = '';
  TextEditingController startController = TextEditingController();
  /*  距离计算  */
  _getDistance() {
    AMapSearch().distanceSearch(
      [LatLng(location.latitude, location.longitude)],
      LatLng(38.882006, 121.587922),
      DistanceSearchType.driver,
    ).then((distanceList) {
      print('距离${distanceList[0]}');
      distance = (distanceList[0] / 1000).toString();
      setState(() {});
    }, onError: (e) {
      if (e is PlatformException) {
        print("发生错误,错误原因${e.code}");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    GetLocation.getlocations(
      onValue: (value) {
        setState(() {
          location = value;

          _getDistance();
        });

        print(
            '------------------>坐标：${value.longitude}，${value.latitude}，地点：${value.aoiName} @ ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
      },
      onError: (error) => print('无定位权限'),
    );
    // _initLocation();
    // _getDistance();
  }

  //初始化定位监听
  void _initLocation() async {
    _amapLocation.init();

    final options = LocationClientOptions(
      isOnceLocation: true, //获取位置标题
      locatingWithReGeocode: true, //获取坐标点
    );

    if (await Permissions().requestPermission()) {
      _amapLocation.startLocate(options).listen((_) => setState(() {
            _result =
                '坐标：${_.longitude}，${_.latitude}，地点：${_.aoiName} @ ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
            print('当前位置信息：$_result');
          }));
    } else {
      setState(() {
        _result = "无定位权限";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 145,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 55,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Color.fromRGBO(39, 153, 93, 1)),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          child: Text(
                            '||||||||||||',
                            maxLines: 7,
                            style: TextStyle(fontSize: 4),
                          ),
                        ),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Color.fromRGBO(255, 77, 76, 1)),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 200,
                            height: 33,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(238, 238, 238, 1),
                            ),
                            child: Text(
                              location.aoiName == null
                                  ? ' 我的位置'
                                  : ' ' + location.aoiName,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 200,
                          height: 33,
                          child: Text(
                            ' ${widget.endAddress}',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: location.latitude == null
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    //height: MediaQuery.of(context).size.height - 145 - 170,
                    child: AMapView(
                      onAMapViewCreated: (mapController) {
                        _controller = mapController;

                        mapController.setZoomLevel(10);
                        mapController.setMyLocationStyle(MyLocationStyle(
                            showsHeadingIndicator: false,
                            myLocationType: LOCATION_TYPE_FOLLOW_NO_CENTER,
                            showMyLocation: true));
                        loading(
                          context,
                          AMapSearch().calculateDriveRoute(
                            RoutePlanParam(
                              from:
                                  LatLng(location.latitude, location.longitude),
                              to: LatLng(38.882006, 121.587922),
                            ),
                          ),
                        ).then((result) {
                          final allPoint = result.paths[0].steps
                              .expand((step) => step.polyline)
                              .toList();

                          result.paths[0].steps
                              .expand((step) => step.TMCs)
                              .forEach((tmc) {
                            _controller.addPolyline((PolylineOptions(
                              latLngList: tmc.polyline,
                              width: 20,
                              lineJoinType: PolylineOptions.LINE_JOIN_MITER,
                              lineCapType: PolylineOptions.LINE_CAP_TYPE_ROUND,
                              isUseTexture: true,
                              isGeodesic: true,
                              color: _getTmcColor(tmc.status),
                            )));
                          });

                          _controller.zoomToSpan(allPoint);
                          _controller.addMarkers(
                            [
                              LatLng(location.latitude, location.longitude),
                              LatLng(38.882006, 121.587922)
                            ]
                                .map((latLng) => MarkerOptions(
                                      //icon:Icon(Icons.accessibility,color: Colors.red,),
                                      title: '终点所在',
                                      position: LatLng(38.882006, 121.587922),
                                    ))
                                .toList(),
                          );
                        }).catchError((e) => {});
                        setState(() {});
                      },
                      amapOptions: AMapOptions(),
                    )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 170,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 35,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '全程$distance km',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        isDismissible: true,
                        enableDrag: false,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return new Container(
                              height: 210.0,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          /*  高德   */
                                          MapUtil.gotoAMap(
                                            location.longitude,
                                            location.latitude,
                                            widget.endLatLng.longitude,
                                            widget.endLatLng.latitude,
                                            location.aoiName, //起始位置
                                            widget.endAddress, //终点位置
                                          );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white),
                                          child: Center(
                                            child: Text(
                                              '高德地图',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ),
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
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          /*  百度   有待转经纬度*/

                                          MapUtil.gotoBaiduMap(
                                            location.longitude,
                                            location.latitude,
                                            widget.endLatLng.longitude,
                                            widget.endLatLng.latitude,
                                            location.aoiName, //起始位置
                                            widget.endAddress, //终点位置
                                          );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white),
                                          child: Center(
                                            child: Text(
                                              '百度地图',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ),
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
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          /*  苹果   */
                                          MapUtil.gotoAppleMap(
                                            location.longitude,
                                            location.latitude,
                                            widget.endLatLng.longitude,
                                            widget.endLatLng.latitude,
                                            location.aoiName, //起始位置
                                            widget.endAddress, //终点位置
                                          );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white),
                                          child: Center(
                                            child: Text(
                                              '苹果地图',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ),
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
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white),
                                          child: Center(
                                            child: Text(
                                              '取消',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  )
                                ],
                              ));
                        });
                  },
                  child: Container(
                    width: 270,
                    height: 33,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(39, 153, 93, 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '使用其他地图导航',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTmcColor(String tmc) {
    switch (tmc) {
      case '未知':
        return Colors.cyan;
      case '畅通':
        return Color.fromRGBO(39, 153, 93, 1);
      case '缓行':
        return Colors.yellow;
      case '拥堵':
        return Colors.red;
      default:
        return Colors.cyan;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _amapLocation.stopLocate(); //关闭定位
    super.dispose();
  }
}
