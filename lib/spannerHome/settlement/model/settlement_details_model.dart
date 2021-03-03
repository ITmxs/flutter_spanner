

class SettlementDetailsUserInfoModel {
  ///名称
  String realName;
  ///余额
  String accountBalances;
  ///车辆型号
  String model;
  ///车号
  String brand;
  ///背景颜色类型1 = 绿色 2 蓝色
  String type;


  SettlementDetailsUserInfoModel({this.realName = '', this.accountBalances = '', this.model = '', this.brand = '', this.type = '',});

  SettlementDetailsUserInfoModel.fromJson(Map<String, dynamic> json)
      : realName = json['realName'] != null ? json['realName'].toString():'',
        accountBalances = json['accountBalances'] != null ? json['accountBalances'].toString() : '',
        model = json['model'] != null ? json['model'].toString() : '',
        brand = json['brand'] != null ? json['brand'].toString() : '';
}