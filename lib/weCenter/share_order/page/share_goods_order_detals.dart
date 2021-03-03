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

class ShareGoodsOrderDetailsPage extends StatefulWidget {

  ///1：共享商城:共享商品 2：共享商城:共享工具 3：共享商城:二手配件
  final String shareType;

  final String tradeId;

  final String tradeStatus;

  final ShareGoodsOrderType shareGoodsOrderType;

  const ShareGoodsOrderDetailsPage({Key key, this.tradeId, this.tradeStatus, this.shareGoodsOrderType, this.shareType}) : super(key: key);

  @override
  _ShareGoodsOrderDetailsPageState createState() => _ShareGoodsOrderDetailsPageState();
}

class _ShareGoodsOrderDetailsPageState extends State<ShareGoodsOrderDetailsPage> {

  ShareOrderDetailsProvide _provide;
  final _subscriptions = CompositeSubscription();

  void initState() {
    super.initState();
    _provide = ShareOrderDetailsProvide();
    _loadData();
    print('---------------------------------------------');
    print(widget.shareType);
    print(widget.tradeId);
    print(widget.tradeStatus);
    print(widget.shareGoodsOrderType);
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

    if(widget.shareType == '1'){
      ///顶部返回按钮
      if(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderBuy){
        widgetList.add(
          SliverToBoxAdapter(
            child: Container(
              child: Image.asset(widget.tradeStatus=='2'?'Assets/share_order/diaoru_daijiehuo.png':'Assets/share_order/diaoru_yiquhuo.png',),
            ),
          ),
        );
      }
      else if(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell){
        widgetList.add(
          SliverToBoxAdapter(
            child: Container(
              child: Image.asset(widget.tradeStatus=='2'?'Assets/share_order/diaochu_daiquhuo.png':'Assets/share_order/diaochu_yiquhuo.png',),
            ),
          ),
        );
      }
    }
    else if(widget.shareType == '2'){
      bool type = widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderBuy;
      if(widget.tradeStatus == '7'){
        widgetList.add(
          SliverToBoxAdapter(
            child: Container(
              child: Image.asset(type?'Assets/share_order/gj_jieru_daijiediao.png':'Assets/share_order/gj_jiechu_daijiediao.png',),
            ),
          ),
        );
      }
      else if(widget.tradeStatus == '2'){
        widgetList.add(
          SliverToBoxAdapter(
            child: Container(
              child: Image.asset(type?'Assets/share_order/gj_jieru_daiquhuo.png':'Assets/share_order/es_mairu_yiquhuo.png',),
            ),
          ),
        );
      }
      else if(widget.tradeStatus == '4'){
        widgetList.add(
          SliverToBoxAdapter(
            child: Container(
              child: Image.asset(type?'Assets/share_order/gj_jieru_daiguihuan.png':'Assets/share_order/es_mairu_yiquhuo.png',),
            ),
          ),
        );
      }
      else if(widget.tradeStatus == '8'){
        widgetList.add(
          SliverToBoxAdapter(
            child: Container(
              child: Image.asset(type?'Assets/share_order/gj_jieru_yiguihuan.png':'Assets/share_order/es_mairu_yiquhuo.png',),
            ),
          ),
        );
      }

    }
    else if(widget.shareType == '3'){
      ///顶部返回按钮
      if(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderBuy){
        widgetList.add(
          SliverToBoxAdapter(
            child: Container(
              child: Image.asset(widget.tradeStatus=='2'?'Assets/share_order/es_mairu_daiquhuo.png':'Assets/share_order/es_mairu_yiquhuo.png',),
            ),
          ),
        );
      }
      else if(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell){
        widgetList.add(
          SliverToBoxAdapter(
            child: Container(
              child: Image.asset(widget.tradeStatus=='2'?'Assets/share_order/es_maichu_daiquhuo.png':'Assets/share_order/es_maichu_yiquhuo.png',),
            ),
          ),
        );
      }

    }




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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_provide.detailsOrderModel.shopName, style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_provide.detailsOrderModel.shopAddress, style: TextStyle(fontSize: 13,),),
                    SizedBox(height: 12,),
                    Text('距离您门店 '+_provide.detailsOrderModel.distance+'km', style: TextStyle(fontSize: 13, color: AppColors.SubTextColor),),
                  ],
                ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Loadingmap(
                                    // LatLng(38.858448, 121.519633), //目的地
                                    // LatLng(38.858448, 121.519633), //起始地
                                    //   'startAddress', //起始地 名称
                                    //   'endAddress', //目的地 名称
                                    startAddress: _provide.detailsOrderModel.buyAddress,
                                    startLatLng: LatLng(double.parse(_provide.detailsOrderModel.buyLatitude), double.parse(_provide.detailsOrderModel.buyLongitude)),
                                    endLatLng: LatLng(double.parse(_provide.detailsOrderModel.latitude), double.parse(_provide.detailsOrderModel.longitude)),
                                    endAddress: _provide.detailsOrderModel.shopAddress,
                                  )));
                    },
                    child: Image.asset('Assets/share_shop/shop_map.png'),
                  ),
                  GestureDetector(
                    onTap: (){
                      launchTelURL(_provide.detailsOrderModel.tel);
                    },
                    child: Image.asset('Assets/share_shop/orange_phone.png'),
                  ),
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
    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
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
            ],
          ),
        ),
      ),
    );

    if(widget.shareType == '2') {
      if(widget.tradeStatus == '7'){
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
                      border: Border.all(color:  widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell?AppColors.primaryColor:AppColors.SubTextColor, width: 1),
                    ),
                    child: GestureDetector(
                      onTap: (){
                        if(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell) {

                        }else {

                        }
                      },
                      child: Text(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell?'同意借调':'取消订单', style: TextStyle(fontSize: 14, color: widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell?AppColors.primaryColor:AppColors.TextColor),),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        );
      }
      else if(widget.tradeStatus == '2'){
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
                        if(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyCodePage(tradeId: widget.tradeId,),));
                        }else {
                          _alertDialog(_provide.detailsOrderModel.pickupCode);
                        }
                      },
                      child: Text(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell?'验证取货码':'查看取货码', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        );
      }
      else if(widget.tradeStatus == '4'){
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
                        if(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyCodePage(tradeId: widget.tradeId,),));
                        }else {
                          _alertDialog(_provide.detailsOrderModel.pickupCode);
                        }
                      },
                      child: Text(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell?'确认归还':'我要归还', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        );
      }
    }
    else{
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
                        if(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyCodePage(tradeId: widget.tradeId,),));
                        }else {
                          _alertDialog(_provide.detailsOrderModel.pickupCode);
                        }
                      },
                      child: Text(widget.shareGoodsOrderType == ShareGoodsOrderType.ShareGoodsOrderSell?'验证取货码':'查看取货码', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        );
      }
      else {
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '¥' + _provide.detailsOrderModel.price,
                            maxLines: 1,
                            style:
                            TextStyle(fontSize: 15, color: Colors.red,),
                          ),
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
        Container(
          color: AppColors.ViewBackgroundColor,
          height: 1,
        ),
      ],
    ),
  );

  static void launchTelURL(String phone) async {
    String url = 'tel:'+ phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      BotToast.showText(text: '拨号失败！');
    }
  }

  _alertDialog(String msg) async {
    var result = await showDialog(
        barrierDismissible: false, // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('取货码', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.grey),),
            content: Text(msg, textAlign: TextAlign.center, style: TextStyle(fontSize: 21, color: AppColors.TextColor),),
            actions: <Widget>[
              // FlatButton(
              //   child: Text("取消"),
              //   onPressed: () {
              //     print("取消");
              //     Navigator.of(context).pop("Cancel");
              //   },
              // ),
              FlatButton(
                child: Text("确定",style: TextStyle(fontSize: 15, color: AppColors.TextColor),),
                onPressed: () {
                  print("确定");
                  Navigator.of(context).pop("Ok");
                },
              )
            ],
          );
        });
  }

}
