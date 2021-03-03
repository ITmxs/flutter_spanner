import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/cModel/aboutModel.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import './imageView.dart';
import './vedioView.dart';
import './aaboutRequestApi.dart';
import './aboutDetail.dart';
import './sendComment.dart';
import './personAbout.dart';

// ignore: must_be_immutable
class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  List dataList = List();
  bool recommendBool = false;
  bool loadBool = false; // 加载更多是否 成功
  bool getBool = false; //刷新是否  成功
  ScrollController scrollController = ScrollController();
  Timer _timer;
  String errors = '亲，当前数据为空呦~';
  String typeStr; // 点赞 取消点赞
  int page = 1;
  String queryType = '1'; // 默认 推荐 0为关注列表
  /// 启动倒计时的计时器。
  _startTimer() {
    _timer = Timer(
      // 持续时间参数。
      Duration(seconds: 2),
      // 回调函数参数。
      () {
        setState(() {
          getBool = false;
        });
      },
    );
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  //刷新 数据  queryType  关注 '0' 推荐 '1'
  _getAboutData() async {
    AboutDio.aboutHomeRequest(
        param: {
          'current': page,
          'size': 10,
          'myFlg': '',
          'type': 2,
          'queryType': queryType,
          'userId': await SharedManager.getString('userid')
        },
        onSuccess: (data) {
          print(data);
          setState(() {
            print('技术圈--->$dataList');
            getBool = true;
            _startTimer();
            dataList = data['records'];
          });
        },
        onError: (error) {
          setState(() {});
        });
  }

  // data 非空判断
  int isNull(List list) {
    //return list == null ? 0 : 1;
    if (list == null) {
      return 0;
    } else if (list.length == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  articleLike(String id) {
    AboutDio.articleLike(
        param: {'type': 0, 'userId': id},
        onSuccess: (data) {
          print(data);
          setState(() {});
        },
        onError: (error) {
          setState(() {});
        });
  }

  //加载数据
  _loadAboutData() async {
    AboutDio.aboutHomeRequest(
        param: {
          'current': page,
          'size': 10,
          "myFlg": "",
          "type": 2,
          'queryType': queryType,
          'userId': await SharedManager.getString('userid')
        },
        onSuccess: (data) {
          print(data);
          setState(() {
            print('data智能提醒list：--->$data');
            if (data['records'].length == 0) {
              loadBool = true;
            } else {
              dataList.addAll(data['records']); //add();
            }
          });
        },
        onError: (error) {
          setState(() {
            errors = error;
          });
        });
  }

  String _isCompary(list) {
    if (AboutModel.fromJson(list).imagesStr.toString().split(',').length == 1) {
      if (AboutModel.fromJson(list)
          .imagesStr
          .toString()
          .split(',')[0]
          .contains('mp4')) {
        return '1'; //video
      } else {
        return '2'; //image
      }
    }
  }

  //点赞操作
  /*
  type  0 点赞 1 取消点赞     articleLikeNum  原有点赞数量
  */
  _clickLike(String articleId, String articleLikeNum) {
    AboutDio.aboutarticleLikeRequest(
      param: {
        'articleId': articleId,
        'articleLikeNum': articleLikeNum,
        'type': typeStr
      },
      onSuccess: (data) {
        //setState(() {});
        //_getAboutData();
      },
    );
  }

/*
下拉刷新
*/
  Future _toRefresh() async {
    page = 1;
    _getAboutData();
    return null;
  }

/*
加载更多
*/
  _loadMore() {
    //滑动到底部监听
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page++;
        print('滑动到了最底部${scrollController.position.pixels}');
        _loadAboutData();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getAboutData();
    super.initState();

    _loadMore();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            '技术圈',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              showModalBottomSheet(
                  isDismissible: true,
                  enableDrag: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return new Container(
                        height: 160.0,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    /*  发布 照片   */
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SendComment(
                                                  types: 1,
                                                ))).then(
                                        (value) => _getAboutData());
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: Center(
                                      child: Text(
                                        '发布文字图片',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    /*  发布 视频   */
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SendComment(
                                                  types: 2,
                                                ))).then(
                                        (value) => _getAboutData());
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: Center(
                                      child: Text(
                                        '发布文字视频',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: Center(
                                      child: Text(
                                        '取消',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            )
                          ],
                        ));
                  });
            },
            child: Image.asset(
              'Assets/Technology/carmro.png',
              width: 27,
              height: 27,
            ),
          ),
          actions: [
            Column(
              children: [
                SizedBox(
                  height: 6,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PersonAbout()))
                        .then((value) => _getAboutData());
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.red,
                        image: DecorationImage(
                          image: json.decode(SynchronizePreferences.Get(
                                      "userInfo"))["headUrl"] ==
                                  null
                              ? AssetImage(
                                  'Assets/Technology/3.0x/headimage.png')
                              : NetworkImage(
                                  '${json.decode(SynchronizePreferences.Get("userInfo"))["headUrl"]}'),
                        )),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 15,
            )
          ],
        ),
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              // // 关注   推荐
              Container(
                color: Color.fromRGBO(238, 238, 238, 1),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 120,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              recommendBool
                                  ? recommendBool = false
                                  : recommendBool = true;
                              /*  关注列表  刷新切换  */
                              page = 1;
                              queryType = '0';
                              _getAboutData();
                            });
                          },
                          child: Container(
                            width: 100,
                            child: Text(
                              '关注',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: recommendBool
                                  ? TextStyle(
                                      color: Colors.black,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                            ),
                          ),
                        ),
                        recommendBool
                            ? SizedBox(
                                height: 5,
                              )
                            : Container(),
                        recommendBool
                            ? Container(
                                width: 25,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                  color: Color.fromRGBO(39, 153, 93, 1),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      width: 38,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              recommendBool
                                  ? recommendBool = false
                                  : recommendBool = true;
                              /*  推荐列表  刷新切换  */
                              page = 1;
                              queryType = '1';
                              _getAboutData();
                            });
                          },
                          child: Container(
                            width: 100,
                            child: Text(
                              '推荐',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: recommendBool
                                  ? TextStyle(
                                      color: Colors.black,
                                      fontSize: 19,
                                    )
                                  : TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        recommendBool
                            ? Container()
                            : SizedBox(
                                height: 5,
                              ),
                        recommendBool
                            ? Container()
                            : Container(
                                width: 25,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                  color: Color.fromRGBO(39, 153, 93, 1),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 5,
              ),
              //拍照拍摄弹出层
              //主干部分 默认是关注 展示
              isNull(dataList) == 0
                  ? Expanded(
                      child: RefreshIndicator(
                        child: ScrollConfiguration(
                          behavior: NeverScrollBehavior(),
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              ShowNullDataAlart(
                                alartText: errors,
                              ),
                            ],
                          ),
                        ),
                        onRefresh: _toRefresh,
                      ),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                      child: list(),
                      onRefresh: _toRefresh,
                    )),
            ],
          ),
        ));
  }

  list() {
    return ListView.builder(
        shrinkWrap: true,
        controller: scrollController,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: Column(
                  children: [
                    Container(
                        child: Column(
                      children: [
                        _isCompary(dataList[index]) == '1'
                            ? //视频
                            VedioView(
                                dataLists: dataList[index],
                                onChanged: (value) {
                                  _getAboutData();
                                },
                              )
                            : //展示
                            ImageView(
                                dataLists: dataList[index],
                                onChanged: (value) {
                                  _getAboutData();
                                },
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: Color.fromRGBO(238, 238, 238, 1),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 70,
                            ),
                            /*   评论   */
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AboutDetail(
                                                  dataList: dataList[index],
                                                )))
                                    .then((value) => _getAboutData());
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'Assets/Home/review.png',
                                      width: 19,
                                      height: 19,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AboutModel.fromJson(dataList[index])
                                          .commentNum
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            /*   点赞操作   */
                            InkWell(
                              onTap: () {
                                if (AboutModel.fromJson(dataList[index])
                                    .isLike) {
                                  typeStr = '1';
                                  dataList[index]['isLike'] = false;
                                  //取消点赞 -1
                                  dataList[index]['like'] =
                                      dataList[index]['like'] - 1;
                                } else {
                                  typeStr = '0';
                                  dataList[index]['isLike'] = true;
                                  //点在 +1
                                  dataList[index]['like'] =
                                      dataList[index]['like'] + 1;
                                }
                                // AboutModel.fromJson(
                                //             dataList[
                                //                 index])
                                //         .isLike
                                //     ? typeStr = '1'
                                //     : typeStr = '0';
                                _clickLike(
                                  AboutModel.fromJson(dataList[index])
                                      .id
                                      .toString(),
                                  AboutModel.fromJson(dataList[index])
                                      .like
                                      .toString(),
                                );
                                setState(() {});
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    AboutModel.fromJson(dataList[index]).isLike
                                        ? Image.asset(
                                            'Assets/Home/inLike.png',
                                            width: 17,
                                            height: 17,
                                          )
                                        : Image.asset(
                                            'Assets/Home/like.png',
                                            width: 17,
                                            height: 17,
                                          ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AboutModel.fromJson(dataList[index])
                                          .like
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: AboutModel.fromJson(
                                                      dataList[index])
                                                  .isLike
                                              ? Color.fromRGBO(255, 183, 0, 1)
                                              : Colors.black,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 70,
                            ),
                          ],
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 13,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 7,
                color: Color.fromRGBO(238, 238, 238, 1),
              ),
            ],
          );
        });
  }
}
