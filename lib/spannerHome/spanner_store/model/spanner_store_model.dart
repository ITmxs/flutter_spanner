

class SpannerStoreTypeModel {
  ///ID
  final String id;
  ///分类
  final String name;

  SpannerStoreTypeModel({this.id = '', this.name = '',});

  SpannerStoreTypeModel.fromJson(Map<String, dynamic> json):
        id = json['id'].toString() !=null ? json['id'].toString() : '',
        name = json['name'].toString() !=null ? json['name'].toString() : '';
}

class SpannerStoreContentModel {
  ///ID
  final String id;
  ///分类
  final String name;
  ///分类ID
  final String parentId;
  ///图片
  final String picUrl;

  SpannerStoreContentModel({this.id = '', this.name = '', this.parentId = '', this.picUrl = '',});

  SpannerStoreContentModel.fromJson(Map<String, dynamic> json):
        id = json['id'].toString() !=null ? json['id'].toString() : '',
        name = json['name'].toString() !=null ? json['name'].toString() : '',
        parentId = json['parentId'].toString() !=null ? json['parentId'].toString() : '',
        picUrl = json['picUrl'].toString() !=null ? json['picUrl'].toString() : '';
}