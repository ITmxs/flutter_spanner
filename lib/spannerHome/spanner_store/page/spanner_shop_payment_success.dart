import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/share_shop/model/ss_submit_orders_model.dart';
import 'package:spanners/spannerHome/share_shop/provide/ss_payment_success_provide.dart';
import 'package:spanners/spannerHome/spanner_store/model/spanner_order_details_model.dart';


class SpannerShopPaymentSuccessPage extends StatefulWidget {

  final List submitOrdersModelList;
  final List buyNumberList;
  final List remarkList;
  final int backCount;
  const SpannerShopPaymentSuccessPage(this.backCount, {Key key, this.submitOrdersModelList, this.buyNumberList, this.remarkList}) : super(key: key);
  @override
  _SpannerShopPaymentSuccessPageState createState() => _SpannerShopPaymentSuccessPageState();
}

class _SpannerShopPaymentSuccessPageState extends State<SpannerShopPaymentSuccessPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '订单支付',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
        ),
        backgroundColor: AppColors.AppBarColor,
        elevation: 0,
        leading: FlatButton(
          child: Image(
            image: AssetImage('Assets/appbar/back.png'),
          ),
          onPressed: () {
            if(widget.backCount == 1){
              Navigator.of(context)..pop()..pop(true);
            }
            else if(widget.backCount == 2){
              Navigator.of(context)..pop()..pop()..pop(true);
            }
            else {
              Navigator.of(context)..pop()..pop()..pop()..pop();
            }
          },
        ),
      ),
      body: _initViews(),
    );
  }

  _initViews() => Container(
    color: AppColors.ViewBackgroundColor,
    // padding: EdgeInsets.only(left: 15, top: 15, right: 15),
    child: CustomScrollView(
      slivers: _sliverWidget(),
    ),
  );

  List<Widget> _sliverWidget() {
    List<Widget> widgetList = [
      ///用户信息
      SliverToBoxAdapter(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 15, top: 15, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Image.asset('Assets/share_shop/payment_success.png'),
                  Text('支付成功', style: TextStyle(fontSize: 16),),
                  SizedBox(height: 23,),
                  GestureDetector(
                    onTap: (){
                      print('跳转订单页面');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 85,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 1),
                      ),
                      child: Text('查看订单', style: TextStyle(fontSize: 14),),
                    ),
                  ),
                  SizedBox(height: 27,),
                ],
              ),
            ),
          ],
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.only(
          top: 10,
        ),
        sliver: SliverFixedExtentList(
          itemExtent: 400,
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return _contentWidget(index);
            },
            childCount: widget.submitOrdersModelList.length, //50个列表项
          ),
        ),
      ),
    ];

    return widgetList;
  }

  _contentWidget(int index) {
    SpannerOrderDetailsModel model = widget.submitOrdersModelList[index];
    TextEditingController textEditingController = widget.remarkList[index];
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
      padding: EdgeInsets.only(top: 23, left: 15, right: 12, bottom: 10),
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
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: NetworkImage(model.pic),
                      fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                width: 21,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.goodsName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '¥' + model.price,
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                        Text(
                          'x' + model.number.toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 43,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('商品金额'),
              Text(
                '¥' + model.allPrice,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            color: AppColors.ViewBackgroundColor,
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('订单详情'),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(textEditingController.text, style: TextStyle(), textAlign: TextAlign.right,),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            color: AppColors.ViewBackgroundColor,
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('共计' +
                  model.number.toString() +
                  '件 合计：',
                style:
                TextStyle(fontWeight: FontWeight.bold),),
              Text(
                '¥' + model.allPrice,
                style:
                TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
