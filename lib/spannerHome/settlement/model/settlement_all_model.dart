
class SettlementAllModel {

  ///消费金额
  String consumeAmount = '0';
  ///预付金额
  String prepaymentAmount = '0';
  ///优惠卡金额
  String disCountAmount = '0';
  ///尾款总金额
  String totalAmount = '0';
  ///用户信息
  String realName = '';
  ///订单数量
  String orderCount = '0';
  ///会员标识
  String memberFlag = '0';

  SettlementAllModel();

  SettlementAllModel.fromJson(Map<String, dynamic> json)
      : consumeAmount = json['consumeAmount'] != null ? json['consumeAmount'].toString():'',
        prepaymentAmount = json['prepaymentAmount'] != null ? json['prepaymentAmount'].toString() : '',
        disCountAmount = json['disCountAmount'] != null ? json['disCountAmount'].toString() : '',
        totalAmount = json['totalAmount'] != null ? json['totalAmount'].toString() : '',
        realName = json['realName'] != null ? json['realName'].toString() : '',
        orderCount = json['orderCount'] != null ? json['orderCount'].toString() : '',
        memberFlag = json['memberFlag'] != null ? json['memberFlag'].toString() : '';
}