import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/widget_util.dart';
import 'package:spanners/talkingOnline/friend/provide/add_friend_list_provide.dart';
import 'package:rxdart/rxdart.dart';

class AddFriendListPage extends StatefulWidget {
  @override
  _AddFriendListPageState createState() => _AddFriendListPageState();
}

class _AddFriendListPageState extends State<AddFriendListPage> {

  AddFriendListProvide _provide = AddFriendListProvide();
  final _subscriptions = CompositeSubscription();
  bool _isReload = false;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '新的朋友',
            style: TextStyle(color: Colors.black87),
          ),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context, _isReload);
                });
          }),
        ),
        body: _initSubviews(),
      ),
    );
  }

  _initSubviews() => Consumer<AddFriendListProvide>(
        builder: (build, provide, _) {
          return Container(
            color: Colors.white,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return _userWidget(index);
              },
              itemCount: _provide.modelList.length,
            ),
          );
        },
      );

  _userWidget(int index) => Column(
        children: [
          Container(
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
                        _provide.modelList[index].headUrl,
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
                          _provide.modelList[index].nickName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('添加好友：${'_textEditingController.text'}');
                        this._checkFriend(index, '1');
                        _isReload = true;
                      },
                      child: Container(
                        height: 100,
                        width: 50,
                        color: AppColors.primaryColor,
                        child: Center(
                          child: Text(
                            '同意',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        print('拒绝添加好友：${'_textEditingController.text'}');
                        this._checkFriend(index, '2');
                      },
                      child: Container(
                        height: 100,
                        width: 50,
                        color: Colors.redAccent,
                        child: Center(
                          child: Text(
                            '拒绝',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.black26,
          )
        ],
      );

  _loadData() {
    var s = _provide
        .getApplyMessage()
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  _checkFriend(int index, String status) {
    var s = _provide
        .postApplyMessage(_provide.modelList[index].username, status)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);
  }
}
