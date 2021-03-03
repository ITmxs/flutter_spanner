import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/spanner_store/model/spanner_store_model.dart';
import 'package:spanners/spannerHome/spanner_store/page/spanner_shop_cart_page.dart';
import 'package:spanners/spannerHome/spanner_store/page/spannner_store_type_page.dart';
import 'package:spanners/spannerHome/spanner_store/provide/spanner_store_provide.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

class SpannerStorePage extends StatefulWidget {
  @override
  _SpannerStorePageState createState() => _SpannerStorePageState();
}

class _SpannerStorePageState extends State<SpannerStorePage> {

  SpannerStoreProvide _provide;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    _provide = SpannerStoreProvide();
    _loadData();
  }

  _loadData(){
    var s = _provide
        .getTypeList()
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {
      Map res = convert.jsonDecode(data.toString());
      List resList = res['data'];
      _loadContentData(resList.first['id']);
    }, onError: (e) {});
    _subscriptions.add(s);
  }

  _loadContentData(String id){
    var s = _provide
        .getContentList(id: id)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    _initParameters(context);
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "扳手商城",
            style: TextStyle(color: Colors.black87),
          ),
          //背景颜色
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          //后面放置图标
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.event_note,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SpannerShopCartPage()),
                );
              },
            ),
          ],
        ),
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (ScrollNotification notification){
            _handleNotification(notification);
            return true;
          },
          child: _initWidget(),
        ),
      ),
    );
  }

  _initParameters(BuildContext context){
    _provide.sHeight = MediaQuery.of(context).size.height;
    _provide.listViewHeight = _provide.sHeight + _provide.bannerHeight;
  }



  _initWidget() => Selector<SpannerStoreProvide, int>(builder: (_, selectIndex, child){
    return Container(
      color: Colors.black12,
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SpannerStoreTypePage()),
              );
            },
            child: Container(
              color: Colors.white,
              height: 55,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 23, top: 15, right: 23, bottom: 10),
              child: Container(
                padding: EdgeInsets.only(left: 40, right: 24),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: AppColors.ViewBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('快速搜索'),
                    Icon(Icons.search),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: 160,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('Assets/temp_banner.png', fit: BoxFit.fill,),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _typeListWidget(),
                _typeContentWidget(),
              ],
            ),),
        ],
      ),
    );
  }, selector: (_, provide)=> _provide.selectType);

  _typeListWidget() => Selector<SpannerStoreProvide, List>(builder: (_, typeList, child){
    return Container(
      width: _provide.typeItemWidth,
      color: Colors.white,
      child: ListView.builder(
        itemCount: _provide.typeList.length,
        itemBuilder: (BuildContext context, int position) {
          return getType(position);
        },
      ),
    );
  }, selector: (_, provide)=> _provide.typeList);

  _typeContentWidget() => Selector<SpannerStoreProvide, List>(builder: (_, contentList, child){
    return Container(
      width: MediaQuery.of(context).size.width-_provide.typeItemWidth,
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Container(
            //height: double.infinity,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 10, right: 23, top: 10),
            color: Colors.white,
            child: getContent(_provide.selectType), //传入一级分类下标
          ),
        ],
      ),
    );
  }, selector: (_, provide)=> _provide.contentList);


  Widget getType(int i) {
    Color textColor = AppColors.TextColor; //字体颜色
    bool showUpImg = false;
    bool showDownImg = false;
    if(_provide.selectType+1 == i) {
      showDownImg = true;
    }
    if(_provide.selectType-1 == i) {
      showUpImg = true;
    }
    SpannerStoreTypeModel model = _provide.typeList[i];
    return GestureDetector(
      child: Container(
        height: 50,
        alignment: Alignment.center,
        // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        margin: EdgeInsets.only(bottom: 1),
        decoration: BoxDecoration(
          color: _provide.selectType == i ? Colors.white : AppColors.ViewBackgroundColor,
          border: Border(
            left: BorderSide(
                width: 5,
                color:
                _provide.selectType == i ? AppColors.primaryColor : AppColors.ViewBackgroundColor),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: showDownImg?Image.asset('Assets/spanner_store/store_type_down.png'):Container(),),
            Align(alignment: Alignment.center, child: Text(
              model.name,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
              ),
            ),),
            Align(
              alignment: Alignment.bottomRight,
              child: showUpImg?Image.asset('Assets/spanner_store/store_type_up.png'):Container(),),
          ],
        ),
      ),
      onTap: () {
        _provide.selectType = i; //记录选中的下标
        _loadContentData(model.id);
      },
    );
  }

  Widget getContent(int i) {

    return Wrap(
      spacing: 14.0, //两个widget之间横向的间隔
      direction: Axis.horizontal, //方向
      alignment: WrapAlignment.start, //内容排序方式
      children: List<Widget>.generate(
        _provide.contentList.length,
            (int index) {
              SpannerStoreContentModel model = _provide.contentList[index];
              return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SpannerStoreTypePage(goodsTypeID: model.id,)),
              );
            },
            child: Container(
              width: (MediaQuery.of(context).size.width-_provide.typeItemWidth-14*2-33)/3.0,
              child: Column(
                children: [
                Image.network(model.picUrl,
                    width: (MediaQuery.of(context).size.width-_provide.typeItemWidth-14*2-33)/3.0, scale: 1, fit: BoxFit.fill),
                  SizedBox(height: 5,),
                  Text(model.name),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  _handleNotification(ScrollNotification notification) {
    // print('=-------------------------------- viewportDimension ');
    // print(notification.metrics.viewportDimension);
    // print('=-------------------------------- extentBefore ');
    // print(notification.metrics.extentBefore);
    // print('=-------------------------------- extentAfter ');
    // print(notification.metrics.extentAfter);
    // print('=-------------------------------- pixels ');
    // print(notification.metrics.pixels);
    // var totalOffset = notification.metrics.viewportDimension - _itemExtent;//总偏移量=listView高度-Item高度
    // var firstVisible = notification.metrics.extentBefore ~/ _itemExtent;//通过整除，计算出当前第一个可见的Item
    // var lastVisible =
    //     _itemCount - notification.metrics.extentAfter ~/ _itemExtent;//通过整除，计算出当前最后一个可见的Item
    // if (firstVisible <= _adPosition && _adPosition <= lastVisible - 1) {//图片完全处于屏幕中时
    //   if (null == _adStartOffset)//第一次，记录初始偏移量
    //     _adStartOffset = notification.metrics.extentBefore;
    //   var percent = (notification.metrics.extentBefore - _adStartOffset) /
    //       totalOffset;//之后的滑动中，计算相对偏移比例
    //   setState(() {
    //     _adPicAlignment = _calculateAlignment(1 - percent);//改变图片显示位置
    //   });
    // }
    // double beforeOffset = notification.metrics.extentBefore;
    // double afterOffset = notification.metrics.extentAfter;
    // double pixels = notification.metrics.pixels;
    // if(pixels >= _provide.bannerHeight) {
    //   _provide.contentPhysics = AlwaysScrollableScrollPhysics();
    //
    // }
    // else if(pixels < 0){
    //   _provide.contentPhysics = NeverScrollableScrollPhysics();
    // }



    return true;
  }

}
