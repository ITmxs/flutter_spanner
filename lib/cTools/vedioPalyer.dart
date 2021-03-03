import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// ignore: camel_case_types
class videoPalyer extends StatefulWidget {
  final url;

  const videoPalyer({Key key, this.url}) : super(key: key);
  @override
  _videoPalyerState createState() => _videoPalyerState();
}

// ignore: camel_case_types
class _videoPalyerState extends State<videoPalyer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    print('video-->${widget.url}');
    _controller = VideoPlayerController.network(widget.url.toString()) //加载网络视频
      //_controller = VideoPlayerController.asset("assets/images/1.mp4") //加载本地视频
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        // _controller.setVolume(0.0);
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Center(
          child: Container(
            height: 300,
            child: VideoPlayer(_controller),
          ),
        ));
  }
}
