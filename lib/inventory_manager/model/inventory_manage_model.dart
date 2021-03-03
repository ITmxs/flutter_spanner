

class InventoryManageTypeModel {
  ///名称
  final String name;
  ///标签ID
  final String id;
  ///数量
  final String num;

  InventoryManageTypeModel.fromJson(Map<String, dynamic> json):
        name = json['name'].toString() != null ? json['name'].toString():'',
        id = json['id'].toString() != null ? json['id'].toString():'',
        num = json['num'].toString() != null ? json['num'].toString():'';

}

class InventoryManageContentListModel {

  ///商品ID¥
  final String goodsId;
  ///商品名
  final String goodsName;
  ///商品图片
  final String primaryPicUrl;
  ///适用车型
  final String applyto;
  ///标签ID
  final String categoryId;
  ///库存数量
  final String stock;
  ///商品唯一ID
  final String shopGoodsId;
  ///共享非共享判断
  final bool shareFlag;

  InventoryManageContentListModel.fromJson(Map<String, dynamic> json):
        goodsId = json['goodsId'].toString() != null ? json['goodsId'].toString():'',
        goodsName = json['goodsName'].toString() != null ? json['goodsName'].toString():'',
        primaryPicUrl = json['primaryPicUrl'].toString() != null ? json['primaryPicUrl'].toString():'',
        applyto = json['applyto'].toString() != null ? json['applyto'].toString():'',
        categoryId = json['categoryId'].toString() != null ? json['categoryId'].toString():'',
        stock = json['stock'].toString() != null ? json['stock'].toString():'',
        shopGoodsId = json['shopGoodsId'].toString() != null ? json['shopGoodsId'].toString():'',
        shareFlag = json['shareFlag'].toString() == 'true'?true:false;
}