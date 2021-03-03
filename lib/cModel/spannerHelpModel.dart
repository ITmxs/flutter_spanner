/*
   救援 model 定义
*/
class HelpModel {
  final String vehicleLicence; //---> 车牌
  final String description; //--->  描述
  final String brand; //--->  型号
  final latitude; //--->  纬度
  final longitude; //--->  经度
  final int status; //--->  状态
  final String address; //--->  地址
  final String mobile; //---> 手机号
  final List picList; //---> 图片
  final String id; //---> 手机号
  final String arriveTime; //-->完成 时间
  final String createTime; //-->申请 时间
  final String updateTime; //-->接受 时间
  final String distance; //-->距离
  final String reason; //-->拒绝原因
  HelpModel(
      this.address,
      this.status,
      this.description,
      this.latitude,
      this.longitude,
      this.vehicleLicence,
      this.brand,
      this.mobile,
      this.picList,
      this.id,
      this.arriveTime,
      this.createTime,
      this.updateTime,
      this.distance,
      this.reason);
  HelpModel.fromJson(Map<String, dynamic> json)
      : vehicleLicence = json['vehicleLicence'],
        description = json['description'].toString(),
        latitude = json['latitude'],
        longitude = json['longitude'],
        brand = json['brand'].toString(),
        status = json['status'],
        mobile = json['mobile'],
        id = json['id'],
        reason = json['reason'],
        arriveTime = json['arriveTime'],
        createTime = json['createTime'],
        updateTime = json['updateTime'],
        distance = json['distance'].toString(),
        picList = json['picList'],
        address = json['address'] == null ? '' : json['address'].toString();
  Map<String, dynamic> toJson() => {
        'vehicleLicence': vehicleLicence,
        'brand': brand,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'mobile': mobile,
        'id': id,
        'reason': reason,
        'arriveTime': arriveTime,
        'createTime': createTime,
        'updateTime': updateTime,
        'distance': distance,
        'picList': picList,
        'address': address
      };
}
