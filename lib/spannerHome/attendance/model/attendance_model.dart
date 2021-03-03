// To parse this JSON data, do
//
//     final attendanceModel = attendanceModelFromJson(jsonString);

import 'dart:convert';

AttendanceModel attendanceModelFromJson(String str) =>
    AttendanceModel.fromJson(json.decode(str));

String attendanceModelToJson(AttendanceModel data) =>
    json.encode(data.toJson());

class AttendanceModel {
  AttendanceModel({
    this.attendanceRuleLists,
  });

  List<dynamic> attendanceRuleLists = <AttendanceRuleList>[];

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        attendanceRuleLists: List<AttendanceRuleList>.from(
            json["attendanceRuleLists"]
                .map((x) => AttendanceRuleList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "attendanceRuleLists":
            List<dynamic>.from(attendanceRuleLists.map((x) => x.toJson())),
      };
}

class AttendanceRuleList {
  AttendanceRuleList({
    this.inWorkTime,
    this.outWorkTime,
    this.attDtos,
    this.ruleId,
  });

  String inWorkTime = '';
  String outWorkTime = '';
  List<AttDto> attDtos = <AttDto>[];
  String ruleId = '';

  factory AttendanceRuleList.fromJson(Map<String, dynamic> json) =>
      AttendanceRuleList(
        inWorkTime: json["inWorkTime"],
        outWorkTime: json["outWorkTime"],
        attDtos:
            List<AttDto>.from(json["attDtos"].map((x) => AttDto.fromJson(x))),
        ruleId: json["ruleId"],
      );

  Map<String, dynamic> toJson() => {
        "inWorkTime": inWorkTime,
        "outWorkTime": outWorkTime,
        "attDtos": List<dynamic>.from(attDtos.map((x) => x.toJson())),
        "ruleId": ruleId,
      };
}

class AttDto {
  AttDto({
    this.groupName,
    this.groupId,
    this.personGroupList,
  });

  String groupName = '';
  String groupId = '';
  List<PersonGroupList> personGroupList = <PersonGroupList>[];

  factory AttDto.fromJson(Map<String, dynamic> json) => AttDto(
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

  String userName = '';
  String userId = '';

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
