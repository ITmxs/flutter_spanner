
class ShareShopServiceModel {

  ///所属项目
  final String belongName;
  ///价格
  final String price;
  ///项目名称
  final String projectName;
  ///描述
  final String remark;
  ///地址
  final String shopAddress;
  ///店名
  final String shopName;
  ///电话
  final String tel;

  ShareShopServiceModel({this.belongName = '', this.price = '', this.projectName = '', this.remark = '', this.shopAddress = '', this.shopName = '', this.tel = ''});

  ShareShopServiceModel.fromJson(Map<String, dynamic> json):
        belongName = json['belongName'].toString() !=null ? json['belongName'].toString() : '',
        price = json['price'].toString() !=null ? json['price'].toString() : '',
        projectName = json['projectName'].toString() !=null ? json['projectName'].toString() : '',
        remark = json['remark'].toString() !=null ? json['remark'].toString() : '',
        shopAddress = json['shopAddress'].toString() !=null ? json['shopAddress'].toString() : '',
        shopName = json['shopName'].toString() !=null ? json['shopName'].toString() : '',
        tel = json['tel'].toString() !=null ? json['tel'].toString() : '';
}