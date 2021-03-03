import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:video_player/video_player.dart';
import 'package:spanners/cTools/photoSelect.dart';
import 'package:spanners/cTools/vedioPalyer.dart';
import 'package:spanners/cTools/imageChange.dart';
import 'imageView.dart';
import './aaboutRequestApi.dart';

class SendComment extends StatefulWidget {
  final List _imagesList = List();
  final int types; //拍照  拍摄

  SendComment({Key key, this.types}) : super(key: key);
  @override
  _SendCommentState createState() => _SendCommentState();
}

class _SendCommentState extends State<SendComment> {
  //视频 缩略图
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;
  String videoUrl;
  String text = ''; //发布 的 文本内容
  /* 九张图 与 add 图 逻辑 */
  int _returnInt(List imagelist) {
    return imagelist.length == 0 ? 1 : imagelist.length + 1;
  }

  /* 图片点击放大 逻辑 */
  int _returnChangeInt(int returnInt, int index) {
    return index == returnInt - 1 ? 0 : 1;
  }

  /*  发布技术圈 */
  _postComment() {
    List list = List();
    if (widget.types == 2) {
      list = widget._imagesList;
    } else {
      for (var i = 0; i < widget._imagesList.length; i++) {
        Map imageMap = Map();
        imageMap['picUrl'] = widget._imagesList[i];
        imageMap['fileKbn'] = 0;
        list.add(imageMap);
      }
    }

    _isPost()
        ? AboutDio.aboutPostCommentRequest(
            param: {
              'text': text.toString(),
              'type': 2,
              'articlepicentitylist': list,
              'status': 0
            },
            onSuccess: (data) {
              Navigator.pop(context);
            },
            onError: (error) {},
          )
        : Text('');
  }

  /* 文字 图片视频 检查  */
  bool _isPost() {
    if (text == '') {
      Alart.showAlartDialog('未输入发布内容', 1);
      return false;
    } else if (widget._imagesList.length == 0) {
      Alart.showAlartDialog('请选择图片或视频', 1);
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromRGBO(39, 153, 93, 1)),
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              InkWell(
                onTap: () {
                  _postComment();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromRGBO(39, 153, 93, 1)),
                  child: Text(
                    '发布',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200, maxWidth: 300),
                  child: TextFormField(
                    maxLines: 6,
                    onChanged: (value) {
                      setState(() {
                        /*  发布 文字 数量 限制  */
                        value.length > 500
                            ? Alart.showAlartDialog('超出字数限制', 1)
                            : text = value;
                      });
                    },
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      hintText: '请输入发表的内容',
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(136, 133, 133, 1),
                          fontSize: 15),
                      enabledBorder: OutlineInputBorder(
                        //未选中时候的颜色
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(238, 238, 238, 1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        //选中时外边框颜色
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(238, 238, 238, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              widget.types == 2
                  ? InkWell(
                      onTap: () {
                        videoUrl == null
                            ?
                            /*     发布 视频的      */
                            showModalBottomSheet(
                                isDismissible: true,
                                enableDrag: false,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return new Container(
                                    height: 160.0,
                                    child: PhotoSelect(
                                      isScan: false,
                                      isVin: false,
                                      type: 2,
                                      onChangedVideo: (value) {
                                        setState(
                                          () {
                                            widget._imagesList.clear();
                                            videoUrl = value;
                                            Map imageMap = Map();
                                            imageMap['picUrl'] = value;
                                            imageMap['fileKbn'] = 1;
                                            widget._imagesList.add(imageMap);
                                            print(
                                                '成功上传的图片地址：${widget._imagesList}');

                                            _controller =
                                                VideoPlayerController.network(
                                                    videoUrl); //网络视频，也可以是file
                                            _controller.setLooping(true);
                                            _initializeVideoPlayerFuture =
                                                _controller.initialize();
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              )
                            :
                            /*  视频上传成功后 点击播放视频  */
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new videoPalyer(
                                          url: videoUrl,
                                        )),
                              );
                      },
                      child: Container(
                          width: 140,
                          height: 220,
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(0),
                                child: videoUrl == null
                                    ? Image.asset(
                                        'Assets/Home/image_add.png',
                                        fit: BoxFit.fill,
                                      )
                                    : ConstrainedBox(
                                        constraints: BoxConstraints.expand(),
                                        child: FutureBuilder(
                                          //显示缩略图
                                          future: _initializeVideoPlayerFuture,
                                          builder: (context, snapshot) {
                                            print(snapshot.connectionState);
                                            if (snapshot.hasError)
                                              print(snapshot.error);
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return AspectRatio(
                                                aspectRatio: 2 / 3,
//                      aspectRatio: _controller.value.aspectRatio,
                                                child: VideoPlayer(_controller),
                                              );
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                              ),
                              videoUrl == null
                                  ? Container()
                                  : Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(118, 2, 2, 198),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              videoUrl = null;
                                            });
                                          },
                                          child: Image.asset(
                                            'Assets/Technology/deletclose.png',
                                            width: 20,
                                            height: 20,
                                          ))),
                              videoUrl == null
                                  ? Container()
                                  : Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          140 / 2 - 20,
                                          220 / 2 - 20,
                                          140 / 2 - 20,
                                          220 / 2 - 20),
                                      child: InkWell(
                                        onTap: () {
                                          /*  视频上传成功后 点击播放视频  */
                                          Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new videoPalyer(
                                                      url: videoUrl,
                                                    )),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      )),
                            ],
                          )),
                    )
                  : Expanded(
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: new NeverScrollableScrollPhysics(), //禁止滑动
                          itemCount: _returnInt(widget._imagesList) > 9
                              ? 9
                              : _returnInt(widget._imagesList), //做多9个
                          //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  //横轴元素个数
                                  crossAxisCount: 3,
                                  //纵轴间距
                                  mainAxisSpacing: 10.0,
                                  //横轴间距
                                  crossAxisSpacing: 15.0,
                                  //子组件宽高长度比例
                                  childAspectRatio: 1.0),
                          itemBuilder: (BuildContext context, int index) {
                            //Widget Function(BuildContext context, int index)
                            return InkWell(
                              onTap: () {
                                _returnChangeInt(_returnInt(widget._imagesList),
                                            index) ==
                                        0
                                    ?
                                    /*     发布 图片的      */
                                    showModalBottomSheet(
                                        isDismissible: true,
                                        enableDrag: false,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return new Container(
                                            height: 160.0,
                                            child: PhotoSelect(
                                              isScan: false,
                                              isVin: false,
                                              imageNumber: 9,
                                              type: 1,
                                              imageList:
                                                  widget._imagesList.length == 0
                                                      ? null
                                                      : widget._imagesList,
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    // List list = List();
                                                    // for (var i = 0;
                                                    //     i < value.length;
                                                    //     i++) {
                                                    //   Map imageMap = Map();
                                                    //   imageMap['picUrl'] =
                                                    //       value[i];
                                                    //   imageMap['fileKbn'] = 0;
                                                    //   list.add(imageMap);
                                                    // }
                                                    //widget._imagesList.clear();
                                                    widget._imagesList
                                                        .addAll(value);
                                                    print(
                                                        '成功上传的图片地址：${widget._imagesList}');
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      )
                                    :
                                    /*     图片点击方法     */

                                    Navigator.of(context).push(new FadeRoute(
                                        page: PhotoViewSimpleScreen(
                                        imageProvider: NetworkImage(
                                          widget._imagesList[index],
                                        ),
                                        heroTag: 'simple',
                                      )));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3 -
                                    50 / 3,
                                height: MediaQuery.of(context).size.width / 3 -
                                    50 / 3,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: index + 1 ==
                                            _returnInt(widget._imagesList)
                                        ? Image.asset(
                                            'Assets/Home/image_add.png',
                                            fit: BoxFit.cover,
                                          )
                                        : Stack(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.all(0),
                                                  child: ConstrainedBox(
                                                    constraints:
                                                        BoxConstraints.expand(),
                                                    child: Image.network(
                                                      widget._imagesList[index],
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3 -
                                                        50 / 3 -
                                                        20 -
                                                        2,
                                                    2,
                                                    2,
                                                    MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3 -
                                                        50 / 3 -
                                                        20 -
                                                        2),
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        /*  删除 图片操作  */
                                                        widget._imagesList
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    child: Image.asset(
                                                      'Assets/Technology/deletclose.png',
                                                      width: 20,
                                                      height: 20,
                                                    )),
                                              ),
                                            ],
                                          )),
                              ),
                            );
                          }),
                    ),
              SizedBox(
                width: 15,
              ),
            ],
          )
        ],
      ),
    );
  }
}
