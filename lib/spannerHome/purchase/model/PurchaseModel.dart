/// Copyright (C), 2020-2020, spanners
/// FileName: PurchaseModel
/// Author: Jack
/// Date: 2020/12/18
/// Description:
// To parse this JSON data, do
//
//     final purchaseModel = purchaseModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final purchaseModel = purchaseModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

PurchaseModel purchaseModelFromJson(String str) =>
    PurchaseModel.fromJson(json.decode(str));

String purchaseModelToJson(PurchaseModel data) => json.encode(data.toJson());

class PurchaseModel {
  PurchaseModel(
      {this.id,
      this.shopId,
      this.orderNo,
      this.source,
      this.purchaseDate,
      this.comment,
      this.createUser,
      this.createTime,
      this.updateUser,
      this.updateTime,
      this.purchaseItemEntityList,
      this.createUserName});

  String id = "";
  String shopId = "";
  String orderNo = "";
  int source = 4;
  String purchaseDate = "";
  String comment = "";
  String createUser = "";
  String createUserName = "";
  DateTime createTime = DateTime.now();
  String updateUser = "";
  DateTime updateTime = DateTime.now();
  List<PurchaseItemEntityList> purchaseItemEntityList =
      <PurchaseItemEntityList>[PurchaseItemEntityList()];

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
        id: json["id"],
        shopId: json["shopId"],
        orderNo: json["orderNo"],
        source: json["source"],
        purchaseDate: json["purchaseDate"],
        comment: json["comment"],
        createUser: json["createUser"],
        createUserName: json["createUserName"],
        createTime: DateTime.parse(json["createTime"]),
        updateUser: json["updateUser"],
        updateTime: DateTime.parse(json["updateTime"]),
        purchaseItemEntityList: List<PurchaseItemEntityList>.from(
            json["purchaseItemEntityList"]
                .map((x) => PurchaseItemEntityList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shopId": shopId,
        "orderNo": orderNo,
        "source": source,
        "purchaseDate": purchaseDate,
        "comment": comment,
        "createUser": createUser,
        "createUserName": createUserName,
        "createTime":
            "${createTime.year.toString().padLeft(4, '0')}-${createTime.month.toString().padLeft(2, '0')}-${createTime.day.toString().padLeft(2, '0')}",
        "updateUser": updateUser,
        "updateTime":
            "${updateTime.year.toString().padLeft(4, '0')}-${updateTime.month.toString().padLeft(2, '0')}-${updateTime.day.toString().padLeft(2, '0')}",
        "purchaseItemEntityList":
            List<dynamic>.from(purchaseItemEntityList.map((x) => x.toJson())),
      };
}

class PurchaseItemEntityList {
  PurchaseItemEntityList({
    this.id,
    this.purchaseId,
    this.shopGoodsId,
    this.buyPrice,
    this.count,
    this.instore,
    this.createUser,
    this.createTime,
    this.updateUser,
    this.updateTime,
    this.delFlg,
    this.stock,
    this.source,
    this.comment,
    this.purchaseDate,
    this.applyTo,
    this.picUrl,
    this.itemName,
    this.tbShopGoodsEntity,
  });

  String id = "";
  String purchaseId = "";
  String shopGoodsId = "";
  String purchaseDate = "";
  String comment = "";
  num buyPrice = 0;
  num count = 0;
  int instore = 0;
  String createUser = "";
  DateTime createTime = DateTime.now();
  String updateUser = "";
  DateTime updateTime = DateTime.now();
  int delFlg = 0;
  num stock = 0;
  int source = 0;
  String applyTo = "";
  String itemName = "";
  String picUrl =
      "http://bs-brother-bucket.oss-cn-zhangjiakou.aliyuncs.com/carfriend/1605257794522.jpg";
  dynamic tbShopGoodsEntity;
  TextEditingController buyPriceController = TextEditingController();
  TextEditingController countController = TextEditingController();

  factory PurchaseItemEntityList.fromJson(Map<String, dynamic> json) =>
      PurchaseItemEntityList(
        id: json["id"],
        purchaseId: json["purchaseId"],
        shopGoodsId: json["shopGoodsId"],
        buyPrice: json["buyPrice"],
        count: json["count"],
        instore: json["instore"],
        createUser: json["createUser"],
        createTime: DateTime.parse(json["createTime"]),
        updateUser: json["updateUser"],
        updateTime: DateTime.parse(json["updateTime"]),
        delFlg: json["delFlg"],
        stock: json["stock"],
        source: json["source"],
        applyTo: json["applyTo"],
        picUrl: json["picURL"],
        comment: json["comment"],
        purchaseDate: json["purchaseDate"],
        itemName: json["itemName"],
        tbShopGoodsEntity: json["tbShopGoodsEntity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "purchaseId": purchaseId,
        "shopGoodsId": shopGoodsId,
        "buyPrice": buyPrice,
        "count": count,
        "instore": instore,
        "createUser": createUser,
        "createTime": createTime.toIso8601String(),
        "updateUser": updateUser,
        "updateTime": updateTime.toIso8601String(),
        "delFlg": delFlg,
        "stock": stock,
        "source": source,
        "applyTo": applyTo,
        "picURL": picUrl,
        "itemName": itemName,
        "tbShopGoodsEntity": tbShopGoodsEntity,
      };
}

MaterialModel materialModelFromJson(String str) =>
    MaterialModel.fromJson(json.decode(str));

String materialModelToJson(MaterialModel data) => json.encode(data.toJson());

class MaterialModel {
  MaterialModel({
    this.id,
    this.workServiceId,
    this.workOrderId,
    this.itemGoodsId,
    this.materialName,
    this.itemMaterial,
    this.itemModel,
    this.itemUnit,
    this.itemNumber,
    this.itemPrice,
    this.partsCost,
    this.partsSource,
    this.purchaseSource,
    this.spec,
    this.creater,
    this.createDate,
    this.updater,
    this.updateDate,
  });

  String id = "";
  String workServiceId = "";
  String workOrderId = "";
  String materialName = "";
  String itemGoodsId = "";
  String itemMaterial = "";
  String itemModel = "";
  String itemUnit = "";
  num itemNumber = 1;
  num itemPrice = 1;
  num partsCost = 1;
  int partsSource = 1;

  dynamic purchaseSource = "";
  String spec = "";
  String creater = "";
  DateTime createDate = DateTime.now();
  String updater = "";
  DateTime updateDate = DateTime.now();

  factory MaterialModel.fromJson(Map<String, dynamic> json) => MaterialModel(
        id: json["id"],
        workServiceId: json["workServiceId"],
        workOrderId: json["workOrderId"],
        itemGoodsId: json["itemGoodsId"],
        materialName: json["materialName"],
        itemMaterial: json["itemMaterial"],
        itemModel: json["itemModel"],
        itemUnit: json["itemUnit"],
        itemNumber: json["itemNumber"],
        itemPrice: json["itemPrice"],
        partsCost: json["partsCost"],
        partsSource: json["partsSource"],
        purchaseSource: json["purchaseSource"],
        spec: json["spec"],
        creater: json["creater"],
        createDate: DateTime.parse(json["createDate"]),
        updater: json["updater"],
        updateDate: DateTime.parse(json["updateDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "workServiceId": workServiceId,
        "workOrderId": workOrderId,
        "materialName": materialName,
        "itemGoodsId": itemGoodsId,
        "itemMaterial": itemMaterial,
        "itemModel": itemModel,
        "itemUnit": itemUnit,
        "itemNumber": itemNumber,
        "itemPrice": itemPrice,
        "partsCost": partsCost,
        "partsSource": partsSource,
        "purchaseSource": purchaseSource,
        "spec": spec,
        "creater": creater,
        "createDate": createDate.toIso8601String(),
        "updater": updater,
        "updateDate": updateDate.toIso8601String(),
      };
}

StockModel stockModelFromJson(String str) =>
    StockModel.fromJson(json.decode(str));

String stockModelToJson(StockModel data) => json.encode(data.toJson());

class StockModel {
  StockModel({
    this.shopGoodsId,
    this.itemName,
    this.applyTo,
    this.picUrl,
    this.stock,
  });

  String shopGoodsId = "";
  String itemName = "";
  String applyTo = "";
  String picUrl =
      "http://bs-brother-bucket.oss-cn-zhangjiakou.aliyuncs.com/carfriend/1605257794522.jpg";
  num stock = 0;
  bool chooseFlag = false;
  num buyPrice = 0;
  num count = 0;
  TextEditingController buyPriceController = TextEditingController();
  TextEditingController countController = TextEditingController();

  factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
        shopGoodsId: json["shopGoodsId"],
        itemName: json["itemName"],
        applyTo: json["applyTo"],
        picUrl: json["picURL"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "shopGoodsId": shopGoodsId,
        "itemName": itemName,
        "applyTo": applyTo,
        "picURL": picUrl,
        "stock": stock,
      };
}
