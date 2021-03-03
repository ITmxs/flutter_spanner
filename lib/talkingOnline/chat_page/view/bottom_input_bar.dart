import 'package:flutter/material.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/talkingOnline/talking/y_voice_widget.dart';

class BottomInputBar extends StatefulWidget {
  BottomInputBarDelegate delegate;

  BottomInputBar(BottomInputBarDelegate delegate) {
    this.delegate = delegate;
  }

  @override
  _BottomInputBarState createState() => _BottomInputBarState(this.delegate);
}

class _BottomInputBarState extends State<BottomInputBar> {

  BottomInputBarDelegate delegate;
  FocusNode _focusNode;
  InputBarStatus inputBarStatus;

  String message;
  bool isChanged = false;
  bool isShowVoiceAction = false;
  final controller = TextEditingController();
  bool isSendVoice;
  bool _showSendButton = false;

  _BottomInputBarState(BottomInputBarDelegate delegate) {
    this.delegate = delegate;
    this.inputBarStatus = InputBarStatus.Normal;
  }

  _submittedMessage(String messageStr) {
    if (messageStr == null || messageStr.length <= 0) {
      print('不能为空');
      return;
    }
    if (this.delegate != null) {
      this.delegate.sendText(messageStr);
    } else {
      print('没有实现 bottom input bar delegate');
    }
    this.controller.text = '';
    this.message = '';
    this._showSendButton = false;
  }

  _notifyInputStatusChanged(InputBarStatus status) {
    this.inputBarStatus = status;
    if (this.delegate != null) {
      this.delegate.inputStatusChanged(status);
    } else {
      print('没有实现 bottom input bar delegate');
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _notifyInputStatusChanged(InputBarStatus.Normal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.inputBarStatus == InputBarStatus.Normal) {
      // FocusScope.of(context).requestFocus(_focusNode);
    }
    return Container(
//      color: AppColors.ViewBackgroundColor,
      padding: EdgeInsets.fromLTRB(15, 6, 15, 2),
      decoration: BoxDecoration(
          color: AppColors.ViewBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -1.0), //阴影xy轴偏移量
                blurRadius: 15.0, //阴影模糊程度
                spreadRadius: 1.0 //阴影扩散程度
            )
          ]),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              switchVoice();
            },
            child: Container(
              width: 60,
              alignment: Alignment.center,
              child: this.inputBarStatus == InputBarStatus.Voice
                  ? Icon(Icons.keyboard, size: 33,)
                  : Icon(Icons.mic_none, size: 33,),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  TextField(
                    onSubmitted: _submittedMessage,
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10, bottom: 13),
                      hintStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    focusNode: _focusNode,
                    onChanged: (text) {
                      message = text;
                      isChanged = true;
                      if(text.length>0 && !_showSendButton) {
                        setState(() {
                          _showSendButton = true;
                        });
                      }else if(text.length==0 && _showSendButton){
                        setState(() {
                          _showSendButton = false;
                        });
                      }
                    },
                  ),
                  this.inputBarStatus == InputBarStatus.Voice
                      ? Container(
                          alignment: Alignment.center,
                          child: VoiceWidget(
                            sendVoice: (isSend){
                              isSendVoice = isSend;
                              if (isSend) {
                                print("取消发送");
                              } else {
                                print("进行发送");
                              }
                            },
                            stopRecord: (path, time) {
                              print('------==========----------------------');
                              print(time);
                              print(path);
                              print('---------++++++++++-------------------');
                              if (this.delegate != null && !isSendVoice) {
                                this.delegate.sendVoice(path, time);
                              } else {
                                print("没有实现 BottomInputBarDelegate");
                              }
                            },
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        )
                      : Container(),
                ],
              ),
              height: 34,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          _showSendButton?GestureDetector(
            onTap: () {
              print(controller.text);
              _submittedMessage(controller.text);
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              width: 50,
              height: 30,
              decoration: BoxDecoration(
                color:  AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              alignment: Alignment.center,
              child: Text('发送', style: TextStyle(color: Colors.white),),
            ),
          ):GestureDetector(
            onTap: () {
              switchExt();
            },
            child: Container(
              width: 60,
              alignment: Alignment.center,
              child: Icon(Icons.add_circle_outline, size: 33,),
            ),
          ),
        ],
      ),
    );
  }

  switchExt() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
    InputBarStatus status = InputBarStatus.Normal;
    if (this.inputBarStatus != InputBarStatus.Ext) {
      status = InputBarStatus.Ext;
    }
    if (this.delegate != null) {
      this.delegate.onTapExtButton();
    } else {
      print("没有实现 BottomInputBarDelegate");
    }
    _notifyInputStatusChanged(status);
  }

  switchVoice() {
    InputBarStatus status;

    if (this.inputBarStatus == InputBarStatus.Normal) {
      status = InputBarStatus.Voice;
      _focusNode.unfocus();
    } else if (this.inputBarStatus == InputBarStatus.Voice) {
      status = InputBarStatus.Normal;
      FocusScope.of(context).requestFocus(_focusNode);
    }

    _notifyInputStatusChanged(status);
  }

  //页面销毁
  @override
  void dispose() {
    super.dispose();
    //释放
    _focusNode.dispose();
  }
}

enum InputBarStatus {
  Normal, //正常
  Voice, //语音输入
  Ext, //扩展栏
}

abstract class BottomInputBarDelegate {
  ///输入工具栏状态发生变更
  inputStatusChanged(InputBarStatus status);

  ///发送消息
  sendText(String text);

  ///发送语音
  sendVoice(String path, int duration);

  ///点击了加号按钮
  void onTapExtButton();
}
