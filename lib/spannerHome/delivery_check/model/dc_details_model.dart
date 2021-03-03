import 'package:spanners/cTools/public_function.dart';

class DCDetailMode {
  ///车牌号
  String vehicleLicence;

  ///品牌
  String brand;

  ///车辆型号
  String model;

  ///车主姓名
  String vehicleOwners;

  ///手机号
  String customerMobile;

  ///vin码
  String carVin;

  ///车辆颜色
  String carColor;

  ///发动机型号
  String carEngine;

  ///行驶里程
  String roadHaulString;

  ///送修人姓名
  String sendUser;

  ///油表数
  String oilMeters;

  ///接车人姓名
  String requester;

  ///备注
  String remark;

  ///照片数组
  List imgList;

  DCDetailMode.fromJson(Map<String, dynamic> json)
      : vehicleLicence =
            json['vehicleLicence'] != null ? json['vehicleLicence'] : '',
        brand = json['brand'] != null ? json['brand'] : '',
        model = json['model'] != null ? json['model'] : '',
        vehicleOwners =
            json['vehicleOwners'] != null ? json['vehicleOwners'] : '',
        customerMobile =
            json['customerMobile'] != null ? json['customerMobile'] : '',
        carVin = json['carVin'] != null ? json['carVin'] : '',
        carColor = json['carColor'] != null ? json['carColor'] : '',
        carEngine = json['carEngine'] != null ? json['carEngine'] : '',
        roadHaulString = json['roadHaulString'] != null
            ? json['roadHaulString'].toString()
            : '0.0',
        sendUser = json['sendUser'] != null ? json['sendUser'] : '',
        oilMeters = json['oilMeters'] != null ? json['oilMeters'] : '',
        requester = json['requester'] != null ? json['requester'] : '',
        remark = json['remark'] != null ? json['remark'] : '',
        imgList = json['imgList'] != null ? json['imgList'] : [];
}

class DCDetailServiceMode {
  ///名称
  String itemMaterial;

  ///规格
  String spce;

  ///单价
  String itemPrice;

  ///数量
  String itemNumber;

  ///总价
  String totalPrices;

  ///型号
  String itemModel;

  ///二级服务ID
  String serviceId;

  DCDetailServiceMode(this.itemMaterial, this.spce, this.itemPrice,
      this.itemNumber, this.totalPrices,
      {this.serviceId});

  DCDetailServiceMode.fromJson(Map<String, dynamic> json)
      : itemMaterial =
            json['itemMaterial'] != null ? json['itemMaterial'].toString() : '',
        spce = json['spce'] != null ? json['spce'].toString() : '',
        itemPrice =
            json['itemPrice'] != null ? '¥' + json['itemPrice'].toString() : '',
        itemNumber =
            json['itemNumber'] != null ? json['itemNumber'].toString() : '',
        totalPrices = '¥' +
            multiplyTotalPrices(
                json['itemNumber'].toString(), json['itemPrice'].toString()),
        itemModel =
            json['itemModel'] != null ? json['itemModel'].toString() : '';
}
