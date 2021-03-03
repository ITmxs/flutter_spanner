
class SSSubmitOrdersModel {

  ///商品数量
  final int number;
  ///单件价格
  final String price;
  ///总价
  final String allPrice;
  ///店名
  final String shopName;
  ///地址
  final String address;
  ///商品名
  final String goodsName;
  ///封面图
  final String pic;

  SSSubmitOrdersModel({this.number = 0, this.price = '', this.allPrice = '', this.shopName = '', this.address = '', this.goodsName = '', this.pic = ''});

}