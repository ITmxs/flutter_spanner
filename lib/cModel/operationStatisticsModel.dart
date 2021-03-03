/*
   运营统计 model 定义
*/
class OperationModel {
  final String nowDayPutFactoryCount; //---> 今日进厂
  final String nowDayOutFactoryCount; //---> 今日出厂
  final String nowMonthShopCarCount; //---> 月新增绑定车辆
  final String shopCarCount; //---> 绑定车辆总数
  final String nowMonthPutFactoryCount; //-->月进厂次数
  final String nowMonthOutFactoryCount; //-->月出厂次数
  final String nowMonthProfitSum; //-->本月利润总额
  final String nowMonthWorkPriceSum; //-->本月工单实收金额
  final String nowMonthPartsCostSum; //-->本月配件成本
  final String personAchievementsSum; //-->员工绩效
  final String otherIncomeSum; //-->其他收入
  final String otherExpenditureSum; //--> 其他支出
  final String nowMonthStoredValueSum; //--> 本月新增储值额
  final String nowMonthConsumptionSum; //-->  本月消费储值额     ****
  final String accountBalanceSum; //-->  会员储值剩余总额
  final String nowMonthOnAccountSum; //--> 本月新增挂账额
  final String onAccountSum; //-->  挂账总额
  final String nowMonthBindingPersonCount; //-->  本月新增绑定会员数
  final String bindingPersonCount; //-->  绑定会员总数
  final String nowMonthStorePersonCount; //-->本月新增储值会员数
  final String storePersonCount; //-->储值会员总数
  final String customerCount; //-->客户总数

  OperationModel(
      this.nowDayPutFactoryCount,
      this.nowDayOutFactoryCount,
      this.nowMonthShopCarCount,
      this.shopCarCount,
      this.nowMonthPutFactoryCount,
      this.nowMonthOutFactoryCount,
      this.nowMonthProfitSum,
      this.nowMonthWorkPriceSum,
      this.nowMonthPartsCostSum,
      this.personAchievementsSum,
      this.otherIncomeSum,
      this.otherExpenditureSum,
      this.nowMonthStoredValueSum,
      this.nowMonthConsumptionSum,
      this.accountBalanceSum,
      this.nowMonthOnAccountSum,
      this.onAccountSum,
      this.nowMonthBindingPersonCount,
      this.bindingPersonCount,
      this.nowMonthStorePersonCount,
      this.storePersonCount,
      this.customerCount);
  OperationModel.fromJson(Map<String, dynamic> json)
      : nowDayPutFactoryCount = json['nowDayPutFactoryCount'].toString() ?? '',
        nowDayOutFactoryCount = json['nowDayOutFactoryCount'].toString() ?? '',
        nowMonthShopCarCount = json['nowMonthShopCarCount'].toString() ?? '',
        shopCarCount = json['shopCarCount'].toString() ?? '',
        nowMonthPutFactoryCount =
            json['nowMonthPutFactoryCount'].toString() ?? '',
        nowMonthOutFactoryCount =
            json['nowMonthOutFactoryCount'].toString() ?? '',
        nowMonthProfitSum = json['nowMonthProfitSum'].toString() ?? '',
        nowMonthWorkPriceSum = json['nowMonthWorkPriceSum'].toString() ?? '',
        nowMonthPartsCostSum = json['nowMonthPartsCostSum'].toString() ?? '',
        personAchievementsSum = json['personAchievementsSum'].toString() ?? '',
        otherIncomeSum = json['otherIncomeSum'].toString() ?? '',
        otherExpenditureSum = json['otherExpenditureSum'].toString() ?? '',
        nowMonthStoredValueSum =
            json['nowMonthStoredValueSum'].toString() ?? '',
        nowMonthConsumptionSum =
            json['nowMonthConsumptionSum'].toString() ?? '',
        accountBalanceSum = json['accountBalanceSum'].toString() ?? '',
        nowMonthOnAccountSum = json['nowMonthOnAccountSum'].toString() ?? '',
        onAccountSum = json['onAccountSum'].toString() ?? '',
        nowMonthBindingPersonCount =
            json['nowMonthBindingPersonCount'].toString() ?? '',
        bindingPersonCount = json['bindingPersonCount'].toString() ?? '',
        nowMonthStorePersonCount =
            json['nowMonthStorePersonCount'].toString() ?? '',
        storePersonCount = json['storePersonCount'].toString() ?? '',
        customerCount = json['customerCount'].toString() ?? '';
  Map<String, dynamic> toJson() => {
        'nowDayPutFactoryCount': nowDayPutFactoryCount,
        'nowDayOutFactoryCount': nowDayOutFactoryCount,
        'nowMonthShopCarCount': nowMonthShopCarCount,
        'shopCarCount': shopCarCount,
        'nowMonthPutFactoryCount': nowMonthPutFactoryCount,
        'nowMonthOutFactoryCount': nowMonthOutFactoryCount,
        'nowMonthProfitSum': nowMonthProfitSum,
        'nowMonthWorkPriceSum': nowMonthWorkPriceSum,
        'nowMonthPartsCostSum': nowMonthPartsCostSum,
        'personAchievementsSum': personAchievementsSum,
        'otherIncomeSum': otherIncomeSum,
        'otherExpenditureSum': otherExpenditureSum,
        'nowMonthStoredValueSum': nowMonthStoredValueSum,
        'nowMonthConsumptionSum': nowMonthConsumptionSum,
        'accountBalanceSum': accountBalanceSum,
        'nowMonthOnAccountSum': nowMonthOnAccountSum,
        'onAccountSum': onAccountSum,
        'nowMonthBindingPersonCount': nowMonthBindingPersonCount,
        'bindingPersonCount': bindingPersonCount,
        'nowMonthStorePersonCount': nowMonthStorePersonCount,
        'storePersonCount': storePersonCount,
        'customerCount': customerCount,
      };
}

/*
   运营统计 利润统计 model 定义
*/
class OperationProfitModel {
  final String nowMonthInPrice; //---> 月收入
  final String nowMonthOutPrice; //---> 月支出
  final String yearProfit; //---> 全年利润统计
  final String nowMonthProfit; //---> 本月利润总额
  final String nowMonthWorkPriceSum; //-->本月工单实收金额
  final String nowMonthPartsCostSum; //-->本月配件成本
  final String personAchievementsSum; //-->员工绩效
  final String otherIncomeSum; //-->其他收入
  final String otherExpenditureSum; //-->其他支出
  final List monthProfitDetailVos; //-->本月利润走势

  OperationProfitModel(
      this.nowMonthInPrice,
      this.nowMonthOutPrice,
      this.yearProfit,
      this.nowMonthProfit,
      this.nowMonthWorkPriceSum,
      this.nowMonthPartsCostSum,
      this.personAchievementsSum,
      this.otherIncomeSum,
      this.otherExpenditureSum,
      this.monthProfitDetailVos);
  OperationProfitModel.fromJson(Map<String, dynamic> json)
      : nowMonthInPrice = json['nowMonthInPrice'].toString() ?? '',
        nowMonthOutPrice = json['nowMonthOutPrice'].toString() ?? '',
        yearProfit = json['yearProfit'].toString() ?? '',
        nowMonthProfit = json['nowMonthProfit'].toString() ?? '',
        nowMonthWorkPriceSum = json['nowMonthWorkPriceSum'].toString() ?? '',
        nowMonthPartsCostSum = json['nowMonthPartsCostSum'].toString() ?? '',
        personAchievementsSum = json['personAchievementsSum'].toString() ?? '',
        otherIncomeSum = json['otherIncomeSum'].toString() ?? '',
        otherExpenditureSum = json['otherExpenditureSum'].toString() ?? '',
        monthProfitDetailVos = json['monthProfitDetailVos'];
  Map<String, dynamic> toJson() => {
        'nowMonthInPrice': nowMonthInPrice,
        'nowMonthOutPrice': nowMonthOutPrice,
        'yearProfit': yearProfit,
        'nowMonthProfit': nowMonthProfit,
        'nowMonthWorkPriceSum': nowMonthWorkPriceSum,
        'nowMonthPartsCostSum': nowMonthPartsCostSum,
        'personAchievementsSum': personAchievementsSum,
        'otherIncomeSum': otherIncomeSum,
        'otherExpenditureSum': otherExpenditureSum,
        'monthProfitDetailVos': monthProfitDetailVos,
      };
}

/*
   运营统计 新增会员储值走势 model 定义
*/
class NewVipModel {
  final String nowMonthStoreValue; //---> 本月新增储值额
  final String storeValue; //---> 会员储值总额
  final String nowMonthConsume; //---> 本月新增消费额
  final List monthStoreValueDetailVos; //---> 新增储值明细
  final List monthStoreValueHistogramVos; //-->新增储值走势

  NewVipModel(this.nowMonthStoreValue, this.storeValue, this.nowMonthConsume,
      this.monthStoreValueDetailVos, this.monthStoreValueHistogramVos);
  NewVipModel.fromJson(Map<String, dynamic> json)
      : nowMonthStoreValue = json['nowMonthStoreValue'].toString() ?? '',
        storeValue = json['storeValue'].toString() ?? '',
        nowMonthConsume = json['nowMonthConsume'].toString() ?? '',
        monthStoreValueDetailVos = json['monthStoreValueDetailVos'],
        monthStoreValueHistogramVos = json['monthStoreValueHistogramVos'];
  Map<String, dynamic> toJson() => {
        'nowMonthStoreValue': nowMonthStoreValue,
        'storeValue': storeValue,
        'nowMonthConsume': nowMonthConsume,
        'monthStoreValueDetailVos': monthStoreValueDetailVos,
        'monthStoreValueHistogramVos': monthStoreValueHistogramVos,
      };
}

/*
   运营统计 新增会员储值走势 model 定义
*/
class PuttingModel {
  final String nowMonthOnAccount; //---> 本月新增挂账额
  final String onAccountSum; //---> 会员挂账总额
  final List monthOnAccountDetailVos; //-->挂账明细

  PuttingModel(
    this.nowMonthOnAccount,
    this.onAccountSum,
    this.monthOnAccountDetailVos,
  );
  PuttingModel.fromJson(Map<String, dynamic> json)
      : nowMonthOnAccount = json['nowMonthOnAccount'].toString() ?? '',
        onAccountSum = json['onAccountSum'].toString() ?? '',
        monthOnAccountDetailVos = json['monthOnAccountDetailVos'];
  Map<String, dynamic> toJson() => {
        'nowMonthOnAccount': nowMonthOnAccount,
        'onAccountSum': onAccountSum,
        'monthOnAccountDetailVos': monthOnAccountDetailVos,
      };
}

/*
   运营统计 工单详情 model 定义
*/
class BillModel {
  final String workOrderMoney; //---> 工单实收金额
  final String workOrderPartMoney; //---> 工单配件成本
  final List workOrderListDtos; //-->工单列表

  BillModel(
    this.workOrderMoney,
    this.workOrderPartMoney,
    this.workOrderListDtos,
  );
  BillModel.fromJson(Map<String, dynamic> json)
      : workOrderMoney = json['workOrderMoney'].toString() ?? '',
        workOrderPartMoney = json['workOrderPartMoney'].toString() ?? '',
        workOrderListDtos = json['workOrderListDtos'];
  Map<String, dynamic> toJson() => {
        'workOrderMoney': workOrderMoney,
        'workOrderPartMoney': workOrderPartMoney,
        'workOrderListDtos': workOrderListDtos,
      };
}

/*
   运营统计 工单详情List model 定义
*/
class BillListModel {
  final String carNo; //---> 车牌号
  final String workOrderMoney; //---> 工单实收金额
  final String workOrderPartMoney; //-->工单配件成本
  final String time; //-->
  final String workOrderId; //-->工单id

  BillListModel(this.carNo, this.workOrderMoney, this.workOrderPartMoney,
      this.time, this.workOrderId);
  BillListModel.fromJson(Map<String, dynamic> json)
      : carNo = json['carNo'].toString() ?? '',
        workOrderMoney = json['workOrderMoney'].toString() ?? '',
        workOrderPartMoney = json['workOrderPartMoney'].toString() ?? '',
        time = json['time'].toString() ?? '',
        workOrderId = json['workOrderId'].toString() ?? '';
  Map<String, dynamic> toJson() => {
        'carNo': carNo,
        'workOrderMoney': workOrderMoney,
        'workOrderPartMoney': workOrderPartMoney,
        'time': time,
        'workOrderId': workOrderId,
      };
}
