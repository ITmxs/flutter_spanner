import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/weCenter/share_order/model/share_order_model.dart';
import 'package:spanners/weCenter/share_order/page/share_goods_order_page.dart';
import 'package:spanners/weCenter/share_order/provide/share_order_provide.dart';

class ShareOrderPage extends StatefulWidget {
  @override
  _ShareOrderPageState createState() => _ShareOrderPageState();
}

class _ShareOrderPageState extends State<ShareOrderPage> {


  ShareOrderProvide _provide;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    _provide = ShareOrderProvide();
    _loadData();
  }

  _loadData(){
    var s = _provide
        .getOrderCount()
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {

    }, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '共享订单'),
        body: _initViews(),
      ),
    );
  }

  _initViews() => Selector<ShareOrderProvide, ShareOrderModel>(builder: (_, countModel, child){return Container(
    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
    color: AppColors.ViewBackgroundColor,
    child: ListView(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ShareGoodsOrderPage(shareType:'1')),);
          },
          child: Container(
            height: 155,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Image.asset('Assets/share_order/share_goods.png'),
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('待取货（'+countModel.shareGoodsWaitReceive+'）', style: TextStyle(),),
                  ],),),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ShareGoodsOrderPage(shareType:'2')),);
          },
          child: Container(
            height: 155,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Image.asset('Assets/share_order/share_tools.png'),
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('待取货（'+countModel.shareEquipmentWaitReceive+'）', style: TextStyle(),),
                    Text('待归还（'+countModel.shareEquipmentWaitReturn+'）', style: TextStyle(),),
                  ],),),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ShareGoodsOrderPage(shareType:'3')),);
          },
          child: Container(
            height: 155,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Image.asset('Assets/share_order/second_hand.png'),
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('待取货（'+countModel.secondGoodsWaitReceive+'）', style: TextStyle(),),
                  ],),),
              ],
            ),
          ),
        ),
      ],
    ),
  );}, selector: (_, provide) => _provide.countModel);

}
