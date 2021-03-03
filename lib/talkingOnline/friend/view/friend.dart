import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/widget_util.dart';
import 'package:spanners/talkingOnline/chat_groups/view/chat_groups_page.dart';
import 'package:spanners/talkingOnline/chat_page/view/chat_page.dart';
import 'package:spanners/talkingOnline/chat_page/view/search_user_page.dart';
import 'package:spanners/talkingOnline/friend/model/contact_model.dart';
import 'package:spanners/talkingOnline/friend/provide/friend_provide.dart';
import 'package:spanners/talkingOnline/friend/view/add_friend_list_page.dart';

class Friend extends StatefulWidget {
  @override
  _FriendState createState() => _FriendState();
}

class _FriendState extends State<Friend> implements EMContactEventListener {
  FriendProvide _provide;

  int _suspensionHeight = 40;
  int _itemHeight = 54;
  int _headHeight = 162;
  double _headItemHeight = 54;
  double _itemLeft = 31.0;
  double _itemRight = 17.0;
  String _hitTag = "";
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    _provide = FriendProvide();
    EMClient.getInstance().contactManager().addContactListener(this);
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    EMClient.getInstance().contactManager().removeContactListener(this);
  }

  Widget _buildHeader() {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            child: _itemWidget(
                _provide.systemItem[0]['name'], _provide.systemItem[0]['icon'],
                haveRemind: true),
            onTap: () async {
              final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddFriendListPage()));
              if(result) {
                _loadData();
              }
            },
          ),
          GestureDetector(
            child: _itemWidget(
                _provide.systemItem[1]['name'], _provide.systemItem[1]['icon']),
            onTap: () {
            },
          ),
          // GestureDetector(
          //   child: _itemWidget(
          //       _provide.systemItem[2]['name'], _provide.systemItem[2]['icon']),
          //   onTap: () {
          //     Navigator.of(context).push(
          //         MaterialPageRoute(builder: (context) => ChatGroupsPage()));
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      height: _suspensionHeight.toDouble(),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: _itemLeft),
        color: AppColors.ViewBackgroundColor,
        child: Row(
          children: <Widget>[
            Text(
              '$susTag',
              textScaleFactor: 1.2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(ContactInfo model) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        GestureDetector(
          onTap: () async {
            print(model.id);
            final result = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ChatPage(model, 0)));
            if(result) {
              _loadData();
            }
          },
          child: _itemWidget(model.name, model.headUrl),
        ),
      ],
    );
  }

  _itemWidget(String name, String avatar, {bool haveRemind = false}) =>
      Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: _headItemHeight,
              padding: EdgeInsets.only(left: _itemLeft, right: _itemRight),
              child: Row(
                children: [
                  ClipRRect(
                    child: WidgetUtil.avatarType(avatar,
                        35, 35),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(name),
                                _provide.showNewFriendMessage && haveRemind
                                    ? Icon(
                                        Icons.brightness_1,
                                        color: Colors.red,
                                  size: 10,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Container(
                            color: AppColors.ViewBackgroundColor,
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  _initWidget() => Selector<FriendProvide, List>(
      selector: (_, provide) => _provide.contactsList,
      builder: (_, contactsList, child) {
        return Container(
          child: AzListView(
            data: contactsList,
            itemBuilder: (context, model) => _buildListItem(model),
            isUseRealIndex: true,
            itemHeight: _itemHeight,
            suspensionHeight: _suspensionHeight,
            header: AzListViewHeader(
                height: _headHeight,
                builder: (context) {
                  return _buildHeader();
                }),
            indexBarBuilder: (BuildContext context, List<String> tags,
                IndexBarTouchCallback onTouch) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.transparent, width: .5)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: IndexBar(
                    data: tags,
                    itemHeight: 20,
                    onTouch: (details) {
                      onTouch(details);
                    },
                  ),
                ),
              );
            },
            indexHintBuilder: (context, hint) {
              return Container(
                alignment: Alignment.center,
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Text(hint,
                    style: TextStyle(color: Colors.white, fontSize: 30.0)),
              );
            },
          ),
          color: Colors.white,
        );
      });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              elevation: 0.5,
              //Appbar底部阴影
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '通讯录',
                      style: TextStyle(
                          color: AppColors.TextColor,
                          fontSize: ScreenUtil().setSp(20),
                          fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        Image.asset('Assets/friend/search_friend.png'),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          child: Image.asset('Assets/friend/add_friend.png'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchUserPage()));
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            preferredSize: Size.fromHeight(50)),
        body: _initWidget(),
      ),
    );
  }

  _loadData() {
    var s = _provide
        .getContactsList()
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);

    var applyMessage = _provide
        .getApplyMessage()
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(applyMessage);
  }

  @override
  void onContactAdded(String userName) {
    print('onContactAddedonContactAddedonContactAddedonContactAdded');
    _loadData();
  }

  @override
  void onContactDeleted(String userName) {
    print('onContactDeletedonContactDeletedonContactDeletedonContactDeleted');
    _loadData();
  }

  @override
  void onContactInvited(String userName, String reason) {
    print('收到新的好友请求!');
    _loadData();
  }

  @override
  void onFriendRequestAccepted(String userName) {
    print(
        'onFriendRequestAcceptedonFriendRequestAcceptedonFriendRequestAccepted');
    _loadData();
  }

  @override
  void onFriendRequestDeclined(String userName) {
    print(
        'onFriendRequestDeclinedonFriendRequestDeclinedonFriendRequestDeclinedonFriendRequestDeclined');
    _loadData();
  }
}
