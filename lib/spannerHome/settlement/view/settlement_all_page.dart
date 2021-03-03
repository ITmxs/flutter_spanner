import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/settlement/provide/settlement_all_provide.dart';
import 'dart:convert' as convert;

class SettlementAllPage extends StatefulWidget {

  final List orderIdList;

  const SettlementAllPage({Key key, this.orderIdList}) : super(key: key);

  @override
  _SettlementAllPageState createState() => _SettlementAllPageState();
}

class _SettlementAllPageState extends State<SettlementAllPage> {

  final _subscriptions = CompositeSubscription();
  SettlementAllProvide _provide;
  TextEditingController _textEditingController;

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _provide = SettlementAllProvide();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        print('弹出键盘');
      }
    });
    _loadData();
  }

  _loadData(){
    var s = _provide.postAllSettlementDetails(widget.orderIdList).doOnListen(() {
    }).doOnCancel(() {
    }).listen((data) {
    }, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '统一结算'),
        body: _initViews(),
      ),
    );
  }

  _initViews() => Consumer<SettlementAllProvide>(
    builder: (_, provide, child) {
      return  Container(
        color: AppColors.ViewBackgroundColor,
        child: Container(
          color: AppColors.ViewBackgroundColor,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('已选中车主',style: TextStyle(fontSize: 14, color: AppColors.TextColor),), Text(' '+judgeStringValue(_provide.allModel.realName)+' ',style: TextStyle(fontSize: 16, color: AppColors.TextColor, fontWeight: FontWeight.w600),), Text('名下',style: TextStyle(fontSize: 14, color: AppColors.TextColor),),Text(' '+judgeStringValue(_provide.allModel.orderCount)+'个订单 ',style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600),),Text('进行统一结算',style: TextStyle(fontSize: 14, color: AppColors.TextColor),),],
          ),
        ),
      ),
    ];

    widgetList.add(SliverPadding(
      padding: EdgeInsets.only(top: 21, bottom: 21),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 19, top: 12, right: 26, bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _moneyInfo(),
          ),
        ),
      ),
    ));

    ///支付方式
    widgetList.add(
      SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              color: AppColors.primaryColor,
              width: 3,
              height: 14,
              margin: EdgeInsets.only(right: 5),
            ),
            Text(
              '支付方式',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );

    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.only(left: 12, right: 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '线下支付',
                      style: TextStyle(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: (){
                        _provide.payType = !_provide.payType;
                      },
                      child: Image.asset(_provide.payType?'Assets/settlement/select_btn_no.png':'Assets/settlement/select_btn_yes.png', width: 15,),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppColors.ViewBackgroundColor,
              ),
              _provide.allModel.memberFlag=='1'?Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '余额支付',
                      style: TextStyle(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: (){
                        _provide.payType = !_provide.payType;
                      },
                      child: Image.asset(_provide.payType?'Assets/settlement/select_btn_yes.png':'Assets/settlement/select_btn_no.png', width: 15,),
                    ),
                  ],
                ),
              ):Container(),
            ],
          ),
        ),
      ),
    );

    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 72, bottom: 98),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  _payment(_provide.payType);
                },
                child: Container(
                  width: 75,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '结算',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return widgetList;
  }

  List<Widget> _moneyInfo() {
    _textEditingController.text = '0';
    List<Widget> widgetList = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '消费总金额',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            '¥' + judgeStringValue(_provide.allModel.consumeAmount),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      SizedBox(
        height: 23,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '预付总金额',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            '¥' + judgeStringValue(_provide.allModel.prepaymentAmount),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      SizedBox(
        height: 23,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '尾款金额',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            '¥' + judgeStringValue(_provide.allModel.totalAmount),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ];

    widgetList.addAll([
      SizedBox(
        height: 30,
      ),
      Container(
        color: AppColors.ViewBackgroundColor,
        height: 1,
      ),
      SizedBox(
        height: 16,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '已优惠',
            style: TextStyle(fontSize: 13),
          ),
          Text(
            '¥'+judgeStringValue(_provide.allModel.disCountAmount),
            style: TextStyle(fontSize: 13, color: Colors.red),
          ),
          Text(
            '实收',
            style: TextStyle(fontSize: 13),
          ),
          Text(
            '¥'+(double.parse(judgeStringValue(_provide.allModel.totalAmount))+double.parse(judgeStringValue(_provide.allModel.prepaymentAmount))).toString(),
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red),
          ),
        ],
      )
    ]);

    return widgetList;
  }

  _payment(bool type){
    var s = _provide.postAllPayment(type, widget.orderIdList).doOnData((event) {
    }).doOnListen(() {
    }).doOnCancel(() {
    }).listen((data) {
      Map res = convert.jsonDecode(data.toString());
      print(data);
      var results = res['data'];
      if(results is String){
        BotToast.showText(text: results);
      }else {
        Navigator.of(context).pop(true);
      }
    }, onError: (e) {});
    _subscriptions.add(s);
  }

}
