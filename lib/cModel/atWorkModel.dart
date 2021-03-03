/*
  派工 列表 model
*/
class AtworkFirstModel {
  final String vehicleLicence; //--->车牌号

  AtworkFirstModel(this.vehicleLicence);
  AtworkFirstModel.fromJson(Map<String, dynamic> json)
      : vehicleLicence = json['vehicleLicence'];
  Map<String, dynamic> toJso(n) => {
        'vehicleLicence': vehicleLicence,
      };
}

class AtworkTwoModel {
  final String secondaryService; //--->服务名称
  final double nums;
  AtworkTwoModel(this.secondaryService, this.nums);
  AtworkTwoModel.fromJson(Map<String, dynamic> json)
      : nums = json['num'],
        secondaryService = json['secondaryService'];
  Map<String, dynamic> toJso(n) => {
        'secondaryService': secondaryService,
        'num': nums,
      };
}

class AtworkThreeModel {
  final String goodsName; //--->配件名称
  final String itemNumber; //--->配件数量
  AtworkThreeModel(this.goodsName, this.itemNumber);
  AtworkThreeModel.fromJson(Map<String, dynamic> json)
      : itemNumber = json['itemNumber'].toString(),
        goodsName = json['itemMaterial'];
  Map<String, dynamic> toJso(n) => {
        'itemNumber': itemNumber,
        'itemMaterial': goodsName,
      };
}
