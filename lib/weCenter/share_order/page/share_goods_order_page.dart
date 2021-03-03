import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/base/kapp_bar.dart';
import 'package:spanners/weCenter/share_order/model/share_goods_order_model.dart';
import 'package:spanners/weCenter/share_order/page/share_goods_order_detals.dart';
import 'package:spanners/weCenter/share_order/page/share_goods_supplement_details.dart';
import 'package:spanners/weCenter/share_order/page/verify_code_page.dart';
import 'package:spanners/weCenter/share_order/provide/share_goods_order_provide.dart';
import 'package:spanners/weCenter/store_order_page/page/store_order_page.dart';
import 'dart:convert' as convert;

class ShareGoodsOrderPage extends StatefulWidget {

  ///1：共享商城:共享商品 2：共享商城:共享工具 3：共享商城:二手配件
  final String shareType;

  const ShareGoodsOrderPage({Key key, this.shareType = '1'}) : super(key: key);

  @override
  _ShareGoodsOrderPageState createState() => _ShareGoodsOrderPageState();
}

class _ShareGoodsOrderPageState extends State<ShareGoodsOrderPage> with SingleTickerProviderStateMixin {

  // 选项卡控制器
  TabController _tabController;
  ShareGoodsOrderProvide _provide;
  final controller = TextEditingController();
  ScrollController _contentScrollController;
  final _subscriptions = CompositeSubscription();
  ShareGoodsOrderType _storeOrderType;

  List<Tab> tabs;

  @override
  void initState() {
    super.initState();

    if(widget.shareType == '1') {
      tabs = <Tab>[
        Tab(
          text: '调入',
        ),
        Tab(
          text: '调出',
        ),
        Tab(
          text: '补货',
        ),
      ];
    }
    else if(widget.shareType == '2'){
      tabs = <Tab>[
        Tab(
          text: '借入',
        ),
        Tab(
          text: '借出',
        ),
      ];
    }
    else if(widget.shareType == '3') {
      tabs = <Tab>[
        Tab(
          text: '买入',
        ),
        Tab(
          text: '卖出',
        ),
      ];
    }


    _provide = ShareGoodsOrderProvide();
    _storeOrderType = ShareGoodsOrderType.ShareGoodsOrderBuy;
    _tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(() {
        switch (_tabController.index) {
          case 0:
            _storeOrderType = ShareGoodsOrderType.ShareGoodsOrderBuy;
            _provide.tradeStatus = '2';
            break;
          case 1:
            _storeOrderType = ShareGoodsOrderType.ShareGoodsOrderSell;
            _provide.tradeStatus = '2';
            break;
          case 2:
            _storeOrderType = ShareGoodsOrderType.ShareGoodsOrderSupplement;
            _provide.tradeStatus = '1';
            break;
        }
        _loadListData();
      });

    _loadListData();
  }

  _loadListData() {
    var s = _provide
        .getOrderList(distinguish: _tabController.index.toString(), tradeStatus: _provide.tradeStatus, tradeType: widget.shareType)
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
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    String title = '';
    if(widget.shareType == '1') {
      title = '共享商品';
    }
    else if(widget.shareType == '2'){
      title = '共享工具';
    }
    else if(widget.shareType == '3'){
      title = '二手配件';
    }

    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: title),
        body: _initViews(),
      ),
    );
  }

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
                            indicatorColor: AppColors.primaryColor,
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
                        children: _tabBarViewChildren(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  _tabBarViewChildren(){
    List<Widget> childrenList = [];
    if(widget.shareType == '1') {
      childrenList.add(_goodsSelector(),);
      childrenList.add(_goodsSelector(),);
      childrenList.add(_replenishSelector(),);
    }
    else if(widget.shareType == '2') {
      childrenList.add(_toolsSelector(),);
      childrenList.add(_toolsSelector(),);
    }
    else if(widget.shareType == '3') {
      childrenList.add(_goodsSelector(),);
      childrenList.add(_goodsSelector(),);
    }
    return childrenList;
  }

  Widget _goodsSelector() =>
      Container(
        child: Selector<ShareGoodsOrderProvide, String>(builder: (_, tradeStatus, child){
          return Column(
            children: [
              Container(
                height: 40,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        _provide.tradeStatus = '2';
                        _loadListData();
                      },
                      child: Text('待取货', style: tradeStatus=='2'?TextStyle(fontSize: 16, fontWeight: FontWeight.bold):TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                    ),
                    GestureDetector(
                      onTap: (){
                        _provide.tradeStatus = '3';
                        _loadListData();
                      },
                      child: Text('已取货', style: tradeStatus=='3'?TextStyle(fontSize: 16, fontWeight: FontWeight.bold):TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container(
                padding: EdgeInsets.only(left: 17, right: 15, bottom: 10, top: 9),
                child: _contentList(),
              ),),
            ],
          );
        }, selector: (_, provide)=>_provide.tradeStatus),
      );

  Widget _replenishSelector() =>
      Container(
        child: Selector<ShareGoodsOrderProvide, String>(builder: (_, tradeStatus, child){
          return Column(
            children: [
              Container(
                height: 40,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        _provide.tradeStatus = '1';
                        _loadListData();
                      },
                      child: Text('待发货', style: tradeStatus=='1'?TextStyle(fontSize: 16, fontWeight: FontWeight.bold):TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                    ),
                    GestureDetector(
                      onTap: (){
                        _provide.tradeStatus = '2';
                        _loadListData();
                      },
                      child: Text('待取货', style: tradeStatus=='2'?TextStyle(fontSize: 16, fontWeight: FontWeight.bold):TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                    ),
                    GestureDetector(
                      onTap: (){
                        _provide.tradeStatus = '3';
                        _loadListData();
                      },
                      child: Text('已收货', style: tradeStatus=='3'?TextStyle(fontSize: 16, fontWeight: FontWeight.bold):TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container(
                padding: EdgeInsets.only(left: 17, right: 15, bottom: 10, top: 9),
                child: _contentList(),
              ),),
            ],
          );
        }, selector: (_, provide)=>_provide.tradeStatus),
      );

  Widget _toolsSelector() =>
      Container(
        child: Selector<ShareGoodsOrderProvide, String>(builder: (_, tradeStatus, child){
          return Column(
            children: [
              Container(
                height: 40,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        _provide.tradeStatus = '7';
                        _loadListData();
                      },
                      child: Text('待借调', style: tradeStatus=='7'?TextStyle(fontSize: 16, fontWeight: FontWeight.bold):TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                    ),
                    GestureDetector(
                      onTap: (){
                        _provide.tradeStatus = '2';
                        _loadListData();
                      },
                      child: Text('待取货', style: tradeStatus=='2'?TextStyle(fontSize: 16, fontWeight: FontWeight.bold):TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                    ),
                    GestureDetector(
                      onTap: (){
                        _provide.tradeStatus = '4';
                        _loadListData();
                      },
                      child: Text('待归还', style: tradeStatus=='4'?TextStyle(fontSize: 16, fontWeight: FontWeight.bold):TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                    ),
                    GestureDetector(
                      onTap: (){
                        _provide.tradeStatus = '8';
                        _loadListData();
                      },
                      child: Text('已归还', style: tradeStatus=='8'?TextStyle(fontSize: 16, fontWeight: FontWeight.bold):TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container(
                padding: EdgeInsets.only(left: 17, right: 15, bottom: 10, top: 9),
                child: _contentList(),
              ),),
            ],
          );
        }, selector: (_, provide)=>_provide.tradeStatus),
      );


  ///内容
  Widget _contentList() =>
      Selector<ShareGoodsOrderProvide, List>(
        selector: (_, provide) => _provide.countList,
        builder: (_, modelList, child) =>
            ListView.builder(
              controller: _contentScrollController,
              itemBuilder: _listItem,
              itemCount: _provide.countList.length,
            ),
      );

  Widget _listItem(BuildContext context, int index) {
    ShareGoodsOrderModel model = _provide.countList[index];
    return Container(
      height: 50+135.0+100,
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
        onTap: () {
          if(_storeOrderType == ShareGoodsOrderType.ShareGoodsOrderSupplement) {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ShareGoodsSupplementDetailsPage(tradeId: model.tradeId, tradeStatus: _provide.tradeStatus, shareGoodsOrderType: _storeOrderType, orderId: model.orderId,)),);
          }else {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ShareGoodsOrderDetailsPage(tradeId: model.tradeId, tradeStatus: _provide.tradeStatus, shareGoodsOrderType: _storeOrderType, shareType: widget.shareType,)),);
          }
        },
        child: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 50,
                padding: EdgeInsets.only(left: 15, right: 11),
                child: Text(model.shopName, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Expanded(child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (BuildContext context , int index) {
                    return  _itemCell(model);
                  }),),
              Container(
                height: 99,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('共'+model.count+'件 合计：', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text('¥'+model.amount, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),),
                        SizedBox(width: 11,),
                      ],
                    ),
                    SizedBox(height: 20,),
                    widget.shareType == '2'?_setToolsButton(model):_setButton(model),
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


  _setButton(ShareGoodsOrderModel model){

    if(_storeOrderType == ShareGoodsOrderType.ShareGoodsOrderBuy){
      return _provide.tradeStatus == '3'?Container():Container(
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
            _alertDialog(model.pickupCode);
          },
          child: Text('查看取货码', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
        ),
      );
    }
    else if(_storeOrderType == ShareGoodsOrderType.ShareGoodsOrderSell) {
      return _provide.tradeStatus == '3'?Container():Container(
        margin: EdgeInsets.only(right: 44),
        alignment: Alignment.center,
        height: 30,
        width: 85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primaryColor, width: 1),
        ),
        child: GestureDetector(
          onTap: () async {
            final value = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerifyCodePage(tradeId: model.tradeId,),));
            if(value){
              _loadListData();
            }
          },
          child: Text('验证取货码', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
        ),
      );
    }
    else {
      return _provide.tradeStatus == '2'?Container(
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
            _confirmTheGoods(model.orderId);
          },
          child: Text('确认收货', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
        ),
      ):Container();
    }

  }

  _setToolsButton(ShareGoodsOrderModel model){

    if(_storeOrderType == ShareGoodsOrderType.ShareGoodsOrderBuy){

      if(_provide.tradeStatus == '7'){
        return Container(
          margin: EdgeInsets.only(right: 44),
          alignment: Alignment.center,
          height: 30,
          width: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.SubTextColor, width: 1),
          ),
          child: GestureDetector(
            onTap: (){
              print('取消订单');
            },
            child: Text('取消订单', style: TextStyle(fontSize: 14, color: AppColors.TextColor),),
          ),
        );
      }
      else if(_provide.tradeStatus == '2'){
        return Container(
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
              _alertDialog(model.pickupCode);
            },
            child: Text('查看取货码', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
          ),
        );
      }
      else if(_provide.tradeStatus == '4'){
        return Container(
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
              print('我要归还');
            },
            child: Text('我要归还', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
          ),
        );
      }
      else if(_provide.tradeStatus == '8'){
        return Container();
      }
    }
    else if(_storeOrderType == ShareGoodsOrderType.ShareGoodsOrderSell) {
      if(_provide.tradeStatus == '7'){
        return Container(
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
              print('同意借调');
            },
            child: Text('同意借调', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
          ),
        );
      }
      else if(_provide.tradeStatus == '2'){
        return Container(
          margin: EdgeInsets.only(right: 44),
          alignment: Alignment.center,
          height: 30,
          width: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.primaryColor, width: 1),
          ),
          child: GestureDetector(
            onTap: () async {
              final value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyCodePage(tradeId: model.tradeId,),));
              if(value){
                _loadListData();
              }
            },
            child: Text('验证取货码', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
          ),
        );
      }
      else if(_provide.tradeStatus == '4'){
        return Container(
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
              _alertDialog(model.pickupCode);
            },
            child: Text('确认归还码', style: TextStyle(fontSize: 14, color: AppColors.primaryColor),),
          ),
        );
      }
      else if(_provide.tradeStatus == '8'){
        return Container();
      }
    }
  }

  _itemCell(ShareGoodsOrderModel model) =>
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
                      child: Image.network(model.picUrl,
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
                            model.showName,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '¥' + model.price,
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



enum ShareGoodsOrderType {
  /// 调入
  ShareGoodsOrderBuy,

  /// 调出
  ShareGoodsOrderSell,

  /// 补货
  ShareGoodsOrderSupplement,

}