import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/share_shop/model/ss_goods_details_model.dart';
import 'package:spanners/spannerHome/share_shop/page/ss_submit_orders_page.dart';
import 'package:spanners/spannerHome/share_shop/provide/ss_goods_details_provide.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/spannerHome/spannerHelp.dart/amapGD.dart';

class SSSecondDetailsPage extends StatefulWidget {
  final shopGoodsId;

  const SSSecondDetailsPage({Key key, this.shopGoodsId}) : super(key: key);
  @override
  _SSSecondDetailsPageState createState() => _SSSecondDetailsPageState();
}

class _SSSecondDetailsPageState extends State<SSSecondDetailsPage> {

  SSGoodsDetailsProvide _provide;
  ScrollController _customScrollController;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _customScrollController = ScrollController();
    _provide = SSGoodsDetailsProvide();
    _loadData();
  }

  _loadData(){
    var s = _provide
        .getShareShopGoodsDetails(widget.shopGoodsId)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {}, onError: (e) {
      _loadSpec();
    });
    _subscriptions.add(s);
  }

  _loadSpec(){
    var s = _provide
        .getShareShopGoodsSpec()
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

  _initViews() => SafeArea(child: Selector<SSGoodsDetailsProvide, ShareShopDetailsModel>(builder: (_, model, child)=> Container(
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
              onTap: (){
                _customScrollController.jumpTo(0);
              },
              child: Image.asset('Assets/share_shop/shop_top.png'),
            )),
        Selector<SSGoodsDetailsProvide, bool>(builder: (_, showShopInfo, child) {
          return _provide.showShopInfo?Expanded(
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  Expanded(child: GestureDetector(
                    onTap: (){
                      _provide.showShopInfo = false;
                    },
                    child: Container(
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                  ),),
                  Container(
                    padding: EdgeInsets.only(left: 30, top: 20, right: 26),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _provide.detailsModel.listPics.length>0?Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey,width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(image: NetworkImage(_provide.detailsModel.listPics.first), fit: BoxFit.fill),
                                  ),
                                ):Container(),
                                SizedBox(width: 25,),
                                Text('¥', style: TextStyle(color: Colors.red, fontSize: 15),),
                                Text(_provide.detailsModel.sharePrice, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 15),),
                                SizedBox(width: 10,),
                                Text('市场价', style: TextStyle(color: AppColors.SubTextColor, fontSize: 13),),
                                Text(_provide.detailsModel.goodsPrice, style: TextStyle(color: AppColors.SubTextColor, fontSize: 13, decoration: TextDecoration.lineThrough),),
                              ],
                            ),
                            GestureDetector(
                              onTap: (){
                                _provide.showShopInfo = false;
                              },
                              child: Icon(Icons.close),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Text('型号', style: TextStyle(fontSize: 16),),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 28, right: 28, top: 3, bottom: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFFF4D4C), width: 0.5), // 边色与边宽度
                            borderRadius: BorderRadius.circular((20.0)), // 圆
                            color: Color.fromRGBO(254, 216, 216, 1),// 角度
                          ),
                          child: Text(_provide.detailsModel.model, style: TextStyle(fontSize: 13, color: Color(0xFFFF4D4C),),),
                        ),
                        SizedBox(height: 30,),
                        Text('规格', style: TextStyle(fontSize: 16),),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 28, right: 28, top: 3, bottom: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFFF4D4C), width: 0.5), // 边色与边宽度
                            borderRadius: BorderRadius.circular((20.0)), // 圆
                            color: Color.fromRGBO(254, 216, 216, 1),// 角度
                          ),
                          child: Text(_provide.detailsModel.specName, style: TextStyle(fontSize: 13, color: Color(0xFFFF4D4C),),),
                        ),
                        SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('数量', style: TextStyle(fontSize: 16),),
                                SizedBox(width: 10,),
                                Text('剩余 '+ _provide.detailsModel.shareStock +' 件', style: TextStyle(fontSize: 13),),
                              ],
                            ),
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 0.5), // 边色与边宽度
                                borderRadius: BorderRadius.circular((5.0)), // 圆
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    child: Icon(Icons.remove, size: 13,),
                                    onTap: (){
                                      if(_provide.buyNumber > 1) {
                                        _provide.buyNumber -= 1;
                                      }
                                    },
                                  ),
                                  Container(width: 0.5, height: 22, color: Colors.grey,),
                                  Selector<SSGoodsDetailsProvide, int>(builder: (_, number, child) => Text(_provide.buyNumber.toString(), style: TextStyle(fontSize: 13),) , selector: (_,provide)=>_provide.buyNumber),
                                  Container(width: 0.5, height: 22, color: Colors.grey,),
                                  GestureDetector(
                                    child: Icon(Icons.add, size: 13,),
                                    onTap: (){
                                      if(int.parse(_provide.detailsModel.shareStock) > _provide.buyNumber) {
                                        _provide.buyNumber += 1;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 80,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                _provide.showShopInfo = false;
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SSSubmitOrdersPage(3 ,ordersModel: _provide.detailsModel, buyNumber: _provide.buyNumber, shopGoodsId: widget.shopGoodsId,)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular((5.0)), // 圆
                                  color: Colors.redAccent,// 角度
                                ),
                                padding: EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
                                child: Text('确认购买', style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ):Container();
        }, selector:  (_,provide)=>_provide.showShopInfo)
      ],
    ),
  ), selector:  (_,provide)=>_provide.detailsModel));

  List<Widget> _sliverWidget() {
    List<Widget> widgetList = [
      ///顶部返回键
      SliverToBoxAdapter(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 30,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 30),
            child: Image.asset('Assets/appbar/back.png'),
          ),
        ),
      ),

      ///价格、标题、店名、距离位置
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(left: 30, right: 37, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_provide.detailsModel.shopName),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_provide.detailsModel.specName, style: TextStyle(fontSize: 13),),
                      SizedBox(height: 12,),
                      Text('距离您门店 '+_provide.detailsModel.distance, style: TextStyle(fontSize: 12, color: AppColors.SubTextColor),),
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
          margin: EdgeInsets.only(left: 30, right: 15, top: 14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('已选'),
                  // GestureDetector(
                  //   onTap: (){
                  //     _provide.showShopInfo = true;
                  //   },
                  //   child: Icon(Icons.more_horiz),
                  // )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_provide.detailsModel.model+'，'+_provide.detailsModel.specName+'，'+'1件', style: TextStyle(fontSize: 13),),
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
          margin: EdgeInsets.only(left: 30, right: 37, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('¥', style: TextStyle(color: Colors.red, fontSize: 25),),
                  Text(_provide.detailsModel.sharePrice, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 30),),
                  SizedBox(width: 10,),
                  Text('入手价', style: TextStyle(color: AppColors.SubTextColor, fontSize: 15),),
                  Text(_provide.detailsModel.startingPrise, style: TextStyle(color: AppColors.SubTextColor, fontSize: 15, decoration: TextDecoration.lineThrough),),
                  SizedBox(width: 15,),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFFFB700), width: 0.5), // 边色与边宽度
                      borderRadius: BorderRadius.circular((5.0)), // 圆角度
                    ),
                    child: Text(' 二手配件 ', style: TextStyle(color: Color(0xFFFFB700)),),
                  ),
                ],
              ),
              SizedBox(height: 26,),
              Text(_provide.detailsModel.remarks, style: TextStyle(fontSize: 13),),
              SizedBox(height: 25,),
            ],
          ),
        ),
      ),

    ];

    if(_provide.detailsModel.infoPics != null) {
      for(int i=0;i<_provide.detailsModel.infoPics.length ;i++) {
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
        )
    ));

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
                  Column(
                    children: [
                      Image.asset('Assets/share_shop/shop_iphone.png'),
                      Text('联系门店'),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      _provide.showShopInfo = true;
                    },
                    child: Container(
                      width: 120,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text('确认购买', style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));

    return widgetList;
  }

}
