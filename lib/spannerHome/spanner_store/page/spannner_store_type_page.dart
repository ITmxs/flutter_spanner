import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/spanner_store/model/spanner_store_type_model.dart';
import 'package:spanners/spannerHome/spanner_store/page/spanner_goods_details_page.dart';
import 'package:spanners/spannerHome/spanner_store/page/spanner_shop_cart_page.dart';
import 'package:spanners/spannerHome/spanner_store/provide/spanner_store_type_provide.dart';
import 'package:rxdart/rxdart.dart';

class SpannerStoreTypePage extends StatefulWidget {

  final String goodsTypeID;

  const SpannerStoreTypePage({Key key, this.goodsTypeID}) : super(key: key);

  @override
  _SpannerStoreTypePageState createState() => _SpannerStoreTypePageState();
}

class _SpannerStoreTypePageState extends State<SpannerStoreTypePage> {

  SpannerStoreTypeProvide _provide;
  final _subscriptions = CompositeSubscription();
  final controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    _provide = SpannerStoreTypeProvide();
    _loadData();
  }

  _loadData({String searchKey}){
    var s = _provide
        .getGoodsList(id: widget.goodsTypeID, searchKey: searchKey)
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
        body: _initWidget(),
        ),
    );
  }

  _initWidget() => Container(
    color: Colors.black12,
    child: Column(
      children: [
        Container(
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
            child: _searchView(),
          ),
        ),
        Expanded(
          child: _listWidget(),),
      ],
    ),
  );

  _searchView() => Container(
    margin: EdgeInsets.only(top: 0, left: 0, right: 0),
    padding: EdgeInsets.only(left: 0, right: 0),
    height: 30,
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
            _loadData(searchKey: controller.text);
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Icon(Icons.search),
        ),
      ],
    ),
  );

  _doneButtonAction(String messageStr) {
    if (messageStr == null || messageStr.length <= 0) {
      print('不能为空');
      return;
    }
    controller.text = messageStr;
    _loadData(searchKey:controller.text);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _listWidget() => Selector<SpannerStoreTypeProvide, List>(builder: (_, contentList, child){
    return Container(
      color: AppColors.ViewBackgroundColor,
      child: ListView.builder(
        itemCount: _provide.contentList.length,
        itemBuilder: (BuildContext context, int position) {
          return _getContentItem(position);
        },
      ),
    );
  }, selector: (_, provide)=> _provide.contentList);


  _getContentItem(int index) {

    SpannerStoreTypeListModel model = _provide.contentList[index];

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SpannerGoodsDetailsPage(shopGoodsId: model.id,),),);
      },
      child: Container(
        margin: EdgeInsets.all(15),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '¥'+model.goodPrise,
                          maxLines: 1,
                          style:
                          TextStyle(fontSize: 15, color: Colors.red,),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '¥'+model.partsCost,
                          maxLines: 1,
                          style:
                          TextStyle(fontSize: 12, color: AppColors.SubTextColor, decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
