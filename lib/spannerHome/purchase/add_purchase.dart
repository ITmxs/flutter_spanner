import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/purchase/model/PurchaseModel.dart';
import 'package:spanners/spannerHome/purchase/purchase_api.dart';

/// Copyright (C), 2020-2020, spanners
/// FileName: add_purchase
/// Author: Jack
/// Date: 2020/12/24
/// Description:

class AddPurchase extends StatefulWidget {
  int source = 0;

  setData(data) {
    source = data;
  }

  @override
  _AddPurchaseState createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {
  String source;
  final List<String> sourceList = ["自采", "共享", "平台商品"];
  List<StockModel> goodList = [];
  TextEditingController commentController = TextEditingController();

  save(int storeFlag) {
    int purchaseSource;
    if (source == null && widget.source != 5) {
      CommonWidget.showAlertDialog("来源必须选择");
    }
    if (goodList.isEmpty) {
      CommonWidget.showAlertDialog("必须选择商品");
    }

    List purchaseItemEntityList = [];
    for (StockModel item in goodList) {
      if (item.buyPriceController.text == "" && widget.source != 5) {
        CommonWidget.showAlertDialog("进货价必须填写");
        return;
      }
      if (item.countController.text == "") {
        CommonWidget.showAlertDialog("进货数量必须填写");
        return;
      }
      purchaseItemEntityList.add({
        "shopGoodsId": item.shopGoodsId,
        "buyPrice": item.buyPriceController.text ?? "",
        "count": item.countController.text ?? "",
        "instore": storeFlag
      });
    }
    switch (source) {
      case "自采":
        purchaseSource = 1;
        break;
      case "共享":
        purchaseSource = 2;
        break;
      case "平台商品":
        purchaseSource = 3;
        break;
    }
    PurchaseApi.addPurchase(
        param: {
          "source": purchaseSource ?? widget.source,
          "comment": commentController.text ?? "",
          "purchaseItemEntityList": purchaseItemEntityList
        },
        onSuccess: (data) {
          Navigator.pop(context);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: widget.source != 5,
                  child: Container(
                      margin: EdgeInsets.fromLTRB(15.s, 20.s, 15.s, 0),
                      width: 345.s,
                      color: Colors.white,
                      child: CommonWidget.chooseRow(
                          lineFlag: true,
                          rowName: "来源",
                          rowValue: source ?? "请选择",
                          textColor: source == null
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Colors.black,
                          rowValueColor: source == null
                              ? Color.fromRGBO(164, 164, 164, 1)
                              : Colors.black,
                          onChoose: () {
                            showModalBottomSheet(
                                isDismissible: true,
                                enableDrag: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 300.0,
                                    child: ShowBottomSheet(
                                      type: 7,
                                      dataList: sourceList,
                                      onChanged: (value) {
                                        setState(() {
                                          source = value;
                                        });
                                      },
                                    ),
                                  );
                                });
                          })),
                ),
                CommonWidget.sizedBox,
                Padding(
                  padding: EdgeInsets.fromLTRB(30.s, 0, 0, 15.s),
                  child: CommonWidget.font(
                      text: "商品信息",
                      color: Color.fromRGBO(39, 153, 93, 1),
                      size: 18),
                ),
                for (StockModel stock in goodList)
                  Container(
                    width: 345.s,
                    margin: EdgeInsets.fromLTRB(20.s, 0.s, 0, 10.s),
                    padding: EdgeInsets.fromLTRB(0.s, 30.s, 15.s, 20.s),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    goodList.remove(stock);
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.remove_circle_outline,
                                    color: Color.fromRGBO(255, 77, 76, 1),
                                    size: 20.s,
                                  ),
                                ),
                                Image.network(stock.picUrl,
                                    width: 100.s, height: 100.s),
                              ],
                            ),
                            Container(
                              width: 210.s,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonWidget.font(
                                      text: stock.itemName, size: 14),
                                  CommonWidget.font(
                                      text: stock.applyTo,
                                      color: Color.fromRGBO(145, 145, 145, 1),
                                      size: 13),
                                  SizedBox(height: 20.s),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CommonWidget.font(
                                          text: "库存数: ${stock.stock}",
                                          color: Color.fromRGBO(145, 145, 145, 1),
                                          size: 13),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                            visible: widget.source != 5,
                            child: CommonWidget.inputRow(
                                rowName: "进货价",
                                mustFlag: true,
                                textController: stock.buyPriceController)),
                        CommonWidget.inputRow(
                            rowName: "进货数量",
                            mustFlag: true,
                            textController: stock.countController),
                      ],
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    RouterUtil.push(context, routerName: "stockList",
                        pushThen: (value) {
                      goodList.addAll(value);
                      setState(() {});
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15.s, 0.s, 15.s, 0),
                    padding: EdgeInsets.fromLTRB(15.s, 0, 0, 0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Color.fromRGBO(39, 153, 93, 1), width: 1.s),
                        borderRadius: BorderRadius.circular(5.s)),
                    width: 345.s,
                    height: 35.s,
                    alignment: Alignment.centerLeft,
                    child: CommonWidget.font(
                        text: "请选择商品", color: Color.fromRGBO(188, 188, 188, 1)),
                  ),
                ),
                CommonWidget.sizedBox,
                CommonWidget.sizedBox,
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
                  child: CommonWidget.textField(
                      hintText: "请填写您需要备注的信息",
                      maxLines: 5,
                      textController: commentController),
                ),
                Visibility(
                  visible: widget.source != 5,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30.s, 25.s, 0, 0),
                    child: CommonWidget.font(
                        text:
                            "采购时间： ${FormatUtil.formatDateYMDHM(DateTime.now())}"),
                  ),
                ),
                Visibility(
                  visible: widget.source == 5,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30.s, 25.s, 0, 0),
                    child: CommonWidget.font(
                        text:
                            "记录人： ${json.decode(SynchronizePreferences.Get("userInfo"))["realName"]}"),
                  ),
                ),
                SizedBox(
                  height: 150.s,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(40.s, 0, 40.s, 30.s),
                  child: Row(
                    mainAxisAlignment: widget.source != 5
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: CommonWidget.button(
                            text: "直接入库", width: 105.s, height: 30.s),
                        onTap: () {
                          save(0);
                        },
                      ),
                      Visibility(
                        visible: widget.source != 5,
                        child: GestureDetector(
                          child: CommonWidget.button(
                              text: "保存", width: 105.s, height: 30.s),
                          onTap: () {
                            save(1);
                          },
                        ),
                      )
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
}
