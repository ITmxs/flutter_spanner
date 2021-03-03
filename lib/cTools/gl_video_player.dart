import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:spanners/cTools/vedioPalyer.dart';

class GLVideoPlayer extends StatefulWidget {
  final String netVideoUrl;
  final String localVideoUrl;

  const GLVideoPlayer({Key key, this.netVideoUrl, this.localVideoUrl})
      : super(key: key);

  @override
  _GLVideoPlayerState createState() => _GLVideoPlayerState();
}

class _GLVideoPlayerState extends State<GLVideoPlayer> {
  //视频 缩略图
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      //视频缩略图
      print('//视频缩略图');
      print(widget.localVideoUrl);
      _controller = widget.localVideoUrl != null
          ? VideoPlayerController.file(File(widget.localVideoUrl))
          : VideoPlayerController.network(widget.netVideoUrl);
      _controller.setLooping(true);
      _initializeVideoPlayerFuture = _controller.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 200,
      child: Stack(
        alignment: const FractionalOffset(0.5, 0.5),
        overflow: Overflow.visible,
        children: [
          FutureBuilder(
            //显示缩略图
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (snapshot.hasError) print(snapshot.error);
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: 2 / 3,
//                      aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 60,
              height: 60,
                color: Color.fromRGBO(200, 200, 200, 0.6),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
