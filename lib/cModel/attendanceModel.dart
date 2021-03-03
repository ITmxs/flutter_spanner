/*
考勤分析 model
*/
class AttendanceModel {
  final String userName; //--->姓名
  final String onWorkTime; //---> 上班打卡
  final String outWorkTime; //--->下班打卡
  final String onWorkFlg; //--->上班打卡状态 （0:正常 1:缺卡 2:迟到）
  final String outWorkFlg; //--->下班打卡状态 （0:正常 1:缺卡 2:早退）
  final String id; //--->员工ID
  final String picUrl; //--->图片地址

  AttendanceModel(this.userName, this.onWorkTime, this.outWorkTime,
      this.onWorkFlg, this.outWorkFlg, this.id, this.picUrl);
  AttendanceModel.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        onWorkTime = json['onWorkTime'],
        outWorkTime = json['outWorkTime'],
        onWorkFlg = json['onWorkFlg'],
        outWorkFlg = json['outWorkFlg'],
        id = json['id'],
        picUrl = json['picUrl'];
  Map<String, dynamic> toJso(n) => {
        'userName': userName,
        'onWorkTime': onWorkTime,
        'outWorkTime': outWorkTime,
        'onWorkFlg': onWorkFlg,
        'outWorkFlg': outWorkFlg,
        'id': id,
        'picUrl': picUrl,
      };
}
