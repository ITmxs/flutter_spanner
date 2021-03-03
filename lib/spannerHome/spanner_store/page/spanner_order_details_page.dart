import 'package:bot_toast/bot_toast.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/share_shop/page/ss_payment_details_page.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/spanner_store/model/spanner_order_details_model.dart';
import 'package:spanners/spannerHome/spanner_store/page/spanner_shop_payment_page.dart';
import 'package:spanners/spannerHome/spanner_store/provide/spanner_order_details_provide.dart';
import 'package:url_launcher/url_launcher.dart';

class SpannerOrderDetailsPage extends StatefulWidget {

  final List ordersModelList;

  final List buyNumberList;
  final List shopGoodsIdList;

  final String buyerAddress;
  final String buyerShopName;

  const SpannerOrderDetailsPage(
      {Key key, this.ordersModelList, this.buyNumberList, this.shopGoodsIdList, this.buyerAddress, this.buyerShopName})
      : super(key: key);

  @override
  _SpannerOrderDetailsPageState createState() =>
      _SpannerOrderDetailsPageState();
}

class _SpannerOrderDetailsPageState extends State<SpannerOrderDetailsPage> {

  SpannerSubmitOrdersProvide _provide;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();

    _provide = SpannerSubmitOrdersProvide();

    for(int i = 0;i<widget.ordersModelList.length;i++) {
      SpannerOrderDetailsModel goodsModel = widget.ordersModelList[i];
      int buyNumber = widget.buyNumberList[i];
      _provide.allPrice += (buyNumber * double.parse(goodsModel.price));
      _provide.textControllerList.add(TextEditingController());
    }
    _provide.modelList = widget.ordersModelList;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(context, title: '提交订单'),
      body: _initViews(),
      resizeToAvoidBottomPadding: false,
    );
  }

  _initViews() => SafeArea(
        child: CustomScrollView(
          slivers: _sliverWidget(),
        ),
      );


  List<Widget> _sliverWidget() {
    List<Widget> widgetList = [

      ///用户信息
      SliverToBoxAdapter(
        child: _topWidget(),
      ),

      SliverPadding(
        padding: EdgeInsets.only(
          top: 10,
        ),
        sliver: SliverFixedExtentList(
          itemExtent: 600,
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return _contentWidget(index);
            },
            childCount: _provide.modelList.length, //50个列表项
          ),
        ),
      ),

    SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        color: Colors.white,
        height: 84,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '应付总额（不含运费）',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Row(
              children: [
                Text(
                  '¥' + _provide.allPrice.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    _submitOrder();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular((5.0)), // 圆
                      color: Colors.redAccent, // 角度
                    ),
                    padding: EdgeInsets.only(
                        left: 18, right: 18, top: 5, bottom: 5),
                    child: Text(
                      '提交订单',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
    ];
    return widgetList;
  }

  _topWidget() => Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
        padding: EdgeInsets.only(top: 30, left: 15, right: 27, bottom: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('Assets/share_shop/yellow_location.png'),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.buyerShopName),
                  SizedBox(height: 5,),
                  Text(widget.buyerAddress, style: TextStyle(color: AppColors.SubTextColor, fontSize: 13),),
                ],
              ),
            ),
          ],
        ),
      );

  _contentWidget(int index) {
    SpannerOrderDetailsModel model = _provide.modelList[index];
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 50),
      padding: EdgeInsets.only(top: 23, left: 15, right: 12, bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: NetworkImage(model.pic),
                      fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                width: 21,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.goodsName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '¥' + model.price,
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                        Text(
                          'x' + model.number.toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('配送方式'),
              Text(
                '平台供应商配送',
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            color: AppColors.ViewBackgroundColor,
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('商品金额'),
              Text(
                '¥' + model.allPrice,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            color: AppColors.ViewBackgroundColor,
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('运费'),
              Row(
                children: [
                  Text(
                    '运费协商到付',
                  ),
                  SizedBox(width: 15,),
                  GestureDetector(
                    onTap: (){
                      launchTelURL(model.tel);
                    },
                    child: Image.asset('Assets/share_shop/orange_phone.png'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            color: AppColors.ViewBackgroundColor,
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('订单详情'),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: _provide.textControllerList[index],
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: '可以告诉门店你的需求',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            color: AppColors.ViewBackgroundColor,
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('共计' +
                  model.number.toString() +
                  '件 合计：'),
              Text(
                '¥' + model.allPrice,
                style:
                TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _submitOrder() {
    ///0平台商品 1 共享商品 2共享工具 3二手配件List goodsList, String price
    String totalPrice = _provide.allPrice.toString();

    List goodsList = [];

    for(int i = 0;i<widget.ordersModelList.length;i++) {
      int buyNumber = widget.buyNumberList[i];
      String shopGoodsId = widget.shopGoodsIdList[i];
      TextEditingController textEditingController = _provide.textControllerList[i];
      goodsList.add({
        "count": buyNumber.toString(),
        "shopGoodsId": shopGoodsId,
        'remarks':textEditingController.text
      });
    }

    var s1 = _provide
        .postSubmitSpannerShopOrder(
            price: totalPrice,
      goodsList: goodsList,
    )
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
      Map res = convert.jsonDecode(event.toString());
      if (res['data'] == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SpannerShopPaymentPage(
                  4,
                      totalPrice: totalPrice,
                      orderId: res['msg'],
                      submitOrdersModelList: widget.ordersModelList,
                      buyNumberList: widget.buyNumberList,
                      remarkList: _provide.textControllerList,
                    )));
      }else {
        BotToast.showText(text: (res['msg']));
      }
    }, onError: (e) {});
    _subscriptions.add(s1);
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
