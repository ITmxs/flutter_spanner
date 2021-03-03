import 'package:flutter/material.dart';
import 'package:spanners/cModel/recCarModel.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/imageChange.dart';
import 'package:spanners/cTools/photoSelect.dart';
import 'package:spanners/cTools/regExp.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/appointment/appointmentRequestApi.dart';
import 'package:spanners/spannerHome/newOrder/carARquestApi.dart';
import 'package:spanners/spannerHome/newOrder/carName.dart';
import 'package:spanners/talkingOnline/about/imageView.dart';

class CheckWrite extends StatefulWidget {
  final String id;
  final String checkStandard;
  final String inspectionItem;
  final List _imagesList = List();
  final ValueChanged<Map> onChanged;
  final Map writeMap;

  CheckWrite(
      {Key key,
      this.onChanged,
      this.id,
      this.checkStandard,
      this.inspectionItem,
      this.writeMap})
      : super(key: key);
  @override
  _CheckWriteState createState() => _CheckWriteState();
}

class _CheckWriteState extends State<CheckWrite> {
  int _imageValue = 1;
  Map upMap = Map();
  int type;
  int item = 1;
  List projectList = List(); //一级项目集
  List titleList = List(); //一级项目名称集
  List dataList = List(); //模糊查询结果
  Map firstName = Map(); //一级服务
  Map secondName = Map(); //二级服务
  int itemIndex = 0; //模糊搜索list
  String serviceId = ''; //一级服务Id
  List<TextEditingController> textEditingControllerList = List();
  List<TextEditingController> controllers = List();

  var _namecontroller = TextEditingController();
  static Future _showAlartDialog(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowAlart(
          backLart: 1,
          title: message,
        );
      },
    );
  }

  /*  获取一二级分类 */
  _getTypeList() {
    ApiDio.getserviceDictList(
        pragm: '',
        onSuccess: (data) {
          projectList = data;
          var count = projectList.length;
          print('projectList--->$projectList');
          for (var i = 0; i < count; i++) {
            titleList.add(projectList[i]['dictName']);
          }
          print('projectList--->$titleList');
        },
        onError: (value) {
          _showAlartDialogs('');
        });
  }

  Future _showAlartDialogs(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ServiceLoad(
          onChanged: (value) {
            _getTypeList();
          },
        );
      },
    );
  }

  /* 本地模糊搜索 */
  _searchSecondaryList(String secText) {
    setState(() {
      dataList.clear();
    });

    for (var i = 0; i < projectList.length; i++) {
      if (projectList[i]['id'] == serviceId) {
        for (var j = 0; j < projectList[i]['secondaryList'].length; j++) {
          if (projectList[i]['secondaryList'][j]['secondaryDictName']
              .contains(secText)) {
            dataList.add(projectList[i]['secondaryList'][j]);
          }
        }
      }
    }
    print('模糊搜索结果');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firstName['0'] = '请选择';
    secondName['0'] = '';
    List list = List();
    Map map = Map();
    map['serviceId'] = ''; //一级分类 id
    map['serviceName'] = ''; //一级分类 id
    list.add(map);
    if (widget.writeMap == null) {
      upMap['type'] = 0;
      upMap['checkStandard'] = widget.checkStandard;
      upMap['inspectionItem'] = widget.inspectionItem;
      upMap['detailList'] = list;
    } else {
      type = widget.writeMap['type'];
      upMap['type'] = type;
      _namecontroller.text = widget.writeMap['remark'];
      if (widget.writeMap.containsKey('imgList')) {
        if (widget.writeMap['imgList'].length > 0) {
          _imageValue = widget.writeMap['imgList'].length + 1;
          widget._imagesList.addAll(widget.writeMap['imgList']);
        }
      }
      if (widget.writeMap['detailList'].length == 0) {
        upMap = widget.writeMap;
        upMap['detailList'] = list;
      } else {
        upMap = widget.writeMap;
      }
    }

    _getTypeList();
    print(widget.writeMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text('检查说明',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: GestureDetector(
            onTap: () {
              //点击空白处隐藏键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            behavior: HitTestBehavior.translucent,
            child: ScrollConfiguration(
              behavior: NeverScrollBehavior(),
              child: ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '请选择',
                        style: TextStyle(
                            color: Color.fromRGBO(10, 10, 10, 1), fontSize: 15),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            type = 1;
                            upMap['type'] = 1;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(
                                  255, 77, 76, type == 1 ? 1 : 0.6)),
                          child: Text(
                            '必须',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            type = 2;
                            upMap['type'] = 0;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(
                                  255, 183, 0, type == 1 ? 0.6 : 1)),
                          child: Text(
                            '建议',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 13,
                      ),
                      Container(
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Color.fromRGBO(238, 238, 238, 1),
                                width: 1.0),
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: 120,
                                maxWidth:
                                    MediaQuery.of(context).size.width - 30),
                            child: TextFormField(
                              controller: _namecontroller,
                              onChanged: (value) {
                                upMap['remark'] = value;
                              },
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                                hintText: '请输入本项目问题...',
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(164, 164, 164, 1),
                                    fontSize: 13),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                              // keyboardType: TextInputType.multiline,
                            ),
                          )),
                      SizedBox(
                        width: 13,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '项目种类',
                          style: TextStyle(
                              color: Color.fromRGBO(52, 52, 52, 1),
                              fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 85,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '项目名称',
                          style: TextStyle(
                              color: Color.fromRGBO(52, 52, 52, 1),
                              fontSize: 15),
                        ),
                      )
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
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                              upMap['detailList'].length, //  item,
                              (index) => Column(
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              showModalBottomSheet(
                                                isDismissible: true,
                                                enableDrag: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    height: 300.0,
                                                    child: ShowBottomSheet(
                                                      type: 1,
                                                      dataList: titleList,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          print('项目种类$value');
                                                          firstName[index
                                                                  .toString()] =
                                                              value;
                                                          if (value == null) {
                                                          } else {
                                                            for (var i = 0;
                                                                i <
                                                                    projectList
                                                                        .length;
                                                                i++) {
                                                              if (projectList[i]
                                                                      [
                                                                      'dictName'] ==
                                                                  value) {
                                                                print(
                                                                    '指向这里${projectList[i]['dictName']}');
                                                                //添加一级服务名称 id
                                                                List list =
                                                                    List();
                                                                Map map = Map();

                                                                map['serviceId'] =
                                                                    projectList[
                                                                            i][
                                                                        'id']; //一级分类 id
                                                                serviceId =
                                                                    projectList[
                                                                            i]
                                                                        ['id'];
                                                                map['serviceName'] =
                                                                    projectList[
                                                                            i][
                                                                        'dictName']; //一级分类 id
                                                                list.add(map);
                                                                if (upMap
                                                                    .containsKey(
                                                                        'detailList')) {
                                                                  upMap['detailList']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'checkStandard'] =
                                                                      widget
                                                                          .checkStandard;
                                                                  upMap['detailList']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'inspectionItem'] =
                                                                      widget
                                                                          .inspectionItem;
                                                                  upMap['detailList']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'serviceId'] = projectList[
                                                                          i][
                                                                      'id']; //一级分类 id
                                                                  upMap['detailList']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'serviceName'] = projectList[
                                                                          i][
                                                                      'dictName']; // //一级分类 id
                                                                } else {
                                                                  upMap['detailList'] =
                                                                      list;
                                                                }
//                                                         upMap.containsKey(
//                                                                 'detailList')
//                                                             ? upMap['detailList'][index][''] =
//                                                                 .add(list)
//                                                             : upMap['detailList'] =
//                                                                 list;
                                                              }
                                                            }
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  40 / 2 -
                                                  30 / 2,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color.fromRGBO(
                                                      39, 153, 93, 0.1)),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      upMap['detailList'][index]
                                                                  [
                                                                  'serviceName'] ==
                                                              ''
                                                          ? '请选择'
                                                          : upMap['detailList']
                                                                  [index]
                                                              ['serviceName'],
                                                      // firstName[index.toString()]
                                                      //     .toString(),
                                                      style: TextStyle(
                                                          color: upMap['detailList']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'serviceName'] ==
                                                                  ''
                                                              ? Color.fromRGBO(
                                                                  149,
                                                                  149,
                                                                  149,
                                                                  1)
                                                              : Color.fromRGBO(
                                                                  10,
                                                                  10,
                                                                  10,
                                                                  1),
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Color.fromRGBO(
                                                          149, 149, 149, 1)),
                                                  SizedBox(
                                                    width: 5,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        238, 238, 238, 1),
                                                    width: 1.0),
                                              ),
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxHeight: 30,
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            40 / 2 -
                                                            30 / 2 -
                                                            2),
                                                child: TextFormField(
                                                  /* 暂时没想到更好的办法先这么实现，将来替换*/
                                                  // controller:
                                                  //     controllers[index],
                                                  controller: TextEditingController.fromValue(
                                                      TextEditingValue(
                                                          text:
                                                              /* 默认值逻辑*/
                                                              upMap['detailList'][index]['secondaryService'] ==
                                                                      null
                                                                  ? ''
                                                                  : upMap['detailList']
                                                                          [index][
                                                                      'secondaryService'],
                                                          selection: TextSelection.fromPosition(TextPosition(
                                                              affinity:
                                                                  TextAffinity
                                                                      .downstream,
                                                              offset: upMap['detailList'][index]['secondaryService'] ==
                                                                      null
                                                                  ? 0
                                                                  : upMap['detailList'][index]
                                                                          ['secondaryService']
                                                                      .length)))),
                                                  onChanged: (value) {
                                                    itemIndex = index;

                                                    if (serviceId == '') {
                                                      Alart.showAlartDialog(
                                                          '请先选择项目种类', 1);
                                                    } else {
                                                      if (RegExpQs.isChinese(
                                                          value)) {
                                                      } else {
                                                        // 模糊 查询
                                                        _searchSecondaryList(
                                                            value);
                                                      }
                                                    }

                                                    secondName[index
                                                        .toString()] = value;
                                                    /*  传来的 二级项目名 ID*/
                                                    upMap['detailList'][index][
                                                            'secondaryService'] =
                                                        value;
                                                    upMap['detailList'][index]
                                                        ['secondaryId'] = '';
                                                  },

                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: secondName[index
                                                                  .toString()] ==
                                                              '请输入'
                                                          ? Color.fromRGBO(
                                                              164, 164, 164, 1)
                                                          : Colors.black),
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
                                                        fontSize: 13),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),
                                                  ),
                                                  // keyboardType: TextInputType.multiline,
                                                ),
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                item--;
                                                if (item == 1) {
                                                  item = 1;
                                                } else {
                                                  upMap['detailList']
                                                      .removeAt(index);
                                                }
                                              });
                                            },
                                            child: Image.asset(
                                              'Assets/check/checkdelete.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                          )
                                        ],
                                      ),

                                      /*
                                展示 模糊搜索 结果
                               */
                                      itemIndex == index
                                          ? CarNameList(
                                              type: 2,
                                              dataList: dataList,
                                              onChanged: (value) {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());

                                                  secondName[index.toString()] =
                                                      RecCarModel.fromJson(
                                                              value)
                                                          .dictName
                                                          .toString();
                                                  /*  传来的 二级项目名 ID*/
                                                  upMap['detailList'][index]
                                                          ['secondaryService'] =
                                                      RecCarModel.fromJson(
                                                              value)
                                                          .dictName
                                                          .toString();
                                                  upMap['detailList'][index]
                                                          ['secondaryId'] =
                                                      RecCarModel.fromJson(
                                                              value)
                                                          .id
                                                          .toString();

                                                  dataList.clear();
                                                });
                                              },
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  )),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      )
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
                      InkWell(
                        onTap: () {
                          setState(() {
                            for (var i = 0;
                                i < upMap['detailList'].length;
                                i++) {
                              if (upMap['detailList'][i]['secondaryId'] == '' ||
                                  upMap['detailList'][i]['serviceId'] == '' ||
                                  !upMap['detailList'][i]
                                      .containsKey('secondaryId')) {
                                Alart.showAlartDialog('请先填选项目', 1);
                                return;
                              }
                            }

                            item++;
                            firstName[(item - 1).toString()] = '请选择';
                            secondName[(item - 1).toString()] = '';

                            List list = List();
                            Map map = Map();
                            map['serviceId'] = ''; //一级分类 id
                            map['serviceName'] = ''; //一级分类 id

                            list.add(map);
                            upMap['checkStandard'] = widget.checkStandard;
                            upMap['inspectionItem'] = widget.inspectionItem;
                            if (upMap.containsKey('detailList')) {
                              // upMap['detailList'][item - 1]['serviceId'] = ''; //一级分类 id
                              // upMap['detailList'][item - 1]['serviceName'] =
                              //     ''; // //一级分类 id
                              upMap['detailList'].add(map);
                            } else {
                              upMap['detailList'] = list;
                            }
                          });
                        },
                        child: Text(
                          '添加',
                          style: TextStyle(
                              color: Color.fromRGBO(39, 153, 93, 1),
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '检车图片',
                          style: TextStyle(
                              color: Color.fromRGBO(10, 10, 10, 1),
                              fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '可上传4张',
                          style: TextStyle(
                              color: Color.fromRGBO(157, 157, 157, 1),
                              fontSize: 13),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

//拍照区域
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: new NeverScrollableScrollPhysics(), //禁止滑动
                            itemCount: _imageValue > 4 ? 4 : _imageValue, //做多6个
                            //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    //横轴元素个数
                                    crossAxisCount: 4,
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
                                    index + 1 == _imageValue
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
                                                    imageNumber: 4,
                                                    type: 1,
                                                    onChanged: (value) {
                                                      setState(() {
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

                                                        widget._imagesList
                                                            .addAll(value);
                                                        upMap['imgList'] =
                                                            widget._imagesList;
                                                        _imageValue = widget
                                                                    ._imagesList
                                                                    .length ==
                                                                0
                                                            ? 1
                                                            : widget._imagesList
                                                                    .length +
                                                                1;

                                                        print(
                                                            '--->${widget._imagesList.length}');
                                                      });
                                                      print(
                                                          '图片路径：${widget._imagesList}');
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
                                      child: index + 1 == _imageValue
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
                                                              4 -
                                                          50 / 4 -
                                                          20 -
                                                          2,
                                                      2,
                                                      2,
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4 -
                                                          50 / 4 -
                                                          20 -
                                                          2),
                                                  child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          /*  删除 图片操作  */
                                                          widget._imagesList
                                                              .removeAt(index);
                                                          _imageValue = widget
                                                                      ._imagesList
                                                                      .length ==
                                                                  0
                                                              ? 1
                                                              : widget._imagesList
                                                                      .length +
                                                                  1;
                                                          upMap['imageList'] =
                                                              widget
                                                                  ._imagesList;

                                                          // widget.onChanged(upMap);
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
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 46,
                      ),
                      InkWell(
                        onTap: () {
                          print(upMap);
                          if (!upMap.containsKey('type')) {
                            _showAlartDialog('请选择维修优先度');
                            return;
                          }
                          // if (!upMap.containsKey('remark') || upMap['remark'] == '') {
                          //   _showAlartDialog('请填写项目问题');
                          //   return;
                          // }

                          upMap['inspectionId'] = widget.id;

                          for (var i = 0; i < upMap['detailList'].length; i++) {
                            if (upMap['detailList'][i]['serviceName']
                                    .toString() ==
                                '') {
                              upMap['detailList'].removeAt(i);
                            }
                          }
                          if (upMap['detailList'].length == 0) {
                            _showAlartDialog('请选择项目');
                            return;
                          }
                          widget.onChanged(upMap);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 75,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromRGBO(39, 153, 93, 1),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '保存',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 23,
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
