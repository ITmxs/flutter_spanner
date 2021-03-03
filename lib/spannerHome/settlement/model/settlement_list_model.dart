
class SettlementListModel {
  ///车牌号
  final String vehicleLicence;
  ///消费金额
  final String consumeAmount;
  ///预付金额
  final String prepaymentAmount;
  ///尾款金额
  final String balancePaymentAmount;
  ///实收金额
  final String finalPayment;
  ///订单编号
  final String orderSn;
  ///接车时间
  final String createDate;
  ///工单ID
  final String workOrderId;
  ///是否是会员0非会员1会员
  final String memberFlag;
  ///是否分红0未分红1以分红
  final String shareFlag;
  ///是否分红0未分红1以分红
  final String popShow;



  SettlementListModel({this.vehicleLicence, this.consumeAmount, this.prepaymentAmount, this.balancePaymentAmount, this.finalPayment, this.orderSn, this.createDate, this.workOrderId, this.memberFlag, this.shareFlag, this.popShow});

  SettlementListModel.fromJson(Map<String, dynamic> json):
        vehicleLicence = json['vehicleLicence'].toString(),
        consumeAmount = json['consumeAmount'].toString(),
        prepaymentAmount = json['prepaymentAmount'].toString(),
        balancePaymentAmount = json['balancePaymentAmount'].toString(),
        finalPayment = json['finalPayment'].toString(),
        orderSn = json['orderSn'].toString(),
        createDate = json['createDate'].toString(),
        workOrderId = json['workOrderId'].toString(),
        memberFlag = json['memberFlag'].toString(),
        shareFlag = json['shareFlag'].toString(),
  popShow = json['popShow'].toString()
  ;

}