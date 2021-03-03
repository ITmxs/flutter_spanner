import 'package:flutter/material.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/vedioPalyer.dart';
import 'package:spanners/cModel/aboutModel.dart';
import 'package:spanners/cTools/foldText.dart';
import 'package:spanners/talkingOnline/about/aaboutRequestApi.dart';
//视频缩略题
import 'package:video_player/video_player.dart';

class VedioView extends StatefulWidget {
  final dataLists;
  final ValueChanged<String> onChanged; //
  const VedioView({Key key, this.dataLists, this.onChanged}) : super(key: key);
  @override
  _VedioViewState createState() => _VedioViewState();
}

class _VedioViewState extends State<VedioView> {
  //视频 缩略图
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;

  var dataModel;
  List<String> imageList;

  //关注
  _followUserId(String articleId, String type) {
    AboutDio.followUserId(
        param: {'followUserId': articleId, 'type': type},
        onSuccess: (data) {
          print(data);
          setState(() {
            widget.onChanged('');
          });
        },
        onError: (error) {
          setState(() {});
        });
  }

  //加好友
  _addFriend(
    String friendname,
  ) async {
    AboutDio.addFriendRequest(
        param: {
          'friendname': friendname,
          'ownername': await SharedManager.getString('mobile')
        },
        onSuccess: (data) {
          print(data);
          setState(() {
            widget.onChanged('');
          });
        },
        onError: (error) {
          setState(() {});
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      dataModel = AboutModel.fromJson(widget.dataLists);
      if (dataModel.imagesStr.toString().length > 0) {
        imageList = dataModel.imagesStr.toString().split(',');
      }
      //视频缩略图
      _controller = VideoPlayerController.network(
          imageList[0].toString()); //网络视频，也可以是file
      _controller.setLooping(true);
      _initializeVideoPlayerFuture = _controller.initialize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dataModel = AboutModel.fromJson(widget.dataLists);
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 11,
          ),
//--> 头像
          Row(children: <Widget>[
            SizedBox(
              width: 5,
            ),
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
                image: DecorationImage(
                  image: dataModel.headurl == null
                      ? AssetImage('Assets/Technology/headimage.png')
                      : NetworkImage(dataModel.headurl.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 7,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Container(
                  // width: 160,
                  height: 20,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(dataModel.realName.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Medium')),
                  ),
                ),
                Container(
                  // width: 160,
                  height: 20,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(dataModel.date.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontFamily: 'Medium')),
                  ),
                ),
              ],
            ),
            Expanded(child: SizedBox()),
            //加好友
            dataModel.auth == SynchronizePreferences.Get('userid')
                ? Container()
                : dataModel.isFriend
                    ? Container()
                    : InkWell(
                        onTap: () {
                          _addFriend(dataModel.mobile);
                        },
                        child: Image.asset(
                          'Assets/Technology/addfiend.png',
                          width: 22,
                          height: 22,
                          fit: BoxFit.fill,
                        ),
                      ),
            SizedBox(
              width: 20,
            ),

            // 关注
            dataModel.auth == SynchronizePreferences.Get('userid')
                ? Container()
                : InkWell(
                    onTap: () {
                      dataModel.isWatching
                          ? _followUserId(dataModel.auth, '1')
                          : _followUserId(dataModel.auth, '0');
                    },
                    child: Container(
                        width: 50,
                        height: 25,
                        child: dataModel.isWatching
                            ? Image.asset("Assets/Home/focused.png")
                            : Image.asset("Assets/Home/focus.png")),
                  ),
            SizedBox(
              width: 20,
            ),
          ]),
          SizedBox(
            height: 22,
          ),
//--> 内容
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Expanded(
                  child: FoldText(
                text: dataModel.text.toString(),
                width: MediaQuery.of(context).size.width - 30,
              )),
              SizedBox(
                width: 15,
              ),
            ],
          ),

          SizedBox(
            height: 20,
          ),
//--> vedio 区域
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 151,
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Stack(
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                                        url: imageList[0],
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
