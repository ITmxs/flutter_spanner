
class StoreOrderModel {

  ///商品数量
  final String count;
  ///单件价格
  final String payAmount;
  ///总价
  final String money;
  ///店名
  final String goodsName;
  ///订单ID
  final String orderId;
  ///订单号
  final String orderSn;
  ///封面图
  final String primaryPicUrl;
  ///交易ID
  final String tradeId;
  ///备注
  final String remark;
  ///电话
  final String tel;

  StoreOrderModel({this.count = '', this.payAmount = '', this.money = '', this.goodsName = '', this.orderId = '', this.orderSn = '', this.primaryPicUrl = '', this.tradeId = '', this.remark = '', this.tel = '',});

  StoreOrderModel.fromJson(Map<String, dynamic> json):
        count = json['count'].toString() !=null ? json['count'].toString() : '',
        payAmount = json['payAmount'].toString() !=null ? json['payAmount'].toString() : '',
        money = json['money'].toString() !=null ? json['money'].toString() : '',
        goodsName = json['goodsName'].toString() !=null ? json['goodsName'].toString() : '',
        orderId = json['orderId'].toString() !=null ? json['orderId'].toString() : '',
        orderSn = json['orderSn'].toString() !=null ? json['orderSn'].toString() : '',
        primaryPicUrl = json['primaryPicUrl'].toString() !=null ? json['primaryPicUrl'].toString() : '',
        tradeId = json['tradeId'].toString() !=null ? json['tradeId'].toString() : '',
        remark = json['remark'].toString() !=null ? json['remark'].toString() : '',
        tel = json['tel'].toString() !=null ? json['tel'].toString() : '';
}