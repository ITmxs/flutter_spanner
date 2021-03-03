import 'package:flutter/material.dart';
import 'package:spanners/cModel/recCarModel.dart';
import 'package:spanners/cTools/imageChange.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/newOrder/carARquestApi.dart';
import 'package:spanners/spannerHome/newOrder/carCheckAllHistory.dart';
import 'package:spanners/spannerHome/newOrder/carCheckAllWrite.dart';
import 'package:spanners/spannerHome/newOrder/carCheckNext.dart';
import 'package:spanners/talkingOnline/about/imageView.dart';

class AllCheck extends StatefulWidget {
  final String vehicleLicence;

  const AllCheck({Key key, this.vehicleLicence}) : super(key: key);
  @override
  _AllCheckState createState() => _AllCheckState();
}

class _AllCheckState extends State<AllCheck> {
  int selectIndex = 0;
  Map selectMap = Map(); //选中
  //检查项
  List firstCheckList = List();
  List secondCheckList = List();
  //补充检查说明
  List checkList = List();
  Map checkMap = Map();
  //全部项
  int allNumber = 0;
  //获取 检查项
  _getCheckItem() {
    RecCarDio.getCheckItemRequest(
      onSuccess: (data) {
        setState(() {
          selectMap.clear();
          checkList.clear();
          firstCheckList = data;
          secondCheckList = data[0]['secondCheckList'];
          for (var i = 0; i < firstCheckList.length; i++) {
            allNumber = allNumber + firstCheckList[i]['secondCheckList'].length;
          }
        });
      },
    );
  }

  //计算全部项
  _getNumber() {}
  //
  int getItem(String id) {
    int item = 0;
    for (var i = 0; i < checkList.length; i++) {
      checkMap = checkList[i];
      if (checkMap['inspectionId'] == id) {
        item = 1;
        break;
      } else {
        item = 0;
      }
    }
    return item == 0 ? 0 : 1;
  }

  //
  Map _getmap(String id) {
    int item = 0;
    for (var i = 0; i < checkList.length; i++) {
      checkMap = checkList[i];

      if (checkMap['inspectionId'] == id) {
        item = 1;
        break;
      } else {
        item = 0;
      }
    }
    return item == 0 ? Map() : checkMap;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCheckItem();
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
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckHistory(
                            vehicleLicence: widget.vehicleLicence,
                          )));
            },
            child: Image.asset(
              'Assets/check/checkhistory.png',
              width: 26,
              height: 26,
            ),
          ),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      body: Column(
        children: [
          //汽车全检 大项分类
          Container(
              height: 55,
              color: Color.fromRGBO(255, 255, 255, 1),
              child: ScrollConfiguration(
                  behavior: NeverScrollBehavior(),
                  child: ScrollConfiguration(
                    behavior: NeverScrollBehavior(),
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            firstCheckList.length,
                            (index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    selectIndex = index;
                                    secondCheckList = firstCheckList[index]
                                        ['secondCheckList'];
                                  });
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 18,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              FirstCheckModel.fromJson(
                                                      firstCheckList[index])
                                                  .category,
                                              style: selectIndex == index
                                                  ? TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      selectIndex == index
                                          ? Container(
                                              width: 63,
                                              height: 3,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: Color.fromRGBO(
                                                      39, 153, 93, 1)),
                                            )
                                          : Container()
                                    ],
                                  ),
                                )))),
                  ))),
          SizedBox(
            height: 6,
          ),
          //汽车全检 大项中对应小项
          Expanded(
              child: ScrollConfiguration(
            behavior: NeverScrollBehavior(),
            child: ListView(children: [
              ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(
                      secondCheckList.length,
                      (index) => InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                  child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          width: 60,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              SecondCheckModel.fromJson(
                                                      secondCheckList[index])
                                                  .inspectionItem,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
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
                                              SecondCheckModel.fromJson(
                                                      secondCheckList[index])
                                                  .checkStandard,
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
                                          onTap: () {
                                            setState(() {
                                              if (selectMap.containsKey(
                                                  selectIndex.toString())) {
                                                if (selectMap[
                                                        selectIndex.toString()]
                                                    .contains(index)) {
                                                } else {
                                                  //做 添加  操作
                                                  selectMap[selectIndex
                                                          .toString()]
                                                      .add(index);
                                                }
                                              } else {
                                                //做 添加  操作
                                                selectMap[selectIndex
                                                    .toString()] = [index];
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromRGBO(
                                                      238,
                                                      238,
                                                      238,
                                                      selectMap.containsKey(
                                                              selectIndex
                                                                  .toString())
                                                          ? selectMap[selectIndex
                                                                      .toString()]
                                                                  .contains(
                                                                      index)
                                                              ? 0
                                                              : 1
                                                          : 1),
                                                  width: 1.0),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5)),
                                              color: selectMap.containsKey(
                                                      selectIndex.toString())
                                                  ? selectMap[selectIndex
                                                              .toString()]
                                                          .contains(index)
                                                      ? Color.fromRGBO(
                                                          255, 219, 219, 1)
                                                      : Colors.white
                                                  : Colors.white,
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '不良',
                                                style: TextStyle(
                                                  color: selectMap.containsKey(
                                                          selectIndex
                                                              .toString())
                                                      ? selectMap[selectIndex
                                                                  .toString()]
                                                              .contains(index)
                                                          ? Color.fromRGBO(
                                                              255, 77, 76, 1)
                                                          : Color.fromRGBO(
                                                              204, 204, 204, 1)
                                                      : Color.fromRGBO(
                                                          204, 204, 204, 1),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
//-->  不良   做 删除  操作
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (selectMap.containsKey(
                                                  selectIndex.toString())) {
                                                if (selectMap[
                                                        selectIndex.toString()]
                                                    .contains(index)) {
                                                  //做 删除  操作
                                                  selectMap[selectIndex
                                                          .toString()]
                                                      .remove(index);
                                                }
                                              }
                                              print(selectMap);
                                            });
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromRGBO(
                                                      238,
                                                      238,
                                                      238,
                                                      selectMap.containsKey(
                                                              selectIndex
                                                                  .toString())
                                                          ? selectMap[selectIndex
                                                                      .toString()]
                                                                  .contains(
                                                                      index)
                                                              ? 1
                                                              : 0
                                                          : 0),
                                                  width: 1.0),
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5)),
                                              color: selectMap.containsKey(
                                                      selectIndex.toString())
                                                  ? selectMap[selectIndex
                                                              .toString()]
                                                          .contains(index)
                                                      ? Colors.white
                                                      : Color.fromRGBO(
                                                          39, 153, 93, 0.2)
                                                  : Color.fromRGBO(
                                                      39, 153, 93, 0.2),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '正常',
                                                style: TextStyle(
                                                  color: selectMap.containsKey(
                                                          selectIndex
                                                              .toString())
                                                      ? selectMap[selectIndex
                                                                  .toString()]
                                                              .contains(index)
                                                          ? Color.fromRGBO(
                                                              204, 204, 204, 1)
                                                          : Color.fromRGBO(
                                                              39, 153, 93, 1)
                                                      : Color.fromRGBO(
                                                          39, 153, 93, 1),
                                                  fontSize: 12,
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
                                      height: 25,
                                    ),
                                    getItem(SecondCheckModel.fromJson(
                                                    secondCheckList[index])
                                                .id) ==
                                            0
                                        ? selectMap.containsKey(
                                                selectIndex.toString())
                                            ? selectMap[selectIndex.toString()]
                                                    .contains(index)
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                          child: SizedBox()),
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            CheckWrite(
                                                                              id: SecondCheckModel.fromJson(secondCheckList[index]).id,
                                                                              checkStandard: SecondCheckModel.fromJson(secondCheckList[index]).checkStandard,
                                                                              inspectionItem: SecondCheckModel.fromJson(secondCheckList[index]).inspectionItem,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  //checkMap['${SecondCheckModel.fromJson(secondCheckList[index]).id}'] = value;
                                                                                  checkList.add(value);
                                                                                  print('回调数值==>$checkList');
                                                                                });
                                                                              },
                                                                            )));
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Image.asset(
                                                                    'Assets/unpeople.png',
                                                                    width: 11,
                                                                    height: 11,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      '补充检查说明',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              39,
                                                                              153,
                                                                              93,
                                                                              1),
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 25,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Container()
                                            : Container()
                                        : Container(),

                                    //补充检查说明展示
                                    getItem(SecondCheckModel.fromJson(
                                                    secondCheckList[index])
                                                .id) ==
                                            0
                                        ? Container()
                                        : checkMap.length == 0
                                            ? Container()
                                            : selectMap.containsKey(
                                                    selectIndex.toString())
                                                ? selectMap[selectIndex
                                                            .toString()]
                                                        .contains(index)
                                                    ? Container(
                                                        child: Column(
                                                          children: [
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
                                                                  child: _getmap(
                                                                              SecondCheckModel.fromJson(secondCheckList[index]).id)['type'] ==
                                                                          0
                                                                      ? Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              20,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              color: Color.fromRGBO(255, 183, 0, 1)),
                                                                          child:
                                                                              Text(
                                                                            '建议',
                                                                            style:
                                                                                TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 12),
                                                                          ),
                                                                        )
                                                                      :
                                                                      //用户根据不同 展示不同
                                                                      Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              20,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              color: Color.fromRGBO(255, 77, 76, 1)),
                                                                          child:
                                                                              Text(
                                                                            '必须',
                                                                            style:
                                                                                TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 12),
                                                                          ),
                                                                        ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          68,
                                                                          0,
                                                                          61,
                                                                          0),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        129 -
                                                                        30,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        _getmap(SecondCheckModel.fromJson(secondCheckList[index]).id)['remark'] ==
                                                                                null
                                                                            ? ''
                                                                            : _getmap(SecondCheckModel.fromJson(secondCheckList[index]).id)['remark'],
                                                                        maxLines:
                                                                            3,
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                10,
                                                                                10,
                                                                                10,
                                                                                1)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            MediaQuery.of(context).size.width -
                                                                                75,
                                                                            0,
                                                                            16,
                                                                            0),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => CheckWrite(
                                                                                      id: SecondCheckModel.fromJson(secondCheckList[index]).id,
                                                                                      checkStandard: SecondCheckModel.fromJson(secondCheckList[index]).checkStandard,
                                                                                      inspectionItem: SecondCheckModel.fromJson(secondCheckList[index]).inspectionItem,
                                                                                      //传递数据
                                                                                      writeMap: _getmap(SecondCheckModel.fromJson(secondCheckList[index]).id), //checkMap['${SecondCheckModel.fromJson(secondCheckList[index]).id}'], //checkList[index],
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          checkMap['${SecondCheckModel.fromJson(secondCheckList[index]).id}'] = value;
                                                                                          // checkList.add(value);
                                                                                          if (checkList.length == 0) {
                                                                                            checkList.add(value);
                                                                                            return;
                                                                                          }
                                                                                          for (var i = 0; i < checkList.length; i++) {
                                                                                            if (checkList[i]['inspectionId'] == value['inspectionId']) {
                                                                                              checkList.removeAt(i);
                                                                                              checkList.add(value);
                                                                                            } else {
                                                                                              checkList.add(value);
                                                                                            }
                                                                                          }
                                                                                          print('回调数值==>$checkList');
                                                                                        });
                                                                                      },
                                                                                    )));
                                                                      },
                                                                      child: Image
                                                                          .asset(
                                                                        'Assets/check/checkedit.png',
                                                                        width:
                                                                            19,
                                                                        height:
                                                                            19,
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            //服务项目 展示区域
                                                            _getmap(SecondCheckModel.fromJson(
                                                                            secondCheckList[index])
                                                                        .id)['detailList'] ==
                                                                    null
                                                                ? Container()
                                                                : ListView(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    children: List.generate(
                                                                        _getmap(SecondCheckModel.fromJson(secondCheckList[index]).id)['detailList'].length, //
                                                                        (indexe) => Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Container(
                                                                                      width: MediaQuery.of(context).size.width / 2 - 40 / 2 - 30 / 2,
                                                                                      height: 30,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color.fromRGBO(39, 153, 93, 0.1)),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: 5,
                                                                                          ),
                                                                                          Align(
                                                                                            alignment: Alignment.centerLeft,
                                                                                            child: Text(
                                                                                              _getmap(SecondCheckModel.fromJson(secondCheckList[index]).id)['detailList'][indexe]['serviceName'],
                                                                                              style: TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontSize: 13),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Container(
                                                                                      width: MediaQuery.of(context).size.width / 2 - 40 / 2 - 30 / 2,
                                                                                      height: 30,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Color.fromRGBO(39, 153, 93, 0.1), width: 1.0), color: Colors.white),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: 5,
                                                                                          ),
                                                                                          Align(
                                                                                            alignment: Alignment.centerLeft,
                                                                                            child: Text(
                                                                                              _getmap(SecondCheckModel.fromJson(secondCheckList[index]).id)['detailList'][indexe]['secondaryService'],
                                                                                              style: TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontSize: 13),
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
                                                                                )
                                                                              ],
                                                                            )),
                                                                  ),

                                                            SizedBox(
                                                              height: 15,
                                                            ),

//照片区域
                                                            _getmap(SecondCheckModel.fromJson(
                                                                            secondCheckList[index])
                                                                        .id)['imgList'] ==
                                                                    null
                                                                ? Container()
                                                                : Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            15,
                                                                      ),
                                                                      Expanded(
                                                                        child: GridView.builder(
                                                                            shrinkWrap: true,
                                                                            physics: NeverScrollableScrollPhysics(), //禁止滑动
                                                                            itemCount: _getmap(SecondCheckModel.fromJson(secondCheckList[index]).id)['imgList'].length, //
                                                                            //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                //横轴元素个数
                                                                                crossAxisCount: 4,
                                                                                //纵轴间距
                                                                                mainAxisSpacing: 10.0,
                                                                                //横轴间距
                                                                                crossAxisSpacing: 15.0,
                                                                                //子组件宽高长度比例
                                                                                childAspectRatio: 1.0),
                                                                            itemBuilder: (BuildContext context, int indexs) {
                                                                              //Widget Function(BuildContext context, int index)
                                                                              return InkWell(
                                                                                onTap: () {
                                                                                  //_takePhoto();
                                                                                  setState(() {
                                                                                    Navigator.of(context).push(FadeRoute(
                                                                                        page: PhotoViewSimpleScreen(
                                                                                      imageProvider: NetworkImage(
                                                                                        _getmap(SecondCheckModel.fromJson(secondCheckList[index]).id)['imgList'][indexs],
                                                                                      ),
                                                                                      heroTag: 'simple',
                                                                                    )));
                                                                                  });
                                                                                },
                                                                                child: Container(
                                                                                  width: MediaQuery.of(context).size.width / 3 - 50 / 3,
                                                                                  height: MediaQuery.of(context).size.width / 3 - 50 / 3,
                                                                                  child: ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                      child: Stack(
                                                                                        children: [
                                                                                          Padding(
                                                                                              padding: EdgeInsets.all(0),
                                                                                              child: ConstrainedBox(
                                                                                                constraints: BoxConstraints.expand(),
                                                                                                child: Image.network(
                                                                                                  _getmap(SecondCheckModel.fromJson(secondCheckList[index]).id)['imgList'][indexs],
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
                                                                        width:
                                                                            15,
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container()
                                                : Container(),

                                    Container(
                                        height: 1,
                                        color: Color.fromRGBO(238, 238, 238, 1))
                                  ],
                                ),
                              )),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          )))),
              Column(
                children: [
                  SizedBox(
                    height: 46,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckNext(
                                    vehicleLicence: widget.vehicleLicence,
                                    numbers: allNumber,
                                    dataList: checkList,
                                  ))).then((value) => _getCheckItem());
                    },
                    child: Container(
                      width: 114,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(39, 153, 93, 1),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '生成检查单',
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
            ]),
          )),
        ],
      ),
    );
  }
}
