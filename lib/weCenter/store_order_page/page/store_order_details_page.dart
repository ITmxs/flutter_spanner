import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/spanner_store/model/spanner_order_details_model.dart';
import 'package:spanners/spannerHome/spanner_store/page/spanner_shop_payment_page.dart';
import 'package:spanners/weCenter/store_order_page/model/store_order_details_model.dart';
import 'package:spanners/weCenter/store_order_page/model/store_order_model.dart';
import 'package:spanners/weCenter/store_order_page/page/store_order_page.dart';
import 'package:spanners/weCenter/store_order_page/provide/store_prder_details_provide.dart';
import 'dart:convert' as convert;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreOrderDetailsPage extends StatefulWidget {

  final StoreOrderType orderDetailsType;
  final StoreOrderModel model;
  const StoreOrderDetailsPage({Key key, this.orderDetailsType, this.model}) : super(key: key);

  @override
  _StoreOrderDetailsPageState createState() => _StoreOrderDetailsPageState();
}

class _StoreOrderDetailsPageState extends State<StoreOrderDetailsPage> {

  StoreOrderDetailsProvide _provide;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    _provide = StoreOrderDetailsProvide();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        body: _initWidget(),
      ),
    );
  }

  _initWidget() => Container(
    color: AppColors.ViewBackgroundColor,
    child: Selector<StoreOrderDetailsProvide, StoreOrderDetailsModel>(builder: (_, model, child){
      return Stack(
        children: [
          Image.asset('Assets/store_order/store_order_details.png'),
          CustomScrollView(
            slivers: _allSliverWidget(),
          ),
        ],
      );
    }, selector: (_, provide)=>_provide.detailsOrderModel),
  );

  _loadData() {
    var s = _provide
        .getStoreOrderList(tradeId: widget.model.tradeId)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {
    }, onError: (e) {});
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
        Navigator.of(context).pop(true);
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
        print('改成完成状态');
        Navigator.of(context).pop(true);
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

  List<Widget> _allSliverWidget() {
    List<Widget> widgetList = [];

    ///顶部返回按钮
    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Stack(
            children: [
              Positioned(
                left: 30,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.white,),
                ),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('门店订单', style: TextStyle(color: Colors.white, fontSize: 20),),
                ],
              )
            ],
          ),
        ),
      ),
    );

    String topString = '';
    switch(widget.orderDetailsType){
      case StoreOrderType.StoreOrderNonPayment:
        topString = '等待门店付款';
        break;
      case StoreOrderType.StoreOrderDelivered:
        topString = '门店已付款';
        break;
      case StoreOrderType.StoreOrderNonReceived:
        topString = '卖家已发货';
        break;
      case StoreOrderType.StoreOrderReceived:
        topString = '交易成功';
        break;
    }


    ///顶部店铺信息
    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 50,left: 35,),
          child: Text(topString, style: TextStyle(color: Colors.white),),
        ),
      ),
    );

    ///顶部店铺信息
    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 25,left: 15, right: 15, bottom: 10),
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              SizedBox(width: 20,),
              Image.asset('Assets/share_shop/yellow_location.png'),
              SizedBox(width: 20,),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_provide.detailsOrderModel.shopName, style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Text(_provide.detailsOrderModel.shopAddress, style: TextStyle(fontSize: 13, color: AppColors.SubTextColor),),
                ],
              ),),
            ],
          ),
        ),
      ),
    );

    ///订单商品信息
    widgetList.add(
      SliverPadding(
        padding: EdgeInsets.only(),
        sliver: SliverFixedExtentList(
          itemExtent: 135.0,
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return  _itemCell();
            },
            childCount: 1, //50个列表项
          ),
        ),
      ),
    );

    ///订单商品合计信息
    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
          padding: EdgeInsets.only(right: 10),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('共'+_provide.detailsOrderModel.count+'件 合计：', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('¥'+_provide.detailsOrderModel.amount, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),),
                  SizedBox(width: 11,),
                ],
              ),
              SizedBox(height: 10,),
              _addButton(),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );

    ///交易信息
    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 17, left: 16,),
                height: 43,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('配送方式', style: TextStyle(fontSize: 14),),
                    Text('平台供应商配送', style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
              Container(color: AppColors.ViewBackgroundColor, height: 1,),
              Container(
                padding: EdgeInsets.only(right: 17, left: 16,),
                height: 43,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('订单编号', style: TextStyle(fontSize: 14),),
                    Row(
                      children: [
                        Text(_provide.detailsOrderModel.orderSn, style: TextStyle(fontSize: 14),),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){
                            Clipboard.setData(ClipboardData(text: _provide.detailsOrderModel.orderSn));
                            BotToast.showText(text: '已复制到剪贴板!');
                          },
                          child: Text('复制', style: TextStyle(color: AppColors.primaryColor),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(color: AppColors.ViewBackgroundColor, height: 1,),
              Container(
                padding: EdgeInsets.only(right: 17, left: 16,),
                height: 43,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('支付宝（微信）交易号', style: TextStyle(fontSize: 14),),
                    Text(_provide.detailsOrderModel.paySn, style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
              Container(color: AppColors.ViewBackgroundColor, height: 1,),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('订单备注', style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 5, top: 14, right: 5, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    child: Text(_provide.detailsOrderModel.remarks, style: TextStyle(fontSize: 13),),
                  ),
                ],
              ),),
            ],
          ),
        ),
      ),
    );

    ///联系电话
    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 17, left: 16,),
                height: 43,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('创建时间', style: TextStyle(fontSize: 14),),
                    Text(_provide.detailsOrderModel.createTime, style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
              Container(color: AppColors.ViewBackgroundColor, height: 1,),
              Container(
                padding: EdgeInsets.only(right: 17, left: 16,),
                height: 43,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('付款时间', style: TextStyle(fontSize: 14),),
                    Text(_provide.detailsOrderModel.payTime, style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
              Container(color: AppColors.ViewBackgroundColor, height: 1,),
              Container(
                padding: EdgeInsets.only(right: 17, left: 16,),
                height: 43,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('发货时间', style: TextStyle(fontSize: 14),),
                    Text(_provide.detailsOrderModel.deliveryTime, style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
              Container(color: AppColors.ViewBackgroundColor, height: 1,),
              Container(
                padding: EdgeInsets.only(right: 17, left: 16,),
                height: 43,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('完成时间', style: TextStyle(fontSize: 14),),
                    Text(_provide.detailsOrderModel.finishTime, style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    ///联系卖家
    widgetList.add(
      SliverToBoxAdapter(
        child: GestureDetector(
          onTap: (){
            launchTelURL(_provide.detailsOrderModel.tel);
          },
          child: Container(
            margin: EdgeInsets.only(top:10, left: 15, right: 15, bottom: 10),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('Assets/store_order/green_phone.png', width: 18,),
                Text('联系卖家'),
              ],
            ),
          ),
        ),
      ),
    );

    widgetList.add(
        SliverToBoxAdapter(
        child: SizedBox(height: 100,),
        ),
    );

    return widgetList;
  }

  _itemCell() => Container(
        height: 135,
        color: Colors.white,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, bottom: 20, top: 10),
              child: Row(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(_provide.detailsOrderModel.picUrl,
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
                            _provide.detailsOrderModel.showName,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '¥' +  _provide.detailsOrderModel.price,
                                maxLines: 1,
                                style:
                                TextStyle(fontSize: 15, color: Colors.red,),
                              ),
                              Text(
                                'x' +  _provide.detailsOrderModel.count,
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

  _addButton(){
    switch(widget.orderDetailsType){
      case StoreOrderType.StoreOrderNonPayment:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: (){
                _deleteListData(widget.model.orderId);
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
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SpannerShopPaymentPage(
                              2,
                              totalPrice: widget.model.money,
                              orderId: widget.model.orderId,
                              submitOrdersModelList: [SpannerOrderDetailsModel(
                                number: int.parse(widget.model.count),
                                price: widget.model.payAmount,
                                allPrice: widget.model.money,
                                goodsName: widget.model.goodsName,
                                pic: widget.model.primaryPicUrl,),],
                              buyNumberList: [widget.model.count],
                              remarkList: [TextEditingController(text: 'model.remakes')],
                            )));
              },
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.red, width: 0.5),
                ),
                child: Text('付款', style: TextStyle(fontSize: 14, color: Colors.red),),
              ),
            ),
          ],
        );
      case StoreOrderType.StoreOrderDelivered:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                _remindTheDelivery(widget.model.orderId);
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
            ),
            SizedBox(width: 30,),
          ],
        );
      case StoreOrderType.StoreOrderNonReceived:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                _confirmTheGoods(widget.model.orderId);
              },
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.red, width: 0.5),
                ),
                child: Text('确认收货', style: TextStyle(fontSize: 14, color: Colors.red),),
              ),
            ),
            SizedBox(width: 30,),
          ],
        );
      case StoreOrderType.StoreOrderReceived:
        return Container();
    }
  }


  static void launchTelURL(String phone) async {
    String url = 'tel:'+ phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      BotToast.showText(text: '拨号失败！');
    }
  }

}

