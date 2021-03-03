import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/public_function.dart';
import 'package:spanners/cTools/widget_util.dart';
import 'package:spanners/registered_vip/provide/registered_vip_provide.dart';

class RegisteredVipPage extends StatefulWidget {
  @override
  _RegisteredVipPageState createState() => _RegisteredVipPageState();
}

class _RegisteredVipPageState extends State<RegisteredVipPage> {
  RegisteredVipProvide _provide;

  TextEditingController _userNameTextController;
  TextEditingController _phoneTextController;

  @override
  void initState() {
    super.initState();

    _provide = RegisteredVipProvide();
    _userNameTextController = TextEditingController();
    _phoneTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '创建会员'),
        body: _initViews(),
      ),
    );
  }

  _initViews() => Container(
        color: AppColors.ViewBackgroundColor,
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Text('个人账户'),
                  Text('企业账户'),
                ],
              ),
            ),
            Expanded(
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                  padding: EdgeInsets.only(bottom: 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _userInfoWidget(),
                      GestureDetector(
                        onTap: (){
                          _registered();
                        },
                        child: Container(
                          width: 105,
                          height: 30,
                          decoration:  BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(5),),
                          ),
                          child: Center(child: Text('创建', style: TextStyle(color: Colors.white, fontSize: 15),),),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );

  _userInfoWidget() => Container(
        color: Colors.white,
        child: Column(
          children: [
            CustomTextFieldItem(MediaQuery.of(context).size.width - 30, '车主姓名', _userNameTextController,
                redStar: true, camera: false),
            CustomTextFieldItem(MediaQuery.of(context).size.width - 30, '电话', _phoneTextController,
                redStar: true),
          ],
        ),
      );

  _registered(){
    print(_userNameTextController.text);
    if(_userNameTextController.text.length <= 0){
      BotToast.showText(text: '请填写车主姓名 ！');
      return;
    }
    if(_phoneTextController.text.length <= 0){
      BotToast.showText(text: '请填写电话 ！');
      return;
    }
    if(isPhone(_phoneTextController.text)) {
      print('申请注册');
    }
  }

}
