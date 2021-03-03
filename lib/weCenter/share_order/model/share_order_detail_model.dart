
class ShareOrderDetailsModel {

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
  ///买方地址
  final String buyAddress;
  ///买方经度
  final String buyLongitude;
  ///买方纬度
  final String buyLatitude;
  ///买方店名
  final String buyShopName;




  ShareOrderDetailsModel({this.amount = '', this.count = '', this.deliveryTime = '--', this.distance = '', this.finishTime = '--', this.latitude = '', this.longitude = '', this.orderSn = '', this.paySn = '', this.payTime = '--', this.pickupCode = '', this.price = '', this.remarks = '', this.shopAddress = '', this.shopName = '', this.showName = '', this.tel = '', this.tradeId = '', this.tradeStatus = '', this.picUrl = '',this.buyAddress = '', this.buyLongitude = '', this.buyLatitude = '', this.buyShopName = ''});

  ShareOrderDetailsModel.fromJson(Map<String, dynamic> json):
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
        pickupCode = json['pickupCode'].toString() !=null ? json['pickupCode'].toString() : '',
        price = json['price'].toString() !=null ? json['price'].toString() : '',
        remarks = json['remarks'].toString() !=null ? json['remarks'].toString() : '',
        shopAddress = json['shopAddress'].toString() !=null ? json['shopAddress'].toString() : '',
        shopName = json['shopName'].toString() !=null ? json['shopName'].toString() : '',
        showName = json['showName'].toString() !=null ? json['showName'].toString() : '',
        tel = json['tel'].toString() !=null ? json['tel'].toString() : '',
        tradeId = json['tradeId'].toString() !=null ? json['tradeId'].toString() : '',
        tradeStatus = json['tradeStatus'].toString() !=null ? json['tradeStatus'].toString() : '',
        picUrl = json['picUrl'].toString() !=null ? json['picUrl'].toString() : '',
        buyAddress = json['buyAddress'].toString() !=null ? json['buyAddress'].toString() : '',
        buyLongitude = json['buyLongitude'].toString() !=null ? json['buyLongitude'].toString() : '',
        buyShopName = json['buyShopName'].toString() !=null ? json['buyShopName'].toString() : '',
        buyLatitude = json['buyLatitude'].toString() !=null ? json['buyLatitude'].toString() : '';
}