import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/scanPut.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/talkingOnline/chat_page/provide/chat_page_provide.dart';
import 'package:spanners/talkingOnline/chat_page/view/bottom_input_bar.dart';
import 'package:spanners/talkingOnline/friend/model/contact_model.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_compress/src/progress_callback.dart/subscription.dart';
import 'chat_item.dart';
import 'package:rxdart/rxdart.dart';

class ChatPage extends StatefulWidget {
  final ContactInfo toModel;
  final int mType;

  ChatPage(this.toModel, this.mType);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    implements
        EMMessageListener,
        EMMessageStatus,
        EMCallStateChangeListener,
        BottomInputBarDelegate,
        ChatItemDelegate {
  ScrollController _scrollController;
  ChatStatus _currentStatus; //当前输入工具栏的状态
  List<EMMessage> _messageTotalList; //消息数组
  List<EMMessage> _messageList; //消息数组
  List<EMMessage> _msgListFromDB;
  bool _singleChat; //单独聊天
  int _mType;
  bool _isJoinRoom = false;
  EMConversation _conversation;
  String _afterLoadMessageId = '';
  bool _isLoad;
  ContactInfo _userInfo;
  ChatPageProvide _provide = ChatPageProvide();
  final _subscriptions = CompositeSubscription();
  final int _pageSize = 10;

  Subscription _subscription;

  @override
  void initState() {
    super.initState();
    _currentStatus = ChatStatus.Normal;
    _scrollController = ScrollController();
    EMClient.getInstance().chatManager().addMessageListener(this);
    EMClient.getInstance().chatManager().addMessageStatusListener(this);
    EMClient.getInstance().callManager().addCallStateChangeListener(this);
    _messageTotalList = [];
    _messageList = [];
    _msgListFromDB = [];
    _mType = widget.mType;
    _isLoad = false;
    _userInfo = ContactInfo().getUserModel();

    if (fromChatType(_mType) == ChatType.Chat) {
      _singleChat = true;
    }
    if (fromChatType(_mType) == ChatType.ChatRoom && !_isJoinRoom) {
      _joinChatRoom();
    }

    _onConversationInit();

    _scrollController.addListener(() {
      //此处要用 == 而不是 >= 否则会触发多次
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMessage();
      }
    });

    _subscription = VideoCompress.compressProgress$.subscribe((progress) {
      debugPrint('progress: $progress');
    });
  }

  void _loadMessage() async {
    var loadlist =
        await _conversation.loadMoreMsgFromDB(_afterLoadMessageId, _pageSize);
    if (loadlist.length > 0) {
      _afterLoadMessageId = loadlist.first.msgId;
      loadlist.sort((a, b) => b.msgTime.compareTo(a.msgTime));
      await Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _messageTotalList.addAll(loadlist);
        });
      });

      _isLoad = true;
    } else {
      _isLoad = true;
      print('没有更多数据了');
    }
//    print(_messageTotalList.length.toString() + '_loadMessage');
    _scrollController.animateTo(_scrollController.offset,
        duration: new Duration(seconds: 2), curve: Curves.ease);
  }

  void _onConversationInit() async {
    _messageList.clear();
    _conversation = await EMClient.getInstance().chatManager().getConversation(
        widget.toModel.id, fromEMConversationType(_mType), true);

    if (_conversation != null) {
      _conversation.markAllMessagesAsRead();
      _msgListFromDB = await _conversation.loadMoreMsgFromDB('', 20);
    }

    if (_msgListFromDB != null && _msgListFromDB.length > 0) {
      _afterLoadMessageId = _msgListFromDB.first.msgId;
      _messageList.addAll(_msgListFromDB);
    }
    _isLoad = false;
    setState(() {});
  }

  ///如果是聊天室类型 先加入聊天室
  _joinChatRoom() {
    EMClient.getInstance().chatRoomManager().joinChatRoom(widget.toModel.id,
        onSuccess: () {
      _isJoinRoom = true;
    }, onError: (int errorCode, String errorString) {
      print('errorCode: ' +
          errorCode.toString() +
          ' errorString: ' +
          errorString);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_messageList.length > 0) {
      _messageList.sort((a, b) => b.msgTime.compareTo(a.msgTime));
      if (!_isLoad) {
        _messageTotalList.clear();
        _messageTotalList.addAll(_messageList);
//        print(_messageTotalList.length.toString() + 'after build true: ' + _messageList.length.toString());
      } else {
        print('_scrollController: ' + _scrollController.offset.toString());
        _scrollController.animateTo(_scrollController.offset,
            duration: new Duration(seconds: 2), curve: Curves.ease);
      }
//      print(_messageTotalList.length.toString() + 'build');
    }

    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.toModel.name,
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: false,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context, false);
                });
          }),
          actions: <Widget>[
            // 隐藏的菜单
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_horiz,
                color: Colors.black,
              ),
              itemBuilder: _singleChat == true
                  ? (BuildContext context) => <PopupMenuItem<String>>[
                        this.SelectView(Icons.delete, '删除记录', 'A'),
                        this.SelectView(Icons.delete, '删除好友', 'B'),
                      ]
                  : (BuildContext context) => <PopupMenuItem<String>>[
                        this.SelectView(Icons.delete, '删除记录', 'A'),
                        this.SelectView(Icons.people, '查看详情', 'B'),
                      ],
              onSelected: (String action) {
                // 点击选项的时候
                switch (action) {
                  case 'A':
                    this._cleanAllMessage();
                    break;
                  case 'B':
                    //                  _viewDetails();
                    this._deleteFriend();
                    break;
                }
              },
            ),
          ],
        ),
        body: Container(
          color: AppColors.ViewBackgroundColor,
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Flexible(
                        child: Column(
                      children: [
                        Flexible(
                          child: ListView.builder(
                            key: UniqueKey(),
                            shrinkWrap: true,
                            reverse: true,
                            controller: _scrollController,
                            itemCount: _messageTotalList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (_messageTotalList.length != null &&
                                  _messageTotalList.length > 0) {
//                              print(index);
//                              print(_messageTotalList[index]);
                                return ChatItem(this, _messageTotalList[index],
                                    _isShowTime(index), widget.toModel);
                              } else {
                                return Container();
                              }
                            },
                          ),
                        )
                      ],
                    )),
                    Container(
                      height: 51,
                      child: BottomInputBar(this),
                    ),
                    _getExtWidgets(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 判断时间间隔在60秒内不需要显示时间
  bool _isShowTime(int index) {
    // return true;
    //  print('判断时间间隔在60秒内不需要显示时间');
    //  print(index);
    if (index == 0) {
      return true;
    }
    print(_messageTotalList.toString());
    print(index);
    String lastTime = _messageTotalList[index - 1].msgTime;
    print('before' +
        _messageTotalList[index - 1].body.toString() +
        ' beforeTime:' +
        lastTime);
    String afterTime = _messageTotalList[index].msgTime;
    print('after' +
        _messageTotalList[index].body.toString() +
        ' afterTime:' +
        afterTime);
    return isCloseEnough(lastTime, afterTime);
  }

  ///判断消息时间间隔
  static const int INTERVAL_IN_MILLISECONDS = 60 * 1000;
  static bool isCloseEnough(String time1, String time2) {
    int lastTime = int.parse(time1);
    int afterTime = int.parse(time2);
    int delta = lastTime - afterTime;
    if (delta < 0) {
      delta = -delta;
    }
    return delta > INTERVAL_IN_MILLISECONDS;
  }

  ///清除记录
  _cleanAllMessage() {
    if (null != this._conversation) {
      print('删除聊天记录');
      this._messageTotalList.forEach((element) {
        EMMessage emMessage = element;
        this._conversation.removeMessage(emMessage.msgId);
      });
      //
      // this._conversation.clearAllMessages();
      setState(() {
        this._messageList = [];
        this._messageTotalList = [];
      });
      // Navigator.of(context).pop(true);
    }
  }

  // ignore: non_constant_identifier_names
  SelectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // ignore: non_constant_identifier_names
            Icon(icon, color: Colors.red),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }

  bool showExtWidget = false; //是否显示加号扩展栏内容

  Widget _getExtWidgets() {
    if (showExtWidget) {
      return Container(
          height: 312 - 50.0,
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            padding: EdgeInsets.all(10),
            children: [
              GestureDetector(
                onTap: () {
                  _openGallery();
                },
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.image,
                          size: 35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Text('相册')
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _takePhoto();
                },
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.camera_alt,
                          size: 35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Text('拍摄')
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _takeVideo();
                },
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.videocam,
                          size: 35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Text('视频')
                    ],
                  ),
                ),
              )
            ],
          ));
    } else {
      return Container();
    }
  }

  /*拍照*/
  _takePhoto() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    onTapItemCamera(image.path);
  }

  /*相册*/
  _openGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    onTapItemPicture(image.path);
  }

  /*视频*/
  _takeVideo() async {
    ImagePicker _imagePicker = ImagePicker();
    PickedFile _pickedFile =
        await _imagePicker.getVideo(source: ImageSource.gallery);
    print(
        'select video —————————————————————————————————————————--—————————————— ${_pickedFile.path}');
    // onTapItemVideo(_pickedFile.path);
    _compressVideo(_pickedFile.path);
  }

  @override
  void dispose() {
    super.dispose();
    EMClient.getInstance().chatManager().removeMessageListener(this);
    _scrollController.dispose();
    _messageTotalList.clear();
    if (_isJoinRoom) {
      checkOutRoom();
    }
    _subscription.unsubscribe();
  }

  checkOutRoom() {
    EMClient.getInstance().chatRoomManager().leaveChatRoom(widget.toModel.id,
        onSuccess: () {
      print('退出聊天室成功');
    }, onError: (int errorCode, String errorString) {
      print('errorCode: ' +
          errorCode.toString() +
          ' errorString: ' +
          errorString);
    });
  }

  _deleteFriend() {
    var s = _provide
        .getApplyMessage(_userInfo.id, widget.toModel.id)
        .doOnData((event) {
          print('删除成功删除！！！！');
          Navigator.pop(context, true);
        })
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  ///EMMessageListener
  @override
  void onCmdMessageReceived(List<EMMessage> messages) {
    // TODO: implement onCmdMessageReceived
  }

  @override
  void onMessageChanged(EMMessage message) {
    // TODO: implement onMessageChanged
  }

  @override
  void onMessageDelivered(List<EMMessage> messages) {
    // TODO: implement onMessageDelivered
  }

  @override
  void onMessageRead(List<EMMessage> messages) {
    // TODO: implement onMessageRead
  }

  @override
  void onMessageRecalled(List<EMMessage> messages) {
    // TODO: implement onMessageRecalled
  }

  @override
  void onMessageReceived(List<EMMessage> messages) {
    for (var message in messages) {
      String username = message.from;

      // if the message is for current conversation
      if (username == widget.toModel.id ||
          message.to == widget.toModel.id ||
          message.conversationId == widget.toModel.id) {
        _conversation.markMessageAsRead(message.msgId);
      }
    }
    _onConversationInit();
  }

  ///EMMessageStatus
  @override
  void onProgress(int progress, String status) {
    // TODO: implement onProgress
  }

  ///EMCallStateChangeListener
  @override
  void onAccepted() async {
    // TODO: implement onAccepted
    // var callId = await EMClient.getInstance().callManager().getCallId();
    // var getExt = await EMClient.getInstance().callManager().getExt();
    // var getLocalName =
    //     await EMClient.getInstance().callManager().getLocalName();
    // var getRemoteName =
    //     await EMClient.getInstance().callManager().getRemoteName();
    // var isRecordOnServer =
    //     await EMClient.getInstance().callManager().isRecordOnServer();
    // var getConnectType =
    //     await EMClient.getInstance().callManager().getConnectType();
    // var getCallType = await EMClient.getInstance().callManager().getCallType();
    // print(' onAcceptedinfo:  ' +
    //     ' callId: ' +
    //     callId.toString() +
    //     ' getExt: ' +
    //     getExt.toString() +
    //     ' getLocalName: ' +
    //     getLocalName.toString() +
    //     ' getRemoteName: ' +
    //     getRemoteName.toString() +
    //     ' isRecordOnServer: ' +
    //     isRecordOnServer.toString() +
    //     ' getConnectType: ' +
    //     getConnectType.toString() +
    //     ' getCallType: ' +
    //     getCallType.toString());
    print('-----------EMCallStateChangeListener---------->' + ': onAccepted');
  }

  @override
  void onConnected() {
    // TODO: implement onConnected
  }

  @override
  void onConnecting() {
    // TODO: implement onConnecting
  }

  @override
  void onDisconnected(CallReason reason) async {
    Future.delayed(Duration(milliseconds: 500), () {
      _onConversationInit();
    });
    // var getServerRecordId =
    //     await EMClient.getInstance().callManager().getServerRecordId();
    // print('-----------getServerRecordId----------> ' + getServerRecordId);
    print('-----------EMCallStateChangeListener---------->' +
        ': onDisconnected' +
        reason.toString());
  }

  @override
  void onNetVideoPause() {
    // TODO: implement onNetVideoPause
  }

  @override
  void onNetVideoResume() {
    // TODO: implement onNetVideoResume
  }

  @override
  void onNetVoicePause() {
    // TODO: implement onNetVoicePause
  }

  @override
  void onNetVoiceResume() {
    // TODO: implement onNetVoiceResume
  }

  @override
  void onNetWorkDisconnected() {
    // TODO: implement onNetWorkDisconnected
  }

  @override
  void onNetWorkNormal() {
    // TODO: implement onNetWorkNormal
  }

  @override
  void onNetworkUnstable() {
    // TODO: implement onNetworkUnstable
  }

  ///BottomInputBarDelegate
  ///输入时调用
  @override
  inputStatusChanged(InputBarStatus status) {
    if (status == InputBarStatus.Ext) {
      showExtWidget = true;
    } else {
      showExtWidget = false;
    }
    setState(() {});
  }

  ///发送消息调用
  @override
  sendText(String text) {
    EMMessage message = EMMessage.createTxtSendMessage(
        userName: widget.toModel.id, content: text);
    message.chatType = fromChatType(_mType);
    EMTextMessageBody body = EMTextMessageBody(text);
    message.body = body;
    print('-----------LocalID---------->' + message.msgId);
    message.setAttribute({"test1": "1111", "test2": "2222"});
    EMClient.getInstance().chatManager().sendMessage(message, onSuccess: () {
      print('-----------ServerID---------->' + message.msgId);
      print('-----------MessageStatus---------->' + message.status.toString());
    });
    _onConversationInit();
  }

  ///点击语音按钮
  @override
  void sendVoice(String path, int duration) {
    print('-----$path------$duration------------------------发送语音消息');
    EMMessage message = EMMessage.createVoiceSendMessage(
        userName: widget.toModel.id, filePath: path, timeLength: duration);
    message.chatType = fromChatType(_mType);
    EMVoiceMessageBody body = EMVoiceMessageBody(File(path), duration);
    message.body = body;
    print('-----------LocalID---------->' + message.msgId);
    message.setAttribute({"test1": "1111", "test2": "2222"});
    EMClient.getInstance().chatManager().sendMessage(
      message,
      onSuccess: () {
        print('-----------ServerID---------->' + message.msgId);
        print(
            '-----------MessageStatus---------->' + message.status.toString());
        _onConversationInit();
      },
      onError: (int errorCode, String desc) {
        print('传输中...失败.........');
        print(desc);
      },
      onProgress: (int progress) {
        print('传输中.............');
        print(progress);
      },
    );
  }

  void onTapItemPicture(String imgPath) {
    print('onTapItemPicture' + imgPath);

    EMMessage imageMessage = EMMessage.createImageSendMessage(
        userName: widget.toModel.id,
        filePath: imgPath,
        sendOriginalImage: true);
    imageMessage.chatType = fromChatType(_mType);
    EMClient.getInstance().chatManager().sendMessage(imageMessage,
        onSuccess: () {
      print('--------Picture---success---------->');
      _onConversationInit();
    });
  }

  void onTapItemCamera(String imgPath) {
    print('onTapItemCamera' + imgPath);
    EMMessage imageMessage = EMMessage.createImageSendMessage(
        userName: widget.toModel.id,
        filePath: imgPath,
        sendOriginalImage: true);
    imageMessage.chatType = fromChatType(_mType);
    EMClient.getInstance().chatManager().sendMessage(imageMessage,
        onSuccess: () {
      print('-------Camera----success---------->');
      _onConversationInit();
    });
  }

  void onTapItemVideo(String videoPath) {
    // _compressVideo(videoPath);
    EMMessage videoMessage = EMMessage.createVideoSendMessage(
        userName: widget.toModel.id, filePath: videoPath, timeLength: 11);
    videoMessage.chatType = fromChatType(_mType);
    EMClient.getInstance().chatManager().sendMessage(
      videoMessage,
      onSuccess: () {
        print('--------Video---success---------->');
        _onConversationInit();
      },
      onError: (int errorCode, String desc) {
        print('传输中...失败.........');
        print(desc);
      },
      onProgress: (int progress) {
        print('传输中.............');
        print(progress);
      },
    );
  }

  void _onTapCustomVideo(String videoPath) {
    print('发送自定义方法！！！！');
    EMMessage videoMessage = EMMessage.createCustomSendMessage(
        userName: widget.toModel.id,
        event: 'CustomVideo',
        params: {'CustomVideo': videoPath});
    videoMessage.chatType = fromChatType(_mType);
    print('发送自定义方法！！！！2222222222222222');
    EMClient.getInstance().chatManager().sendMessage(
      videoMessage,
      onSuccess: () {
        print('--------Video---success---------->');
        _onConversationInit();
      },
      onError: (int errorCode, String desc) {
        print('传输中...失败.........');
        print(desc);
      },
      onProgress: (int progress) {
        print('传输中.............');
        print(progress);
      },
    );
  }

  ///压缩视频
  _compressVideo(String path) async {
    // final file =
    // await ImagePicker().getVideo(source: ImageSource.gallery);
    await VideoCompress.setLogLevel(0);
    final info = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    if (info != null) {
      print(
          'video 本地压缩路径========================================== ${info.path}');
      _postVideoPath(FormData.fromMap({
        'file': await MultipartFile.fromFile(info.path,
            filename: info.path
                .substring(info.path.lastIndexOf("/") + 1, info.path.length))
      }));
      VideoCompress.cancelCompression();
    }
  }

  ///视频上传
  _postVideoPath(imagePath) async {
    print('视频上传~~~~~~~~');
    _showAlertDialog('发送中...');
    ScanDio.videoRequest(
      param: imagePath,
      onSuccess: (data) {
        print('视频上传成功-->$data  type --> ${data.runtimeType}');
        _onTapCustomVideo(data);
      },
      onError: (error) {},
    );
  }

  /*  加载数据的  loading 动画  */
  static Future _showAlertDialog(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowLoading(
          title: message,
        );
      },
    );
  }

  ///点击加号按钮
  @override
  void onTapExtButton() {
    // TODO: implement onTapExtButton
  }

  ///聊天item
  @override
  void onLongPressMessageItem(EMMessage message, Offset tapPos) {
    // TODO: implement onLongPressMessageItem
  }

  @override
  void onTapMessageItem(EMMessage message) {
    // TODO: implement onTapMessageItem
  }

  @override
  void onTapUserPortrait(String userId) {
    // TODO: implement onTapUserPortrait
  }

  @override
  void onNetworkDisconnected() {
    // TODO: implement onNetworkDisconnected
  }

  @override
  void onNetworkNormal() {
    // TODO: implement onNetworkNormal
  }
}

enum ChatStatus {
  Normal, //正常
  VoiceRecorder, //语音输入，页面中间回弹出录音的 gif
}
