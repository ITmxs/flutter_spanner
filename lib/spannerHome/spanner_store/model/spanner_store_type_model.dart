
class SpannerStoreTypeListModel {
  ///ID
  final String id;
  ///名称
  final String name;
  ///商品价格
  final String goodPrise;
  ///灰色价格
  final String partsCost;
  ///商品图片
  final String picUrl;


  SpannerStoreTypeListModel({this.id = '', this.name = '', this.goodPrise = '', this.partsCost = '', this.picUrl = ''});

  SpannerStoreTypeListModel.fromJson(Map<String, dynamic> json):
        id = json['id'].toString() !=null ? json['id'].toString() : '',
        name = json['name'].toString() !=null ? json['name'].toString() : '',
        goodPrise = json['goodPrise'].toString() !=null ? json['goodPrise'].toString() : '',
        partsCost = json['partsCost'].toString() !=null ? json['partsCost'].toString() : '',
        picUrl = json['picUrl'].toString() !=null ? json['picUrl'].toString() : '';
}