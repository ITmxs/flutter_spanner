import 'package:flutter/material.dart';
import 'package:flutter_plugin_record/flutter_plugin_record.dart';

typedef startRecord = Future Function();
typedef stopRecord = Future Function();
//typedef voiceChange = void Function(int i);

class VoiceWidget extends StatefulWidget {
  final Function startRecord;
  final Function stopRecord;
  final Function onVoiceChanges;
  final Function sendVoice;
  //final voiceChange<String> onVoiceChanges;

  /// startRecord 开始录制回调  stopRecord回调
  const VoiceWidget({
    Key key,
    this.startRecord,
    this.stopRecord,
    this.onVoiceChanges,
    this.sendVoice,
  }) : super(key: key);

  @override
  _VoiceWidgetState createState() => _VoiceWidgetState();

  // noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// class _VoiceWidgetState extends State<VoiceWidget> {
class _VoiceWidgetState extends State<VoiceWidget> {
  double starty = 0.0;
  double offset = 0.0;
  bool isUp = false;
  String textShow = "按住说话";
  String toastShow = "手指上滑,取消发送";
  String voiceIco = "Assets/voice_volume_1.png";

  ///默认隐藏状态
  bool voiceState = true;
  OverlayEntry overlayEntry;
  FlutterPluginRecord recordPlugin;

  @override
  void initState() {
    super.initState();
    recordPlugin = FlutterPluginRecord();

    _init();

    ///初始化方法的监听
    recordPlugin.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });

    /// 开始录制或结束录制的监听
    recordPlugin.response.listen((data) {
      if (data.msg == "onStop") {
        ///结束录制时会返回录制文件的地址方便上传服务器
//        print("onStop  " + data.path);
        widget.stopRecord(data.path, data.audioTimeLength.toInt());
      } else if (data.msg == "onStart") {
//        print("onStart --");
        widget.startRecord();
      }
    });

    ///录制过程监听录制的声音的大小 方便做语音动画显示图片的样式
    recordPlugin.responseFromAmplitude.listen((data) {
      var voiceData = double.parse(data.msg);
      setState(() {
        if (voiceData > 0 && voiceData < 0.1) {
          voiceIco = "Assets/voice_volume_2.png";
        } else if (voiceData > 0.2 && voiceData < 0.3) {
          voiceIco = "Assets/voice_volume_3.png";
        } else if (voiceData > 0.3 && voiceData < 0.4) {
          voiceIco = "Assets/voice_volume_4.png";
        } else if (voiceData > 0.4 && voiceData < 0.5) {
          voiceIco = "Assets/voice_volume_5.png";
        } else if (voiceData > 0.5 && voiceData < 0.6) {
          voiceIco = "Assets/voice_volume_6.png";
        } else if (voiceData > 0.6 && voiceData < 0.7) {
          voiceIco = "Assets/voice_volume_7.png";
        } else if (voiceData > 0.7 && voiceData < 1) {
          voiceIco = "Assets/voice_volume_7.png";
        } else {
          voiceIco = "Assets/voice_volume_1.png";
        }
        if (overlayEntry != null) {
          overlayEntry.markNeedsBuild();
        }
      });

//      print("振幅大小   " + voiceData.toString() + "  " + voiceIco);
    });
  }

  ///显示录音悬浮布局
  buildOverLayView(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = new OverlayEntry(builder: (content) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.5 - 80,
          left: MediaQuery.of(context).size.width * 0.5 - 80,
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xff77797A),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Image.asset(
                          voiceIco,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Container(
//                      padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                        child: Text(
                          toastShow,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context).insert(overlayEntry);
    }
  }

  showVoiceView() {
    setState(() {
      textShow = "松开结束";
      voiceState = false;
    });
    buildOverLayView(context);
    start();
  }

  hideVoiceView() {
    setState(() {
      textShow = "按住说话";
      voiceState = true;
    });

    stop();
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

//    print(isUp);
    if (isUp) {
      print("取消发送");
    } else {
      print("进行发送");
    }
    widget.sendVoice(isUp);
  }

  moveVoiceView() {
    // print(offset - start);
    setState(() {
      isUp = starty - offset > 100 ? true : false;
//      print('11111111111  isup');
//      print(isUp);
      if (isUp) {
        textShow = "松开手指,取消发送";
        toastShow = textShow;
      } else {
        textShow = "松开结束";
        toastShow = "手指上滑,取消发送";
      }
    });
  }

  ///初始化语音录制的方法
  void _init() async {
    recordPlugin.init();
  }

  ///开始语音录制的方法
  void start() async {
    recordPlugin.start();
  }

  ///停止语音录制的方法
  void stop() {
    recordPlugin.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        GestureDetector(
//        onLongPress: (){
//          print("onLongPress------onLongPress");
//        },
          onLongPressStart: (details) {
            starty = details.globalPosition.dy;
//            print("start------onLongPressStart");
            showVoiceView();
          },
          onLongPressEnd: (details) {
            hideVoiceView();
//            print("end------onLongPressEnd");

            //发送成功
//            widget.onVoiceChanges(2);
          },
          onLongPressMoveUpdate: (details) {
            offset = details.globalPosition.dy;
            moveVoiceView();
//            print("update------onLongPressMoveUpdate");
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 60 -60 -30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            // height: 60,
            // color: Colors.blue,
            // margin: EdgeInsets.fromLTRB(50, 0, 50, 20),
            child: Center(
              child: Text(
                textShow,
              ),
            ),
          ),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    if (recordPlugin != null) {
      recordPlugin.dispose();
    }
    super.dispose();
  }
}


class PlayerRecord {
  FlutterPluginRecord recordPlugin = FlutterPluginRecord();

  init(){
    ///初始化方法的监听
    recordPlugin.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });

    recordPlugin.responsePlayStateController.listen((data) {
      print("播放路径   " + data.playPath);
      print("播放状态   " + data.playState);
    });
  }

  ///播放语音的方法
  void play() {
    recordPlugin.play();
  }


  ///type : "file" "url"
  ///播放指定路径录音文件  url为iOS播放网络语音，file为播放本地语音文件
  void playByPath(String path,String type) {
    recordPlugin.playByPath(path,type);
  }

  ///暂停|继续播放
  void pause() {
    recordPlugin.pausePlay();
  }

  // @override
  // void dispose() {
  //   /// 当界面退出的时候是释放录音资源
  //   recordPlugin.dispose();
  //   super.dispose();
  // }

  void stopPlay() {
    recordPlugin.stopPlay();
  }


}

