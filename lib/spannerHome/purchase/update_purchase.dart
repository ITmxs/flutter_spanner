import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/purchase/purchase_api.dart';

import 'model/PurchaseModel.dart';

/// Copyright (C), 2020-2020, spanners
/// FileName: update_purchase
/// Author: Jack
/// Date: 2020/12/28
/// Description:
class UpdatePurchase extends StatefulWidget {
  List<PurchaseItemEntityList> purchaseItemEntityList = [];

  setData(data) {
    purchaseItemEntityList = data;

    for (int i = 0; i < purchaseItemEntityList.length;) {
      if (purchaseItemEntityList[i].instore == 0) {
        purchaseItemEntityList.removeAt(i);
      } else {
        i++;
      }
    }
  }

  @override
  _UpdatePurchaseState createState() => _UpdatePurchaseState();
}

class _UpdatePurchaseState extends State<UpdatePurchase> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    initData();
  }

  initData() {
    commentController.text = widget.purchaseItemEntityList[0].comment;
    for (PurchaseItemEntityList stock in widget.purchaseItemEntityList) {
      stock.countController.text = stock.count.toString();

      stock.buyPriceController.text = stock.buyPrice.toString();
    }
  }

  save() {
    Map dataMap = {};
    dataMap["purchaseItemDtoList"] = [];

    if (widget.purchaseItemEntityList.isEmpty) {
      CommonWidget.showAlertDialog("必须选择商品");
    }
    for (PurchaseItemEntityList item in widget.purchaseItemEntityList) {
      if (item.buyPriceController.text == "") {
        CommonWidget.showAlertDialog("进货价必须填写");
        return;
      }
      if (item.countController.text == "") {
        CommonWidget.showAlertDialog("进货数量必须填写");
        return;
      }
      dataMap["purchaseItemDtoList"].add({
        "buyPrice": item.buyPriceController.text,
        "count": item.countController.text,
        "purchaseItemId": item.id,
      });
    }

    dataMap["comment"] = commentController.text ?? "";
    dataMap["purchaseId"] = widget.purchaseItemEntityList.first.purchaseId;
    PurchaseApi.updatePurchase(
        param: dataMap,
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
                Padding(
                  padding: EdgeInsets.fromLTRB(30.s, 0, 0, 15.s),
                  child: CommonWidget.font(
                      text: "商品信息",
                      color: Color.fromRGBO(39, 153, 93, 1),
                      size: 18),
                ),
                for (PurchaseItemEntityList stock
                    in widget.purchaseItemEntityList)
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
                                    widget.purchaseItemEntityList.remove(stock);
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
                        CommonWidget.inputRow(
                            rowName: "进货价",
                            mustFlag: true,
                            textController: stock.buyPriceController),
                        CommonWidget.inputRow(
                            rowName: "进货数量",
                            mustFlag: true,
                            textController: stock.countController)
                      ],
                    ),
                  ),
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
                Padding(
                  padding: EdgeInsets.fromLTRB(30.s, 25.s, 0, 0),
                  child: CommonWidget.font(
                      text:
                          "采购时间： ${widget.purchaseItemEntityList[0].purchaseDate}"),
                ),
                CommonWidget.sizedBox,
                CommonWidget.sizedBox,
                GestureDetector(
                  onTap: () {
                    save();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonWidget.button(text: "保存", width: 100.s, height: 30.s)
                    ],
                  ),
                ),
                CommonWidget.sizedBox,
                CommonWidget.sizedBox,
              ],
            )
          ],
        ),
      ),
    );
  }
}
