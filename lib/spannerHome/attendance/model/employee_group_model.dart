/// Copyright (C), 2015-2020, spanners
/// FileName: employee_group_model
/// Author: Jack
/// Date: 2020/11/26
/// Description:
// To parse this JSON data, do
//
//     final employByGroupModel = employByGroupModelFromJson(jsonString);

import 'dart:convert';

List<EmployByGroupModel> employByGroupModelFromJson(String str) =>
    List<EmployByGroupModel>.from(
        json.decode(str).map((x) => EmployByGroupModel.fromJson(x)));

String employByGroupModelToJson(List<EmployByGroupModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployByGroupModel {
  EmployByGroupModel({
    this.groupName,
    this.groupId,
    this.personGroupList,
  });

  String groupName = "";
  String groupId = "";
  bool chooseFlag = false;
  bool showFlag = true;
  List<PersonGroupList> personGroupList = <PersonGroupList>[];

  factory EmployByGroupModel.fromJson(Map<String, dynamic> json) =>
      EmployByGroupModel(
        groupName: json["groupName"],
        groupId: json["groupId"],
        personGroupList: List<PersonGroupList>.from(
            json["personGroupList"].map((x) => PersonGroupList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "groupName": groupName,
        "groupId": groupId,
        "personGroupList":
            List<dynamic>.from(personGroupList.map((x) => x.toJson())),
      };
}

class PersonGroupList {
  PersonGroupList({
    this.userName,
    this.userId,
  });

  String userName = "";
  String userId = "";
  bool chooseFlag = false;

  factory PersonGroupList.fromJson(Map<String, dynamic> json) =>
      PersonGroupList(
        userName: json["userName"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userId": userId,
      };
}
