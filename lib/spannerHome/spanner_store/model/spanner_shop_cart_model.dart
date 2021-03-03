
class SpannerShopCartModel {

  ///购物车id
  final String cartId;
  ///商品ID
  final String shopGoodsId;
  ///名称
  final String name;
  ///数量
  final String count;
  ///价格
  final String price;
  ///封面图
  final String picUrl;
  ///电话号
  final String sellTel;
  ///本店名
  final String buyerShopName;
  ///本店地址
  final String buyerShopAddress;

  SpannerShopCartModel({this.cartId, this.shopGoodsId, this.name = '', this.count = '', this.price = '', this.picUrl = '', this.sellTel = '', this.buyerShopName = '', this.buyerShopAddress = ''});

  SpannerShopCartModel.fromJson(Map<String, dynamic> json):
        cartId = json['cartId'].toString() !=null ? json['cartId'].toString() : '',
        shopGoodsId = json['shopGoodsId'].toString() !=null ? json['shopGoodsId'].toString() : '',
        name = json['name'].toString() !=null ? json['name'].toString() : '',
        count = json['count'].toString() !=null ? json['count'].toString() : '',
        price = json['price'].toString() !=null ? json['price'].toString() : '',
        sellTel = json['sellTel'].toString() !=null ? json['sellTel'].toString() : '',
        buyerShopName = json['buyerShopName'].toString() !=null ? json['buyerShopName'].toString() : '',
        buyerShopAddress = json['buyerShopAddress'].toString() !=null ? json['buyerShopAddress'].toString() : '',
        picUrl = json['picUrl'].toString() !=null ? json['picUrl'].toString() : '';

}