import 'dart:io';

import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:spanners/cTools/gl_video_player.dart';
import 'package:spanners/cTools/media_util.dart';

class MessageItemFactory extends StatelessWidget {
  final EMMessage message;

  const MessageItemFactory({Key key, this.message}) : super(key: key);

  _textMessageItem() {
    EMTextMessageBody msg = message.body;
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        msg.message,
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  ///图片消息 item
  ///优先读缩略图，否则读本地路径图，否则读网络图
  _imageMessageItem() {
    EMImageMessageBody msg = message.body;
    Widget widget;
    if (msg.thumbnailUrl != null && msg.thumbnailUrl.length > 0) {
      widget = Image.network(msg.thumbnailUrl,
          width: 90, height: 100, fit: BoxFit.fill);
    } else {
      if (msg.localUrl != null) {
        String path = MediaUtil.instance.getCorrectedLocalPath(msg.localUrl);
        print('图片path -----');
        File file = File(path);
        if (file != null && file.existsSync()) {
          widget = Image.file(file, width: 90, height: 100, fit: BoxFit.fill);
          print('显示缩略图-----');
        } else {
          widget = Image.network(msg.localUrl,
              width: 90, height: 100, fit: BoxFit.fill);
          print('显示缩略图123 -----');
        }
      } else {
        widget = Image.network(msg.remoteUrl,
            width: 90, height: 100, fit: BoxFit.fill);
      }
    }
    return widget;
  }

  _voiceMessageItem() {
    EMVoiceMessageBody msg = message.body;
    Widget widget;
    if (msg.localUrl != null || msg.remoteUrl != null) {
      widget = Container(
        width: 180/60*msg.getVoiceDuration()+60,
        height: 35,
        child: message.direction == Direction.SEND?Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('${msg.getVoiceDuration()}\'\''),
            SizedBox(width: 10,),
            Image.asset('Assets/friend/voice_send.png'),
            SizedBox(width: 10,),
          ],
        ):Row(
          children: [
            SizedBox(width: 10,),
            Image.asset('Assets/friend/voice_ receive.png'),
            SizedBox(width: 10,),
            Text('${msg.getVoiceDuration()}\'\''),
          ],
        ),
      );
    } else {
      widget = Text('失败的语音消息');
    }
    return widget;
  }

  _videoMessageItem() {
    EMFileMessageBody msg = message.body;
    // msg.displayName = 'video.MOV';
    print(msg.toString());

    Widget widget;
    if (msg.localUrl != null) {
      File file = File(msg.remoteUrl);
      print('filefilefilefilefilefilefilefilefile');
      //文件大小
      int fileLength = file.lengthSync();
      print(fileLength);

      // file.renameSync(msg.localUrl);
      // print(file);

      // widget = GLVideoPlayer(localVideoUrl: msg.localUrl,);
    }
    else if(msg.remoteUrl != null){
      widget = GLVideoPlayer(netVideoUrl: msg.remoteUrl,);
    }
    else {
      widget = Text('视频消息错误');
    }
    return widget;
  }

  _customVideoMessageItem(){
    EMCustomMessageBody msg = message.body;
    Widget widget;
    widget = GLVideoPlayer(netVideoUrl: msg.params['CustomVideo'],);
    return widget;
  }

  _messageItem() {
    if (message.body is EMTextMessageBody) {
      return _textMessageItem();
    } else if (message.body is EMImageMessageBody) {
      return _imageMessageItem();
    } else if (message.body is EMVoiceMessageBody) {
      print('语音消息：${message.body}');
      return _voiceMessageItem();
    } else if (message.body is EMVideoMessageBody) {
      return _videoMessageItem();
    }
    else if(message.body is EMCustomMessageBody){
      EMCustomMessageBody msg = message.body;
      if(msg.event == 'CustomVideo'){
          return _customVideoMessageItem();
      }
    }
    else {
      print('其他消息：${message.body}');
      return Text('其他消息');
    }
  }

  _getMessageWidgetBGColor(int messageDirection) {
    Color color = Color(0xFF49DA6E);
    if (message.direction == Direction.RECEIVE) {
      color = Color(0xffffffff);
    }
    else if(message.body is EMCustomMessageBody){
      color = Color(0xffffffff);
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getMessageWidgetBGColor(toDirect(message.direction)),
      child: _messageItem(),
    );
  }
}
