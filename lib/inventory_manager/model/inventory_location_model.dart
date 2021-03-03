
class InventoryLocationModel {
  ///名称
  final String name;
  ///标签ID
  final String id;

  InventoryLocationModel.fromJson(Map<String, dynamic> json):
        name = json['name'].toString() != null ? json['name'].toString():'',
        id = json['id'].toString() != null ? json['id'].toString():'';

}