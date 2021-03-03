/*
   公共  model
*/
class PublicModel {
  final String vehicleLicence; //---> 车辆牌子
  final String realName; //---> 姓名 / 公司
  final String brand; //---> 车辆品牌
  final String model; //---> 模型
  final String accountBalances; //---> 余额

  PublicModel(
    this.vehicleLicence,
    this.realName,
    this.brand,
    this.model,
    this.accountBalances,
  );
  PublicModel.fromJson(Map<String, dynamic> json)
      : vehicleLicence = json['vehicleLicence'],
        realName = json['realName'].toString(),
        brand = json['brand'].toString(),
        model = json['model'].toString(),
        accountBalances = json['accountBalances'].toString();
  Map<String, dynamic> toJson() => {
        'vehicleLicence': vehicleLicence,
        'realName': realName,
        'brand': brand,
        'model': model,
        'accountBalances': accountBalances
      };
}

/*
   公共vip 卡劵  model
*/
class PublicOwnListModel {
  final String quantity; //---> 卡劵次数
  final String realName; //---> 卡劵名称

  PublicOwnListModel(
    this.quantity,
    this.realName,
  );
  PublicOwnListModel.fromJson(Map<String, dynamic> json)
      : quantity = json['frequency'].toString(),
        realName = json['campaignName'].toString();
  Map<String, dynamic> toJson() =>
      {'frequency': quantity, 'campaignName': realName};
}

/*
   查看成本 api model
*/
class PublicCostListModel {
  final String name; //---> 配件名字
  final String spec; //---> 规格
  final String cost; //---> 成本单价
  final number; //---> 个数
  final String totalCost; //---> 总成本

  PublicCostListModel(
      this.name, this.spec, this.cost, this.number, this.totalCost);
  PublicCostListModel.fromJson(Map<String, dynamic> json)
      : name = json['itemMaterial'].toString(),
        spec = json['spce'].toString(),
        cost = json['partsCost'].toString(),
        number = json['itemNumber'].toString(),
        totalCost = json['totalCost'].toString();
  Map<String, dynamic> toJson() => {
        'itemMaterial': name,
        'spec': spec,
        'partsCost': cost,
        'itemNumber': number,
        'totalCost': totalCost
      };
}

/*
   查看成本 本地 model
*/
class PublicShareCostListModel {
  final String name; //---> 配件名字
  final String spec; //---> 规格
  final String cost; //---> 价格
  final String number; //---> 个数

  PublicShareCostListModel(this.name, this.spec, this.cost, this.number);
  PublicShareCostListModel.fromJson(Map<String, dynamic> json)
      : name = json['itemMaterial'].toString(),
        spec = json['spec'].toString(),
        cost = json['partsCost'].toString(),
        number = json['itemNumber'].toString();

  Map<String, dynamic> toJson() => {
        'itemMaterial': name,
        'spec': spec,
        'partsCost': cost,
        'itemNumber': number,
      };
}

/*
   公共 保养手册 model
*/
class PublicMainfenceModel {
  final String serviceName; //---> 服务名称
  final String receiveTime; //---> 上次服务时间
  final String nextService; //---> 下次服务时间
  final String nextServiceKm; //---> 下次服务公里数
  final String remark; //---> 备注

  PublicMainfenceModel(
    this.serviceName,
    this.receiveTime,
    this.nextService,
    this.nextServiceKm,
    this.remark,
  );
  PublicMainfenceModel.fromJson(Map<String, dynamic> json)
      : serviceName = json['serviceName'],
        receiveTime = json['receiveTime'].toString(),
        nextService = json['nextService'].toString(),
        nextServiceKm = json['nextServiceKm'].toString(),
        remark = json['remark'].toString();
  Map<String, dynamic> toJson() => {
        'serviceName': serviceName,
        'receiveTime': receiveTime,
        'nextService': nextService,
        'nextServiceKm': nextServiceKm,
        'remark': remark
      };
}

/*
   公共 保养手册筛选ser model
*/
class PublicMainfenceSerModel {
  final String secondaryService; //---> 服务名称
  final String serviceId; //--->
  final String receiveTime;
  final String vehicleLicence;
  final String workOrderId;

  PublicMainfenceSerModel(
    this.secondaryService,
    this.serviceId,
    this.receiveTime,
    this.vehicleLicence,
    this.workOrderId,
  );
  PublicMainfenceSerModel.fromJson(Map<String, dynamic> json)
      : secondaryService = json['secondaryService'],
        receiveTime = json['receiveTime'],
        vehicleLicence = json['vehicleLicence'],
        workOrderId = json['workOrderId'],
        serviceId = json['serviceId'].toString();
  Map<String, dynamic> toJson() => {
        'secondaryService': secondaryService,
        'receiveTime': receiveTime,
        'vehicleLicence': vehicleLicence,
        'workOrderId': workOrderId,
        'serviceId': serviceId
      };
}

/*
   公共 保养手册筛选 配件 model
*/
class PublicMainfenceMaterialModel {
  final String itemMaterial; //---> 服务名称

  PublicMainfenceMaterialModel(
    this.itemMaterial,
  );
  PublicMainfenceMaterialModel.fromJson(Map<String, dynamic> json)
      : itemMaterial = json['itemMaterial'];
  Map<String, dynamic> toJson() => {'itemMaterial': itemMaterial};
}
