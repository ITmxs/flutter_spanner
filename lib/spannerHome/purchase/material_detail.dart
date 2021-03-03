import 'dart:async';
import 'dart:collection';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/delivery_check/view/dc_details_page.dart';
import 'package:spanners/spannerHome/purchase/model/PurchaseModel.dart';
import 'package:spanners/spannerHome/purchase/purchase_api.dart';

/// Copyright (C), 2020-2020, spanners
/// FileName: material_detail
/// Author: Jack
/// Date: 2020/12/22
/// Description:
class MaterialDetail extends StatefulWidget {
  String materialId;
  String flag;
  setData(data) {
    materialId = data;
  }

  @override
  _MaterialDetailState createState() => _MaterialDetailState();
}

class _MaterialDetailState extends State<MaterialDetail> {
  MaterialModel materialDetail;
  List<String> leftValueList = [
    "名称",
    "型号",
    "规格",
    "单价",
    "数量",
    "金额",
    "采购来源",
    "成本单价",
  ];

  List<String> leftValue2List = ["名称", "型号", "规格", "单价", "数量", "金额"];

  List<String> rightValueList = ["", "", "", "", "", "", "", ""];
  bool updateFlag = false;
  TextEditingController sourceController = TextEditingController();
  TextEditingController costController = TextEditingController();

  @override
  // ignore: must_call_super
  void initState() {
    initData();
  }

  initData() {
    PurchaseApi.getServiceMaterialDetail(
        param: {"materialId": widget.materialId},
        onSuccess: (data) {
          materialDetail = MaterialModel.fromJson(data);
          rightValueList.clear();
          rightValueList.add(materialDetail.itemMaterial);
          rightValueList.add(materialDetail.itemModel);
          rightValueList.add(materialDetail.spec);
          rightValueList.add(materialDetail.itemPrice.toString());
          rightValueList.add(materialDetail.itemNumber.toString());
          rightValueList.add((materialDetail.itemPrice*materialDetail.itemNumber).toString());
          rightValueList.add(materialDetail.purchaseSource);
          rightValueList.add(materialDetail.partsCost.toString());
          sourceController.text = materialDetail.purchaseSource;
          costController.text = materialDetail.partsCost.toString();
          setState(() {});
        });
  }

  updateMaterialInfo() {
    if (costController.text == "") {
      CommonWidget.showAlertDialog("成本单价必须输入");
      return;
    }
    if (sourceController.text == "") {
      CommonWidget.showAlertDialog("采购来源必须输入");
      return;
    }
    PurchaseApi.updateMaterial(
        param: {
          "materialId": widget.materialId,
          "price": costController.text,
          "source": sourceController.text
        },
        onSuccess: (data) {
          materialDetail = null;
          initData();
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
                Padding(
                  padding: EdgeInsets.fromLTRB(15.s, 25.s, 15.s, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonWidget.greenFont(text: "商品采购详情"),
                          GestureDetector(
                            child: CommonWidget.font(text: "修改"),
                            onTap: () {
                              updateFlag = !updateFlag;
                              setState(() {});
                            },
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.s, 0, 0),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              width: 345.s,
                              child: Column(
                                children: [
                                  CommonWidget.simpleList(
                                      keyList: updateFlag
                                          ? leftValue2List
                                          : leftValueList,
                                      valueList: rightValueList,
                                      mustFlag: false),
                                  Visibility(
                                    visible: updateFlag,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration:
                                              CommonWidget.grayTopBorder(),
                                          padding: EdgeInsets.fromLTRB(
                                              25.s, 20.s, 0, 10.s),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CommonWidget.font(text: "采购来源"),
                                              Container(
                                                width: 150.s,
                                                child: CommonWidget.textField(
                                                    textController:
                                                        sourceController),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration:
                                              CommonWidget.grayTopBorder(),
                                          padding: EdgeInsets.fromLTRB(
                                              25.s, 20.s, 0, 10.s),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CommonWidget.font(text: "成本单价"),
                                              Container(
                                                width: 150.s,
                                                child: CommonWidget.textField(
                                                    textController:
                                                        costController),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        30.s, 90.s, 30.s, 30.s),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: CommonWidget.button(
                                              text: "保存",
                                              width: 105.s,
                                              height: 30.s),
                                          onTap: () {
                                            updateMaterialInfo();
                                          },
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => DCDetailsPage(
                                                        workOrderId:
                                                            materialDetail
                                                                .workOrderId,
                                                        detailsType: DetailsType
                                                            .DetailsTypeNoSettlement,
                                                        showShareRed: "0",
                                                        showShareButton: "0")));
                                          },
                                          child: CommonWidget.button(
                                              text: "查看采购原因",
                                              width: 130.s,
                                              height: 30.s),
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
