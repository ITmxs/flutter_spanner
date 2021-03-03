/*
  施工版  消息  提示
  */
class HomeWorkModel {
  final String appointmentNum; //--->预约
  final String receptionNum; //--->接车
  final String dispatchingNum; //--->派工
  final String inspectionNum; //---> 施工
  final String examinationNum; //--->交验
  final String accountNum; //---> 结算
  final String washCarNum; //---> 待洗车次数
  final String shopJobNum; //--->店内任务
  final String spannerJobNum; //--->扳手救援
  final String rescueNum; //现用 扳手救援

  final List mstWarningEntities; //-->智能提醒 list
  final List goodsList; //-->扳手商城list
  HomeWorkModel(
    this.appointmentNum,
    this.receptionNum,
    this.dispatchingNum,
    this.inspectionNum,
    this.examinationNum,
    this.accountNum,
    this.washCarNum,
    this.shopJobNum,
    this.spannerJobNum,
    this.mstWarningEntities,
    this.goodsList,
    this.rescueNum,
  );

  HomeWorkModel.fromJson(Map<String, dynamic> json)
      : appointmentNum = json['appointmentNum'].toString(),
        receptionNum = json['receptionNum'].toString(),
        dispatchingNum = json['dispatchingNum'].toString(),
        inspectionNum = json['inspectionNum'].toString(),
        examinationNum = json['examinationNum'].toString(),
        accountNum = json['accountNum'].toString(),
        washCarNum = json['washCarNum'].toString(),
        shopJobNum = json['shopJobNum'].toString(),
        spannerJobNum = json['spannerJobNum'].toString(),
        rescueNum = json['rescueNum'].toString(),
        mstWarningEntities = json['mstWarningEntities'],
        goodsList = json['goodsList'];

  Map<String, dynamic> toJso(n) => {
        'appointmentNum': appointmentNum,
        'receptionNum': receptionNum,
        'dispatchingNum': dispatchingNum,
        'inspectionNum': inspectionNum,
        'examinationNum': examinationNum,
        'accountNum': accountNum,
        'washCarNum': washCarNum,
        'shopJobNum': shopJobNum,
        'spannerJobNum': spannerJobNum,
        'rescueNum': rescueNum,
        'mstWarningEntities': mstWarningEntities,
        'goodsList': goodsList
      };
}

class WarningModel {
  final String commont; //提醒文字内容
  final String vehicleLicence; //车牌
  final String userName; //--->车主名
  final String moblie; //
  WarningModel(this.commont, this.vehicleLicence, this.userName, this.moblie);
  WarningModel.fromJson(Map<String, dynamic> json)
      : commont = json['commont'],
        userName = json['userName'].toString(),
        moblie = json['userTel'].toString(),
        vehicleLicence = json['vehicleLicence'];
  Map<String, dynamic> toJson() => {
        'commont': commont,
        'userName': userName,
        'userTel': moblie,
        'vehicleLicence': vehicleLicence
      };
}

class GoodsModel {
  final String primaryPicUrl; //图片url
  final String goodsName; //商品名称
  final retailPrice; //价格
  final String specName; //规格
  final String model; //型号
  final String shopGoodsId;
  GoodsModel(this.primaryPicUrl, this.goodsName, this.retailPrice,
      this.specName, this.model, this.shopGoodsId);
  GoodsModel.fromJson(Map<String, dynamic> json)
      : primaryPicUrl = json['pic'],
        goodsName = json['goodsName'],
        specName = json['specName'],
        shopGoodsId = json['shopGoodsId'],
        model = json['model'],
        retailPrice = json['goodsPrice'];
  Map<String, dynamic> toJson() => {
        'pic': primaryPicUrl,
        'goodsName': goodsName,
        'specName': specName,
        'shopGoodsId': shopGoodsId,
        'model': model,
        'goodsPrice': retailPrice
      };
}
