
class StoreOrderDetailsModel {

  ///合计金额
  final String amount;
  ///购买数量
  final String count;
  ///收货时间
  final String deliveryTime;
  ///距离
  final String distance;
  ///完成时间
  final String finishTime;
  ///店铺维度
  final String latitude;
  ///店铺经度
  final String longitude;
  ///订单编号
  final String orderSn;
  ///支付宝(微信)交易号
  final String paySn;
  ///付款时间
  final String payTime;
  ///创建时间
  final String createTime;
  ///取货码
  final String pickupCode;
  ///单价
  final String price;
  ///订单备注
  final String remarks;
  ///店铺地址
  final String shopAddress;
  ///店铺名称
  final String shopName;
  ///名称规格型号
  final String showName;
  ///店铺电话
  final String tel;
  ///订单号
  final String tradeId;
  ///订单状态
  final String tradeStatus;
  ///详情图
  final String picUrl;



  StoreOrderDetailsModel({this.amount = '', this.count = '', this.deliveryTime = '--', this.distance = '', this.finishTime = '--', this.latitude = '', this.longitude = '', this.orderSn = '', this.paySn = '', this.payTime = '--', this.createTime = '--', this.pickupCode = '', this.price = '', this.remarks = '', this.shopAddress = '', this.shopName = '', this.showName = '', this.tel = '', this.tradeId = '', this.tradeStatus = '', this.picUrl = ''});

  StoreOrderDetailsModel.fromJson(Map<String, dynamic> json):
        amount = json['amount'].toString() !=null ? json['amount'].toString() : '',
        count = json['count'].toString() !=null ? json['count'].toString() : '',
        deliveryTime = json['deliveryTime'] !=null ? json['deliveryTime'].toString() : '--',
        distance = json['distance'].toString() !=null ? json['distance'].toString() : '',
        finishTime = json['finishTime'] !=null ? json['finishTime'].toString() : '--',
        latitude = json['latitude'].toString() !=null ? json['latitude'].toString() : '',
        longitude = json['longitude'].toString() !=null ? json['longitude'].toString() : '',
        orderSn = json['orderSn'].toString() !=null ? json['orderSn'].toString() : '',
        paySn = json['paySn'].toString() !=null ? json['paySn'].toString() : '',
        payTime = json['payTime'] !=null ? json['payTime'].toString() : '--',
        createTime = json['createTime'].toString() !=null ? json['createTime'].toString() : '--',
        pickupCode = json['pickupCode'].toString() !=null ? json['pickupCode'].toString() : '',
        price = json['price'].toString() !=null ? json['price'].toString() : '',
        remarks = json['remarks'].toString() !=null ? json['remarks'].toString() : '',
        shopAddress = json['shopAddress'].toString() !=null ? json['shopAddress'].toString() : '',
        shopName = json['shopName'].toString() !=null ? json['shopName'].toString() : '',
        showName = json['showName'].toString() !=null ? json['showName'].toString() : '',
        tel = json['tel'].toString() !=null ? json['tel'].toString() : '',
        tradeId = json['tradeId'].toString() !=null ? json['tradeId'].toString() : '',
        tradeStatus = json['tradeStatus'].toString() !=null ? json['tradeStatus'].toString() : '',
        picUrl = json['picUrl'].toString() != null ? json['picUrl'].toString() : '';
}