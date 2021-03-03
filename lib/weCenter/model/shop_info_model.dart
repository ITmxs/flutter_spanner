/// Copyright (C), 2015-2020, spanners
/// FileName: shop_info_model
/// Author: Jack
/// Date: 2020/12/3
/// Description:
// To parse this JSON data, do
//
//     final shopInfoModel = shopInfoModelFromJson(jsonString);

import 'dart:convert';

ShopInfoModel shopInfoModelFromJson(String str) =>
    ShopInfoModel.fromJson(json.decode(str));

String shopInfoModelToJson(ShopInfoModel data) => json.encode(data.toJson());

class ShopInfoModel {
  ShopInfoModel({
    this.id,
    this.shopname,
    this.logo,
    this.provinceId,
    this.cityId,
    this.countyId,
    this.address,
    this.type,
    this.tel,
    this.mobile,
    this.faildResion,
    this.delFlag,
    this.createUser,
    this.createTime,
    this.updUser,
    this.updTime,
    this.provinceName,
    this.cityName,
    this.countyName,
    this.shopkeeperName,
    this.shopkeeperId,
    this.startDate,
    this.endDate,
    this.realName,
    this.longitude,
    this.latitude,
    this.idcard,
  });

  String id = "";
  String shopname = "";
  dynamic logo = "";
  String provinceId = "";
  String cityId = "";
  String countyId = "";
  String address = "";
  String type = "";
  dynamic tel = "";
  String mobile = "";
  dynamic faildResion = "";
  int delFlag = 0;
  dynamic createUser = "";
  DateTime createTime = DateTime.now();
  dynamic updUser = "";
  DateTime updTime = DateTime.now();
  String provinceName = "";
  String cityName = "";
  String countyName = "";
  String shopkeeperName = "";
  dynamic shopkeeperId = "";
  dynamic startDate = "";
  dynamic endDate = "";
  String realName = "";
  dynamic longitude = "";
  dynamic latitude = "";
  dynamic idcard = "";

  factory ShopInfoModel.fromJson(Map<String, dynamic> json) => ShopInfoModel(
        id: json["id"],
        shopname: json["shopname"],
        logo: json["logo"],
        provinceId: json["provinceId"],
        cityId: json["cityId"],
        countyId: json["countyId"],
        address: json["address"],
        type: json["type"],
        tel: json["tel"],
        mobile: json["mobile"],
        faildResion: json["faildResion"],
        delFlag: json["delFlag"],
        createUser: json["createUser"],
        createTime: DateTime.parse(json["createTime"]),
        updUser: json["updUser"],
        updTime: DateTime.parse(json["updTime"]),
        provinceName: json["provinceName"],
        cityName: json["cityName"],
        countyName: json["countyName"],
        shopkeeperName: json["shopkeeperName"],
        shopkeeperId: json["shopkeeperId"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        realName: json["realName"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        idcard: json["idcard"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shopname": shopname,
        "logo": logo,
        "provinceId": provinceId,
        "cityId": cityId,
        "countyId": countyId,
        "address": address,
        "type": type,
        "tel": tel,
        "mobile": mobile,
        "faildResion": faildResion,
        "delFlag": delFlag,
        "createUser": createUser,
        "createTime": createTime.toIso8601String(),
        "updUser": updUser,
        "updTime": updTime.toIso8601String(),
        "provinceName": provinceName,
        "cityName": cityName,
        "countyName": countyName,
        "shopkeeperName": shopkeeperName,
        "shopkeeperId": shopkeeperId,
        "startDate": startDate,
        "endDate": endDate,
        "realName": realName,
        "longitude": longitude,
        "latitude": latitude,
        "idcard": idcard,
      };
}
