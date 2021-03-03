import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spanners/cModel/aboutModel.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import './imageView.dart';
import './vedioView.dart';
import './aaboutRequestApi.dart';

class AboutDetail extends StatefulWidget {
  final dataList;
  List<Map> floatList = List(); // 没有 回复合集
  List<Map> doubleList = List(); // 有 回复 合集
  Map<String, List> dataMap = Map(); // 有 回复 Map 集合
  AboutDetail({Key key, this.dataList}) : super(key: key); //top  信息
  @override
  _AboutDetailState createState() => _AboutDetailState();
}

class _AboutDetailState extends State<AboutDetail> {
  ScrollController scrollController = ScrollController();
  bool getBool = false;
  Timer _timer;
  List listData;
  String girlName = ''; //回复对象
  String girlId = ''; //回复对象id
  String parentid = ''; //回复 对象内容id
  String comment = ''; // 回复-评论 内容
  TextEditingController _controller = TextEditingController();

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

  /*
下拉刷新
*/
  Future _toRefresh() async {
    listData.clear();
    widget.floatList.clear();
    widget.doubleList.clear();
    widget.dataMap.clear();
    _getDataList();
    return null;
  }

/*
获取 评论数据
*/
  _getDataList() {
    AboutDio.aboutRequest(
      param: {'id': widget.dataList['id'].toString()},
      onSuccess: (data) {
        setState(() {
          listData = data['comment'];
          widget.floatList.clear();
          widget.doubleList.clear();
          widget.dataMap.clear();
          // 外层数据 list 存储
          for (var i = 0; i < listData.length; i++) {
            if (listData[i]['repeatUser'].toString() == 'null') {
              //对动态的 总 评论 集合
              widget.floatList.add(listData[i]);
              print('没有 回复的 评论 集合-->${widget.floatList}');
            } else {
              //有 回复的 评论 集合
              widget.doubleList.add(listData[i]);
              print('有 回复的 评论 集合-->${widget.doubleList}');
            }
          }

          /// 有 回复的 评论 集合 根据 repeatid 分开 组list 合集
          /// 内层 Map 存储
          for (var i = 0; i < widget.floatList.length; i++) {
            var sendId =
                AboutTalkModel.fromJson(widget.floatList[i]).sendId.toString();
            var comId =
                AboutTalkModel.fromJson(widget.floatList[i]).comid.toString();
            for (var j = 0; j < widget.doubleList.length; j++) {
              var repeatId = AboutTalkModel.fromJson(widget.doubleList[j])
                  .repeatId
                  .toString();
              var parentId = AboutTalkModel.fromJson(widget.doubleList[j])
                  .parentId
                  .toString();

              if (comId == parentId) {
                //将下面的sendId 换成 comId
                if (widget.dataMap.containsKey(comId)) {
                  List commitList = List();
                  commitList = widget.dataMap[comId];
                  commitList.add(widget.doubleList[j]);
                  widget.dataMap[comId] = commitList;
                } else {
                  List commitList = List();
                  commitList.add(widget.doubleList[j]);
                  widget.dataMap[comId] = commitList;
                }
              }
            }
          }
          print('有 回复的 评论 Map-->${widget.dataMap}');
        });
      },
      onError: (error) {},
    );
  }

  /*   发表评论  */
  _postComment() {
    print('文章id${AboutModel.fromJson(widget.dataList).id}');
    comment == ''
        ? Alart.showAlartDialog('内容不能为空', 1)
        : AboutDio.aboutCommentRequest(
            param: girlName == ''
                ? {
                    'articleid': AboutModel.fromJson(widget.dataList).id,
                    'createuser':
                        'c591f0f0f43e463790782a3f1a7ca48f', //userid  当前用户id
                    'comment': comment
                  }
                : {
                    'articleid': AboutModel.fromJson(widget.dataList).id,
                    'parentid': parentid,
                    'createuser':
                        SynchronizePreferences.Get('userid'), //userid  当前用户id
                    'repeatuser': girlId,
                    'comment': comment
                  },
            onSuccess: (data) {
              _getDataList();
            },
            onError: (error) {},
          );
  }

  @override
  void initState() {
    // TODO: implement initState
    _getDataList();
    super.initState();
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
        //backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: true,
          title: new Text(
            '评论',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              iconSize: 20,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: listData == null
            ? Container()
            : GestureDetector(
                onTap: () {
                  setState(() {
                    girlName = '';
                    girlId = '';
                    parentid = '';
                  });

                  //点击空白处隐藏键盘
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                behavior: HitTestBehavior.translucent,
                child: Column(
                  children: [
                    Expanded(
                      child:
                          //主干部分 默认是关注 展示
                          Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: RefreshIndicator(
                          child: ScrollConfiguration(
                            behavior: NeverScrollBehavior(),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                /*头部展示区域*/
                                getBool
                                    ? Container(
                                        child: Column(
                                          children: [
                                            Text(
                                              '刷新成功',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                _isCompary(widget.dataList) == '1'
                                    ? //视频
                                    VedioView(
                                        dataLists: widget.dataList,
                                        onChanged: (value) {
                                          setState(() {
                                            widget.dataList['isWatching']
                                                ? widget.dataList[
                                                    'isWatching'] = false
                                                : widget.dataList[
                                                    'isWatching'] = true;
                                          });
                                        },
                                      )
                                    : //展示
                                    ImageView(
                                        dataLists: widget.dataList,
                                        onChanged: (value) {
                                          setState(() {
                                            widget.dataList['isWatching']
                                                ? widget.dataList[
                                                    'isWatching'] = false
                                                : widget.dataList[
                                                    'isWatching'] = true;
                                          });
                                        },
                                      ),
                                SizedBox(
                                  height: 13,
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
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      //height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              Color.fromRGBO(238, 238, 238, 1)),
                                      child: /* 评论 展示 区域*/
                                          ListView(
                                              shrinkWrap: true,
                                              controller: scrollController,
                                              children: List.generate(
                                                widget.floatList.length,
                                                (index) => InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      /*点击对指定 人员 回复*/
                                                      girlName = AboutTalkModel
                                                              .fromJson(widget
                                                                      .floatList[
                                                                  index])
                                                          .sendUser
                                                          .toString();
                                                      girlId = AboutTalkModel
                                                              .fromJson(widget
                                                                      .floatList[
                                                                  index])
                                                          .sendId
                                                          .toString();
                                                      parentid = AboutTalkModel
                                                              .fromJson(widget
                                                                      .floatList[
                                                                  index])
                                                          .comid
                                                          .toString();
                                                      print(girlName);
                                                    });
                                                  },
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: RichText(
                                                                  text: TextSpan(
                                                                      text: AboutTalkModel.fromJson(widget.floatList[
                                                                              index])
                                                                          .sendUser
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.black),
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                              ': ${AboutTalkModel.fromJson(widget.floatList[index]).comment.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              color: Colors.black),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                              '\n${AboutTalkModel.fromJson(widget.floatList[index]).sendTime.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      ListView(
                                                          shrinkWrap: true,
                                                          controller:
                                                              scrollController,
                                                          children:
                                                              List.generate(
                                                                  widget.dataMap.containsKey(AboutTalkModel.fromJson(widget.floatList[
                                                                              index])
                                                                          .comid
                                                                          .toString())
                                                                      ? widget
                                                                          .dataMap[AboutTalkModel.fromJson(widget.floatList[index])
                                                                              .comid
                                                                              .toString()]
                                                                          .length
                                                                      : 0,
                                                                  (indexs) =>
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              /*点击对指定 人员 回复*/
                                                                              girlName = widget.dataMap[AboutTalkModel.fromJson(widget.floatList[index]).comid.toString()][indexs]['sendUser'];
                                                                              girlId = widget.dataMap[AboutTalkModel.fromJson(widget.floatList[index]).comid.toString()][indexs]['sendId'];
                                                                              parentid = AboutTalkModel.fromJson(widget.floatList[index]).comid.toString();
                                                                              //  widget
                                                                              //     .dataMap[AboutTalkModel.fromJson(
                                                                              //         widget.floatList[index])
                                                                              //     .comid
                                                                              //     .toString()][indexs]['comid'];
                                                                              print(girlName);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Container(
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 15,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Align(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: RichText(
                                                                                          text: TextSpan(text: '${widget.dataMap[AboutTalkModel.fromJson(widget.floatList[index]).comid.toString()][indexs]['sendUser']}', style: TextStyle(fontSize: 11, color: Colors.black), children: [
                                                                                            TextSpan(
                                                                                              text: '回复',
                                                                                              style: TextStyle(fontSize: 11, color: Colors.blue),
                                                                                            ),
                                                                                            TextSpan(
                                                                                              text: '${widget.dataMap[AboutTalkModel.fromJson(widget.floatList[index]).comid.toString()][indexs]['repeatUser']}',
                                                                                              style: TextStyle(fontSize: 11, color: Colors.black),
                                                                                            ),
                                                                                            TextSpan(
                                                                                              text: ': ${widget.dataMap[AboutTalkModel.fromJson(widget.floatList[index]).comid.toString()][indexs]['comment']}',
                                                                                              style: TextStyle(fontSize: 11, color: Colors.black),
                                                                                            ),
                                                                                            TextSpan(
                                                                                              text: '\n${widget.dataMap[AboutTalkModel.fromJson(widget.floatList[index]).comid.toString()][indexs]['sendTime']}',
                                                                                              style: TextStyle(fontSize: 10, color: Colors.black),
                                                                                            ),
                                                                                          ]),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                            ],
                                                                          )))),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                          onRefresh: _toRefresh,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 5,
                      color: Colors.white,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Color.fromRGBO(238, 238, 238, 1),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxHeight: 40, maxWidth: 200),
                              child: TextFormField(
                                controller: _controller,
                                onChanged: (value) {
                                  comment = value;
                                },
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  hintText: girlName == ''
                                      ? '输入评论内容'
                                      : '回复' + girlName + ':',
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
                            )),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                _postComment();
                                _controller.text = '';
                                girlName = '';
                                girlId = '';
                                parentid = '';
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(39, 153, 93, 1)),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '发送',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ))
                  ],
                )));
  }
}
