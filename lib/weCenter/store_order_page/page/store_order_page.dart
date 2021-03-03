import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/base/kapp_bar.dart';
import 'package:spanners/spannerHome/spanner_store/model/spanner_order_details_model.dart';
import 'package:spanners/spannerHome/spanner_store/page/spanner_shop_payment_page.dart';
import 'package:spanners/weCenter/store_order_page/model/store_order_model.dart';
import 'package:spanners/weCenter/store_order_page/page/store_order_details_page.dart';
import 'package:spanners/weCenter/store_order_page/provide/store_order_provide.dart';
import 'dart:convert' as convert;

class StoreOrderPage extends StatefulWidget {
  @override
  _StoreOrderPageState createState() => _StoreOrderPageState();
}

class _StoreOrderPageState extends State<StoreOrderPage>
    with SingleTickerProviderStateMixin {

  // 选项卡控制器
  TabController _tabController;
  StoreOrderProvide _provide;
  final controller = TextEditingController();
  ScrollController _contentScrollController;
  final _subscriptions = CompositeSubscription();
  StoreOrderType _storeOrderType;

  @override
  void initState() {
    super.initState();
    _provide = StoreOrderProvide();
    _storeOrderType = StoreOrderType.StoreOrderNonPayment;
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(() {
        String type = '0';
        switch (_tabController.index) {
          case 0:
            _storeOrderType = StoreOrderType.StoreOrderNonPayment;
            type = '0';
            break;
          case 1:
            _storeOrderType = StoreOrderType.StoreOrderDelivered;
            type = '1';
            break;
          case 2:
            _storeOrderType = StoreOrderType.StoreOrderNonReceived;
            type = '2';
            break;
          case 3:
            _storeOrderType = StoreOrderType.StoreOrderReceived;
            type = '3';
            break;
        }
        print(type);
        _loadListData(type);
      });
    _loadListData('0');
  }

  _loadListData(String status) {
    var s = _provide
        .getStoreOrderList(status: status)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  _deleteListData(String orderId) {
    var s = _provide
        .postDeleteOrder(orderId)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {
      Map res = convert.jsonDecode(data.toString());
      if(res['data']) {
        _loadListData('0');
      }
      BotToast.showText(text: res['msg']);
    }, onError: (e) {});
    _subscriptions.add(s);
  }

  _confirmTheGoods(String orderId) {
    var s = _provide
        .postConfirm(orderId)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {
      Map res = convert.jsonDecode(data.toString());
      if(res['data']) {
        _loadListData('2');
      }
      BotToast.showText(text: res['msg']);
    }, onError: (e) {});
    _subscriptions.add(s);
  }

  _remindTheDelivery(String orderId) {
    var s = _provide
        .postRemind(orderId)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {
      Map res = convert.jsonDecode(data.toString());
      BotToast.showText(text: res['msg']);
    }, onError: (e) {});
    _subscriptions.add(s);
  }


  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '门店订单'),
        body: _initViews(),
      ),
    );
  }

  final List<Tab> tabs = <Tab>[
    Tab(
      text: '待付款',
    ),
    Tab(
      text: '待发货',
    ),
    Tab(
      text: '待收货',
    ),
    Tab(
      text: '已收货',
    ),
  ];

  _initViews() =>
      SafeArea(
        child: Container(
          color: AppColors.ViewBackgroundColor,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        // SliverToBoxAdapter(
                        //   child: _searchWidget(),
                        // ),
                        KSliverAppBar(
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          backgroundColor: Colors.white,
                          pinned: true,
                          floating: true,
                          expandedHeight: 30,
                          bottom: TabBar(
                            controller: _tabController,
                            tabs: tabs,
                            isScrollable: false,
                            indicatorColor: Colors.redAccent,
                            indicatorWeight: 3,
                            indicatorPadding: EdgeInsets.only(bottom: 10),
                            labelColor: Colors.black,
                            labelStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                            unselectedLabelColor: Colors.black54,
                            unselectedLabelStyle: TextStyle(fontSize: 13),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(controller: _tabController,
                        // physics: NeverScrollableScrollPhysics(),禁止侧滑
                        children: [
                          _goodsSelector(),
                          _goodsSelector(),
                          _goodsSelector(),
                          _goodsSelector(),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  _searchWidget() =>
      Container(
        padding: EdgeInsets.only(
            top: 10, bottom: 10, left: 23, right: 23),
        height: 50,
        color: Colors.white,
        child: GestureDetector(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.ViewBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: _doneButtonAction,
                          controller: controller,
                          textAlignVertical: TextAlignVertical.bottom,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.TextColor,
                          ),
                          textAlign: TextAlign.left,
                          onChanged: (value) {
                            print(value);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: '快速搜索',
                            hintStyle:
                            TextStyle(fontSize: 13, color: AppColors.TextColor),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(controller.text);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Icon(Icons.search),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(right: 20),
                  padding: EdgeInsets.only(left: 39, right: 24),
                ),
              ),
            ],
          ),
          onTap: () {},
        ),
      );

  _doneButtonAction(String messageStr) {
    if (messageStr == null || messageStr.length <= 0) {
      print('不能为空');
      return;
    }
    print(controller.text);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _goodsSelector() =>
      Container(
        padding: EdgeInsets.only(left: 17, right: 15, bottom: 10, top: 9),
        child: Column(
          children: [
            Expanded(child: _contentList(),),
          ],
        ),
      );


  ///内容
  Widget _contentList() =>
      Selector<StoreOrderProvide, List>(
        selector: (_, provide) => _provide.countList,
        builder: (_, modelList, child) =>
            ListView.builder(
              controller: _contentScrollController,
              itemBuilder: _listItem,
              itemCount: _provide.countList.length,
            ),
      );

  Widget _listItem(BuildContext context, int index) {
    StoreOrderModel model = _provide.countList[index];
    String statusString = '';
    switch (_tabController.index) {
      case 0:
        statusString = '等待门店付款';
        break;
      case 1:
        statusString = '门店已付款';
        break;
      case 2:
        statusString = '卖家已发货';
        break;
      case 3:
        statusString = '交易成功';
        break;
    }
    return
      Container(
        height: 50 + 135.0 * 1 + 100,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 3.0),
                blurRadius: 3.0,
                spreadRadius: 1.0)
          ],
        ),
        child: GestureDetector(
          onTap: () async {
            final value = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                StoreOrderDetailsPage(model: model,
                  orderDetailsType: _storeOrderType,)),);
            if(value) {
              _loadListData('0');
            }
          },
          child: Container(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  height: 50,
                  padding: EdgeInsets.only(left: 15, right: 11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(model.orderSn,
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(statusString, style: TextStyle(color: Colors.red),),
                    ],
                  ),
                ),
                Expanded(child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return _itemCell(model);
                    }),),
                Container(
                  height: 99,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('共' + model.count + '件 合计：',
                            style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('¥' + model.money,
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.redAccent),),
                          SizedBox(width: 11,),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _typeButton(model),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // child: _selectCell(_storeOrderType, _provide.countList[index]),
        ),
      );
  }


  _typeButton(StoreOrderModel model) {
    List<Widget> widgetList = [];

    switch (_tabController.index) {
      case 0:
        widgetList.add(GestureDetector(
          onTap: () {
            _deleteListData(model.orderId);
          },
          child: Container(
            alignment: Alignment.center,
            height: 30,
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            child: Text('取消订单', style: TextStyle(fontSize: 14),),
          ),
        ),);
        widgetList.add(SizedBox(width: 24,),);
        widgetList.add(GestureDetector(
          onTap: () async {
            final value = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SpannerShopPaymentPage(
                        1,
                          totalPrice: model.money,
                          orderId: model.orderId,
                          submitOrdersModelList: [SpannerOrderDetailsModel(
                          number: int.parse(model.count),
                          price: model.payAmount,
                          allPrice: model.money,
                          goodsName: model.goodsName,
                          pic: model.primaryPicUrl,),],
                  buyNumberList: [model.count],
                  remarkList: [TextEditingController(text: model.remark)],
                )));
            if(value) {
              _loadListData('0');
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: 30,
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red, width: 1),
            ),
            child: Text(
              '付款', style: TextStyle(fontSize: 14, color: Colors.red),),
          ),
        ),);
        widgetList.add(SizedBox(width: 21,),);
        break;
      case 1:
        widgetList.add(GestureDetector(
          onTap: () {
            _remindTheDelivery(model.orderId);
          },
          child: Container(
            alignment: Alignment.center,
            height: 30,
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            child: Text('提醒发货', style: TextStyle(fontSize: 14),),
          ),
        ),);
        widgetList.add(SizedBox(width: 21,),);
        break;
      case 2:
        widgetList.add(GestureDetector(
          onTap: () {
            _confirmTheGoods(model.orderId);
          },
          child: Container(
            alignment: Alignment.center,
            height: 30,
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red, width: 1),
            ),
            child: Text(
              '确认收货', style: TextStyle(fontSize: 14, color: Colors.red),),
          ),
        ),);
        widgetList.add(SizedBox(width: 21,),);
        break;
      case 3:
        break;
    }

    return widgetList;
  }

  _itemCell(StoreOrderModel model) =>
      Container(
        height: 135,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, bottom: 20),
              child: Row(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(model.primaryPicUrl,
                          width: 90, height: 90, fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 11),
                      color: Colors.white,
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            model.goodsName,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '¥' + model.payAmount,
                                maxLines: 1,
                                style:
                                TextStyle(fontSize: 15, color: Colors.red,),
                              ),
                              Text(
                                'x' + model.count,
                                maxLines: 1,
                                style:
                                TextStyle(fontSize: 12,
                                  color: AppColors.SubTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),),
                ],
              ),
            ),
            Container(
              color: AppColors.ViewBackgroundColor,
              height: 1,
            ),
          ],
        ),
      );

}

enum StoreOrderType {
  /// 待付款
  StoreOrderNonPayment,

  /// 待发货
  StoreOrderDelivered,

  /// 待收货
  StoreOrderNonReceived,

  /// 已收货
  StoreOrderReceived,
}