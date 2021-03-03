class SpannerGoodsDetailsModel {

  ///地址
  final String address;
  ///卖方维度
  final String sellerLatitude;
  ///卖方经度
  final String sellerLongitude;
  ///买方地址
  final String buyerAddress;
  ///买方维度
  final String buyerLatitude;
  ///买方经度
  final String buyerLongitude;
  ///距离
  final String distance;
  ///商品名称
  final String goodsName;
  ///商品价格
  final String goodsPrice;
  ///详情图片
  final List infoPics;
  ///列表图
  final List listPics;
  ///型号
  final String model;
  ///商品详情
  final String remarks;
  ///共享价格
  final String sharePrice;
  ///共享ID
  final String shopGoodsId;
  ///商店ID
  final String shopId;
  ///店铺名
  final String shopName;
  ///规格
  final String specName;
  ///库存
  final String stock;
  ///库存数量
  final String shareStock;
  ///电话
  final String tel;
  ///置灰价格
  final String partsCost;
  ///本门店店名
  final String buyerShopName;


  SpannerGoodsDetailsModel({this.sellerLatitude = '', this.sellerLongitude = '', this.buyerAddress = '', this.buyerLatitude = '', this.buyerLongitude = '', this.partsCost = '', this.address = '', this.distance = '', this.goodsName = '', this.goodsPrice = '', this.infoPics, this.listPics, this.model = '', this.remarks = '', this.sharePrice = '', this.shopGoodsId = '', this.shopId = '', this.shopName = '', this.specName = '', this.stock = '', this.shareStock = '', this.tel = '', this.buyerShopName = ''});

  SpannerGoodsDetailsModel.fromJson(Map<String, dynamic> json):
        address = json['address'].toString() !=null ? json['address'].toString() : '',
        distance = json['distance'].toString() !=null ? json['distance'].toString() : '',
        goodsName = json['goodsName'].toString() !=null ? json['goodsName'].toString() : '',
        goodsPrice = json['goodsPrice'].toString() !=null ? json['goodsPrice'].toString() : '',
        infoPics = json['infoPics'] !=null ? json['infoPics'] : [],
        listPics = json['listPics'] !=null ? json['listPics'] : [],
        model = json['model'].toString() !=null ? json['model'].toString() : '',
        remarks = json['remarks'].toString() !=null ? json['remarks'].toString() : '',
        sharePrice = json['sharePrice'].toString() !=null ? json['sharePrice'].toString() : '',
        shopGoodsId = json['shopGoodsId'].toString() !=null ? json['shopGoodsId'].toString() : '',
        shopId = json['shopId'].toString() !=null ? json['shopId'].toString() : '',
        shopName = json['shopName'].toString() !=null ? json['shopName'].toString() : '',
        specName = json['specName'].toString() !=null ? json['specName'].toString() : '',
        shareStock = json['shareStock'].toString() !=null ? json['shareStock'].toString() : '',
        stock = json['stock'].toString() !=null ? json['stock'].toString() : '',
        tel = json['tel'].toString() !=null ? json['tel'].toString() : '',
        sellerLatitude = json['sellerLatitude'].toString() !=null ? json['sellerLatitude'].toString() : '',
        sellerLongitude = json['sellerLongitude'].toString() !=null ? json['sellerLongitude'].toString() : '',
        buyerAddress = json['buyerAddress'].toString() !=null ? json['buyerAddress'].toString() : '',
        buyerLatitude = json['buyerLatitude'].toString() !=null ? json['buyerLatitude'].toString() : '',
        buyerLongitude = json['buyerLongitude'].toString() !=null ? json['buyerLongitude'].toString() : '',
        partsCost = json['partsCost'].toString() !=null ? json['partsCost'].toString() : '',
        buyerShopName = json['buyerShopName'].toString() !=null ? json['buyerShopName'].toString() : ''
  ;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address'] = this.address;
    data['distance'] = this.distance;
    data['goodsName'] = this.goodsName;
    data['goodsPrice'] = this.goodsPrice;
    data['infoPics'] = this.infoPics;
    data['listPics'] = this.listPics;
    data['model'] = this.model;
    data['remarks'] = this.remarks;
    data['sharePrice'] = this.sharePrice;
    data['shopGoodsId'] = this.shopGoodsId;
    data['shopId'] = this.shopId;
    data['shopName'] = this.shopName;
    data['specName'] = this.specName;
    data['shareStock'] = this.shareStock;
    data['stock'] = this.stock;
    data['tel'] = this.tel;
    data['sellerLatitude'] = this.sellerLatitude;
    data['sellerLongitude'] = this.sellerLongitude;
    data['buyerAddress'] = this.buyerAddress;
    data['buyerLatitude'] = this.buyerLatitude;
    data['buyerLongitude'] = this.buyerLongitude;
    data['partsCost'] = this.partsCost;
    data['buyerShopName'] = this.buyerShopName;
    return data;
  }
}


class ShareShopDetailsSpecModel {
  ///所有关联关系
  final List data;
  ///所有规格
  final List specList;
  ///所有型号
  final List modelList;

  ShareShopDetailsSpecModel({this.data, this.specList, this.modelList});

  ShareShopDetailsSpecModel.fromJson(Map<String, dynamic> json):
        data = json['data'] !=null ? json['data'] : [],
        specList = json['specList'] !=null ? json['specList'] : [],
        modelList = json['modelList'] !=null ? json['modelList'] : [];

}