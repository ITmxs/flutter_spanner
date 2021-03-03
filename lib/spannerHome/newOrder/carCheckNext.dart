import 'package:flutter/material.dart';
import 'package:spanners/cTools/imageChange.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/newOrder/carARquestApi.dart';
import 'package:spanners/talkingOnline/about/imageView.dart';

class CheckNext extends StatefulWidget {
  final String vehicleLicence;
  final int numbers;
  final List dataList;
  const CheckNext({Key key, this.dataList, this.numbers, this.vehicleLicence})
      : super(key: key);
  @override
  _CheckNextState createState() => _CheckNextState();
}

class _CheckNextState extends State<CheckNext> {
  //异常项
  int nums;
  List showMustList = List();
  List showMaybeList = List();
  List mustList = List();
  List maybeList = List();
  DateTime now = DateTime.now();
  //上传数据
  _upload() {
    RecCarDio.upCheckItemRequest(
      param: {
        'vehicleLicence': widget.vehicleLicence,
        'vehicleCheck': widget.dataList
      },
      onSuccess: (data) {
        if (data) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('数据:${widget.dataList}');
    for (var i = 0; i < widget.dataList.length; i++) {
      if (widget.dataList[i]['type'] == 1) {
        showMustList.add(widget.dataList[i]);
        if (widget.dataList[i].containsKey('detailList')) {
          mustList.addAll(widget.dataList[i]['detailList']);
        }
      }
      if (widget.dataList[i]['type'] == 0) {
        showMaybeList.add(widget.dataList[i]);
        if (widget.dataList[i].containsKey('detailList')) {
          maybeList.addAll(widget.dataList[i]['detailList']);
        }
      }
    }
    nums = widget.dataList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text('全车检查',
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
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              //维修项目列表
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 17,
                        ),
                        Text(
                          '维修项目列表',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        mustList.length == 0
                            ? Container()
                            : Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '必须维修项目',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        //必须维修项目
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                              mustList.length == 0 ? 0 : mustList.length,
                              (index) => Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
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
                                                    mustList[index]
                                                            ['serviceName']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            52, 52, 52, 1),
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
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
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        39, 153, 93, 0.1),
                                                    width: 1.0),
                                                color: Colors.white),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    mustList[index]
                                                            ['secondaryService']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            52, 52, 52, 1),
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //建议维修项目
                        maybeList.length == 0
                            ? Container()
                            : Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '建议维修项目',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                              maybeList.length == 0 ? 0 : maybeList.length,
                              (indexs) => Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Container(
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
                                                    maybeList[indexs]
                                                            ['serviceName']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            52, 52, 52, 1),
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
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
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        39, 153, 93, 0.1),
                                                    width: 1.0),
                                                color: Colors.white),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    maybeList[indexs]
                                                            ['secondaryService']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            52, 52, 52, 1),
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
//               //车辆检查单 展示
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(child: SizedBox()),
                            Text(
                              '${now.year}/${now.month}/${now.day}',
                              style: TextStyle(
                                  color: Color.fromRGBO(145, 145, 145, 1),
                                  fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          '车辆检查单',
                          style: TextStyle(
                              color: Color.fromRGBO(10, 10, 10, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              '全车检查共包含${widget.numbers}项，正常项目${widget.numbers - nums}项',
                              style: TextStyle(
                                  color: Color.fromRGBO(12, 12, 12, 1),
                                  fontSize: 15),
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
                              width: MediaQuery.of(context).size.width - 60,
                              height: 1,
                              color: Color.fromRGBO(238, 238, 238, 1),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 19,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              '$nums 项异常，具体形况如下',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 77, 76, 1),
                                  fontSize: 15),
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
                              width: MediaQuery.of(context).size.width - 60,
                              height: 1,
                              color: Color.fromRGBO(238, 238, 238, 1),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        //必须维修项目
                        showMustList.length == 0
                            ? Container()
                            : Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '必须维修项目',
                                    style: TextStyle(
                                        color: Color.fromRGBO(12, 12, 12, 1),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 35,
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                              showMustList.length == 0
                                  ? 0
                                  : showMustList.length,
                              (index) => Container(
                                    child: Column(
                                      children: [
                                        //
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                showMustList[index]
                                                        ['inspectionItem']
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            Expanded(
                                                child: Container(
                                              width: 96,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  showMustList[index]
                                                          ['checkStandard']
                                                      .toString(),
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            )),
                                            SizedBox(
                                              width: 20,
                                            ),
//-->   不良    做 添加  操作
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                width: 40,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color.fromRGBO(
                                                          238, 238, 238, 0),
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color.fromRGBO(
                                                      255, 219, 219, 1),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '不良',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 77, 76, 1),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
//-->  不良   做 删除  操作

                                            SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height: 25,
                                        ),
                                        //补充说明
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  16,
                                                  0,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      30 -
                                                      40 -
                                                      16,
                                                  0),
                                              child: showMustList[index]
                                                          ['type'] ==
                                                      0
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 40,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Color.fromRGBO(
                                                              255, 183, 0, 1)),
                                                      child: Text(
                                                        '建议',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                            fontSize: 12),
                                                      ),
                                                    )
                                                  :
                                                  //用户根据不同 展示不同
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 40,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Color.fromRGBO(
                                                              255, 77, 76, 1)),
                                                      child: Text(
                                                        '必须',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  68, 0, 61, 0),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    129 -
                                                    30,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    showMustList[index]
                                                                ['remark'] ==
                                                            null
                                                        ? ''
                                                        : showMustList[index]
                                                            ['remark'],
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            10, 10, 10, 1)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        //照片区域
                                        showMustList[index]['imgList'] == null
                                            ? Container()
                                            : Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Expanded(
                                                    child: GridView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            new NeverScrollableScrollPhysics(), //禁止滑动
                                                        itemCount:
                                                            showMustList[index]
                                                                    ['imgList']
                                                                .length, //
                                                        //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                //横轴元素个数
                                                                crossAxisCount:
                                                                    4,
                                                                //纵轴间距
                                                                mainAxisSpacing:
                                                                    10.0,
                                                                //横轴间距
                                                                crossAxisSpacing:
                                                                    15.0,
                                                                //子组件宽高长度比例
                                                                childAspectRatio:
                                                                    1.0),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          //Widget Function(BuildContext context, int index)
                                                          return InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(FadeRoute(
                                                                        page: PhotoViewSimpleScreen(
                                                                  imageProvider:
                                                                      NetworkImage(showMustList[index]
                                                                              [
                                                                              'imgList']
                                                                          [
                                                                          index]),
                                                                  heroTag:
                                                                      'simple',
                                                                )));
                                                              });
                                                            },
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      3 -
                                                                  50 / 3,
                                                              height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      3 -
                                                                  50 / 3,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  child: Stack(
                                                                    children: [
                                                                      Padding(
                                                                          padding: EdgeInsets.all(
                                                                              0),
                                                                          child:
                                                                              ConstrainedBox(
                                                                            constraints:
                                                                                BoxConstraints.expand(),
                                                                            child:
                                                                                Image.network(
                                                                              showMustList[index]['imgList'][index],
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          )),
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
                                        Container(
                                            height: 1,
                                            color: Color.fromRGBO(
                                                238, 238, 238, 1)),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        //建议维修项目
                        showMaybeList.length == 0
                            ? Container()
                            : Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '建议维修项目',
                                    style: TextStyle(
                                        color: Color.fromRGBO(12, 12, 12, 1),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 35,
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                              showMaybeList.length == 0
                                  ? 0
                                  : showMaybeList.length,
                              (index) => Container(
                                    child: Column(
                                      children: [
                                        //
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                showMaybeList[index]
                                                        ['checkStandard']
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            Expanded(
                                                child: Container(
                                              width: 96,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  showMaybeList[index]
                                                          ['inspectionItem']
                                                      .toString(),
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            )),
                                            SizedBox(
                                              width: 20,
                                            ),
//-->   不良    做 添加  操作
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                width: 40,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color.fromRGBO(
                                                          238, 238, 238, 0),
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color.fromRGBO(
                                                      255, 219, 219, 1),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '不良',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 77, 76, 1),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
//-->  不良   做 删除  操作

                                            SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height: 25,
                                        ),
                                        //补充说明
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  16,
                                                  0,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      30 -
                                                      40 -
                                                      16,
                                                  0),
                                              child: showMaybeList[index]
                                                          ['type'] ==
                                                      0
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 40,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Color.fromRGBO(
                                                              255, 183, 0, 1)),
                                                      child: Text(
                                                        '建议',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                            fontSize: 12),
                                                      ),
                                                    )
                                                  :
                                                  //用户根据不同 展示不同
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 40,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Color.fromRGBO(
                                                              255, 77, 76, 1)),
                                                      child: Text(
                                                        '必须',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  68, 0, 61, 0),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    129 -
                                                    30,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    showMaybeList[index]
                                                                ['remark'] ==
                                                            null
                                                        ? ''
                                                        : showMaybeList[index]
                                                            ['remark'],
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            10, 10, 10, 1)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      75,
                                                  0,
                                                  16,
                                                  0),
                                              child: Image.asset(
                                                '',
                                                width: 19,
                                                height: 19,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        //照片区域
                                        showMaybeList[index]['imgList'] == null
                                            ? Container()
                                            : Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Expanded(
                                                    child: GridView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            new NeverScrollableScrollPhysics(), //禁止滑动
                                                        itemCount:
                                                            showMaybeList[index]
                                                                    ['imgList']
                                                                .length, //
                                                        //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                //横轴元素个数
                                                                crossAxisCount:
                                                                    4,
                                                                //纵轴间距
                                                                mainAxisSpacing:
                                                                    10.0,
                                                                //横轴间距
                                                                crossAxisSpacing:
                                                                    15.0,
                                                                //子组件宽高长度比例
                                                                childAspectRatio:
                                                                    1.0),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int items) {
                                                          //Widget Function(BuildContext context, int index)
                                                          return InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(FadeRoute(
                                                                        page: PhotoViewSimpleScreen(
                                                                  imageProvider:
                                                                      NetworkImage(
                                                                          // widget._imagesList[index],
                                                                          showMaybeList[index]['imgList']
                                                                              [
                                                                              items]),
                                                                  heroTag:
                                                                      'simple',
                                                                )));
                                                              });
                                                            },
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      3 -
                                                                  50 / 3,
                                                              height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      3 -
                                                                  50 / 3,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  child: Stack(
                                                                    children: [
                                                                      Padding(
                                                                          padding: EdgeInsets.all(
                                                                              0),
                                                                          child:
                                                                              ConstrainedBox(
                                                                            constraints:
                                                                                BoxConstraints.expand(),
                                                                            child:
                                                                                Image.network(
                                                                              //widget._imagesList[index],
                                                                              showMaybeList[index]['imgList'][items],
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          )),
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
                                        Container(
                                            height: 1,
                                            color: Color.fromRGBO(
                                                238, 238, 238, 1)),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 1,
                        ),
                        InkWell(
                          onTap: () {
                            _upload();
                          },
                          child: Container(
                            width: 135,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(39, 153, 93, 1),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '保存并发送给车主',
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
