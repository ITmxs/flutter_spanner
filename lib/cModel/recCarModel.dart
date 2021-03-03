/*
   接车 二级联动 model 定义
*/
class RecCarModel {
  final String id; //---> 分类ID
  final String dictName; //---> 分类名称
  final String cost; //---> 项目单价

  RecCarModel(this.id, this.dictName, this.cost);
  RecCarModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dictName = json['secondaryDictName'],
        cost = json['cost'].toString();
  Map<String, dynamic> toJson() =>
      {'id': id, 'secondaryDictName': dictName, 'cost': cost};
}

class MaterCarModel {
  final String itemGoodsId; //---> 配件名称ID
  final String itemMaterial; //---> 配件名称
  final String itemModel; //---> 配件型号
  final String spec; //---> 配件规格
  final String itemPrice; //---> 单价
  final String partsCost; //---> 成本价
  MaterCarModel(this.itemGoodsId, this.itemMaterial, this.itemModel, this.spec,
      this.itemPrice, this.partsCost);
  MaterCarModel.fromJson(Map<String, dynamic> json)
      : itemGoodsId = json['shopGoodsId'].toString(),
        itemMaterial = json['goodsName'].toString(),
        itemModel = json['model'].toString(),
        spec = json['specName'].toString(),
        itemPrice = json['goodsPrice'].toString(),
        partsCost = json['partsCost'].toString();
  Map<String, dynamic> toJson() => {
        'shopGoodsId': itemGoodsId,
        'goodsName': itemMaterial,
        'model': itemModel,
        'specName': spec,
        'goodsPrice': itemPrice,
        'partsCost': partsCost
      };
}

/*
   接车 看板 model
*/
class RecCarListModel {
  final String workOrderId; //--->
  final String vehicleLicence; //---> 车牌号
  final String createDate; //---> 时间
  final String status; //为2 时 展示 客户确认中

  RecCarListModel(
      this.workOrderId, this.vehicleLicence, this.createDate, this.status);
  RecCarListModel.fromJson(Map<String, dynamic> json)
      : workOrderId = json['workOrderId'],
        vehicleLicence = json['vehicleLicence'],
        status = json['status'].toString(),
        createDate = json['createDate'];
  Map<String, dynamic> toJson() => {
        'workOrderId': workOrderId,
        'vehicleLicence': vehicleLicence,
        'status': status,
        'createDate': createDate
      };
}

class RecCarSerModel {
  final String serviceName; //--->名称
  final String nums; //---> 个数
  final String price; //---> 钱

  RecCarSerModel(this.serviceName, this.nums, this.price);
  RecCarSerModel.fromJson(Map<String, dynamic> json)
      : serviceName = json['secondaryService'],
        nums = json['num'].toString(),
        price = json['price'].toString();
  Map<String, dynamic> toJson() =>
      {'serviceName': serviceName, 'num': nums, 'price': price};
}

class RecCarMaterilModel {
  final String itemName; //--->名称
  final String itemNum; //---> 个数
  final String itemPrice; //---> 钱

  RecCarMaterilModel(this.itemName, this.itemNum, this.itemPrice);
  RecCarMaterilModel.fromJson(Map<String, dynamic> json)
      : itemName = json['itemMaterial'],
        itemNum = json['itemNumber'].toString(),
        itemPrice = json['itemPrice'].toString();
  Map<String, dynamic> toJson() =>
      {'itemMaterial': itemName, 'itemNumber': itemNum, 'itemPrice': itemPrice};
}

class RecCarHistoryModel {
  final String secondaryService; //--->
  final String createDate; //---> 时间
  final String price; //---> 钱

  RecCarHistoryModel(this.secondaryService, this.createDate, this.price);
  RecCarHistoryModel.fromJson(Map<String, dynamic> json)
      : secondaryService = json['secondaryService'],
        createDate = json['createDate'].toString(),
        price = json['price'].toString();
  Map<String, dynamic> toJson() => {
        'secondaryService': secondaryService,
        'createDate': createDate,
        'price': price
      };
}

/*
   全车检查 model
*/
class FirstCheckModel {
  final String category; //--->名称

  FirstCheckModel(
    this.category,
  );
  FirstCheckModel.fromJson(Map<String, dynamic> json)
      : category = json['category'];
  Map<String, dynamic> toJson() => {'category': category};
}

/*
   全车检查 model
*/
class SecondCheckModel {
  final String id; //--->id
  final String inspectionItem; //--->名称
  final String checkStandard; //--->内容

  SecondCheckModel(
    this.id,
    this.inspectionItem,
    this.checkStandard,
  );
  SecondCheckModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        inspectionItem = json['inspectionItem'],
        checkStandard = json['checkStandard'];
  Map<String, dynamic> toJson() => {
        'id': id,
        'inspectionItem': inspectionItem,
        'checkStandard': checkStandard
      };
}
