import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/settlement/model/preferential_card_model.dart';
import 'package:spanners/spannerHome/settlement/provide/preferential_card_provide.dart';

class PreferentialCardPage extends StatefulWidget {
  final String workOrderId;
  final List selectCardList;

  const PreferentialCardPage(this.workOrderId, this.selectCardList, {Key key})
      : super(key: key);

  @override
  _PreferentialCardPageState createState() => _PreferentialCardPageState();
}

class _PreferentialCardPageState extends State<PreferentialCardPage> {
  PreferentialCardProvide _provide;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();

    _provide = PreferentialCardProvide();
    _loadData();
  }

  _loadData() {
    var s = _provide
        .getCouponList(widget.workOrderId, widget.selectCardList)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '优惠卡',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
          ),
          backgroundColor: AppColors.AppBarColor,
          elevation: 1,
          leading: FlatButton(
            child: Image(
              image: AssetImage('Assets/appbar/back.png'),
            ),
            onPressed: () {
              Navigator.of(context).pop([]);
            },
          ),
        ),
        body: _initViews(),
      ),
    );
  }

  _initViews() => Consumer<PreferentialCardProvide>(
        builder: (_, provide, child) {
          return Container(
            color: Colors.white,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 15, right: 15, top: 6),
              child: CustomScrollView(
                slivers: _sliverWidget(),
              ),
            ),
          );
        },
      );

  List<Widget> _sliverWidget() {
    List<Widget> widgetList = [
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Text('可使用优惠卡（${_provide.pCardModelList.length.toString()}）'),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.only(bottom: 80),
        sliver: SliverFixedExtentList(
          itemExtent: 111,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _cardItem(index);
            },
            childCount: _provide.pCardModelList.length, //50个列表项
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                List selectCardId = List();
                for(int i=0; i<_provide.selectList.length;i++) {
                  bool judge = _provide.selectList[i];
                  if(judge) {
                    PreferentialCardModel model = _provide.pCardModelList[i];
                    selectCardId.add(model);
                  }
                }
                print(selectCardId);
                Navigator.of(context).pop(selectCardId);
              },
              child: Container(
                alignment: Alignment.center,
                width: 85,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: EdgeInsets.only(top: 100, bottom: 80),
                child: Text(
                  '确认',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
    return widgetList;
  }

  _cardItem(int index) {
    PreferentialCardModel model = PreferentialCardModel();
    model = _provide.pCardModelList[index];
    return GestureDetector(
      onTap: () {
        _provide.selectList[index] = !_provide.selectList[index];
        _provide.reload();
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Color(0xFFFEF5F0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('Assets/settlement/card_type.png'),
                    Text(
                      model.campaignName,
                      style: TextStyle(fontSize: 11, color: Colors.red),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '¥',
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      ),
                      Text(
                        model.buyPrice,
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  model.campaignName,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '有效期至 ${model.endTime} 23：59',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                Text(
                  model.remarks+model.frequency+' 次',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
            _provide.selectList[index]
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset('Assets/settlement/card_select_btn.png'),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
