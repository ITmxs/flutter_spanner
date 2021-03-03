import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spanners/cModel/aboutModel.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/talkingOnline/about/aaboutRequestApi.dart';
import 'package:spanners/talkingOnline/about/aboutDetail.dart';
import 'package:spanners/talkingOnline/about/imageView.dart';
import 'package:spanners/talkingOnline/about/vedioView.dart';

class PersonAbout extends StatefulWidget {
  @override
  _PersonAboutState createState() => _PersonAboutState();
}

class _PersonAboutState extends State<PersonAbout> {
  List dataList = List();
  ScrollController scrollController = ScrollController();
  Map info = {};
  String typeStr; // 点赞 取消点赞
  int page = 1;
  //
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
      },
    );
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

  /*
下拉刷新
*/
  Future _toRefresh() async {
    page = 1;
    _getAboutData();
    return null;
  }

  //获取数据
  _getAboutData() async {
    AboutDio.aboutPersonRequest(
        param: {
          'myFlg': '',
          'type': 2,
          'size': 10,
          'current': page,
          'userId': await SharedManager.getString('userid')
        },
        onSuccess: (data) {
          setState(() {
            page == 1
                ? dataList = data['records']
                : dataList.addAll(data['records']);
          });
        });
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
        //做加载请求
        _getAboutData();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMore();
    info = json.decode(SynchronizePreferences.Get("userInfo"));
    _getAboutData();
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
        backgroundColor: Color.fromRGBO(49, 58, 67, 1),
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            controller: scrollController,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.black, // Color.fromRGBO(49, 58, 67, 1),
                    image: DecorationImage(
                        image: AssetImage('Assets/wecenter/centertopback.png'),
                        fit: BoxFit.fill)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 35,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              image: DecorationImage(
                                  //做网络 本地判断
                                  image: AssetImage(
                                      'Assets/Technology/3.0x/headimage.png'))),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${info["realName"] ?? ""}',
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '我发布的动态',
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              //主干部分 默认是关注 展示
              isNull(dataList) == 0
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: RefreshIndicator(
                        child: ScrollConfiguration(
                            behavior: NeverScrollBehavior(),
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                ShowNullDataAlart(
                                  alartText: '亲，当前数据为空呦~',
                                ),
                              ],
                            )),
                        onRefresh: _toRefresh,
                      ))
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height - 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: RefreshIndicator(
                        child: list(),
                        onRefresh: _toRefresh,
                      ),
                    )
            ],
          ),
        ));
  }

  list() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: dataList.length,
        physics: NeverScrollableScrollPhysics(),
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
                                onChanged: (value) {},
                              )
                            : //展示
                            ImageView(
                                dataLists: dataList[index],
                                onChanged: (value) {},
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
              dataList.length < 3
                  ? SizedBox(
                      height: 500,
                    )
                  : SizedBox(
                      height: 0,
                    ),
            ],
          );
        });
  }
}
