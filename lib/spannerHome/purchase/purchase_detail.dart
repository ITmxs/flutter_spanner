import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/purchase/purchase_api.dart';

import 'model/PurchaseModel.dart';

/// Copyright (C), 2020-2020, spanners
/// FileName: purchase_Detail
/// Author: Jack
/// Date: 2020/12/28
/// Description:

class PurchaseDetail extends StatefulWidget {
  Map purchase;

  setData(Map data) {
    purchase = data;
  }

  @override
  _PurchaseDetailState createState() => _PurchaseDetailState();
}

class _PurchaseDetailState extends State<PurchaseDetail> {
  List<PurchaseItemEntityList> purchaseItemEntityList = [];
  bool storeFlag = false;
  double total = 0;

  @override
  void initState() {
    initData();
  }

  initData() {
    storeFlag = false;
    PurchaseApi.getPurchaseDetail(
        param: {"purchaseId": widget.purchase["purchaseId"]},
        onSuccess: (data) {
          print(data);
          purchaseItemEntityList = List<PurchaseItemEntityList>.from(
              data.map((x) => PurchaseItemEntityList.fromJson(x)));
          print(purchaseItemEntityList);

          forStore:
          for (int i = 0; i < purchaseItemEntityList.length; i++) {
            if (purchaseItemEntityList[i].instore == 1) {
              storeFlag = true;
              break forStore;
            }
          }
          for (int i = 0; i < purchaseItemEntityList.length; i++) {
            total += purchaseItemEntityList[i].buyPrice *
                purchaseItemEntityList[i].count;
          }
          setState(() {});
        });
  }

  delete(value) {
    PurchaseApi.deleteItem(
        param: {"itemId": value},
        onSuccess: (data) {
          print(data);
          initData();
          setState(() {});
        });
  }

  inStore(value) {
    PurchaseApi.itemInStore(
        param: {"itemId": value},
        onSuccess: (data) {
          print(data);
          initData();
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "采购管理"),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(15.s, 20.s, 15.s, 0),
                    padding: EdgeInsets.fromLTRB(15.s, 0.s, 15.s, 0),
                    width: 345.s,
                    height: 40.s,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidget.font(text: "来源"),
                        CommonWidget.font(
                            text:
                                "${purchaseItemEntityList.length != 0 ? caseSource(purchaseItemEntityList.first.source) : ""}"),
                      ],
                    )),
                CommonWidget.sizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.s, 0, 0, 15.s),
                      child: CommonWidget.font(
                          text: "商品信息",
                          color: Color.fromRGBO(39, 153, 93, 1),
                          size: 18),
                    ),
                  ],
                ),
                for (PurchaseItemEntityList purchaseItem
                    in purchaseItemEntityList)
                  if (purchaseItem.instore == 0)
                    Container(
                      width: 345.s,
                      padding: EdgeInsets.fromLTRB(10.s, 10.s, 10.s, 20.s),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidget.font(text: "已入库商品"),
                          CommonWidget.sizedBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(purchaseItem.picUrl,
                                  width: 100.s, height: 100.s),
                              Container(
                                width: 210.s,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonWidget.font(
                                        text: purchaseItem.itemName, size: 14),
                                    CommonWidget.font(
                                        text: purchaseItem.applyTo,
                                        color: Color.fromRGBO(145, 145, 145, 1),
                                        size: 13),
                                    SizedBox(height: 20.s),
                                    CommonWidget.font(
                                        text:
                                            "${caseSource(purchaseItem.source)}/采购量${purchaseItem.count}",
                                        color: Color.fromRGBO(145, 145, 145, 1),
                                        size: 13),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10.s, 0, 10.s),
                            decoration: CommonWidget.grayBottomBorder(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonWidget.font(text: "进货价"),
                                CommonWidget.font(
                                    text: "￥${purchaseItem.buyPrice.toString()}"),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10.s, 0, 10.s),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonWidget.font(text: "进货数量"),
                                CommonWidget.font(
                                    text: purchaseItem.count.toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                CommonWidget.sizedBox,
                Visibility(
                  visible: storeFlag,
                  child: Container(
                    width: 345.s,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(10.s, 20.s, 10.s, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonWidget.font(
                                text: "待入库商品",
                                color: Color.fromRGBO(39, 153, 93, 1)),
                            GestureDetector(
                              child: CommonWidget.font(
                                  text: "修改",
                                  color: Color.fromRGBO(39, 153, 93, 1)),
                              onTap: () {
                                RouterUtil.push(context,
                                    routerName: "updatePurchase",
                                    data: purchaseItemEntityList,
                                    pushThen: (value) {
                                  initData();
                                });
                              },
                            ),
                          ],
                        ),
                        CommonWidget.sizedBox,
                        for (PurchaseItemEntityList purchaseItem
                            in purchaseItemEntityList)
                          if (purchaseItem.instore == 1)
                            Container(
                              width: 345.s,
                              padding: EdgeInsets.fromLTRB(10.s, 10.s, 0.s, 20.s),
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 10.s, 0, 10.s),
                                    decoration: CommonWidget.grayBottomBorder(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CommonWidget.font(text: "进货价"),
                                        CommonWidget.font(
                                            text:
                                                purchaseItem.buyPrice.toString()),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 10.s, 0, 0.s),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CommonWidget.font(text: "进货数量"),
                                        CommonWidget.font(
                                            text:
                                                purchaseItem.count.toString()),
                                      ],
                                    ),
                                  ),
                                  CommonWidget.sizedBox,
                                  Padding(
                                    padding: EdgeInsets.all(40.s),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: CommonWidget.customButton(
                                              text: "删除",
                                              width: 90.s,
                                              height: 30.s,
                                              buttonColor:
                                                  Color.fromRGBO(255, 77, 76, 1)),
                                          onTap: () {
                                            delete(purchaseItem.id);
                                          },
                                        ),
                                        GestureDetector(
                                          child: CommonWidget.button(
                                              text: "直接入库",
                                              width: 90.s,
                                              height: 30.s),
                                          onTap: () {
                                            inStore(purchaseItem.id);
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 40.s,
                  width: 345.s,
                  padding: EdgeInsets.fromLTRB(10.s, 0, 10.s, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "采购总价"),
                      CommonWidget.font(text: "￥${total.toString()}"),
                    ],
                  ),
                ),
                CommonWidget.sizedBox,
                CommonWidget.sizedBox,
                Visibility(
                  visible: purchaseItemEntityList.length != 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.s, 0, 0, 15.s),
                        child: CommonWidget.font(
                          text: "入库备注",
                        ),
                      ),
                      Container(
                        width: 345.s,
                        margin: EdgeInsets.fromLTRB(15.s, 0.s, 15.s, 0),
                        height: 90.s,
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(15.s, 15.s, 0, 0),
                        child: CommonWidget.font(
                            text: purchaseItemEntityList.length != 0
                                ? purchaseItemEntityList.first.comment
                                : ""),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.s, 25.s, 0, 0),
                        child: CommonWidget.font(
                            text:
                                "采购时间： ${purchaseItemEntityList.length != 0 ? purchaseItemEntityList.first.purchaseDate : ""}"),
                      ),
                      SizedBox(
                        height: 150.s,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
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
