/*
  扳手保险
  */
class InsureModel {
  final String vehicleLicence; //--->
  final int type; //--->询价 门店-车主
  final String updTime; //--->创建时间
  final int state; //---> 询价状态   0:询价中;1:流失;2:成交;3已报价
  final String id; //--->
  final String commercialInsuranceNumber; //商业险单号
  final String compulsoryInsuranceNumber; //交强险单号
  InsureModel(
    this.vehicleLicence,
    this.type,
    this.updTime,
    this.state,
    this.id,
    this.commercialInsuranceNumber,
    this.compulsoryInsuranceNumber,
  );

  InsureModel.fromJson(Map<String, dynamic> json)
      : vehicleLicence = json['vehicleLicence'].toString(),
        type = json['type'],
        updTime = json['createTime'].toString(),
        state = json['state'],
        commercialInsuranceNumber =
            json['commercialInsuranceNumber'].toString(),
        compulsoryInsuranceNumber =
            json['compulsoryInsuranceNumber'].toString(),
        id = json['id'].toString();

  Map<String, dynamic> toJso(n) => {
        'vehicleLicence': vehicleLicence,
        'type': type,
        'createTime': updTime,
        'state': state,
        'commercialInsuranceNumber': commercialInsuranceNumber,
        'compulsoryInsuranceNumber': compulsoryInsuranceNumber,
        'id': id,
      };
}
