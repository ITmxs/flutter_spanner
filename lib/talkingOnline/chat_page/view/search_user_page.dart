import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/widget_util.dart';
import 'package:spanners/em_manager/em_manager.dart';
import 'package:spanners/talkingOnline/chat_page/provide/search_user_provide.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/talkingOnline/friend/model/contact_model.dart';

class SearchUserPage extends StatefulWidget {
  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  SearchUserProvide _provide;
  TextEditingController _textEditingController;
  bool _isPhone;
  bool _showUser;
  String _searchUserName = '';
  String _searchUserHeadUrl = '';

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _isPhone = false;
    _showUser = false;
    _provide = SearchUserProvide();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '添加朋友',
          style: TextStyle(color: Colors.black87),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context, true);
              });
        }),
      ),
      body: _initSubviews(),
    );
  }

  _initSubviews() => Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 50),
              alignment: Alignment.center,
              padding: EdgeInsets.only(
//                left: 20,
                  ),
              height: ScreenUtil().setHeight(33),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0), //灰色的一层边框
                color: Color.fromRGBO(255, 255, 255, 0.7),
                borderRadius: BorderRadius.all(Radius.circular(16.5)),
              ),
              child: TextFormField(
                controller: _textEditingController,
                onChanged: (value) {
                  if (value.length == 11) {
                    setState(() {
                      _isPhone = true;
                    });
                  } else {
                    setState(() {
                      _isPhone = false;
                    });
                  }
                },
                maxLines: 1,
                style: TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
//                    setState(() {
//                      print('搜索');
//                    });
                    },
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                  hintText: '请输入手机号',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenUtil().setSp(13),
                  ),
//              fillColor: Color.fromRGBO(
//                  255, 255, 255, 0.7),
//              filled: true,
                  border: OutlineInputBorder(
                      //添加边框
                      gapPadding: 10.0,
                      borderRadius: BorderRadius.circular(17.0),
                      borderSide: BorderSide.none),
                  // prefixIcon: Padding(
                  //   padding: EdgeInsets.all(10),
                  // ),
                  //Image.asset('assets/images/user.png',cacheWidth: 25,cacheHeight: 25,),//ImageIcon(AssetImage('assets/images/user.png',),color: Colors.white,),//Image.asset('assets/images/user.png',fit: BoxFit.fitHeight,)
                ),
              ),
            ),
            _isPhone ? _showSearchPhoneWidget() : Container(),
            _showUser ? _userWidget() : Container(),
          ],
        ),
      );

  _showSearchPhoneWidget() => GestureDetector(
        onTap: () {
          _searchUserInfo();
        },
        child: Container(
          height: 60,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Container(
                  height: 30,
                  width: 30,
                  color: AppColors.primaryColor,
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '搜索：',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                _textEditingController.text,
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ],
          ),
        ),
      );

  _userWidget() => Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 50),
        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
        color: Colors.white,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: WidgetUtil.avatarType(
                    _searchUserHeadUrl,
                    ScreenUtil().setWidth(60),
                    ScreenUtil().setHeight(60),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                      _searchUserName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                print('添加好友：${_textEditingController.text}');
                ContactInfo _userModel = ContactInfo().getUserModel();
                var body = {
                  'friendUsername': _textEditingController.text,
                  'status': '0',
                  'username': _userModel.id,
                };
                _provide.applyFriend(body).doOnData((results) {
                  em_addContact(_textEditingController.text, () {}, () {});
                  BotToast.showText(text: '已发送邀请');
                }).doOnListen(() {})
                    .doOnCancel(() {})
                    .listen((event) {}, onError: (e) {});
              },
              child: Container(
                height: 100,
                width: 50,
                color: AppColors.primaryColor,
                child: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );

  _searchUserInfo() {
    _provide
        .searchUserInfo(_textEditingController.text)
        .doOnData((result) {
          Map res = convert.jsonDecode(result.toString());
          print(res);
          if (res['data'] != null) {
            setState(() {
              _searchUserName = res['data']['realName'] != null
                  ? res['data']['realName']
                  : '';
              _searchUserHeadUrl =
                  res['data']['headUrl'] != null ? res['data']['headUrl'] : '';
              print('_searchUserName+_searchUserHeadUrl');
              print(_searchUserName + _searchUserHeadUrl);
              _showUser = true;
            });
          } else {
            setState(() {
              _showUser = false;
              BotToast.showText(text: '未找到用户！');
            });
          }
        })
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
  }
}
