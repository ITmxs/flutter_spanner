
class ShareGoodsOrderModel {

  ///ID
  final String tradeId;
  ///店铺名
  final String shopName;
  ///商品名
  final String showName;
  ///单价
  final String price;
  ///订单ID
  final String orderId;
  ///数量
  final String count;
  ///总价
  final String amount;
  ///取货码
  final String pickupCode;
  ///图片
  final String picUrl;

  ShareGoodsOrderModel({this.tradeId = '', this.shopName = '', this.showName = '', this.price = '', this.count = '', this.amount = '', this.pickupCode = '', this.orderId = '', this.picUrl = ''});

  ShareGoodsOrderModel.fromJson(Map<String, dynamic> json):
        tradeId = json['tradeId'].toString() !=null ? json['tradeId'].toString() : '',
        shopName = json['shopName'].toString() !=null ? json['shopName'].toString() : '',
        showName = json['showName'].toString() !=null ? json['showName'].toString() : '',
        price = json['price'].toString() !=null ? json['price'].toString() : '',
        count = json['count'].toString() !=null ? json['count'].toString() : '',
        amount = json['amount'].toString() !=null ? json['amount'].toString() : '',
        orderId = json['orderId'].toString() !=null ? json['orderId'].toString() : '',
        picUrl = json['picUrl'].toString() !=null ? json['picUrl'].toString() : '',
        pickupCode = json['pickupCode'].toString() !=null ? json['pickupCode'].toString() : '';
}