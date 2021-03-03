import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/widget_util.dart';
import 'dart:convert' as convert;

import 'package:spanners/talkingOnline/friend/model/contact_model.dart';

class ConversationListItem extends StatefulWidget{

  final EMConversation con;
  final ConversationListItemDelegate delegate;
  const ConversationListItem(this.con, this.delegate);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ConversationListItemState(this.con, this.delegate);
  }
}

class _ConversationListItemState extends State<ConversationListItem>{
  ConversationListItemDelegate delegate;
  EMConversation con;
  EMMessage message;
  int underCount;
  String titleName;
  String content;
  Offset tapPos;

  ContactInfo _contactInfo;

  _ConversationListItemState(EMConversation con, ConversationListItemDelegate delegate){
    this.con = con;
    this.delegate = delegate;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async{

    String userJson = SynchronizePreferences.Get(this.con.conversationId);
    Map<String, dynamic> user = convert.jsonDecode(userJson);
    _contactInfo = ContactInfo();
    _contactInfo.name = user['name'];
    _contactInfo.id = user['id'];
    _contactInfo.headUrl = user['headUrl'];

    message = await con.getLastMessage();
    content = '';
    switch(message.type){
      case EMMessageType.TXT:
        var body = message.body as EMTextMessageBody;
        content = body.message;
        break;
      case EMMessageType.IMAGE:
        content = '[图片]';
        break;
      case EMMessageType.VIDEO:
        content = '[视频]';
        break;
      case EMMessageType.FILE:
        content = '[文件]';
        break;
      case EMMessageType.VOICE:
        content = '[语音]';
        break;
      case EMMessageType.LOCATION:
        content = '[位置]';
        break;
      case EMMessageType.CUSTOM:
        content = '[视频]';
        break;
      default:
        content = '';
    }
    underCount = await con.getUnreadMsgCount();
    titleName = _contactInfo.name;
    if(con.isGroup()){
      EMGroup group = await EMClient.getInstance().groupManager().getGroup(con.conversationId);
      if(group != null){
        titleName = group.getGroupName();
      }
    }
    _refresh();
  }

  void _refresh(){
    if(mounted){
      setState(() {

      });
    }
  }

  void _onTaped() {
    if(this.delegate != null) {
      this.delegate.onTapConversation(this.con);
    }else {
      print("没有实现 EMConversationListItemDelegate");
    }
  }

  void _onLongPressed() {
    if(this.delegate != null) {
      this.delegate.onLongPressConversation(this.con,this.tapPos);
    }else {
      print("没有实现 EMConversationListItemDelegate");
    }
  }

  Widget _buildUnreadMark(){
    if(underCount > 0){
      String count = underCount.toString();
      double width = 20;
      if(underCount > 9){
        width = 20/2*3;
      }
      if(underCount > 99){
        count = '99+';
        width = 24;
      }
      return Positioned(
        right: -5.0,
        top: -5.0,
        child: Container(
            width: width,
            height: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width/2.0),
              color: Colors.red,
            ),
            child: Text(count, style:TextStyle(fontSize: 12, color:Colors.white,))
        ),
      );
    }
    return Container();
  }

  Widget _buildPortrait(){
    return Container(
      child: Stack(
        alignment: const FractionalOffset(0, 0.5),
        overflow: Overflow.visible,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 8,
              ),
              ClipRRect(
                child: WidgetUtil.avatarType(_contactInfo.headUrl,
                    46, 46),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ],
          ),
          _buildUnreadMark(),
        ],
      ),
    );
  }

  Widget _buildContent(){
    return Expanded(
      child: Container(
        height: 74,
        margin: EdgeInsets.only(left:10, right: 10),
        decoration:  BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey)
            )
        ),
        child: Row(
          children: <Widget>[
            _buildTitle(),
            _buildTime(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(){
    return Expanded(
      child : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            titleName,
            style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6,),
          Text(
            content==null?'':content,
            style: TextStyle(fontSize: 14,
                color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget _buildTime(){
    var time = TimeUtil.convertTime(int.parse(message.msgTime));
    if(message.msgTime == '0') {
      time = '';
    }
    return Container(
      width: 74,
      margin: EdgeInsets.only(right:10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(time,style:TextStyle(fontSize: 12, color: Colors.grey)),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    if(!(message == null)) {
      return Material(
        color: Colors.white,
        child: InkWell(
          onTapDown: (TapDownDetails details) {
            tapPos = details.globalPosition;
          },
          onTap: () {
            _onTaped();
          },
          onLongPress: () {
            _onLongPressed();
          },
          child: Container(
            height: 74,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildPortrait(),
                _buildContent(),
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }
}

abstract class ConversationListItemDelegate {
  ///点击了会话 item
  void onTapConversation(EMConversation conversation);
  ///长按了会话 item
  void onLongPressConversation(EMConversation conversation,Offset tapPos);
}