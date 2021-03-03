
class ShareShopModel {

  ///ID
  final String id;
  ///标题
  final String name;
  ///图片
  final String picUrl;
  ///店名
  final String shopName;
  ///距离
  final String distance;
  ///入手价格
  final String goodPrise;
  ///零售价格
  final String sharePrice;
  ///服务详情
  final String remark;

  ShareShopModel({this.id = '', this.name = '', this.picUrl = '', this.shopName = '', this.distance = '', this.goodPrise = '', this.sharePrice = '', this.remark = ''});

  ShareShopModel.fromJson(Map<String, dynamic> json):
        id = json['id'].toString() !=null ? json['id'].toString() : '',
        name = json['name'].toString() !=null ? json['name'].toString() : '',
        picUrl = json['picUrl'].toString() !=null ? json['picUrl'].toString() : '',
        shopName = json['shopName'].toString() !=null ? json['shopName'].toString() : '',
        distance = json['distance'].toString() !=null ? json['distance'].toString() : '',
        goodPrise = json['goodPrise'].toString() !=null ? json['goodPrise'].toString() : '',
        sharePrice = json['sharePrice'].toString() !=null ? json['sharePrice'].toString() : '',
        remark = json['remark'].toString() !=null ? json['remark'].toString() : '';
}