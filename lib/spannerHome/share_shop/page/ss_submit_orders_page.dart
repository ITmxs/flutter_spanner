import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/share_shop/model/ss_goods_details_model.dart';
import 'package:spanners/spannerHome/share_shop/model/ss_other_details_model.dart';
import 'package:spanners/spannerHome/share_shop/model/ss_submit_orders_model.dart';
import 'package:spanners/spannerHome/share_shop/page/ss_payment_details_page.dart';
import 'package:spanners/spannerHome/share_shop/provide/ss_submit_orders_provide.dart';
import 'dart:convert' as convert;

class SSSubmitOrdersPage extends StatefulWidget {
  final int type;///0平台商品 1 共享商品 2共享工具 3二手配件
  final ShareShopDetailsModel ordersModel;
  final ShareShopOtherDetailsModel otherDetailsModel;

  final int buyNumber;
  final String shopGoodsId;
  final String equipmentId;
  const SSSubmitOrdersPage(this.type, {Key key, this.ordersModel, this.buyNumber, this.shopGoodsId, this.otherDetailsModel, this.equipmentId}) : super(key: key);
  @override
  _SSSubmitOrdersPageState createState() => _SSSubmitOrdersPageState();
}

class _SSSubmitOrdersPageState extends State<SSSubmitOrdersPage> {

  SSSubmitOrdersProvide _provide;
  final _subscriptions = CompositeSubscription();
  TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();

    _provide = SSSubmitOrdersProvide();
    _textEditingController = TextEditingController();

    if(widget.type == 1) {
      _provide.submitOrdersModel = SSSubmitOrdersModel(number: widget.buyNumber,
          price: widget.ordersModel.sharePrice,
          allPrice: (widget.buyNumber*double.parse(widget.ordersModel.sharePrice)).toString(),
          shopName: widget.ordersModel.shopName,
          address: widget.ordersModel.address,
          pic: widget.ordersModel.listPics.first);
    }else if(widget.type == 2) {
      _provide.submitOrdersModel = SSSubmitOrdersModel(number: widget.buyNumber,
          price: widget.otherDetailsModel.sharePrice,
          allPrice: (widget.buyNumber*double.parse(widget.otherDetailsModel.sharePrice)).toString(),
          shopName: widget.otherDetailsModel.shopName,
          address: widget.otherDetailsModel.address,
          pic: widget.otherDetailsModel.infoPics.first);
    }
    else {
      _provide.submitOrdersModel = SSSubmitOrdersModel(number: widget.buyNumber,
          price: widget.ordersModel.sharePrice,
          allPrice: (widget.buyNumber*double.parse(widget.ordersModel.sharePrice)).toString(),
          shopName: widget.ordersModel.shopName,
          address: widget.ordersModel.address,
          pic: widget.ordersModel.infoPics.first);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(context, title: '提交订单'),
      body: _initViews(),
      resizeToAvoidBottomPadding: false,
    );
  }

  _initViews() => SafeArea(child: SingleChildScrollView(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _topWidget(),
              _contentWidget(),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 35, right: 31),
            color: Colors.white,
            height: 84,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('应付总额', style: TextStyle(fontSize: 12, color: Colors.grey),),
                Row(
                  children: [
                    Text('¥'+_provide.submitOrdersModel.allPrice, style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),),
                    SizedBox(width: 15,),
                    GestureDetector(
                      onTap: (){
                        _submitOrder();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular((5.0)), // 圆
                          color: Colors.redAccent,// 角度
                        ),
                        padding: EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
                        child: Text('提交订单', style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  ),);

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
        SizedBox(width: 15,),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_provide.submitOrdersModel.shopName),
            Text(_provide.submitOrdersModel.address),
          ],
        ),),
        Image.asset('Assets/share_shop/orange_phone.png'),
      ],
    ),
  );

  _contentWidget() => Container(
    margin: EdgeInsets.only(top: 10, left: 15, right: 15),
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
                border: Border.all(color: Colors.grey,width: 1),
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(image: NetworkImage(_provide.submitOrdersModel.pic), fit: BoxFit.fill),
              ),
            ),
            SizedBox(width: 21,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_provide.submitOrdersModel.goodsName, maxLines: 2,overflow: TextOverflow.ellipsis,softWrap: true, style: TextStyle(fontSize: 14),),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('¥'+_provide.submitOrdersModel.price, style: TextStyle(color: Colors.red, fontSize: 13),),
                    Text('x'+_provide.submitOrdersModel.number.toString(), style: TextStyle(color: Colors.grey, fontSize: 13),),
                  ],),
              ],
            ),),
          ],
        ),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('商品金额'),
            Text('¥'+_provide.submitOrdersModel.allPrice, style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
        SizedBox(height: 10,),
        Container(height: 1, color: AppColors.ViewBackgroundColor,),
        SizedBox(height: 25,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('订单详情'),
            SizedBox(width: 20,),
            Expanded(child: TextField(
              controller: _textEditingController,
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText:'可以告诉门店你的需求',
                border: InputBorder.none,
              ),
            ),),
          ],
        ),
        SizedBox(height: 10,),
        Container(height: 1, color: AppColors.ViewBackgroundColor,),
        SizedBox(height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('共计'+_provide.submitOrdersModel.number.toString()+'件 合计：'),
            Text('¥'+_provide.submitOrdersModel.allPrice, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
          ],
        ),
      ],
    ),
  );


  _submitOrder(){
    ///0平台商品 1 共享商品 2共享工具 3二手配件
    String totalPrice = _provide.submitOrdersModel.allPrice;
    var s1 = _provide
        .postSubmitOrder(count: _provide.submitOrdersModel.number.toString(), price:totalPrice, remarks:_textEditingController.text, shopGoodsId:widget.shopGoodsId, equipmentId: widget.equipmentId, type:widget.type.toString())
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
      Map res = convert.jsonDecode(event.toString());
      if(res['data'] == true){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SSPaymentDetailsPage(totalPrice: totalPrice, orderId: res['msg'], submitOrdersModel: _provide.submitOrdersModel, buyNumber: widget.buyNumber, remark: _textEditingController.text,)));
      }else {
        BotToast.showText(text: (res['msg']));
      }
    }, onError: (e) {});
    _subscriptions.add(s1);
  }
}
