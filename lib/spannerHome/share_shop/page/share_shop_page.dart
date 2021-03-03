import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/base/kapp_bar.dart';
import 'package:spanners/spannerHome/share_shop/model/share_shop_model.dart';
import 'package:spanners/spannerHome/share_shop/page/ss_goods_details_page.dart';
import 'package:spanners/spannerHome/share_shop/page/ss_other_details_page.dart';
import 'package:spanners/spannerHome/share_shop/page/ss_second_details.dart';
import 'package:spanners/spannerHome/share_shop/page/ss_service_details_page.dart';
import 'package:spanners/spannerHome/share_shop/provide/share_shop_provide.dart';


class ShareShopPage extends StatefulWidget {
  @override
  _ShareShopPageState createState() => _ShareShopPageState();
}

class _ShareShopPageState extends State<ShareShopPage> with SingleTickerProviderStateMixin {

  // 选项卡控制器
  TabController _tabController;
  ShareShopProvide _provide;
  ShareShopPageType _shareShopPageType;
  final controller = TextEditingController();
  ScrollController _contentScrollController;
  final _subscriptions = CompositeSubscription();
  ShareShopSortType _shareShopSortType;
  @override
  void initState() {
    super.initState();
    _provide = ShareShopProvide();
    _shareShopPageType = ShareShopPageType.ShareShopPageGoods;
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(() {
        switch (_tabController.index) {
          case 0:
            _shareShopPageType = ShareShopPageType.ShareShopPageGoods;
            _shareShopSortType = ShareShopSortType.ShareShopSortAsc;
            break;
          case 1:
            _shareShopPageType = ShareShopPageType.ShareShopPageEquipment;
            _shareShopSortType = ShareShopSortType.ShareShopSortAsc;
            break;
          case 2:
            _shareShopPageType = ShareShopPageType.ShareShopPageSecondHand;
            _shareShopSortType = ShareShopSortType.ShareShopSortAsc;
            break;
          case 3:
            _shareShopPageType = ShareShopPageType.ShareShopPageService;
            _shareShopSortType = ShareShopSortType.ShareShopSortAsc;
            break;
        }
        _loadListData();
      });

    _loadListData();

  }

  _loadListData({String searchKey}) {
    String properties = '';
    String sort = '';
    print(_shareShopSortType);
    switch(_shareShopSortType){
      case ShareShopSortType.ShareShopSortAsc:
        properties = '';
        sort = 'asc';
        break;
      case ShareShopSortType.ShareShopSortDesc:
        properties = '';
        sort = 'desc';
        break;
      case ShareShopSortType.ShareShopSortDistance:
        properties = 'distance';
        sort = '';
        break;
    }

    var s = _provide
        .getShareShopQueryList(_tabController.index.toString(), properties: properties, sort: sort, searchKey:searchKey)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {}, onError: (e) {});
  _subscriptions.add(s);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '扳手共享'),
        body: _initViews(),
      ),
    );
  }

  final List<Tab> tabs = <Tab>[
    Tab(
      text: '商品',
    ),
    Tab(
      text: '工具',
    ),
    Tab(
      text: '二手配件',
    ),
    Tab(
      text: '服务',
    ),
  ];

  _initViews() => SafeArea(
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
                    SliverToBoxAdapter(
                      child: _searchWidget(),
                    ),
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
                    children: [
                      _goodsSelector(),
                      _goodsSelector(),
                      _goodsSelector(),
                      _goodsSelector(),
                    ]),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  _searchWidget() => Container(
    padding: EdgeInsets.only(
        top: 10, bottom: 10, left: 23, right: 23),
    height: 50,
    color: Colors.white,
    child: GestureDetector(
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.ViewBackgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: _doneButtonAction,
                      controller: controller,
                      textAlignVertical: TextAlignVertical.bottom,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.TextColor,
                      ),
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        print(value);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: '快速搜索',
                        hintStyle:
                        TextStyle(fontSize: 13, color: AppColors.TextColor),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      _loadListData(searchKey: controller.text);
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Icon(Icons.search),
                  ),
                ],
              ),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(right: 20),
              padding: EdgeInsets.only(left: 39, right: 24),
            ),
          ),
        ],
      ),
      onTap: () {

      },
    ),
  );

  _doneButtonAction(String messageStr) {
    if (messageStr == null || messageStr.length <= 0) {
      print('不能为空');
      return;
    }
    _loadListData(searchKey: messageStr);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  ///
  Widget _goodsSelector() => Container(
    child: Column(
      children: [
        _screenWidget(),
        Expanded(child: _contentList(),),
      ],
    ),
  );

  ///筛选条件
  Widget _screenWidget() => Selector<ShareShopProvide, List>(selector: (_,provide)=>_provide.countList , builder: (_, modelList, child) => Container(
      color: Colors.white,
      height: 40,
      padding: EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              if(_shareShopSortType == ShareShopSortType.ShareShopSortAsc){
                _shareShopSortType = ShareShopSortType.ShareShopSortDesc;
              }else {
                _shareShopSortType = ShareShopSortType.ShareShopSortAsc;
              }
              _loadListData();
            },
            child: Container(
              margin: EdgeInsets.only(right: 40),
              child: Row(
                children: [
                  Text(
                    '价格',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 5,),
                  Image.asset(_shareShopSortType == ShareShopSortType.ShareShopSortAsc?'Assets/share_shop/share_price_up.png':_shareShopSortType == ShareShopSortType.ShareShopSortDesc?'Assets/share_shop/share_price_down.png':'Assets/share_shop/share_price_up.png'),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _shareShopSortType = ShareShopSortType.ShareShopSortDistance;
              _loadListData();
            },
            child: Container(
              margin: EdgeInsets.only(right: 40),
              child: Text(
                '附近',
                style: TextStyle(
                    fontSize: 13,
                    color: _shareShopSortType == ShareShopSortType.ShareShopSortDistance?AppColors.primaryColor:Colors.black87
                ),
              ),
            ),
          ),
        ],
      ),
    ),);

  ///内容
  Widget _contentList() => Selector<ShareShopProvide, List>(
    selector: (_,provide)=>_provide.countList,
    builder: (_, modelList, child) => ListView.builder(
      controller: _contentScrollController,
      itemBuilder: _listItem,
      itemCount: _provide.countList.length,
    ),
  );

  Widget _listItem(BuildContext context, int index) => Container(
    margin: EdgeInsets.only(left: 17, right: 15, bottom: 10, top: 9),
    height: 135,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(3.0),
      boxShadow: [
        BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 3.0),
            blurRadius: 3.0,
            spreadRadius: 1.0)
      ],
    ),
    child: GestureDetector(
      onTap: (){
        ShareShopModel model = _provide.countList[index];
        if(_shareShopPageType == ShareShopPageType.ShareShopPageService){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SSServiceDetailsPage(id: model.id,)),);
        }else if(_shareShopPageType == ShareShopPageType.ShareShopPageGoods){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SSGoodsDetailsPage(shopGoodsId: model.id,)),);
        }else if(_shareShopPageType == ShareShopPageType.ShareShopPageEquipment){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SSOtherDetailsPage(equipmentId: model.id,)),);
        }else {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SSSecondDetailsPage(shopGoodsId: model.id,)),);
        }
      },
      child: _selectCell(_shareShopPageType ,_provide.countList[index]),
    ),
  );

  _selectCell(ShareShopPageType type, ShareShopModel model){
    switch(type){
      case ShareShopPageType.ShareShopPageGoods:
        return _itemCell(model, showStartPrice: true);
      case ShareShopPageType.ShareShopPageEquipment:
        return _itemCell(model);
      case ShareShopPageType.ShareShopPageSecondHand:
        return _itemCell(model);
      case ShareShopPageType.ShareShopPageService:
        return _serviceCell(model);
    }
  }

  _itemCell(ShareShopModel model, {bool showStartPrice = false}) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
    ),
    padding: EdgeInsets.only(right: 10),
    child: Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, top: 23, bottom: 23),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.name,
                maxLines: 2,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.shopName,
                    maxLines: 1,
                    style:
                    TextStyle(fontSize: 13, color: AppColors.SubTextColor),
                  ),
                  Text(
                    model.distance,
                    maxLines: 1,
                    style:
                    TextStyle(fontSize: 13, color: AppColors.SubTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '¥'+model.sharePrice,
                    maxLines: 1,
                    style:
                    TextStyle(fontSize: 15, color: Colors.red,),
                  ),
                  showStartPrice?Text(
                    '¥'+model.goodPrise,
                    maxLines: 1,
                    style:
                    TextStyle(fontSize: 12, color: AppColors.SubTextColor, decoration: TextDecoration.lineThrough),
                  ):Container(),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
  _serviceCell(ShareShopModel model) => Container(
    color: Colors.white,
    padding: EdgeInsets.only(right: 10, left: 20, top: 15),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                model.name,
                maxLines: 2,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '¥'+model.sharePrice,
                maxLines: 1,
                style:
                TextStyle(fontSize: 15, color: Colors.red,),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                model.remark,
                maxLines: 2,
                style:
                TextStyle(fontSize: 13, color: AppColors.SubTextColor),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.shopName,
                    maxLines: 1,
                    style:
                    TextStyle(fontSize: 13, color: AppColors.TextColor),
                  ),
                  Text(
                    model.distance+'km',
                    maxLines: 1,
                    style:
                    TextStyle(fontSize: 13, color: AppColors.TextColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

}


enum ShareShopPageType {
  /// 库存商品
  ShareShopPageGoods,

  /// 设备管理
  ShareShopPageEquipment,

  /// 二手配件
  ShareShopPageSecondHand,

  /// 服务
  ShareShopPageService,
}

enum ShareShopSortType {
  /// 价格升序
  ShareShopSortAsc,

  /// 价格降序
  ShareShopSortDesc,

  /// 附近距离
  ShareShopSortDistance,

}