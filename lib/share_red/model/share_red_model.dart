
class ShareRedServiceModel {

  ///服务名
  final String secondaryService;
  ///服务ID
  final String serviceId;
  ///价格
  final String price;
  ///数量
  final String num;
  ///总价
  final String totalPrices;
  ///人员ID
  final String executorId;
  ///人员名
  final String executorName;
  ///shopID
  final String shopId;
  ///workOrderId
  final String workOrderId;
  ///分红
  String bonus;
  ///配件数组
  final List materialList;
  ///车牌号
  final String vehicleLicence;
  ///配件model数组
  List materialModelList;

  ShareRedServiceModel({this.secondaryService, this.serviceId, this.price, this.num, this.totalPrices, this.executorId, this.executorName, this.bonus, this.materialList, this.vehicleLicence, this.shopId, this.workOrderId,});

  ShareRedServiceModel.fromJson(Map<String, dynamic> json):
        secondaryService = json['secondaryService'].toString() != null ? json['secondaryService'].toString():'',
        serviceId = json['serviceId'].toString() != null ? json['serviceId'].toString():'',
        price = json['price'].toString() != null ? json['price'].toString():'',
        num = json['num'].toString() != null ? json['num'].toString():'',
        totalPrices = json['totalPrices'].toString() != null ? json['totalPrices'].toString():'',
        executorId = json['executorId'].toString() != null ? json['executorId'].toString():'',
        executorName = json['executorName'].toString() != null ? json['executorName'].toString():'',
        bonus = json['bonus'].toString() != null ? json['bonus'].toString():'',
        materialList = json['materialList']!= null ? json['materialList']:[],
        vehicleLicence = json['vehicleLicence']!= null ? json['vehicleLicence']:[],
        shopId = json['shopId'].toString() != null ? json['shopId'].toString():'',
        workOrderId = json['workOrderId'].toString() != null ? json['workOrderId'].toString():'';

  setMaterialList(){
    materialModelList = [];
    materialList.forEach((element) {
      materialModelList.add(ShareRedMaterialModel.fromJson(element));
    });
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['secondaryService'] = this.secondaryService;
    data['serviceId'] = this.serviceId;
    data['price'] = this.price;
    data['num'] = this.num;
    data['totalPrices'] = this.totalPrices;
    data['executorId'] = this.executorId;
    data['executorName'] = this.executorName;
    data['bonus'] = this.bonus;
    data['shopId'] = this.shopId;
    data['workOrderId'] = this.workOrderId;
    List mapList = [];
    this.materialModelList.forEach((element) {
      ShareRedMaterialModel model = element;
      mapList.add(model.toJson());
    });
    data['materialList'] = mapList;
    return data;
  }

}

class ShareRedMaterialModel {

  ///配件Id
  final String materialId;
  ///配件名
  final String itemMaterial;
  ///单价
  final String itemPrice;
  ///数量
  final String num;
  ///总价
  final String totalCost;
  ///分红
  String bonus;
  ///分红人ID
  String memberID;
  ///分红人
  String memberName;

  ShareRedMaterialModel.fromJson(Map<String, dynamic> json):
        materialId = json['materialId'].toString() != null ? json['materialId'].toString():'',
        itemMaterial = json['itemMaterial'].toString() != null ? json['itemMaterial'].toString():'',
        itemPrice = json['itemPrice'] != null ? json['itemPrice'].toString():'0',
        num = json['num'] != null ? json['num'].toString():'0',
        totalCost = json['totalCost'].toString() != null ? json['totalCost'].toString():'',
        bonus = json['bonus'].toString() != null ? json['bonus'].toString():'',
        memberID = json['memberID'].toString() != null ? json['memberID'].toString():'';

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['materialId'] = this.materialId;
    data['itemMaterial'] = this.itemMaterial;
    data['itemPrice'] = this.itemPrice;
    data['num'] = this.num;
    data['totalCost'] = this.totalCost;
    data['bonus'] = this.bonus;
    data['memberID'] = this.memberID;
    return data;
  }

}