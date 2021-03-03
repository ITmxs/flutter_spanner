import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/photoSelect.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/storage/storageRequestApi.dart';

// ignore: must_be_immutable
class StorageDetail extends StatefulWidget {
  Map data = {};

  setData(data) {
    this.data = data;
  }

  @override
  _StorageDetailState createState() => _StorageDetailState();
}

class _StorageDetailState extends State<StorageDetail> {
  //物品存储条目集合
  List textControllerList = [TextEditingController()];

  //文本框控制器
  TextEditingController commentController = TextEditingController();

  //物品存储信息
  Map storageDetail = {};

  //图片集合
  List storagePicList = [];

  //物品集合
  List storageItemList = [];

  //选择标志
  bool chooseFlag = false;

  @override
  void initState() {
    initData();
  }

  //初始化数据
  initData() {
    StorageRequestApi.getStorageDetailRequest(
        param: {"storageId": widget.data["storageId"]},
        onSuccess: (data) {
          storageDetail = data["storageEntity"];
          storagePicList = data["storagePicEntityList"];
          storageItemList = data["storageItemEntityList"];
          for (var item in storageItemList) {
            item["chooseFlag"] = false;
          }
          commentController.text = storageDetail["comment"];
          setState(() {});
        });
  }

  //更新备注
  updateComment() async {
    await StorageRequestApi.updateComment(
        param: {
          "storageId": widget.data["storageId"],
          "comment": commentController.text
        },
        onSuccess: (data) {
          initData();
          setState(() {});
        });
  }

  //取出物品
  takeOutItem() async {
    List itemList = [];
    for (int i = 0; i < storageItemList.length; i++) {
      if (storageItemList[i]["chooseFlag"] == true) {
        itemList.add(storageItemList[i]["id"]);
      }
    }
    await StorageRequestApi.takeItem(
        param: itemList,
        onSuccess: (data) {
          initData();
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
        appBar: CommonWidget.simpleAppBar(context, title: "存储详情"),
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: [
              Column(
                children: [
                  userInfo(),
                  SizedBox(height: 10.s),
                  itemListWidget(),
                  chooseTime(),
                  choosePic(),
                  tail()
                ],
              )
            ],
          ),
        ));
  }

  //用户信息
  userInfo() {
    return Column(
      children: [
        SizedBox(
          height: 25.s,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.s, 0.s, 0, 10.s),
              child: CommonWidget.greenFont(text: "用户信息"),
            ),
          ],
        ),
        Container(
          width: 345.s,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(3.s)),
          child: Column(
            children: [
              CommonWidget.simpleList(keyList: [
                "车牌号",
                "联系人姓名",
                "手机号"
              ], valueList: [
                storageDetail["vehicleLicence"] ?? "",
                storageDetail["ownerName"] ?? "",
                storageDetail["mobile"] ?? ""
              ], mustFlag: false)
            ],
          ),
        )
      ],
    );
  }

  //物品寄存清单
  itemListWidget() {
    return Column(
      children: [
        Container(
          width: 345.s,
          padding: EdgeInsets.fromLTRB(5.s, 15.s, 2.s, 25.s),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3.s),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10.s, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonWidget.greenFont(text: "物品寄存清单"),
                    GestureDetector(
                      child: CommonWidget.button(
                          text: !chooseFlag ? "选择" : "取消",
                          width: 58.s,
                          height: 26.s),
                      onTap: () {
                        chooseFlag = !chooseFlag;
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.s,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.s, 0, 0, 0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 15.s),
                            Container(
                              width: 120.s,
                              child: CommonWidget.font(
                                  text: "物品名称",
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.start),
                            ),
                            Container(
                              width: 80.s,
                              alignment: Alignment.center,
                              child: CommonWidget.font(
                                  text: "存储状态", fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: 120.s,
                              child: CommonWidget.font(
                                  text: "取出时间",
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                        for (var item in storageItemList)
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20.s, 0, 0),
                            child: Row(
                              children: [
                                (chooseFlag && item["status"] == 0)
                                    ? CommonWidget.circleCheckBox(
                                        checkFlag: item["chooseFlag"],
                                        onTap: () {
                                          item["chooseFlag"] =
                                              !item["chooseFlag"];
                                          setState(() {});
                                        })
                                    : SizedBox(width: 20.s),
                                Container(
                                  width: 120.s,
                                  child: CommonWidget.font(
                                      text: item["itemName"] ?? "",
                                      textAlign: TextAlign.start),
                                ),
                                Container(
                                  width: 80.s,
                                  alignment: Alignment.center,
                                  child: CommonWidget.font(
                                      text: item["status"] == 0 ? "待取出" : "已取出",
                                      color: item["status"] == 0
                                          ? Color.fromRGBO(255, 97, 97, 1)
                                          : Color.fromRGBO(39, 153, 93, 1)),
                                ),
                                Container(
                                  width: 115.s,
                                  alignment: Alignment.center,
                                  child: CommonWidget.font(
                                      text: item["status"] == 0
                                          ? "--"
                                          : item["updateTime"]
                                                  .toString()
                                                  .substring(0, 10) ??
                                              ""),
                                ),
                              ],
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Center(
                                      child: Container(
                                        width: 285.s,
                                        height: 300.s,
                                        padding: EdgeInsets.fromLTRB(
                                            35.s, 35.s, 35.s, 30.s),
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: ScrollConfiguration(
                                              behavior: NeverScrollBehavior(),
                                              child: ListView(
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          storageItemList
                                                              .length;
                                                      i++)
                                                    if (storageItemList[i]
                                                            ["chooseFlag"] ==
                                                        true)
                                                      Row(
                                                        children: [
                                                          CommonWidget.font(
                                                              text: "物品名称"),
                                                          CommonWidget.font(
                                                              text: storageItemList[
                                                                      i]
                                                                  ["itemName"]),
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                      )
                                                ],
                                              ),
                                            )),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CommonWidget.font(text: "取出时间"),
                                                CommonWidget.font(
                                                    text:
                                                        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.s,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: CommonWidget.button(
                                                      text: "取消",
                                                      width: 84.s,
                                                      height: 28.s),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    takeOutItem();
                                                    Navigator.pop(context);
                                                  },
                                                  child: CommonWidget.button(
                                                      text: "确定",
                                                      width: 84.s,
                                                      height: 28.s),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          child: Visibility(
                            visible: chooseFlag,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 20.s, 0, 0),
                              child: CommonWidget.button(
                                  text: "确认取出", width: 107.s, height: 28.s),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  //限时寄存
  chooseTime() {
    if (storageDetail["timeLimit"] != 0) return Container();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.s, 30.s, 45.s, 20.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  CommonWidget.font(
                    text: "限时寄存",
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CommonWidget.font(
                      text: "起始日",
                      color: Color.fromRGBO(39, 153, 93, 1),
                      size: 12),
                  SizedBox(
                    width: 3.s,
                  ),
                  Container(
                    width: 120.s,
                    height: 25.s,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(10.s, 0, 10.s, 0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 245, 238, 1),
                        borderRadius: BorderRadius.circular(5.s)),
                    child: CommonWidget.font(text: storageDetail["startDate"]),
                  ),
                ],
              ),
              Row(
                children: [
                  CommonWidget.font(
                      text: "到期日",
                      color: Color.fromRGBO(39, 153, 93, 1),
                      size: 12),
                  SizedBox(
                    width: 3.s,
                  ),
                  Container(
                    width: 120.s,
                    height: 25.s,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(10.s, 0, 10.s, 0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 245, 238, 1),
                        borderRadius: BorderRadius.circular(5.s)),
                    child: CommonWidget.font(text: storageDetail["endDate"]),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  //物品图片
  choosePic() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.s, 30.s, 0, 15.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.greenFont(text: "物品图片"),
          SizedBox(
            height: 10.s,
          ),
          Container(
            width: 345.s,
            height: 220.s,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              mainAxisSpacing: 10.s,
              children: <Widget>[
                for (var imgUrl in storagePicList)
                  Image.network(
                    imgUrl["picUrl"],
                    width: 150.s,
                    height: 150.s,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

//尾部
  tail() {
    return Column(
      children: [
        Container(
          width: 345.s,
          height: 47.s,
          padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(3.s)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonWidget.font(text: "寄存费用"),
              CommonWidget.font(text: "¥${storageDetail["cost"]}")
            ],
          ),
        ),
        SizedBox(
          height: 20.s,
        ),
        Row(
          children: [
            SizedBox(
              width: 20.s,
            ),
            CommonWidget.font(text: "备注"),
          ],
        ),
        SizedBox(
          height: 15.s,
        ),
        Container(
          width: 345.s,
          height: 80.s,
          padding: EdgeInsets.fromLTRB(20.s, 10.s, 20.s, 0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(3.s)),
          child: CommonWidget.textField(
              hintText: "请填写您需要备注的信息......", textController: commentController),
        ),
        SizedBox(
          height: 40.s,
        ),
        GestureDetector(
          onTap: () {
            updateComment();
            Navigator.pop(context);
          },
          child: Padding(
            child: CommonWidget.button(text: "确定", width: 105.s, height: 30.s),
            padding: EdgeInsets.fromLTRB(20.s, 0, 0, 0),
          ),
        ),
        SizedBox(
          height: 40.s,
        )
      ],
    );
  }
}
