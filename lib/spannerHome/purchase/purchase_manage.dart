import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/purchase/model/PurchaseModel.dart';
import 'package:spanners/spannerHome/purchase/purchase_api.dart';

/// Copyright (C), 2020-2020, spanners
/// FileName: purchase_manage
/// Author: Jack
/// Date: 2020/12/18
/// Description:
class PurchaseManage extends StatefulWidget {
  @override
  _PurchaseManageState createState() => _PurchaseManageState();
}

class _PurchaseManageState extends State<PurchaseManage> {
  bool selectShowFlag = false;
  String selectContent = "全部来源";
  TextEditingController textEditingController = TextEditingController();
  List<PurchaseModel> purchaseList = [];
  List<PurchaseModel> otherPurchaseList = [];
  List<MaterialModel> materialList = [];
  List<MaterialModel> materialCopyList = [];

  //true purchase false material
  int tabFlag = 0;

  int source = 4;

  @override
  // ignore: must_call_super
  void initState() {
    initData();
  }

  initData() {
    PurchaseApi.getPurchaseList(
        param: {"searchKey": "", "sourceFlag": source},
        onSuccess: (data) {
          purchaseList = List<PurchaseModel>.from(
              data.map((x) => PurchaseModel.fromJson(x)));
          setState(() {});
        });
    PurchaseApi.getPurchaseList(
        param: {"searchKey": "", "sourceFlag": 5},
        onSuccess: (data) {
          otherPurchaseList = List<PurchaseModel>.from(
              data.map((x) => PurchaseModel.fromJson(x)));
          setState(() {});
        });
    PurchaseApi.getMaterialList(onSuccess: (data) {
      materialList =
          List<MaterialModel>.from(data.map((x) => MaterialModel.fromJson(x)));
      materialCopyList.addAll(materialList);

      setState(() {});
    });
  }

  searchPurchaseAndMaterial() {
    if (tabFlag == 0) {
      PurchaseApi.getPurchaseList(
          param: {
            "searchKey": textEditingController.text ?? "",
            "sourceFlag": source,
          },
          onSuccess: (data) {
            purchaseList.clear();
            for (var item in data) {
              purchaseList.add(PurchaseModel.fromJson(item));
            }
            setState(() {});
          });
    }
    if (tabFlag == 1) {
      materialList.clear();
      for (MaterialModel materialModel in materialCopyList) {
        if (materialModel.materialName.contains(textEditingController.text)) {
          materialList.add(materialModel);
        }
      }
      setState(() {});
    }
    if (tabFlag == 2) {
      PurchaseApi.getPurchaseList(
          param: {
            "searchKey": textEditingController.text ?? "",
            "sourceFlag": 5,
          },
          onSuccess: (data) {
            otherPurchaseList.clear();
            for (var item in data) {
              otherPurchaseList.add(PurchaseModel.fromJson(item));
            }
            setState(() {});
          });
    }
  }

  tapSelect(key, value) {
    source = int.parse(key);
    selectContent = value;
    selectShowFlag = !selectShowFlag;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "采购管理"),
      body: Stack(
        children: [
          Column(
            children: [
              head(),
              Expanded(
                child: ListView(
                  children: [
                    content(),
                  ],
                ),
              )
            ],
          ),
          CommonWidget.dropDownChoice(
              showFlag: selectShowFlag,
              top: 120.s,
              left: 60.s,
              itemList: [
                {"4": '全部来源'},
                {"1": "自采"},
                {"2": "共享"},
                {"3": "平台商品"},
              ],
              width: 90.s,
              height: 120.s,
              tapSelect: tapSelect)
        ],
      ),
    );
  }

  Widget head() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 10.s,
              ),
              Container(
                width: 330.s,
                height: 30.s,
                padding: EdgeInsets.fromLTRB(40.s, 0, 25.s, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.s),
                    color: Color.fromRGBO(238, 238, 238, 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200.s,
                      child: CommonWidget.textField(
                          hintText: "快速搜素",
                          textController: textEditingController),
                    ),
                    GestureDetector(
                      onTap: () {
                        searchPurchaseAndMaterial();
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
              SizedBox(
                height: 15.s,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40.s, 0, 40.s, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        tabFlag = 0;
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          CommonWidget.font(
                              text: "采购入库",
                              size: 16,
                              fontWeight: tabFlag == 0
                                  ? FontWeight.bold
                                  : FontWeight.w300),
                          Visibility(
                            visible: tabFlag == 0,
                            child: Container(
                                width: 35.s,
                                height: 3.s,
                                color: Color.fromRGBO(39, 153, 93, 1)),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        tabFlag = 1;
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          CommonWidget.font(
                              text: "即采即入",
                              size: 16,
                              fontWeight: tabFlag == 1
                                  ? FontWeight.bold
                                  : FontWeight.w300),
                          Visibility(
                              visible: tabFlag == 1,
                              child: Container(
                                  width: 35.s,
                                  height: 3.s,
                                  color: Color.fromRGBO(39, 153, 93, 1))),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        tabFlag = 2;
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          CommonWidget.font(
                              text: "其它入库",
                              size: 16,
                              fontWeight: tabFlag == 2
                                  ? FontWeight.bold
                                  : FontWeight.w300),
                          Visibility(
                              visible: tabFlag == 2,
                              child: Container(
                                  width: 35.s,
                                  height: 3.s,
                                  color: Color.fromRGBO(39, 153, 93, 1))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15.s,
              ),
              Visibility(
                visible: tabFlag == 0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50.s, 0, 25.s, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectShowFlag = !selectShowFlag;
                          setState(() {});
                        },
                        child: Container(
                            width: 100.s,
                            padding: EdgeInsets.fromLTRB(25.s, 0, 0, 0),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                CommonWidget.font(
                                    text: selectContent, size: 14),
                                SizedBox(
                                  width: 7.s,
                                ),
                                Image.asset(
                                  "Assets/members/down.png",
                                  width: 10.s,
                                  height: 18.s,
                                )
                              ],
                            )),
                      ),
                      GestureDetector(
                        child: CommonWidget.button(
                            text: "添加", width: 60.s, height: 25.s),
                        onTap: () {
                          RouterUtil.push(context,
                              data: 4,
                              routerName: "addPurchase", pushThen: (value) {
                            initData();
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: tabFlag == 2,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50.s, 0, 25.s, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: CommonWidget.button(
                            text: "添加", width: 60.s, height: 25.s),
                        onTap: () {
                          RouterUtil.push(context,
                              data: 5,
                              routerName: "addPurchase", pushThen: (value) {
                            initData();
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget content() {
    if (tabFlag == 0) {
      return Column(
        children: [
          for (PurchaseModel purchase in purchaseList)
            Container(
              color: Color.fromRGBO(188, 188, 188, 0),
              width: 375.s,
              padding: EdgeInsets.fromLTRB(15.s, 10.s, 15.s, 0),
              child: Container(
                color: Colors.white,
                width: 345.s,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.s, 15.s, 15.s, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150.s,
                            child: CommonWidget.font(
                                text: purchase.orderNo,
                                fontWeight: FontWeight.bold,
                                number: 1),
                          ),
                          GestureDetector(
                            child: CommonWidget.font(
                                text: "查看详情",
                                color: Color.fromRGBO(39, 153, 93, 1)),
                            onTap: () {
                              RouterUtil.push(context,
                                  routerName: "purchaseDetail",
                                  data: {
                                    "purchaseId": purchase.id,
                                  }, pushThen: (value) {
                                initData();
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.s, 0, 10.s, 20.s),
                      child: Column(
                        children: [
                          for (PurchaseItemEntityList purchaseItem
                              in purchase.purchaseItemEntityList)
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 20.s, 0, 20.s),
                              decoration: CommonWidget.grayBottomBorder(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(purchaseItem.picUrl,
                                          width: 100.s, height: 100.s),
                                      Container(
                                        width: 210.s,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonWidget.font(
                                                text: purchaseItem.itemName,
                                                size: 14),
                                            CommonWidget.font(
                                                text: purchaseItem.applyTo,
                                                color: Color.fromRGBO(
                                                    145, 145, 145, 1),
                                                size: 13),
                                            SizedBox(height: 20.s),
                                            CommonWidget.font(
                                                text:
                                                    "${caseSource(purchaseItem.source)}/采购量${purchaseItem.count}",
                                                color: Color.fromRGBO(
                                                    145, 145, 145, 1),
                                                size: 13),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30.s, 10.s, 0, 0),
                                    child: purchaseItem.instore == 0
                                        ? CommonWidget.font(text: "已入库")
                                        : CommonWidget.font(text: "待入库",color: Color.fromRGBO(39, 153, 93, 1)),
                                  )
                                  
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.s, 0.s, 15.s, 10.s),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonWidget.font(text: "创建时间"),
                          CommonWidget.font(
                            text: "${purchase.purchaseDate}",
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ],
      );
    }
    if (tabFlag == 1) {
      return Column(
        children: [
          for (MaterialModel material in materialList)
            GestureDetector(
              onTap: () {
                RouterUtil.push(context,
                    routerName: "materialDetail", data: material.id);
              },
              child: Container(
                width: 345.s,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(15.s, 15.s, 15.s, 15.s),
                margin: EdgeInsets.fromLTRB(0, 10.s, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidget.font(text: material.materialName, number: 2),
                    SizedBox(
                      height: 20.s,
                    ),
                    CommonWidget.font(
                        text: FormatUtil.formatDateYMDHM(material.createDate),
                        size: 13,
                        color: Color.fromRGBO(155, 155, 155, 1)),
                  ],
                ),
              ),
            )
        ],
      );
    }
    if (tabFlag == 2) {
      return Column(
        children: [
          for (PurchaseModel purchase in otherPurchaseList)
            Container(
              color: Color.fromRGBO(188, 188, 188, 0),
              width: 375.s,
              padding: EdgeInsets.fromLTRB(15.s, 10.s, 15.s, 0),
              child: Container(
                color: Colors.white,
                width: 345.s,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.s, 15.s, 15.s, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 200.s,
                            child: CommonWidget.font(
                                text: purchase.orderNo,
                                fontWeight: FontWeight.bold,
                                number: 1),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.s, 0, 10.s, 20.s),
                      child: Column(
                        children: [
                          for (PurchaseItemEntityList purchaseItem
                              in purchase.purchaseItemEntityList)
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 20.s, 0, 20.s),
                              decoration: CommonWidget.grayBottomBorder(),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(purchaseItem.picUrl,
                                      width: 100.s, height: 100.s),
                                  Container(
                                    width: 210.s,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonWidget.font(
                                            text: purchaseItem.itemName,
                                            size: 14),
                                        CommonWidget.font(
                                            text: purchaseItem.applyTo,
                                            color: Color.fromRGBO(
                                                145, 145, 145, 1),
                                            size: 13),
                                        SizedBox(height: 20.s),
                                        CommonWidget.font(
                                            text: "入库量${purchaseItem.count}",
                                            color: Color.fromRGBO(
                                                145, 145, 145, 1),
                                            size: 13),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15.s, 0.s, 15.s, 10.s),
                      decoration: CommonWidget.grayBottomBorder(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonWidget.font(text: "入库时间"),
                          CommonWidget.font(
                            text: "${purchase.purchaseDate}",
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15.s, 10.s, 15.s, 10.s),
                      decoration: CommonWidget.grayBottomBorder(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonWidget.font(text: "记录人"),
                          CommonWidget.font(
                            text: "${purchase.createUserName}",
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.s, 10.s, 15.s, 10.s),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonWidget.font(text: "入库原因"),
                          CommonWidget.font(
                            text: "${purchase.comment}",
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      );
    }
  }

  String caseSource(int num) {
    switch (num) {
      case 1:
        return "自采商品";
      case 2:
        return "共享商品";
      case 3:
        return "平台商品";
      default:
        return "未知商品";
    }
  }
}
