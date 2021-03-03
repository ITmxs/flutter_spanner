import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spanners/cTools/imageChange.dart';
import 'package:spanners/cTools/keyboardLimit.dart';
import 'package:spanners/cTools/regExp.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/talkingOnline/about/imageView.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
/* 选择拍照相册*/
import '../../cTools/photoSelect.dart';

// ignore: must_be_immutable
class CarComment extends StatefulWidget {
  final Map dataMap;
  List _imagesList = List();
  final ValueChanged<Map> onChanged;

  CarComment({Key key, this.onChanged, this.dataMap}) : super(key: key);
  @override
  _CarCommentState createState() => _CarCommentState();
}

class _CarCommentState extends State<CarComment> {
  Map upMap = Map();
  var _imagePath;
  int _imageValue = 1;
  List title = ['行驶里程(Km)', '送修人姓名', '油表数', '接车员姓名'];

  /* 九张图 与 add 图 逻辑 */
  int _returnInt(List imagelist) {
    return imagelist.length == 0 ? 1 : imagelist.length + 1;
  }

  /* 图片点击放大 逻辑 */
  int _returnChangeInt(int returnInt, int index) {
    return index == returnInt - 1 ? 0 : 1;
  }

  @override
  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _imagePath = image;
      widget._imagesList.add(_imagePath);
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = image;
      _imagePath == null ? _imageValue = _imageValue : _imageValue++;
      widget._imagesList.add(_imagePath);
      print('图片$_imagePath');
    });
  }

  var _namecontroller = TextEditingController();
  var _roadHaulcontroller = TextEditingController();
  var _sendUsercontroller = TextEditingController();
  var _oilMeterscontroller = TextEditingController();
  var _remarkcontroller = TextEditingController();
  FocusNode remarkTextFieldNode = FocusNode();
  FocusNode sendUserTextFieldNode = FocusNode();
  FocusNode oilMetersTextFieldNode = FocusNode();
  FocusNode roadHaulTextFieldNode = FocusNode();
  @override
  void initState() {
    super.initState();
    var mapstr = SynchronizePreferences.Get('userInfo');
    Map<String, dynamic> dataMap = convert.jsonDecode(mapstr);
    _namecontroller.text = dataMap['realName'];
    upMap['requestUser'] = dataMap['realName'];
    //做本地保存处理 listview 重用机制暂未找到更好的 方法，待 未来有更好的方法 与之替换
    var upMapStr = SynchronizePreferences.Get('CommentUpmap');
    if (upMapStr != null) {
      Map<String, dynamic> map = convert.jsonDecode(upMapStr);

      upMap['roadHaulString'] = map['roadHaulString'];
      _roadHaulcontroller.text = map['roadHaulString'];
      upMap['sendUser'] = map['sendUser'];
      _sendUsercontroller.text = map['sendUser'];
      upMap['oilMeters'] = map['oilMeters'];
      _oilMeterscontroller.text = map['oilMeters'];
      _remarkcontroller.text = map['remark'];
      upMap['remark'] = map['remark'];
      if (map.containsKey('imageList')) {
        widget._imagesList.clear();
        widget._imagesList.addAll(map['imageList']);
        _imageValue =
            widget._imagesList.length == 0 ? 1 : widget._imagesList.length + 1;
      }
    }
    //焦点监听
    roadHaulTextFieldNode.addListener(() {
      if (!roadHaulTextFieldNode.hasFocus) {
        setState(() {
          print('失去焦点-->${_roadHaulcontroller.text}');
          if (_roadHaulcontroller.text != '') {
            if (RegExpQs.isNum(_roadHaulcontroller.text)) {
              upMap['roadHaulString'] = _roadHaulcontroller.text;
              SharedManager.saveString(json.encode(upMap), 'CommentUpmap');
            } else {
              _roadHaulcontroller.text = '';
              Alart.showAlartDialog('请输入数字类型', 1);
            }
          }
        });
      } else {
        print('得到焦点');
      }
    });
  }

  Widget build(BuildContext context) {
    //赋值
    if (widget.dataMap.length > 0) {
      print('指向这里${widget.dataMap}');
      var upMapStr = SynchronizePreferences.Get('CommentUpmap');
      if (upMapStr != null) {
        Map<String, dynamic> map = convert.jsonDecode(upMapStr);
        upMap['roadHaulString'] = map['roadHaulString'];
        _roadHaulcontroller.text = map['roadHaulString'];
        upMap['sendUser'] = map['sendUser'];
        _sendUsercontroller.text = map['sendUser'];
        upMap['oilMeters'] = map['oilMeters'];
        _oilMeterscontroller.text = map['oilMeters'];
        _remarkcontroller.text = map['remark'];
        upMap['remark'] = map['remark'];
        if (map.containsKey('imageList')) {
          widget._imagesList.clear();
          widget._imagesList.addAll(map['imageList']);
          _imageValue = widget._imagesList.length == 0
              ? 1
              : widget._imagesList.length + 1;
        }
      } else {
        _roadHaulcontroller.text = widget.dataMap['roadHaulString'] == null
            ? ''
            : widget.dataMap['roadHaulString'] > 0
                ? widget.dataMap['roadHaulString'].toString()
                : '';
        _sendUsercontroller.text = widget.dataMap['sendUser'] == null
            ? ''
            : widget.dataMap['sendUser'].toString();
        _oilMeterscontroller.text = widget.dataMap['oilMeters'] == null
            ? ''
            : widget.dataMap['oilMeters'].toString();
        _remarkcontroller.text = widget.dataMap['remark'] == null
            ? ''
            : widget.dataMap['remark'].toString();

        upMap['roadHaulString'] = widget.dataMap['roadHaulString'] == null
            ? ''
            : widget.dataMap['roadHaulString'].toString();

        upMap['sendUser'] = widget.dataMap['sendUser'] == null
            ? ''
            : widget.dataMap['sendUser'].toString();

        upMap['oilMeters'] = widget.dataMap['oilMeters'] == null
            ? ''
            : widget.dataMap['oilMeters'].toString();
        upMap['remark'] = widget.dataMap['remark'] == null
            ? ''
            : widget.dataMap['remark'].toString();
        widget._imagesList = widget.dataMap['imageList'];
        upMap['imageList'] = widget.dataMap['imageList'];
        _imageValue =
            widget._imagesList.length == 0 ? 1 : widget._imagesList.length + 1;
      }

      var mapstr = SynchronizePreferences.Get('userInfo');
      Map<String, dynamic> dataMap = convert.jsonDecode(mapstr);

      _namecontroller.text = dataMap['realName'];
      upMap['requestUser'] = dataMap['realName'];
      widget.onChanged(upMap);
    }
    // else {
    //   widget._imagesList = upMap['imageList'];
    // }
    //构造
    return GestureDetector(
        onTap: () {
          //点击空白处隐藏键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 14,
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: List.generate(
                                title.length,
                                (index) => InkWell(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '  ${title[index]}',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        30, 30, 30, 1),
                                                    fontSize: 15),
                                              ),
                                              Expanded(
                                                  child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxHeight: 20,
                                                      maxWidth: 100),
                                                  child: TextFormField(
                                                    inputFormatters:
                                                        title[index] ==
                                                                '行驶里程(Km)'
                                                            ? [KeyboardLimit(1)]
                                                            : null,
                                                    keyboardType: title[
                                                                    index] ==
                                                                '行驶里程(Km)' ||
                                                            title[index] ==
                                                                '油表数'
                                                        ? TextInputType
                                                            .numberWithOptions(
                                                                decimal: true)
                                                        : null,
                                                    focusNode: title[index] ==
                                                            '行驶里程(Km)'
                                                        ? roadHaulTextFieldNode
                                                        : title[index] ==
                                                                '送修人姓名'
                                                            ? sendUserTextFieldNode
                                                            : title[index] ==
                                                                    '油表数'
                                                                ? oilMetersTextFieldNode
                                                                : null,
                                                    controller: title[index] ==
                                                            '接车员姓名'
                                                        ? _namecontroller
                                                        : title[index] ==
                                                                '行驶里程(Km)'
                                                            ? _roadHaulcontroller
                                                            : title[index] ==
                                                                    '送修人姓名'
                                                                ? _sendUsercontroller
                                                                : title[index] ==
                                                                        '油表数'
                                                                    ? _oilMeterscontroller
                                                                    : null,
                                                    enabled:
                                                        title[index] == '接车员姓名'
                                                            ? false
                                                            : true,
                                                    onChanged: (value) {
                                                      switch (title[index]) {
                                                        case '行驶里程(Km)':
                                                          // upMap['roadHaulString'] =
                                                          //     value;
                                                          break;
                                                        case '送修人姓名':
                                                          upMap['sendUser'] =
                                                              value;
                                                          break;
                                                        case '油表数':
                                                          upMap['oilMeters'] =
                                                              value;
                                                          break;
                                                        case '接车员姓名':
                                                          upMap['requestUser'] =
                                                              value;
                                                          break;
                                                        default:
                                                      }
                                                      widget.onChanged(upMap);
                                                      //做本地保存处理 listview 重用机制暂未找到更好的 方法，待 未来有更好的方法 与之替换
                                                      SharedManager.saveString(
                                                          json.encode(upMap),
                                                          'CommentUpmap');
                                                    },
                                                    //controller: nameControll,
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 0,
                                                              horizontal: 0),
                                                      hintText: '请输入',
                                                      hintStyle: TextStyle(
                                                          color: Color.fromRGBO(
                                                              164, 164, 164, 1),
                                                          fontSize: 14),
                                                      border:
                                                          new OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                    ),
                                                    onEditingComplete: () {
                                                      if (title[index] ==
                                                          '行驶里程(Km)') if (_roadHaulcontroller
                                                              .text !=
                                                          '') if (RegExpQs.isNum(_roadHaulcontroller.text)) {
                                                        upMap['roadHaulString'] =
                                                            _roadHaulcontroller
                                                                .text;
                                                        widget.onChanged(upMap);
                                                        //做本地保存处理 listview 重用机制暂未找到更好的 方法，待 未来有更好的方法 与之替换
                                                        SharedManager
                                                            .saveString(
                                                                json.encode(
                                                                    upMap),
                                                                'CommentUpmap');
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                sendUserTextFieldNode);
                                                      } else {
                                                        _roadHaulcontroller
                                                            .text = '';
                                                        // _showAlartDialog(
                                                        //     '请输入数字类型');
                                                        upMap['roadHaulString'] =
                                                            '';
                                                        widget.onChanged(upMap);
                                                        //做本地保存处理 listview 重用机制暂未找到更好的 方法，待 未来有更好的方法 与之替换
                                                        SharedManager
                                                            .saveString(
                                                                json.encode(
                                                                    upMap),
                                                                'CommentUpmap');
                                                      }
                                                      else
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                sendUserTextFieldNode);

                                                      if (title[index] ==
                                                          '送修人姓名')
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                oilMetersTextFieldNode);
                                                      if (title[index] == '油表数')
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                remarkTextFieldNode);
                                                    },
                                                    // keyboardType: TextInputType.multiline,
                                                  ),
                                                ),
                                              )),
                                              SizedBox(
                                                width: 30,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 1,
                                            color: Color.fromRGBO(
                                                229, 229, 229, 1),
                                          ),
                                        ],
                                      ),
                                    ))),
                      ],
                    )),
                SizedBox(
                  width: 14,
                ),
              ],
            ),
            //备注
            Column(children: [
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '备注',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
                        color: Colors.white),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: 200, maxWidth: 300),
                      child: TextFormField(
                        maxLines: 6,
                        focusNode: remarkTextFieldNode,
                        controller: _remarkcontroller,
                        onChanged: (value) {
                          /*  发布 文字 数量 限制  */
                          if (value.length > 500) {
                            Alart.showAlartDialog('超出字数限制', 1);
                          } else {
                            upMap['remark'] = value;
                            widget.onChanged(upMap);
                            //做本地保存处理 listview 重用机制暂未找到更好的 方法，待 未来有更好的方法 与之替换
                            SharedManager.saveString(
                                json.encode(upMap), 'CommentUpmap');
                          }
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
            ]),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '添加照片',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            //iamge add part
            widget._imagesList == null
                ? Container()
                : Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: new NeverScrollableScrollPhysics(), //禁止滑动
                            itemCount: _returnInt(widget._imagesList) > 6
                                ? 6
                                : _returnInt(widget._imagesList), //做多6个
                            //_imageValue > 6 ? 6 : _imageValue, //做多6个
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
                                  //_takePhoto();
                                  setState(() {
                                    _returnChangeInt(
                                                _returnInt(widget._imagesList),
                                                index) ==
                                            0
                                        ? showModalBottomSheet(
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
                                                    imageNumber: 6,
                                                    type: 1,
                                                    imageList: widget
                                                                ._imagesList
                                                                .length ==
                                                            0
                                                        ? null
                                                        : widget._imagesList,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        // //widget._imagesList.clear();
                                                        // for (var i = 0;
                                                        //     i < value.length;
                                                        //     i++) {
                                                        //   widget._imagesList
                                                        //       .add(value[i]);
                                                        //   _imageValue = widget
                                                        //               ._imagesList
                                                        //               .length ==
                                                        //           0
                                                        //       ? 1
                                                        //       : widget._imagesList
                                                        //               .length +
                                                        //           1;
                                                        // }

                                                        // widget._imagesList
                                                        //     .clear();
                                                        widget._imagesList
                                                            .addAll(value);
                                                        upMap['imageList'] =
                                                            widget._imagesList;

                                                        widget.onChanged(upMap);

                                                        //做本地保存处理 listview 重用机制暂未找到更好的 方法，待 未来有更好的方法 与之替换
                                                        SharedManager
                                                            .saveString(
                                                                json.encode(
                                                                    upMap),
                                                                'CommentUpmap');
                                                        print(
                                                            '成功上传的图片地址：${widget._imagesList}');
                                                      });
                                                    },
                                                  ));
                                            })
                                        : Navigator.of(context)
                                            .push(new FadeRoute(
                                                page: PhotoViewSimpleScreen(
                                            imageProvider: NetworkImage(
                                              widget._imagesList[index],
                                            ),
                                            heroTag: 'simple',
                                          )));
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3 -
                                      50 / 3,
                                  height:
                                      MediaQuery.of(context).size.width / 3 -
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
                                                          BoxConstraints
                                                              .expand(),
                                                      child: Image.network(
                                                        widget
                                                            ._imagesList[index],
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
                                                          var upMapStr =
                                                              SynchronizePreferences
                                                                  .Get(
                                                                      'CommentUpmap');
                                                          if (upMapStr !=
                                                              null) {
                                                            Map<String, dynamic>
                                                                map = convert
                                                                    .jsonDecode(
                                                                        upMapStr);
                                                            map['imageList'] =
                                                                widget
                                                                    ._imagesList;
                                                            //做本地保存处理 listview 重用机制暂未找到更好的 方法，待 未来有更好的方法 与之替换
                                                            SharedManager
                                                                .saveString(
                                                                    json.encode(
                                                                        upMap),
                                                                    'CommentUpmap');
                                                          }
                                                          upMap['imageList'] =
                                                              widget
                                                                  ._imagesList;

                                                          widget
                                                              .onChanged(upMap);
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
        ));
  }
}
