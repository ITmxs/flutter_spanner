import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/share_shop/model/ss_submit_orders_model.dart';
import 'package:spanners/spannerHome/share_shop/provide/ss_payment_success_provide.dart';


class SSPaymentSuccessPage extends StatefulWidget {
  final SSSubmitOrdersModel submitOrdersModel;
  final int buyNumber;
  final String remark;
  final String cargoCode;
  const SSPaymentSuccessPage({Key key, this.submitOrdersModel, this.buyNumber, this.remark, this.cargoCode}) : super(key: key);
  @override
  _SSPaymentSuccessPageState createState() => _SSPaymentSuccessPageState();
}

class _SSPaymentSuccessPageState extends State<SSPaymentSuccessPage> {

  SSPaymentSuccessProvide _provide;

  @override
  void initState() {
    super.initState();
    _provide = SSPaymentSuccessProvide();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
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
              Navigator.of(context)..pop()..pop()..pop();
            },
          ),
        ),
        body: _initViews(),
      ),
    );
  }

  _initViews() => Container(
    color: AppColors.ViewBackgroundColor,
    // padding: EdgeInsets.only(left: 15, top: 15, right: 15),
    child: Stack(
      children: [
        Column(
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
                      _provide.showCode = true;
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 85,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.primaryColor, width: 1),
                      ),
                      child: Text('查看取货码', style: TextStyle(color: AppColors.primaryColor, fontSize: 14),),
                    ),
                  ),
                  SizedBox(height: 27,),
                  _contentWidget(),
                ],
              ),
            ),
          ],
        ),
        Selector<SSPaymentSuccessProvide, bool>(builder: (_, showCode, child){
          return showCode? Column(
            children: [
              Expanded(child: GestureDetector(
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                ),
                onTap: (){
                  _provide.showCode = false;
                },
              ),),
              Container(
                color: Colors.white,
                height: 500,
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Icon(Icons.close),
                          onTap: (){
                            _provide.showCode = false;
                          },
                        ),
                        SizedBox(width: 20,),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text('取货码', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(height: 30,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('提货门店：' + widget.submitOrdersModel.shopName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                        SizedBox(height: 10,),
                        Text('门店地址：' + widget.submitOrdersModel.address, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                      ],
                    ),
                    SizedBox(height: 26,),
                    Container(height: 1, color: Colors.grey,),
                    SizedBox(height: 90,),
                    Text(widget.cargoCode, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ],
          ):Container();
        }, selector: (_, provide) => _provide.showCode),
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
                image: DecorationImage(image: NetworkImage(widget.submitOrdersModel.pic), fit: BoxFit.fill),
              ),
            ),
            SizedBox(width: 21,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.submitOrdersModel.goodsName, maxLines: 2,overflow: TextOverflow.ellipsis,softWrap: true, style: TextStyle(fontSize: 14),),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('¥'+widget.submitOrdersModel.price, style: TextStyle(color: Colors.red, fontSize: 13),),
                    Text('x'+widget.buyNumber.toString(), style: TextStyle(color: Colors.grey, fontSize: 13),),
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
            Text('¥'+(widget.buyNumber*double.parse(widget.submitOrdersModel.price)).toString(), style: TextStyle(fontWeight: FontWeight.bold),),
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
            Expanded(child: Text(widget.remark),),
          ],
        ),
        SizedBox(height: 10,),
        Container(height: 1, color: AppColors.ViewBackgroundColor,),
        SizedBox(height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('共计'+widget.buyNumber.toString()+'件 合计：'),
            Text('¥'+(widget.buyNumber*double.parse(widget.submitOrdersModel.price)).toString(), style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
          ],
        ),
      ],
    ),
  );
}
