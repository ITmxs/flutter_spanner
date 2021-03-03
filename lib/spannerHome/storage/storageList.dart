import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/storage/storageRequestApi.dart';

class StorageList extends StatefulWidget {
  @override
  _StorageListState createState() => _StorageListState();
}

class _StorageListState extends State<StorageList> {
  //物品存储集合
  List storageList = [];

  //物品存储商品集合
  List storageItemList = [];

  //处理后的集合
  List storageDataList = [];

  //更新标志
  bool updateFlag = false;

  //删除车牌集合
  List deleteVehicleList = [];

  //删除item集合
  Set deleteStorageIdSet = Set();

  //搜索框controller
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  void initState() {
    initData();
  }

  //初始化数据
  initData() {
    StorageRequestApi.getStorageListRequest(
        param: {"searchKey": ""},
        onSuccess: (data) {
          storageList = data["storageEntity"];
          storageItemList = data["storageItemEntityList"];
          processData();
          setState(() {});
        });
  }

  //结构化物品存储数据
  processData() {
    //根据storageId将一个storage下的具体商品（item）插入
    for (int i = 0; i < storageList.length; i++) {
      storageList[i]["itemList"] = [];
      storageList[i]["picList"] = [];
      storageList[i]["checkFlag"] = false;
      for (int j = 0; j < storageItemList.length;) {
        if (storageList[i]["id"] == storageItemList[j]["storageId"]) {
          storageList[i]["itemList"].add(storageItemList[j]);
          storageItemList.removeAt(j);
          continue;
        }
        j++;
      }
    }
    //将storageList表里所有不重复的车牌号放入storageDataList，作为循环的第一层
    funcA:
    for (int i = 0; i < storageList.length; i++) {
      if (storageDataList.length == 0) {
        storageDataList.add({
          storageList[i]["vehicleLicence"]: [],
          "showFlag": false,
          "checkFlag": false
        });
        continue;
      }
      funcB:
      for (int j = 0; j < storageDataList.length; j++) {
        if (storageDataList[j].keys.first == storageList[i]["vehicleLicence"]) {
          continue funcA;
        }
      }
      storageDataList.add({
        storageList[i]["vehicleLicence"]: [],
        "showFlag": false,
        "checkFlag": false
      });
    }

    //根据车牌号将storage插入集合
    for (int i = 0; i < storageDataList.length; i++) {
      for (int j = 0; j < storageList.length;) {
        if (storageList[j]["vehicleLicence"] == storageDataList[i].keys.first) {
          storageDataList[i][storageDataList[i].keys.first].add(storageList[j]);
          storageList.removeAt(j);
          continue;
        }
        j++;
      }
    }
  }

  //全选
  allChoose() {
    deleteVehicleList.clear();
    for (var storage in storageDataList) {
      storage["checkFlag"] = true;
      deleteVehicleList.add(storage.keys.first);
    }
    setState(() {});
  }

  //删除
  deleteItem() async {
    if (deleteStorageIdSet.toList().isEmpty && deleteVehicleList.isEmpty)
      return;
    await StorageRequestApi.deleteStorage(
        param: {
          "storageIdList": deleteStorageIdSet.toList(),
          "vehicleList": deleteVehicleList
        },
        onSuccess: (data) {
          storageDataList.clear();
          setState(() {
            initData();
          });
        });
  }

  //搜索
  search() async {
    if (searchTextEditingController.text == "") return;

    await StorageRequestApi.getStorageListRequest(
        param: {"searchKey": searchTextEditingController.text},
        onSuccess: (data) {
          storageList = data["storageEntity"];
          storageItemList = data["storageItemEntityList"];
          storageDataList.clear();
          processData();
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.iconAppBar(context, "物品存储",
          rIcon: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 30.s, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    RouterUtil.push(context, routerName: "addStorage",
                        pushThen: (value) {
                      storageDataList.clear();
                      initData();
                    });
                  },
                  child: Image.asset(
                    "Assets/employee/add.png",
                    width: 23.s,
                    height: 23.s,
                  ),
                ),
              ],
            ),
          )),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: NeverScrollBehavior(),
            child: ListView(
              children: [
                Column(
                  children: [
                    head(),
                    for (var storageData in storageDataList)
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              storageData["showFlag"] =
                                  !storageData["showFlag"];
                              setState(() {});
                            },
                            child: Container(
                              width: 345.s,
                              height: 30.s,
                              padding: EdgeInsets.fromLTRB(5.s, 0, 20.s, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.s),
                                  color: Color.fromRGBO(39, 153, 93, 1)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Visibility(
                                        child: CommonWidget.picCheckBox(
                                            checkFlag:
                                                (storageData["checkFlag"] ??
                                                    false),
                                            onTap: () {
                                              storageData["checkFlag"] =
                                                  !storageData["checkFlag"];
                                              if (storageData["checkFlag"]) {
                                                deleteVehicleList.add(
                                                    storageData.keys.first);
                                              }
                                              if (!storageData["checkFlag"]) {
                                                deleteVehicleList.remove(
                                                    storageData.keys.first);
                                              }
                                              setState(() {});
                                            }),
                                        replacement: SizedBox(width: 20.s),
                                        visible: updateFlag,
                                      ),
                                      SizedBox(
                                        width: 3.s,
                                      ),
                                      CommonWidget.font(
                                          text: storageData.keys.first,
                                          color: Colors.white),
                                    ],
                                  ),
                                  storageData["showFlag"]
                                      ? Image.asset(
                                          "Assets/employee/up.png",
                                          width: 17.s,
                                          height: 10.s,
                                        )
                                      : Image.asset(
                                          "Assets/employee/down.png",
                                          width: 17.s,
                                          height: 10.s,
                                        )
                                ],
                              ),
                            ),
                          ),
                          if (storageData["showFlag"])
                            for (var storageItem
                                in storageData[storageData.keys.first])
                              Container(
                                width: 345.s,
                                color: Colors.white,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 8.s),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5.s, 20.s, 30.s, 10.s),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Visibility(
                                                child: CommonWidget.picCheckBox(
                                                    checkFlag: (storageItem[
                                                                "checkFlag"] ??
                                                            false) ||
                                                        storageData[
                                                            "checkFlag"],
                                                    onTap: () {
                                                      if (storageData[
                                                          "checkFlag"]) return;
                                                      storageItem["checkFlag"] =
                                                          !storageItem[
                                                              "checkFlag"];
                                                      if (!storageItem[
                                                                  "checkFlag"] ==
                                                              false &&
                                                          storageData[
                                                                  "checkFlag"] ==
                                                              false) {
                                                        deleteStorageIdSet
                                                            .remove(storageItem[
                                                                "id"]);
                                                      }
                                                      if (storageItem[
                                                              "checkFlag"] &&
                                                          storageData[
                                                                  "checkFlag"] ==
                                                              false) {
                                                        deleteStorageIdSet.add(
                                                            storageItem["id"]);
                                                      }
                                                      setState(() {});
                                                    }),
                                                replacement:
                                                    SizedBox(width: 20.s),
                                                visible: updateFlag,
                                              ),
                                              Visibility(
                                                visible:
                                                    (storageItem["timeLimit"] ??
                                                            1) ==
                                                        0,
                                                child: CommonWidget.font(
                                                    text: storageItem[
                                                            "endDate"] ??
                                                        "2020-20-20"),
                                                replacement: CommonWidget.font(
                                                    text: "不限时"),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            child: CommonWidget.font(
                                                text: "详情",
                                                color: Color.fromRGBO(
                                                    39, 153, 93, 1)),
                                            onTap: () {
                                              RouterUtil.push(context,
                                                  routerName: "storageDetail",
                                                  data: {
                                                    "storageId":
                                                        storageItem["id"]
                                                  }, pushThen: (value) {
                                                storageDataList.clear();
                                                initData();
                                              });
                                            },
                                          )
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                    ),
                                    for (int k = 0;
                                        k < storageItem["itemList"].length;
                                        k++)
                                      Container(
                                        width: 345.s,
                                        padding: EdgeInsets.fromLTRB(
                                            20.s, 15.s, 30.s, 10.s),
                                        decoration: k !=
                                                (storageItem["itemList"]
                                                        .length -
                                                    1)
                                            ? CommonWidget.grayBottomBorder()
                                            : null,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CommonWidget.font(
                                                text: storageItem["itemList"][k]
                                                        ["itemName"] ??
                                                    ""),
                                            Visibility(
                                              visible: (storageItem["itemList"]
                                                          [k]["status"] ??
                                                      1) ==
                                                  0,
                                              child: CommonWidget.font(
                                                  text: "待取出",
                                                  color: Color.fromRGBO(
                                                      255, 77, 76, 1)),
                                              replacement: CommonWidget.font(
                                                  text: "已取出",
                                                  color: Color.fromRGBO(
                                                      35, 193, 93, 1)),
                                            )
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                          SizedBox(
                            height: 10.s,
                          )
                        ],
                      )
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: updateFlag,
            child: Positioned(
              bottom: 0,
              child: Container(
                width: 375.s,
                height: 85.s,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(25.s, 15.s, 30.s, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        allChoose();
                      },
                      child: CommonWidget.font(text: "全选"),
                    ),
                    GestureDetector(
                      onTap: () {
                        deleteItem();
                      },
                      child: CommonWidget.customButton(
                          text: "删除",
                          width: 90.s,
                          height: 30.s,
                          textColor: Colors.white,
                          buttonColor: Color.fromRGBO(255, 77, 76, 1)),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //头部
  head() {
    return Container(
      padding: EdgeInsets.fromLTRB(23.s, 10.s, 40.s, 10.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 240.s,
            height: 30.s,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5.s)),
            child: Row(
              children: [
                Container(
                  width: 220.s,
                  padding: EdgeInsets.fromLTRB(25.s, 0, 0, 0),
                  child: CommonWidget.textField(
                      hintText: "搜索车牌号",
                      maxLines: 1,
                      textController: searchTextEditingController),
                ),
                GestureDetector(
                  onTap: () {
                    search();
                  },
                  child: Image.asset(
                    "Assets/storage/search.png",
                    width: 17.s,
                    height: 17.s,
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            child: updateFlag
                ? CommonWidget.font(
                    text: "完成", size: 18.s, fontWeight: FontWeight.bold)
                : CommonWidget.font(
                    text: "管理", size: 18.s, fontWeight: FontWeight.bold),
            onTap: () {
              updateFlag = !updateFlag;
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}
