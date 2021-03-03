import 'package:amap_base/amap_base.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/spannerHome/spannerHelp.dart/amapGD.dart';
import 'package:spanners/spannerHome/spanner_store/model/spanner_goods_details_model.dart';
import 'package:spanners/spannerHome/spanner_store/model/spanner_order_details_model.dart';
import 'package:spanners/spannerHome/spanner_store/page/spanner_order_details_page.dart';
import 'package:spanners/spannerHome/spanner_store/provide/spanner_goods_details_provide.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;

class SpannerGoodsDetailsPage extends StatefulWidget {
  final shopGoodsId;

  const SpannerGoodsDetailsPage({Key key, this.shopGoodsId}) : super(key: key);

  @override
  _SpannerGoodsDetailsPageState createState() =>
      _SpannerGoodsDetailsPageState();
}

class _SpannerGoodsDetailsPageState extends State<SpannerGoodsDetailsPage> {
  SpannerGoodsDetailsProvide _provide;
  ScrollController _customScrollController;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _customScrollController = ScrollController();
    _provide = SpannerGoodsDetailsProvide();
    _loadData(widget.shopGoodsId);
  }

  _loadData(String shopGoodsId) {
    var s = _provide
        .getSpannerGoodsDetails(shopGoodsId)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {
      Map res = convert.jsonDecode(data.toString());
      Map resMap = res['data'];
      SpannerGoodsDetailsModel model =
          SpannerGoodsDetailsModel.fromJson(resMap);
      _loadSpec(model.goodsName);
    }, onError: (e) {});
    _subscriptions.add(s);
  }

  _loadSpec(String goodsName) {
    var s = _provide
        .getSpannerGoodsSpec(
            shareGoodsId: widget.shopGoodsId, goodsName: goodsName)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  _addStoreCar(String count) {
    var s = _provide
        .postAddStoreCar(shopGoodsId: widget.shopGoodsId, count: count)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _initViews(),
      ),
    );
  }

  _initViews() => SafeArea(
      child: Selector<SpannerGoodsDetailsProvide, SpannerGoodsDetailsModel>(
          builder: (_, model, child) => Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    CustomScrollView(
                      slivers: _sliverWidget(),
                      controller: _customScrollController,
                    ),
                    Positioned(
                        right: 10,
                        bottom: 200,
                        child: GestureDetector(
                          onTap: () {
                            _customScrollController.jumpTo(0);
                          },
                          child: Image.asset('Assets/share_shop/shop_top.png'),
                        )),
                    Selector<SpannerGoodsDetailsProvide, bool>(
                        builder: (_, showShopInfo, child) {
                          return _provide.showShopInfo
                              ? Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            _provide.showShopInfo = false;
                                          },
                                          child: Container(
                                            color: Color.fromRGBO(0, 0, 0, 0.6),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 30, top: 20, right: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    _provide
                                                                .detailsModel
                                                                .listPics
                                                                .length >
                                                            0
                                                        ? Container(
                                                            width: 100,
                                                            height: 100,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              image: DecorationImage(
                                                                  image: NetworkImage(_provide
                                                                      .detailsModel
                                                                      .listPics
                                                                      .first),
                                                                  fit: BoxFit
                                                                      .fill),
                                                            ),
                                                          )
                                                        : Container(),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      '¥',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      _provide.detailsModel
                                                          .goodsPrice,
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '市场价',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .SubTextColor,
                                                          fontSize: 13),
                                                    ),
                                                    Text(
                                                      _provide.detailsModel
                                                          .partsCost,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .SubTextColor,
                                                          fontSize: 13,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _provide.showShopInfo =
                                                        false;
                                                  },
                                                  child: Icon(Icons.close),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              '型号',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            // Container(
                                            //   padding: EdgeInsets.only(left: 28, right: 28, top: 3, bottom: 3),
                                            //   decoration: BoxDecoration(
                                            //     border: Border.all(color: Color(0xFFFF4D4C), width: 0.5), // 边色与边宽度
                                            //     borderRadius: BorderRadius.circular((20.0)), // 圆
                                            //     color: Color.fromRGBO(254, 216, 216, 1),// 角度
                                            //   ),
                                            //   child: Text(_provide.detailsModel.model, style: TextStyle(fontSize: 13, color: Color(0xFFFF4D4C),),),
                                            // ),
                                            _selectWidget(false),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              '规格',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            _selectWidget(true),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '数量',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      '剩余 ' +
                                                          _provide.detailsModel
                                                              .stock +
                                                          ' 件',
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 0.5), // 边色与边宽度
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            (5.0)), // 圆
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 13,
                                                        ),
                                                        onTap: () {
                                                          if (_provide
                                                                  .buyNumber >
                                                              1) {
                                                            _provide
                                                                .buyNumber -= 1;
                                                          }
                                                        },
                                                      ),
                                                      Container(
                                                        width: 0.5,
                                                        height: 22,
                                                        color: Colors.grey,
                                                      ),
                                                      Selector<
                                                              SpannerGoodsDetailsProvide,
                                                              int>(
                                                          builder: (_, number,
                                                                  child) =>
                                                              Text(
                                                                _provide
                                                                    .buyNumber
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13),
                                                              ),
                                                          selector: (_,
                                                                  provide) =>
                                                              _provide
                                                                  .buyNumber),
                                                      Container(
                                                        width: 0.5,
                                                        height: 22,
                                                        color: Colors.grey,
                                                      ),
                                                      GestureDetector(
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 13,
                                                        ),
                                                        onTap: () {
                                                          if (double.parse(_provide
                                                                  .detailsModel
                                                                  .stock) >
                                                              _provide
                                                                  .buyNumber) {
                                                            _provide
                                                                .buyNumber += 1;
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 80,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    _addStoreCar(_provide
                                                        .buyNumber
                                                        .toString());
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              (5.0)), // 圆
                                                      color: Color(
                                                          0xFFFACD89), // 角度
                                                    ),
                                                    padding: EdgeInsets.only(
                                                        left: 18,
                                                        right: 18,
                                                        top: 5,
                                                        bottom: 5),
                                                    child: Text(
                                                      '加入订货单',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _provide.showShopInfo =
                                                        false;
                                                    SpannerOrderDetailsModel model = SpannerOrderDetailsModel(
                                                        number: _provide
                                                            .buyNumber,
                                                        price: _provide
                                                            .detailsModel.goodsPrice,
                                                        allPrice: (_provide.buyNumber *
                                                                double.parse(_provide
                                                                    .detailsModel.goodsPrice))
                                                            .toString(),
                                                        shopName: _provide
                                                            .detailsModel.shopName,
                                                        address: _provide.detailsModel
                                                            .address,
                                                        pic: _provide
                                                                    .detailsModel
                                                                    .listPics
                                                                    .length >
                                                                0
                                                            ? _provide
                                                                .detailsModel
                                                                .listPics
                                                                .first
                                                            : '',
                                                        tel:
                                                            _provide.detailsModel.tel);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SpannerOrderDetailsPage(
                                                                  buyerAddress: _provide
                                                                      .detailsModel
                                                                      .buyerAddress,
                                                                  buyerShopName:
                                                                      _provide
                                                                          .detailsModel
                                                                          .buyerShopName,
                                                                  ordersModelList: [
                                                                    model
                                                                  ],
                                                                  buyNumberList: [
                                                                    _provide
                                                                        .buyNumber
                                                                  ],
                                                                  shopGoodsIdList: [
                                                                    widget
                                                                        .shopGoodsId
                                                                  ],
                                                                )));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              (5.0)), // 圆
                                                      color: Colors
                                                          .redAccent, // 角度
                                                    ),
                                                    padding: EdgeInsets.only(
                                                        left: 18,
                                                        right: 18,
                                                        top: 5,
                                                        bottom: 5),
                                                    child: Text(
                                                      '立即订购',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container();
                        },
                        selector: (_, provide) => _provide.showShopInfo)
                  ],
                ),
              ),
          selector: (_, provide) => _provide.detailsModel));

  List<Widget> _sliverWidget() {
    List<Widget> widgetList = [
      ///顶部轮播图加返回键
      SliverToBoxAdapter(
        child: _provide.detailsModel.listPics != null
            ? _topWidget()
            : Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Image.asset('Assets/shadowBack.png'),
                  ),
                ),
              ),
      ),

      ///价格、标题、店名、距离位置
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(left: 25, right: 37, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '¥',
                    style: TextStyle(color: Colors.red, fontSize: 25),
                  ),
                  Text(
                    _provide.detailsModel.goodsPrice,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '市场价',
                    style:
                        TextStyle(color: AppColors.SubTextColor, fontSize: 15),
                  ),
                  Text(
                    _provide.detailsModel.partsCost,
                    style: TextStyle(
                        color: AppColors.SubTextColor,
                        fontSize: 15,
                        decoration: TextDecoration.lineThrough),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(_provide.detailsModel.goodsName),
              SizedBox(
                height: 28,
              ),
              Text(_provide.detailsModel.shopName),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _provide.detailsModel.specName,
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        '距离您门店 ' + _provide.detailsModel.distance,
                        style: TextStyle(
                            fontSize: 12, color: AppColors.SubTextColor),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Loadingmap(
                                    // LatLng(38.858448, 121.519633), //目的地
                                    // LatLng(38.858448, 121.519633), //起始地
                                    //   'startAddress', //起始地 名称
                                    //   'endAddress', //目的地 名称
                                    startAddress:
                                        _provide.detailsModel.buyerAddress,
                                    startLatLng: LatLng(
                                        double.parse(_provide
                                            .detailsModel.buyerLatitude),
                                        double.parse(_provide
                                            .detailsModel.buyerLongitude)),
                                    endLatLng: LatLng(
                                        double.parse(_provide
                                            .detailsModel.sellerLatitude),
                                        double.parse(_provide
                                            .detailsModel.sellerLongitude)),
                                    endAddress: _provide.detailsModel.address,
                                  )));
                    },
                    child: Image.asset('Assets/share_shop/shop_map.png'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),

      ///线条
      SliverToBoxAdapter(
        child: Container(
          height: 1,
          margin: EdgeInsets.only(left: 15, right: 15, top: 14),
          color: AppColors.ViewBackgroundColor,
        ),
      ),

      ///选择规格
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('已选'),
                  GestureDetector(
                    onTap: () {
                      _provide.showShopInfo = true;
                    },
                    child: Icon(Icons.more_horiz),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _provide.detailsModel.model +
                        '，' +
                        _provide.detailsModel.specName +
                        '，' +
                        '1件',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      ///线条
      SliverToBoxAdapter(
        child: Container(
          height: 1,
          margin: EdgeInsets.only(left: 15, right: 15, top: 14),
          color: AppColors.ViewBackgroundColor,
        ),
      ),

      ///商品详情
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(left: 25, right: 37, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '商品详情',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 26,
              ),
              Text(
                _provide.detailsModel.remarks,
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    ];

    if (_provide.detailsModel.infoPics != null) {
      for (int i = 0; i < _provide.detailsModel.infoPics.length; i++) {
        ///详情图片
        widgetList.add(SliverToBoxAdapter(
          child: Container(
            child: Image.network(
              _provide.detailsModel.infoPics[i],
              fit: BoxFit.fill,
            ),
          ),
        ));
      }
    }

    widgetList.add(SliverToBoxAdapter(
        child: Container(
      height: 50,
    )));

    widgetList.add(SliverToBoxAdapter(
      child: Container(
        height: 90,
        child: Column(
          children: [
            Container(
              color: AppColors.ViewBackgroundColor,
              height: 1,
            ),
            Container(
              padding: EdgeInsets.only(left: 25, right: 16, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      launchTelURL(_provide.detailsModel.tel);
                    },
                    child: Column(
                      children: [
                        Image.asset('Assets/share_shop/shop_iphone.png'),
                        Text('联系门店'),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _addStoreCar('1');
                        },
                        child: Container(
                          width: 120,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFFACD89),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0)),
                          ),
                          child: Text(
                            '加入订货单',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _provide.showShopInfo = true;
                        },
                        child: Container(
                          width: 120,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0)),
                          ),
                          child: Text(
                            '立即订购',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));

    return widgetList;
  }

  _topWidget() => Container(
        child: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Swiper(
                  itemBuilder: _swiperBuilder,
                  itemCount: _provide.detailsModel.listPics.length,
                  scrollDirection: Axis.horizontal,
                  autoplay: false,
                  onTap: (index) => print('点击了第$index个'),
                  pagination: SwiperCustomPagination(builder:
                      (BuildContext context, SwiperPluginConfig config) {
                    print(config);
                    return Container(
                      height: 25,
                      width: 80,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width - 25,
                          left: MediaQuery.of(context).size.width - 80 - 24),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        (config.activeIndex + 1).toString() +
                            ' / ' +
                            config.itemCount.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }),
                )),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.only(left: 25),
                child: Image.asset('Assets/shadowBack.png'),
              ),
            ),
          ],
        ),
      );

  Widget _swiperBuilder(BuildContext context, int index) {
    return (Image.network(
      _provide.detailsModel.listPics[index],
      fit: BoxFit.fill,
    ));
  }

  static void launchTelURL(String phone) async {
    String url = 'tel:' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      BotToast.showText(text: '拨号失败！');
    }
  }

  _selectWidget(bool isSpec) {
    return Wrap(
      direction: Axis.horizontal,

      ///主轴方向，默认为水平方向
      alignment: WrapAlignment.center,

      ///主轴方向的对齐方式
      spacing: 5,

      ///主轴方向上的间距
      textDirection: TextDirection.ltr,

      ///文本方向
      verticalDirection: VerticalDirection.down,

      ///定义了children的摆放顺序，默认是down
      runSpacing: 20,

      ///次轴方向上的间距
      runAlignment: WrapAlignment.center,

      ///次轴的对齐方式
      children: _selectItem(isSpec),
    );
  }

  _selectItem(bool isSpec) {

    List<Widget> widgetList = [];

    List titleList = isSpec?_provide.specMap['specList']:_provide.specMap['modelList'];

    String selectTitle = isSpec?_provide.detailsModel.specName:_provide.detailsModel.model;

    String notSelectTitle = !isSpec?_provide.detailsModel.specName:_provide.detailsModel.model;

    List allOptionalList = _provide.optionalMap[!isSpec?'spec':'model'];
    List optionalList = [];
    allOptionalList.forEach((element) {
      if(element['title'] == notSelectTitle) {
        optionalList = element['optional'];
      }
    });

    for(int i=0;i<titleList.length;i++) {
      Widget currentWidget;

      String currentString = titleList[i];
      bool isSelect = selectTitle == currentString;

      if(optionalList.contains(currentString)) {
        currentWidget = GestureDetector(
          onTap: (){
            if(!isSelect) {
              List dataList = _provide.specMap['data'];
              dataList.forEach((element) {
                if(currentString == element[isSpec?'spec':'model'] && notSelectTitle == element[!isSpec?'spec':'model']) {
                  _loadData(element['shopGoodsId']);
                }
              });
            }
          },
          child: Container(
            padding: EdgeInsets.only(left: 28, right: 28, top: 3, bottom: 3),
            decoration: isSelect? BoxDecoration(
              border: Border.all(color: Color(0xFFFF4D4C), width: 0.5), // 边色与边宽度
              borderRadius: BorderRadius.circular((20.0)), // 圆
              color: Color.fromRGBO(254, 216, 216, 1),// 角度
            ): BoxDecoration(
              borderRadius: BorderRadius.circular((20.0)), // 圆
              color: Color.fromRGBO(238, 238, 238, 1),// 角度
            ),
            child: Text(currentString, style: TextStyle(fontSize: 13, color:isSelect? Color(0xFFFF4D4C):AppColors.TextColor,),),
          ),
        );
      }
      else {
        currentWidget =  Container(
          padding: EdgeInsets.only(left: 28, right: 28, top: 3, bottom: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((20.0)), // 圆
            color: Color.fromRGBO(238, 238, 238, 1),// 角度
          ),
          child: Text(currentString, style: TextStyle(fontSize: 13, color: AppColors.TextColor, decoration: TextDecoration.lineThrough,),),
        );
      }

      widgetList.add(currentWidget);

    }


    return widgetList;
  }


}
