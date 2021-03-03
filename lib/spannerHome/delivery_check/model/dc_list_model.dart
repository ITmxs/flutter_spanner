
class DCListModel {
  String vehicleLicence;
  String workOrderId;

  DCListModel.fromJson(Map<String, dynamic> json)
      : vehicleLicence = json['vehicleLicence'],
        workOrderId = json['workOrderId'];

  List<DCListItemMode> itemListMode;

  setItemListMode(Map<String, dynamic> json) {
    List itemListJson = json['itemTypeList'];
    List<DCListItemMode> itemModel = List();
    itemListJson.forEach(
        (itemJson) => itemModel.add(DCListItemMode.fromJson(itemJson)));
    itemListMode = itemModel;
  }
}

class DCListItemMode {
  ///服务项目名
  String secondaryService;

  ///状态
  String status;

  ///3待校验4拒绝5完成
  ///拒绝原因
  String remark;

  ///施工人员
  String executor;

  ///服务ID
  String serviceId;

  DCListItemMode.fromJson(Map<String, dynamic> json)
      : secondaryService = json['secondaryService'],
        status = json['status'],
        remark = json['remark'],
        executor = json['executor'],
        serviceId = json['serviceId'];
}
