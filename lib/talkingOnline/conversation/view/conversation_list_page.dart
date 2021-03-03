import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/talkingOnline/chat_page/view/chat_page.dart';
import 'package:spanners/talkingOnline/friend/model/contact_model.dart';
import 'conversation_list_item.dart';
import 'dart:convert' as convert;

class ConversationListPage extends StatefulWidget {
  @override
  _ConversationListPageState createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> implements EMMessageListener, EMConnectionListener, ConversationListItemDelegate{

  var conList = List<EMConversation>();
  var sortMap = Map<String, EMConversation>();
  bool _isConnected = EMClient.getInstance().isConnected();
  String errorText;

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadEMConversationList();
  }

  Widget _buildConversationListView(){
    return ListView.builder(
        shrinkWrap: true,
        physics:NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: conList.length + 1,
        itemBuilder: (BuildContext context,int index){
          if(index == 0){
            return _buildErrorItem();
          }
          if(conList.length <= 0){
            return Container();
          }
          return ConversationListItem(conList[index - 1], this);
        }
    );
  }

  Widget _buildErrorItem(){
    return Visibility(
        visible: !_isConnected,
        child:Container(
          height: 30.0,
          color: Colors.red,
          child: Center(child : Text('聊天系统登录失败', style: TextStyle(color: Colors.white),),)),
    );
  }

  void _sortConversation(){
    if(sortMap.length > 0) {
      conList.clear();
      List sortKeys = sortMap.keys.toList();
      /// key排序
      sortKeys.sort((a, b) => b.compareTo(a));
      sortKeys.forEach((k) {
        var v = sortMap.putIfAbsent(k, null);
        conList.add(v);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    _sortConversation();
    return Scaffold(
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
                    '消息',
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
      key: UniqueKey(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConversationListView(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    EMClient.getInstance().chatManager().addMessageListener(this);
    EMClient.getInstance().addConnectionListener(this);
    _loadEMConversationList();
  }

  void _loadEMConversationList() async {
    int i = 0;
    sortMap.clear();
    conList.clear();

    Map map = await EMClient.getInstance().chatManager().getAllConversations();

    print('--- -- ---- -- ----- ---- -- - -');
    print(map);

    if(map.length == 0){
      _refreshUI();
    }
    map.forEach((k, v) async{
      var conversation = v as EMConversation;
      EMMessage message = await conversation.getLastMessage();
      if(message == null){
        map.remove(k);
        return ;
      }
      sortMap.putIfAbsent(message.msgTime,() => v);
      i++;
      if(i == map.length){
        _refreshUI();
      }
    });
  }

  void _refreshUI() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    EMClient.getInstance().chatManager().removeMessageListener(this);
    EMClient.getInstance().removeConnectionListener(this);
  }

  ///EMMessageListener, EMConnectionListener
  @override
  void onCmdMessageReceived(List<EMMessage> messages) {
    // TODO: implement onCmdMessageReceived
  }

  /// 连接监听
  @override
  void onConnected(){
    print('onConnected');
    _isConnected = true;
    _refreshUI();
  }

  @override
  void onDisconnected(int errorCode){
    print('onDisconnected');

    _isConnected = false;
    _refreshUI();
  }
  @override
  void onMessageChanged(EMMessage message) {
    // TODO: implement onMessageChanged
    print('onMessageChanged');
  }

  @override
  void onMessageDelivered(List<EMMessage> messages) {
    // TODO: implement onMessageDelivered
    print('onMessageDelivered');
  }

  @override
  void onMessageRead(List<EMMessage> messages) {
    // TODO: implement onMessageRead
    print('onMessageRead');
  }

  @override
  void onMessageRecalled(List<EMMessage> messages) {
    // TODO: implement onMessageRecalled
    print('onMessageRecalled');
  }

  /// 消息监听
  @override
  void onMessageReceived(List<EMMessage> messages) {
    _loadEMConversationList();
  }

  ///ConversationListItemDelegate
  @override
  void onLongPressConversation(EMConversation conversation, Offset tapPos) {
    // TODO: implement onLongPressConversation
  }

  @override
  void onTapConversation(EMConversation conversation) {

    String userJson = SynchronizePreferences.Get(conversation.conversationId);
    Map<String, dynamic> user = convert.jsonDecode(userJson);
    ContactInfo contactInfo = ContactInfo();
    contactInfo.name = user['name'];
    contactInfo.id = user['id'];
    contactInfo.headUrl = user['headUrl'];
    Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (context) =>  ChatPage(contactInfo,getType(conversation.type)))).then(
            (bool _isRefresh){
              _loadEMConversationList();
            });
  }


  static const int chatTypeSingle = 0;
  static const int chatTypeGroup = 1;
  static const int chatTypeChatRoom = 2;

  int getType(EMConversationType type){
    switch(type){
      case EMConversationType.Chat:
        return chatTypeSingle;
      case EMConversationType.GroupChat:
        return chatTypeGroup;
      case EMConversationType.ChatRoom:
        return chatTypeChatRoom;
      default:
        return chatTypeSingle;
    }
  }

}
