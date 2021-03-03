
class InventoryGoodsTypeModel {
  ///名称
  final String name;
  ///标签ID
  final String id;
  ///数量
  final String num;

  InventoryGoodsTypeModel.fromJson(Map<String, dynamic> json):
        name = json['name'].toString() != null ? json['name'].toString():'',
        id = json['id'].toString() != null ? json['id'].toString():'',
        num = json['num'].toString() != null ? json['num'].toString():'';

}