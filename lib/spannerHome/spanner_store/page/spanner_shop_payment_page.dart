import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/custom_password_keyboard/custom_password_field.dart';
import 'package:spanners/cTools/custom_password_keyboard/custom_password_keyboard.dart';
import 'package:spanners/common/routerUtil.dart';
import 'package:spanners/spannerHome/share_shop/page/ss_payment_success_page.dart';
import 'package:spanners/spannerHome/spanner_store/page/spanner_shop_payment_success.dart';
import 'package:spanners/spannerHome/spanner_store/provide/spanner_shop_payment_provide.dart';
import 'dart:convert' as convert;
import 'package:tobias/tobias.dart' as tobias;

class SpannerShopPaymentPage extends StatefulWidget {
  final String orderId;
  final String totalPrice;
  final List submitOrdersModelList;
  final List buyNumberList;
  final List remarkList;
  final int backCount;

  const SpannerShopPaymentPage(this.backCount,
      {Key key,
      this.orderId,
      this.totalPrice,
      this.submitOrdersModelList,
      this.buyNumberList,
      this.remarkList})
      : super(key: key);

  @override
  _SpannerShopPaymentPageState createState() => _SpannerShopPaymentPageState();
}

class _SpannerShopPaymentPageState extends State<SpannerShopPaymentPage> {
  SpannerShopPaymentProvide _provide;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    _provide = SpannerShopPaymentProvide();
    weChatResponseEventHandler.listen((res) {
      print(res.runtimeType.toString());
      if (res is WeChatPaymentResponse) {
        if (res.errCode == 0) {
          _getWeChatPaymentInfo();
        } else {
          _alertDialog('支付失败');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '确认支付',
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
              _notPaymentAlertDialog();
            },
          ),
        ),
        body: _initViews(),
      ),
    );
  }

  _initViews() => SafeArea(
        child: Selector<SpannerShopPaymentProvide, bool>(
            builder: (_, showPassword, child) {
              return Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                        _topWidget(),
                        _contentWidget(),
                        SizedBox(
                          height: 60,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_provide.selectType == 0) {
                              _provide.showPassword = true;
                            } else if (_provide.selectType == 1) {
                              _postPaymentOrder();
                            } else if (_provide.selectType == 2) {
                              _postPaymentOrder();
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            margin: EdgeInsets.only(left: 15, right: 15),
                            color: Colors.red,
                            child: Text(
                              '确认支付',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///密码框
                  _provide.showPassword ? _passwordWidget() : Container(),
                ],
              );
            },
            selector: (_, provide) => _provide.showPassword),
      );

  ///密码框
  Widget _passwordWidget() => Selector<SpannerShopPaymentProvide, String>(
      builder: (_, password, child) {
        return Container(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _provide.showPassword = false;
                    _provide.password = '';
                  },
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                  ),
                ),
              ),
              Container(
                height: 340,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFEEEEEE),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              '输入支付密码',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Positioned(
                            child: GestureDetector(
                              onTap: () {
                                _provide.showPassword = false;
                                _provide.password = '';
                              },
                              child: Icon(Icons.arrow_back_ios),
                            ),
                            left: 25,
                          )
                        ],
                      ),
                    ),
                    _buildPwd(_provide.password),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '',
                          style: TextStyle(color: Colors.red),
                        ),
                        GestureDetector(
                          onTap: () {
                            RouterUtil.push(context,
                                routerName: "updatePayPassword", data: true);
                          },
                          child: Text(
                            '忘记密码？',
                            style: TextStyle(),
                          ),
                        ),
                      ],
                    ),
                    CustomPasswordKeyboard(_onKeyDown),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      selector: (_, provide) => _provide.password);

  Widget _buildPwd(var pwd) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 20),
        width: 300.0,
        height: 45.0,
//      color: Colors.white,
        child: CustomPasswordField(
          data: pwd,
        ),
      ),
      onTap: () {},
    );
  }

  void _onKeyDown(String string) {
    if (string == 'del') {
      if (_provide.password.length > 0) {
        _provide.password =
            _provide.password.substring(0, _provide.password.length - 1);
        setState(() {});
      }
    } else if (string == 'commit') {
      if (_provide.password.length != 6) {
//        Fluttertoast.showToast(msg: "密码不足6位，请重试", gravity: ToastGravity.CENTER);
        return;
      }
      _postPaymentOrder();
    } else {
      if (_provide.password.length < 6) {
        _provide.password += string;
      }
      print(string);
    }
  }

  _topWidget() => Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
        padding: EdgeInsets.only(top: 30, left: 15, right: 27, bottom: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('应付金额：'),
                Text(
                  '¥' + widget.totalPrice,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ],
            ),
            Text(
              '请尽快完成支付 \n提醒：请在 24 内完成付款，超出时间未付款的订单系统将自动取消',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );

  _contentWidget() => Selector<SpannerShopPaymentProvide, int>(
      builder: (_, selectType, child) {
        return Container(
          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
          padding: EdgeInsets.only(top: 23, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              // Container(
              //   padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              //   child: GestureDetector(
              //     onTap: () {
              //       _provide.selectType = 0;
              //       _getPasswordStatus();
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Row(
              //           children: [
              //             Image.asset(
              //               'Assets/share_shop/payment_balance.png',
              //               width: 30,
              //             ),
              //             SizedBox(
              //               width: 10,
              //             ),
              //             Text('余额'),
              //           ],
              //         ),
              //         Image.asset('Assets/share_shop/payment_select_' +
              //             (_provide.selectType == 0 ? 'yes.png' : 'no.png')),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   color: AppColors.ViewBackgroundColor,
              //   height: 1,
              // ),
              Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 23),
                child: GestureDetector(
                  onTap: () {
                    _provide.selectType = 1;
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>SpannerShopPaymentSuccessPage(widget.backCount,submitOrdersModelList: widget.submitOrdersModelList, buyNumberList: widget.buyNumberList, remarkList: widget.remarkList,),),);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'Assets/share_shop/payment_alipay.png',
                            width: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('支付宝'),
                        ],
                      ),
                      Image.asset('Assets/share_shop/payment_select_' +
                          (_provide.selectType == 1 ? 'yes.png' : 'no.png')),
                    ],
                  ),
                ),
              ),
              Container(
                color: AppColors.ViewBackgroundColor,
                height: 1,
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 20),
                child: GestureDetector(
                  onTap: () {
                    _provide.selectType = 2;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'Assets/share_shop/payment_wechat.png',
                            width: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('微信'),
                        ],
                      ),
                      Image.asset('Assets/share_shop/payment_select_' +
                          (_provide.selectType == 2 ? 'yes.png' : 'no.png')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      selector: (_, provide) => _provide.selectType);

  // _getPasswordStatus() {
  //   var s = _provide
  //       .getPasswordStatus()
  //       .doOnListen(() {})
  //       .doOnCancel(() {})
  //       .listen((event) {
  //     Map res = convert.jsonDecode(event.toString());
  //     if (res['data']) {
  //     } else {
  //       _alertDialog(res['msg']);
  //       _provide.selectType = -1;
  //     }
  //   }, onError: (e) {});
  //   _subscriptions.add(s);
  // }

  _alertDialog(String msg) async {
    var result = await showDialog(
        barrierDismissible: false, // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(msg),
            content: Text('订单支付失败，请再次付款或联系管理员'),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () {
                  print("取消");
                  Navigator.of(context).pop("Cancel");
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () {
                  print("确定");
                  Navigator.of(context).pop("Ok");
                  // RouterUtil.push(context,routerName: "updatePayPassword",data:false);
                },
              )
            ],
          );
        });
  }

  _notPaymentAlertDialog() async {
    var result = await showDialog(
        barrierDismissible: false, // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('确认要放弃付款吗？'),
            actions: <Widget>[
              FlatButton(
                child: Text("放弃"),
                onPressed: () {
                  print("取消");
                  if (widget.backCount == 1) {
                    Navigator.of(context)..pop()..pop();
                  } else if (widget.backCount == 2) {
                    Navigator.of(context)..pop()..pop();
                  } else {
                    Navigator.of(context)..pop()..pop()..pop()..pop();
                  }
                },
              ),
              FlatButton(
                child: Text("继续支付"),
                onPressed: () {
                  print("确定");
                  Navigator.of(context).pop("Ok");
                },
              )
            ],
          );
        });
  }

  _postPaymentOrder() {
    String type = 'OFFLINE';
    switch (_provide.selectType) {
      case 0:
        type = 'BALANCEPAY';
        break;
      case 1:
        type = 'ALIPAY';
        break;
      case 2:
        type = 'WXPAY';
        break;
    }
    var s = _provide
        .postPaymentOrder(
            mallOrderId: widget.orderId,
            password: _provide.password,
            type: type)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
      paymentRes(event);
    }, onError: (e) {});
    _subscriptions.add(s);
  }

  paymentRes(dynamic results) async {
    Map res = convert.jsonDecode(results.toString());
    if (_provide.selectType == 0) {
      if (res['data'] == false) {
        BotToast.showText(text: res['msg']);
      } else {
        String cargoCode = res['data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpannerShopPaymentSuccessPage(
              widget.backCount,
              submitOrdersModelList: widget.submitOrdersModelList,
              buyNumberList: widget.buyNumberList,
              remarkList: widget.remarkList,
            ),
          ),
        );
      }
    } else if (_provide.selectType == 1) {
      Map data = res['data'];
      Map result = await tobias.aliPay(data['aliPay']);
      if (result['resultStatus'].toString() == '9000') {
        _postPaymentOtherOrder(result);
      } else {
        switch (result['resultStatus']) {
          case 8000:
            BotToast.showText(text: '正在处理中');
            break;
          case 4000:
            BotToast.showText(text: '订单支付失败');
            break;
          case 6001:
            BotToast.showText(text: '用户中途取消');
            break;
          case 6002:
            BotToast.showText(text: '网络连接出错');
            break;
        }
      }
    } else if (_provide.selectType == 2) {
      Map data = res['data'];
      print(data);
      payWithWeChat(
        appId: AppConst.wxAppId,
        partnerId: data["partnerId"].toString(),
        prepayId: data['prePayId'].toString(),
        nonceStr: data['nonceStr'].toString(),
        timeStamp: data['timeStamp'],
        sign: data['sign'].toString(),
        packageValue: data['packageValue'].toString(),
      );
    }
  }

  _postPaymentOtherOrder(Map result) {
    if (_provide.selectType == 1) {
      print('支付宝支付');
      result.addAll({'type': 'ALIPAY'});
    } else if (_provide.selectType == 2) {
      print('微信支付');
      result.addAll({'type': 'WXPAY'});
    }
    var s = _provide
        .postPaymentOtherOrder(result: result)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
      Map res = convert.jsonDecode(event.toString());
      if (res['data'] == false) {
        BotToast.showText(text: res['msg']);
      } else {
        String cargoCode = res['data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpannerShopPaymentSuccessPage(
              widget.backCount,
              submitOrdersModelList: widget.submitOrdersModelList,
              buyNumberList: widget.buyNumberList,
              remarkList: widget.remarkList,
            ),
          ),
        );
      }
    }, onError: (e) {});
    _subscriptions.add(s);
  }

  _getWeChatPaymentInfo() {
    var s = _provide
        .getWeChatPaymentInfo(orderId: widget.orderId)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
      Map res = convert.jsonDecode(event.toString());
      if (res['data'] == false) {
        BotToast.showText(text: res['msg']);
      } else {
        String cargoCode = res['data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpannerShopPaymentSuccessPage(
              widget.backCount,
              submitOrdersModelList: widget.submitOrdersModelList,
              buyNumberList: widget.buyNumberList,
              remarkList: widget.remarkList,
            ),
          ),
        );
      }
    }, onError: (e) {});
    _subscriptions.add(s);
  }
}
