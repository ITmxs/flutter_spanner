/*
  外层当月车辆。。  model
*/
class BudgetNowModel {
  final int nowMonthCatNumber; //--->当月车辆
  final nowMonthIncome; //--->当月收入
  final nowMonthPlace; //--->当月支出
  BudgetNowModel(
      this.nowMonthCatNumber, this.nowMonthIncome, this.nowMonthPlace);
  BudgetNowModel.fromJson(Map<dynamic, dynamic> json)
      : nowMonthCatNumber = json['nowMonthCatNumber'],
        nowMonthIncome = json['nowMonthIncome'],
        nowMonthPlace = json['nowMonthPlace'];
  Map<String, dynamic> toJso(n) => {
        'nowMonthCatNumber': nowMonthCatNumber,
        'nowMonthIncome': nowMonthIncome,
        'nowMonthPlace': nowMonthPlace,
      };
}

class BudgetSerModel {
  final materialprice; //--->价格double
  final serviceId;
  final String serviceFLg;
  final String itemNameCn; //--->名称
  final String serviceType; //--->type

  BudgetSerModel(this.materialprice, this.itemNameCn, this.serviceType,
      this.serviceId, this.serviceFLg);
  BudgetSerModel.fromJson(Map<String, dynamic> json)
      : materialprice = json['materialprice'],
        itemNameCn = json['itemNameCn'],
        serviceId = json['serviceId'],
        serviceFLg = json['serviceFLg'],
        serviceType = json['serviceType'];
  Map<String, dynamic> toJso(n) => {
        'materialprice': materialprice,
        'itemNameCn': itemNameCn,
        'serviceId': serviceId,
        'serviceFLg': serviceFLg,
        'serviceType': serviceType,
      };
}

/*
  收入 统计 详情
*/
class BudgetDetailModel {
  final price; //--->
  final createTime; //--->
  final serviceNameCn; //--->子服务项目名称
  final vehicleLicence; //--->车牌
  final workOrderId; //--->
  final recordItem; //--->统计事项（额外收入时使用）
  final orderSn; //--->订单编号：orderSn  (平台收入中使用)
  final campaignName; //--->卡卷名称：campaignName  （卡卷收入中使用）
  final realName; //--->员工姓名：realName(绩效支出明细使用)
  final userId; //--->员工ID：userId(绩效支出明细使用) 调用详情画面时使用
  final payTypeName; //--->采购方式：payTypeName （采购入库，即采即入）
  final id; //-->即采即入
  final purchaseId; //-->采购入库
  final String type; //--->type
  BudgetDetailModel(
      this.price,
      this.createTime,
      this.serviceNameCn,
      this.vehicleLicence,
      this.workOrderId,
      this.recordItem,
      this.orderSn,
      this.campaignName,
      this.realName,
      this.userId,
      this.payTypeName,
      this.id,
      this.purchaseId,
      this.type);
  BudgetDetailModel.fromJson(Map<dynamic, dynamic> json)
      : price = json['price'].toString() ?? '',
        id = json['id'].toString(),
        purchaseId = json['purchaseId'].toString(),
        createTime = json['createTime'].toString() ?? '',
        serviceNameCn = json['serviceNameCn'].toString() ?? '',
        vehicleLicence = json['vehicleLicence'].toString() ?? '',
        workOrderId = json['workOrderId'].toString() ?? '',
        recordItem = json['recordItem'].toString() ?? '',
        orderSn = json['orderSn'].toString() ?? '',
        campaignName = json['campaignName'].toString() ?? '',
        realName = json['realName'].toString() ?? '',
        userId = json['userId'].toString() ?? '',
        type = json['type'].toString() ?? '',
        payTypeName = json['payTypeName'].toString() ?? '';
  Map<String, dynamic> toJso(n) => {
        'price': price,
        'id': id,
        'purchaseId': purchaseId,
        'createTime': createTime,
        'serviceNameCn': serviceNameCn,
        'vehicleLicence': vehicleLicence,
        'workOrderId': workOrderId,
        'recordItem': recordItem,
        'orderSn': orderSn,
        'campaignName': campaignName,
        'realName': realName,
        'userId': userId,
        'type': type,
        'payTypeName': payTypeName,
      };
}
