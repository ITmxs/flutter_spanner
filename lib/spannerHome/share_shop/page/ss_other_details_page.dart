import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/share_shop/model/ss_other_details_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/spannerHome/share_shop/page/ss_submit_orders_page.dart';
import 'package:spanners/spannerHome/share_shop/provide/ss_other_details_provide.dart';
import 'package:spanners/spannerHome/spannerHelp.dart/amapGD.dart';
import 'package:url_launcher/url_launcher.dart';

class SSOtherDetailsPage extends StatefulWidget {

  final equipmentId;

  const SSOtherDetailsPage({Key key, this.equipmentId}) : super(key: key);
  @override
  _SSOtherDetailsPageState createState() => _SSOtherDetailsPageState();
}

class _SSOtherDetailsPageState extends State<SSOtherDetailsPage> {

  SSOtherDetailsProvide _provide;
  ScrollController _customScrollController;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _customScrollController = ScrollController();
    _provide = SSOtherDetailsProvide();
    _loadData();
  }

  _loadData(){
    var s = _provide
        .getShareShopOtherDetails(widget.equipmentId)
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

  _initViews() => SafeArea(child: Selector<SSOtherDetailsProvide, ShareShopOtherDetailsModel>(builder: (_, model, child)=> Container(
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
        Selector<SSOtherDetailsProvide, bool>(builder: (_, showShopInfo, child) {
          return _provide.showShopInfo?Expanded(
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      _provide.showShopInfo = false;
                    },
                    child: Container(
                      height: 275,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                  ),
                  Expanded(child: Container(
                    padding: EdgeInsets.only(left: 30, top: 20),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey,width: 1),
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage('http://bs-brother-bucket.oss-cn-zhangjiakou.aliyuncs.com/carfriend/1605184993947.jpg'), fit: BoxFit.fill),
                              ),
                            ),
                            SizedBox(width: 25,),
                            Text('¥', style: TextStyle(color: Colors.red, fontSize: 15),),
                            Text('269', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 15),),
                            SizedBox(width: 10,),
                            Text('市场价', style: TextStyle(color: AppColors.SubTextColor, fontSize: 13),),
                            Text('500', style: TextStyle(color: AppColors.SubTextColor, fontSize: 13, decoration: TextDecoration.lineThrough),),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Text('型号', style: TextStyle(fontSize: 16),),
                      ],
                    ),
                  ),),
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
          margin: EdgeInsets.only(left: 25, right: 37, top: 30),
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
                      Text(_provide.detailsModel.equipmentName+' '+_provide.detailsModel.specName+' '+_provide.detailsModel.model, style: TextStyle(fontSize: 13),),
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


      ///商品详情
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(left: 25, right: 37, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_provide.detailsModel.equipmentName),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('¥', style: TextStyle(color: Colors.red, fontSize: 25),),
                  Text(_provide.detailsModel.sharePrice, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 30),),
                  SizedBox(width: 10,),
                ],
              ),
              SizedBox(height: 26,),
              Text(_provide.detailsModel.shareDescription, style: TextStyle(fontSize: 13),),
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
                  GestureDetector(
                    onTap: (){
                      launchTelURL(_provide.detailsModel.tel);
                    },
                    child: Column(
                      children: [
                        Image.asset('Assets/share_shop/shop_iphone.png'),
                        Text('联系门店'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SSSubmitOrdersPage(2, otherDetailsModel: _provide.detailsModel, buyNumber: 1, equipmentId: widget.equipmentId,)));
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

  static void launchTelURL(String phone) async {
    String url = 'tel:'+ phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      BotToast.showText(text: '拨号失败！');
    }
  }

}
