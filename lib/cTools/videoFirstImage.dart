import 'package:flutter/material.dart';
import 'package:spanners/cTools/vedioPalyer.dart';
import 'package:video_player/video_player.dart';

class AddVideoFirstImage extends StatefulWidget {
  final String videoUrl;

  const AddVideoFirstImage({Key key, this.videoUrl}) : super(key: key);
  @override
  _AddVideoFirstImageState createState() => _AddVideoFirstImageState();
}

class _AddVideoFirstImageState extends State<AddVideoFirstImage> {
  //视频 缩略图
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      // TODO: implement initState
      setState(() {
        //视频缩略图
        _controller =
            VideoPlayerController.network(widget.videoUrl); //网络视频，也可以是file
        _controller.setLooping(true);
        _initializeVideoPlayerFuture = _controller.initialize();
      });
      super.initState();
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(0),
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: FutureBuilder(
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
          ),
        ),
        /* 播放 按钮所在位置 大小 可根据实际项目 需要 调整 */
        Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 2 - 30 / 2 - 20,
                151 / 2 - 20,
                MediaQuery.of(context).size.width / 2 - 30 / 2 - 20,
                151 / 2 - 20),
            child: InkWell(
              onTap: () {
                /*  视频上传成功后 点击播放视频  */
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new videoPalyer(
                              url: widget.videoUrl,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            )),
      ],
    );
  }
}
