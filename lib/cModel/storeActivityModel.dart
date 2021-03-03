/*
   门店活动 model 定义
*/
class ActivityModel {
  final int type; //---> 1 次卡  0 充值
  final String campaignName; //--->  卡劵名
  final String id; //--->  卡劵
  final String endTime; //--->  结束时间
  final String remarks; //--->  内容
  final String buyPrice; //--->  购买价
  final String accountPrice; //--->  赠送
  final String periodUse; //--->  期限
  ActivityModel(this.accountPrice, this.buyPrice, this.campaignName,
      this.endTime, this.remarks, this.type, this.id, this.periodUse);
  ActivityModel.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        campaignName = json['campaign_name'].toString(),
        endTime = json['end_time'].toString(),
        remarks = json['remarks'] == null ? '' : json['remarks'].toString(),
        id = json['id'].toString(),
        periodUse = json['periodUse'].toString(),
        buyPrice = json['buy_price'].toString(),
        accountPrice = json['account_price'].toString();
  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'campaign_name': campaignName,
        'end_time': endTime,
        'remarks': remarks,
        'periodUse': periodUse,
        'buy_price': buyPrice,
        'account_price': accountPrice
      };
}

class ActivityGoodsModel {
  final String quantity; //---> 上架数
  final String goodsName; //--->  商品 名称
  final String applyto; //--->  适用车型
  final String statusName; //--->  内容
  final String picUrl; //
  final String id;
  final String shopGoodsId;
  ActivityGoodsModel(this.goodsName, this.applyto, this.statusName,
      this.quantity, this.picUrl, this.id, this.shopGoodsId);
  ActivityGoodsModel.fromJson(Map<String, dynamic> json)
      : quantity = json['quantity'].toString(),
        goodsName = json['goodsName'].toString(),
        id = json['id'].toString(),
        shopGoodsId = json['shopGoodsId'].toString(),
        applyto = json['applyto'].toString(),
        picUrl = json['primary_pic_url'].toString(),
        statusName = json['statusName'].toString();
  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'goodsName': goodsName,
        'id': id,
        'shopGoodsId': shopGoodsId,
        'applyto': applyto,
        'primary_pic_url': picUrl,
        'statusName': statusName,
      };
}
