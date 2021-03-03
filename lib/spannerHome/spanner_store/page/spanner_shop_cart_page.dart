import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/spanner_store/model/spanner_order_details_model.dart';
import 'package:spanners/spannerHome/spanner_store/model/spanner_shop_cart_model.dart';
import 'package:spanners/spannerHome/spanner_store/page/spanner_order_details_page.dart';
import 'package:spanners/spannerHome/spanner_store/provide/spanner_shop_cart_provide.dart';
import 'dart:convert' as convert;

class SpannerShopCartPage extends StatefulWidget {
  @override
  _SpannerShopCartPageState createState() => _SpannerShopCartPageState();
}

class _SpannerShopCartPageState extends State<SpannerShopCartPage> {
  SpannerShopCartProvide _provide;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    _provide = SpannerShopCartProvide();
    _loadData();
  }

  _loadData() {
    var s = _provide
        .getShopCartInfo()
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {
      _calculatePrice();
    }, onError: (e) {});
    _subscriptions.add(s);
  }

  _changeCount({String count, String cartId, String shopGoodsId}){
    var s = _provide
        .postChangeCount(count: count, cartId: cartId, shopGoodsId: shopGoodsId)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {
      Map res = convert.jsonDecode(data.toString());
      var result = res['data'];
      if(result){
        _loadData();
      }else {
        BotToast.showText(text: '网络请求错误' + res['msg']);
      }
    }, onError: (e) {});
    _subscriptions.add(s);
  }

  _allDelete({List deleteList}){
    var s = _provide
        .postAllDelete(cartIds: deleteList)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {
          _loadData();
    }, onError: (e) {});
    _subscriptions.add(s);
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '订货单'),
        body: _initWidget(),
      ),
    );
  }

  _initWidget() => Selector<SpannerShopCartProvide, List>(
      builder: (_, goodsList, child) {
        return Container(
          color: AppColors.ViewBackgroundColor,
          padding: EdgeInsets.only(top: 7),
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 25, right: 45, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '共' + goodsList.length.toString() + '件',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        _provide.management = !_provide.management;
                        setState(() {});
                      },
                      child: Text(
                        _provide.management ? '完成' : '管理',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return _itemWidget(index);
                  },
                  itemCount: goodsList.length,
                ),
              ),
              _cartManagement(),
            ],
          ),
        );
      },
      selector: (_, provide) => _provide.goodsList);

  _itemWidget(int index) {
    SpannerShopCartModel model = _provide.goodsList[index];
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 3, right: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _provide.selectItem[index] = !_provide.selectItem[index];
                _calculatePrice();
              });
            },
            child: Image.asset(
              _provide.selectItem[index]
                  ? 'Assets/settlement/select_btn_yes.png'
                  : 'Assets/settlement/select_btn_no.png',
              width: 20,
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            margin: EdgeInsets.only(top: 23, bottom: 23),
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
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.name,
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
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      ),
                      index >= 0
                          ? Container(
                              width: 80,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                // 边色与边宽度
                                borderRadius: BorderRadius.circular((5.0)), // 圆
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    child: Icon(
                                      Icons.remove,
                                      size: 13,
                                    ),
                                    onTap: () {
                                      int count = int.parse(model.count);
                                      if(count>1) {
                                        count -= 1;
                                        _changeCount(count: count.toString(), cartId: model.cartId, shopGoodsId: model.shopGoodsId);
                                        _calculatePrice();
                                      }
                                    },
                                  ),
                                  Container(
                                    width: 0.5,
                                    height: 22,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    model.count,
                                    style: TextStyle(fontSize: 13),
                                  ),
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
                                      int count = int.parse(model.count);
                                      count += 1;
                                      _changeCount(count: count.toString(), cartId: model.cartId, shopGoodsId: model.shopGoodsId);
                                    },
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 29,
                                height: 22,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                  // 边色与边宽度
                                  borderRadius:
                                      BorderRadius.circular((5.0)), // 圆
                                ),
                                child: Text(
                                  model.count,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _cartManagement() => Selector<SpannerShopCartProvide, bool>(
      builder: (_, management, child) {
        return Container(
          padding: EdgeInsets.only(left: 18, right: 31),
          color: Colors.white,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _provide.allSelectItem = !_provide.allSelectItem;
                        _calculatePrice();
                      });
                    },
                    child: Image.asset(
                      _provide.allSelectItem
                          ? 'Assets/settlement/select_btn_yes.png'
                          : 'Assets/settlement/select_btn_no.png',
                      width: 20,
                    ),
                  ),
                  Text('全选'),
                ],
              ),
              management
                  ? GestureDetector(
                onTap: (){
                  List deleteList = [];
                   for(int i=0;i<_provide.selectItem.length;i++) {
                     if(_provide.selectItem[i]) {
                       SpannerShopCartModel model = _provide.goodsList[i];
                       deleteList.add(model.cartId);
                     }
                   }
                   _allDelete(deleteList: deleteList);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  alignment: Alignment.center,
                  width: 90,
                  height: 30,
                  child: Text(
                    '删除',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
                  : Row(
                      children: [
                        Text(
                          '¥' + _provide.allPrice,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: (){
                            List modelList = [];
                            List buyNumberList = [];
                            List shopGoodsIdList = [];
                            for(int i=0;i<_provide.selectItem.length;i++){
                              if(_provide.selectItem[i]) {
                                SpannerShopCartModel model = _provide.goodsList[i];
                                buyNumberList.add(int.parse(model.count));
                                shopGoodsIdList.add(model.shopGoodsId);
                                SpannerOrderDetailsModel orderModel = SpannerOrderDetailsModel(
                                    number: int.parse(model.count),
                                    price: model.price,
                                    allPrice:
                                    (int.parse(model.count) * double.parse(model.price))
                                        .toString(),
                                    shopName: model.buyerShopName,
                                    address: model.buyerShopAddress,
                                    pic: model.picUrl,
                                    tel: model.sellTel);
                                modelList.add(orderModel);
                              }
                            }
                            SpannerShopCartModel model = _provide.goodsList.first;
                            if(_provide.selectNumber > 0){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SpannerOrderDetailsPage(buyerAddress: model.buyerShopAddress, buyerShopName: model.buyerShopName, ordersModelList: modelList, buyNumberList: buyNumberList, shopGoodsIdList: shopGoodsIdList,)));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            alignment: Alignment.center,
                            width: 90,
                            height: 30,
                            child: Text(
                              '结算（'+ _provide.selectNumber.toString()+'）',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
      selector: (_, provide) => _provide.management);

  _calculatePrice(){
    double allPrice = 0.0;
    _provide.selectNumber = 0;
    for(int i=0;i<_provide.selectItem.length;i++){
      if(_provide.selectItem[i]) {
        SpannerShopCartModel model = _provide.goodsList[i];
        allPrice += (double.parse(model.count)*double.parse(model.price));
        _provide.selectNumber++;
      }
    }
    _provide.allPrice = allPrice.toString();
  }

}
