/*
   施工 model 定义
*/
class WorkingModel {
  final String id; //---> 服务ID
  final String workOrderId; //--->
  final String executor; //---> 施工人员
  final String status; //---> 施工状态
  final String serviceName; //---> 施工项目
  final String serviceId; //---> 施工项目id
  final String number; //---> 施工项目个数
  final String createDate; //开始时间
  final String assignjobTime; //派工时间
  final String remark; //派工时间
  WorkingModel(
    this.id,
    this.workOrderId,
    this.executor,
    this.status,
    this.serviceName,
    this.serviceId,
    this.number,
    this.createDate,
    this.assignjobTime,
    this.remark,
  );
  WorkingModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        workOrderId = json['workOrderId'].toString(),
        executor = json['executor'].toString(),
        status = json['status'].toString(),
        serviceName = json['secondaryService'].toString(),
        serviceId = json['serviceId'].toString(),
        number = json['num'].toString(),
        assignjobTime = json['assignjobTime'].toString(),
        remark = json['remark'].toString(),
        createDate = json['updateDate'].toString();
  Map<String, dynamic> toJson() => {
        'id': id,
        'workOrderId': workOrderId,
        'executor': executor,
        'status': status,
        'serviceName': serviceName,
        'serviceId': serviceId,
        'number': number,
        'remark': remark,
        'assignjobTime': assignjobTime,
        'updateDate': createDate,
      };
}

/*
   配件  model
*/
class WorkingMaterModel {
  final String id; //---> 服务ID
  final String itemMaterial; //---> 配件名字
  final String itemUnit; //---> 配件单位
  final String itemNumber; //---> 配件个数

  WorkingMaterModel(
    this.id,
    this.itemNumber,
    this.itemMaterial,
    this.itemUnit,
  );
  WorkingMaterModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        itemMaterial = json['itemMaterial'].toString(),
        itemUnit = json['itemUnit'].toString(),
        itemNumber = json['itemNumber'].toString();
  Map<String, dynamic> toJson() => {
        'id': id,
        'itemMaterial': itemMaterial,
        'itemUnit': itemUnit,
        'itemNumber': itemNumber
      };
}
