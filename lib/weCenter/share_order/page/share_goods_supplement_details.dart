import 'package:amap_base/amap_base.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/spannerHelp.dart/amapGD.dart';
import 'package:spanners/weCenter/share_order/model/share_order_detail_model.dart';
import 'package:spanners/weCenter/share_order/page/share_goods_order_page.dart';
import 'package:spanners/weCenter/share_order/page/verify_code_page.dart';
import 'package:spanners/weCenter/share_order/provide/share_goods_order_details_provide.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;

class ShareGoodsSupplementDetailsPage extends StatefulWidget {

  final String tradeId;

  final String tradeStatus;

  final String orderId;

  final ShareGoodsOrderType shareGoodsOrderType;

  const ShareGoodsSupplementDetailsPage({Key key, this.tradeId, this.tradeStatus, this.shareGoodsOrderType, this.orderId}) : super(key: key);

  @override
  _ShareGoodsSupplementDetailsPageState createState() => _ShareGoodsSupplementDetailsPageState();
}

class _ShareGoodsSupplementDetailsPageState extends State<ShareGoodsSupplementDetailsPage> {

  ShareOrderDetailsProvide _provide;
  final _subscriptions = CompositeSubscription();

  void initState() {
    super.initState();
    _provide = ShareOrderDetailsProvide();
    _loadData();
  }

  _loadData(){
    var s = _provide
        .getStoreOrderList(tradeId: widget.tradeId)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {}, onError: (e) {});
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

      }
      BotToast.showText(text: res['msg']);
    }, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '共享商品'),
        body: _initWidget(),
      ),
    );
  }

  _initWidget() => Container(
    color: AppColors.ViewBackgroundColor,
    child: Selector<ShareOrderDetailsProvide, ShareOrderDetailsModel>(builder: (_, detailsModel, child){
      return CustomScrollView(
        slivers: _allSliverWidget(),
      );
    }, selector: (_, provide)=>_provide.detailsOrderModel),
  );

  List<Widget> _allSliverWidget() {
    List<Widget> widgetList = [];

    ///顶部返回按钮
    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          child: Image.asset(widget.tradeStatus=='1'?'Assets/share_order/buhuo_daifahuo.png':widget.tradeStatus=='2'?'Assets/share_order/buhuo_daishouhuo.png':'Assets/share_order/buhuo_yishouhuo.png',),
        ),
      ),
    );

    ///顶部店铺信息
    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 10,left: 15, right: 15, bottom: 10),
          padding: EdgeInsets.only(top: 15,left: 20, right: 15, bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('Assets/share_shop/yellow_location.png'),
              SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_provide.detailsOrderModel.buyShopName, style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(_provide.detailsOrderModel.buyAddress, style: TextStyle(fontSize: 13,),),
                  SizedBox(height: 12,),
                ],
              ),
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
    // widgetList.add(
    //   SliverToBoxAdapter(
    //     child: Container(
    //       margin: EdgeInsets.only(left: 15, right: 15),
    //       padding: EdgeInsets.only(right: 10),
    //       color: Colors.white,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    //               Text('共'+_provide.detailsOrderModel.count+'件 合计：', style: TextStyle(fontWeight: FontWeight.bold),),
    //               Text('¥'+_provide.detailsOrderModel.amount, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),),
    //               SizedBox(width: 11,),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    if(widget.tradeStatus == '2') {
      widgetList.add(
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            padding: EdgeInsets.only(right: 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(right: 44),
                  alignment: Alignment.center,
                  height: 30,
                  width: 85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                  ),
                  child: GestureDetector(
                    onTap: (){
                      _confirmTheGoods(widget.orderId);
                    },
                    child: Text('确认收货', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      );
    }else {
      widgetList.add(
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
            color: Colors.white,
            child: SizedBox(height: 20,),
          ),
        ),
      );
    }



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
                          child: Text('复制', style: TextStyle(color: AppColors.primaryColor),),),
                      ],
                    ),
                  ],
                ),
              ),
              Container(color: AppColors.ViewBackgroundColor, height: 1,),
            ],
          ),
        ),
      ),
    );

    ///创建时间
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text(
                          //   '¥' + _provide.detailsOrderModel.price,
                          //   maxLines: 1,
                          //   style:
                          //   TextStyle(fontSize: 15, color: Colors.red,),
                          // ),
                          Text(
                            'x' + _provide.detailsOrderModel.count,
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
        // Container(
        //   color: AppColors.ViewBackgroundColor,
        //   height: 1,
        // ),
      ],
    ),
  );


}
