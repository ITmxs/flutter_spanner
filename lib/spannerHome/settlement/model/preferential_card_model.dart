
class PreferentialCardModel {

  ///价值金额
  final String buyPrice;
  ///结束日期
  final String endTime;
  ///服务ID
  final String serviceId;
  ///卡名
  final String campaignName;
  ///优惠卡服务ID
  final String campaignServiceId;
  ///详情
  final String remarks;
  ///详情次数
  final String frequency;

  PreferentialCardModel({this.buyPrice = '', this.endTime = '', this.serviceId = '', this.campaignName = '', this.remarks = '', this.frequency = '', this.campaignServiceId = ''});

  PreferentialCardModel.fromJson(Map<String, dynamic> json):
        buyPrice = json['buyPrice'].toString(),
        endTime = json['endTime'].toString(),
        serviceId = json['serviceId'].toString(),
        campaignName = json['campaignName'].toString(),
        remarks = json['remarks'].toString(),
        frequency = json['frequency'].toString(),
        campaignServiceId = json['campaignServiceId'].toString();
}