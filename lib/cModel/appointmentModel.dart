/*
预约看板 list
*/
class AppointModel {
  final List makeAnAppointMentList;

  AppointModel(this.makeAnAppointMentList); //-->预约看板list

  AppointModel.fromJson(Map<String, dynamic> json)
      : makeAnAppointMentList = json['makeAnAppointMentList'];

  Map<String, dynamic> toJso(n) => {
        'makeAnAppointMentList': makeAnAppointMentList,
      };
}

/*
预约看板 分区头 项目 list
*/
class AppointTitleNameModel {
  final List appointmentVOList; //-->预约看板 分区头 项目 list
  final String dictName; //--->项目名

  AppointTitleNameModel(this.appointmentVOList, this.dictName);

  AppointTitleNameModel.fromJson(Map<String, dynamic> json)
      : appointmentVOList = json['appointmentVOList'],
        dictName = json['dictName'];

  Map<String, dynamic> toJso(n) => {
        'appointmentVOList': appointmentVOList,
        'dictName': dictName,
      };
}

/*
预约看板 项目内用户信息 list
*/
class AppointUserMessageModel {
  final String shopId; //--->门店ID
  final String vehicleLicence; //--->车牌号
  final String secondaryService; //--->类别名
  final String appointmentName; //--->预约人
  final String appointmentStatusName; //--->预约状态
  final String appointmentTime; //--->预约时间
  final String workOrderId; //--->工单ID
  final String id; //--->工单ID

  AppointUserMessageModel(
      this.shopId,
      this.vehicleLicence,
      this.appointmentName,
      this.appointmentStatusName,
      this.appointmentTime,
      this.secondaryService,
      this.workOrderId,
      this.id);

  AppointUserMessageModel.fromJson(Map<String, dynamic> json)
      : shopId = json['shopId'].toString(),
        vehicleLicence = json['vehicleLicence'].toString(),
        appointmentName = json['appointmentName'].toString(),
        appointmentStatusName = json['appointmentStatusName'].toString(),
        appointmentTime = json['appointmentTime'].toString(),
        workOrderId = json['workOrderId'].toString(),
        id = json['id'].toString(),
        secondaryService = json['secondaryService'].toString();

  Map<String, dynamic> toJso(n) => {
        'shopId': shopId,
        'vehicleLicence': vehicleLicence,
        'appointmentName': appointmentName,
        'appointmentStatusName': appointmentStatusName,
        'appointmentTime': appointmentTime,
        'secondaryService': secondaryService,
        'workOrderId': workOrderId,
        'id': id,
      };
}

/*
预约看板 分区头 项目 list
*/
class AppointMessageModel {
  //final List tbWorkOrderWebEntityList; //-->预约看板 分区头 项目 list
  final String id; //--->预约id
  final String img; //--->用户图片
  final String appointmentName; //--->用户名
  final String appointmentStatusName; //--->预约状态
  final String mobile; //--->电话
  final String vehicleLicence; //--->车牌
  final String brand; //--->品牌
  final String model; //--->型号
  final String carColor; //--->车颜色
  final String roadHaul; //--->车里程
  final String dictName; //--->一级服务项目
  final String secondaryService; //--->二级服务项目
  final String remark; //--->备注
  final String vin; //-->VIN
  final String appointmentTime; //-->预约时间

  AppointMessageModel(
      this.vehicleLicence,
      this.brand,
      this.model,
      this.carColor,
      this.roadHaul,
      this.dictName,
      this.remark,
      this.vin,
      this.img,
      this.appointmentName,
      this.appointmentStatusName,
      this.mobile,
      this.appointmentTime,
      this.secondaryService,
      this.id);

  AppointMessageModel.fromJson(Map<String, dynamic> json)
      : vehicleLicence = json['vehicleLicence'],
        id = json['id'].toString(),
        img = json['img'],
        appointmentName = json['appointmentName'],
        appointmentStatusName = json['appointmentStatusName'],
        mobile = json['mobile'],
        appointmentTime = json['appointmentTime'],
        brand = json['brand'],
        model = json['model'],
        carColor = json['carColor'],
        roadHaul = json['roadHaul'],
        dictName = json['dictName'],
        vin = json['vin'],
        secondaryService = json['secondaryService'],
        remark = json['remark'];

  Map<String, dynamic> toJso(n) => {
        'vehicleLicence': vehicleLicence,
        'brand': brand,
        'id': id,
        'model': model,
        'carColor': carColor,
        'roadHaul': roadHaul,
        'dictName': dictName,
        'vin': vin,
        'remark': remark,
        'img': img,
        'appointmentName': appointmentName,
        'appointmentStatusName': appointmentStatusName,
        'mobile': mobile,
        'appointmentTime': appointmentTime,
        'secondaryService': secondaryService,
      };
}
