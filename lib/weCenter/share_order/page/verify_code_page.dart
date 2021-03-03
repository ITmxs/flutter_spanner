import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/weCenter/share_order/provide/verify_code_provide.dart';
import 'dart:convert' as convert;

class VerifyCodePage extends StatefulWidget {

  final String tradeId;

  const VerifyCodePage({Key key, this.tradeId}) : super(key: key);

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {

  VerifyCodeProvide _provide;
  TextEditingController _textEditingController;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    _provide = VerifyCodeProvide();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: ''),
        body: _initViews(),
      ),
    );
  }

  _initViews() => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 77),
        child: Column(
          children: [
            Text(
              '取货码',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 49,
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _textEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入取货码',
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            GestureDetector(
              onTap: (){
                _checkPickupCode();
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 40, right: 40),
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '取货',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      );

  _checkPickupCode(){
    var s = _provide
        .getCheckPickupCode(tradeId: widget.tradeId, pickupCode: _textEditingController.text)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {
      Map res = convert.jsonDecode(data.toString());
      if(res['data']){
        Navigator.of(context).pop(true);
      }
      BotToast.showText(text: res['msg']);
    }, onError: (e) {});
    _subscriptions.add(s);
  }
}
