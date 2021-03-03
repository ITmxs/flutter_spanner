
class ShareOrderModel {

  ///共享商品待取货
  final String shareGoodsWaitReceive;
  ///共享工具待取货
  final String shareEquipmentWaitReceive;
  ///共享工具待归还
  final String shareEquipmentWaitReturn;
  ///二手商品待取货
  final String secondGoodsWaitReceive;

  ShareOrderModel({this.shareGoodsWaitReceive = '0', this.shareEquipmentWaitReceive = '0', this.shareEquipmentWaitReturn = '0', this.secondGoodsWaitReceive = '0'});
}