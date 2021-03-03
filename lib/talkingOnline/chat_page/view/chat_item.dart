import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:spanners/cTools/imageChange.dart';
import 'package:spanners/cTools/vedioPalyer.dart';
import 'package:spanners/cTools/widget_util.dart';
import 'package:spanners/talkingOnline/about/imageView.dart';
import 'package:spanners/talkingOnline/friend/model/contact_model.dart';
import 'package:spanners/talkingOnline/talking/y_voice_widget.dart';

import 'message_item_factory.dart';

class ChatItem extends StatefulWidget {
  EMMessage message;
  ChatItemDelegate delegate;
  ContactInfo receiveModel;
  bool showTime;

  ChatItem(ChatItemDelegate delegate, EMMessage msg, bool showTime,
      ContactInfo receiveModel) {
    this.message = msg;
    this.delegate = delegate;
    this.showTime = showTime;
    this.receiveModel = receiveModel;
  }

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  ContactInfo _sendModel;

  @override
  void initState() {
    super.initState();
    _sendModel = ContactInfo().getUserModel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: <Widget>[
          widget.showTime
              ? buildMessageTimeWidget(widget.message.msgTime)
              : Container(),
          Row(
            children: <Widget>[_subContent()],
          )
        ],
      ),
    );
  }

  /// 消息 item 上的时间
  static Widget buildMessageTimeWidget(String sentTime) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        alignment: Alignment.center,
        width: 80,
        height: 22,
        // color: Color(0xffC8C8C8),
        child: Text(
          TimeUtil.convertTime(int.parse(sentTime)),
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }

  Widget _subContent() {
    if (widget.message.direction == Direction.SEND) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Text(
                      _sendModel.name,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xff9B9B9B),
                      ),
                    ),
                  ),
                  _buildMessageWidget(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ClipRRect(
                child: WidgetUtil.avatarType(
                  _sendModel.headUrl,
                  45,
                  45,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ],
        ),
      );
    } else if (widget.message.direction == Direction.RECEIVE) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: ClipRRect(
                child: WidgetUtil.avatarType(
                  widget.receiveModel.headUrl,
                  45,
                  45,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      widget.receiveModel.name,
                      style: TextStyle(color: Color(0xff9B9B9B)),
                    ),
                  ),
                  _buildMessageWidget(),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  _buildMessageWidget() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 6, 15, 10),
            alignment: widget.message.direction == Direction.SEND
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                _showImage(widget.message, context);
              },
              behavior: HitTestBehavior.opaque,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: MessageItemFactory(message: widget.message),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

_showImage(EMMessage message, BuildContext context) {
  if (message.body is EMTextMessageBody) {
  } else if (message.body is EMImageMessageBody) {
    ImageProvider img;
    EMImageMessageBody msg = message.body;
    if (msg.thumbnailUrl != null && msg.thumbnailUrl.length > 0) {
      img = NetworkImage(msg.thumbnailUrl);
    } else {
      img = NetworkImage(msg.remoteUrl);
    }
    print('-------------------------object');
    Navigator.of(context).push(FadeRoute(
        page: PhotoViewSimpleScreen(
      imageProvider: img,
      heroTag: 'simple',
    )));
  } else if (message.body is EMVoiceMessageBody) {
    EMVoiceMessageBody msg = message.body;
    print(msg.toDataMap());
    print(msg.remoteUrl);
    print(msg.localUrl);
    PlayerRecord playerRecord = PlayerRecord();
    playerRecord.init();
    if (msg.localUrl != null) {
      playerRecord.playByPath(msg.localUrl, 'file');
    } else if (msg.remoteUrl != null) {
      playerRecord.playByPath(msg.remoteUrl, 'url');
    }
  } else if (message.body is EMVideoMessageBody) {
    EMVideoMessageBody body = message.body;
    print('视频消息：${message.body}');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => videoPalyer(
                  url: body.localUrl,
                )));
  } else if (message.body is EMCustomMessageBody) {
    EMCustomMessageBody msg = message.body;
    if (msg.event == 'CustomVideo') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => videoPalyer(
                    url: msg.params['CustomVideo'],
                  )));
    }
  } else {
    print('其他消息：${message.body}');
  }
}

abstract class ChatItemDelegate {
  //点击消息
  void onTapMessageItem(EMMessage message);

  //长按消息
  void onLongPressMessageItem(EMMessage message, Offset tapPos);

  //点击用户头像
  void onTapUserPortrait(String userId);
}
