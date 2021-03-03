
class ShareShopOtherDetailsModel {

  ///地址
  final String address;
  ///距离
  final String distance;
  ///设备ID
  final String equipmentId;
  ///设备名
  final String equipmentName;
  ///详情图片
  final List infoPics;
  ///维度
  final String latitude;
  ///经度
  final String longitude;
  ///型号
  final String model;
  ///商品详情
  final String remarks;
  ///共享价格
  final String sharePrice;
  ///商店ID
  final String shopId;
  ///店铺名
  final String shopName;
  ///规格
  final String specName;
  ///电话
  final String tel;
  ///商品藐视
  final String shareDescription;

  ShareShopOtherDetailsModel({this.address = '', this.distance = '', this.equipmentId = '', this.equipmentName = '', this.infoPics, this.latitude = '', this.longitude = '', this.model = '', this.remarks = '', this.sharePrice = '', this.shopId = '', this.shopName = '', this.specName = '', this.tel = '', this.shareDescription = ''});

  ShareShopOtherDetailsModel.fromJson(Map<String, dynamic> json):
        address = json['address'].toString() !=null ? json['address'].toString() : '',
        distance = json['distance'].toString() !=null ? json['distance'].toString() : '',
        equipmentId = json['equipmentId'].toString() !=null ? json['equipmentId'].toString() : '',
        equipmentName = json['equipmentName'].toString() !=null ? json['equipmentName'].toString() : '',
        infoPics = json['infoPics'] !=null ? json['infoPics'] : [],
        latitude = json['latitude'].toString() !=null ? json['latitude'].toString() : '',
        longitude = json['longitude'].toString() !=null ? json['longitude'].toString() : '',
        model = json['model'].toString() !=null ? json['model'].toString() : '',
        remarks = json['remarks'].toString() !=null ? json['remarks'].toString() : '',
        sharePrice = json['sharePrice'].toString() !=null ? json['sharePrice'].toString() : '',
        shopId = json['shopId'].toString() !=null ? json['shopId'].toString() : '',
        shopName = json['shopName'].toString() !=null ? json['shopName'].toString() : '',
        specName = json['specName'].toString() !=null ? json['specName'].toString() : '',
        tel = json['tel'].toString() !=null ? json['tel'].toString() : '',
        shareDescription = json['shareDescription'].toString() !=null ? json['shareDescription'].toString() : '';
}