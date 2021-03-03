import 'package:spanners/base/common.dart';
import 'package:spanners/ob_networking/ob_networking.dart';

class DeliveryCheckService {
  ///获取列表
  Stream getDeliveryCheckList(dynamic request, Map<String, dynamic> query) {
    var url = Api.Delivery_InspectionList;
    var response = get(url, params: query);
    return response;
  }

  ///拒绝原因

  Stream postRefuseBecauseRequest(dynamic request,
      {Map<String, dynamic> query}) {
    var url = Api.Delivery_RefuseBecause;

    var response = post(url, body: request, queryParameters: query);
    return response;
  }

  ///获取详情
  Stream getDeliveryDetails(dynamic request, Map<String, dynamic> query) {
    var url = Api.Delivery_Details;
    var response = get(url, params: query);
    return response;
  }

  ///获取优惠卡详情
  Stream getCampaignInfo(dynamic request, Map<String, dynamic> query) {
    var url = Api.Delivery_QueryCampaign;
    var response = get(url, params: query);
    return response;
  }
}

class DeliveryCheckRepo {
  final DeliveryCheckService _remote = DeliveryCheckService();

  Stream getDeliveryCheckList({Map<String, dynamic> query}) =>
      _remote.getDeliveryCheckList(null, query);

  Stream postRefuseBecauseRequest(dynamic request) =>
      _remote.postRefuseBecauseRequest(request);

  Stream getDeliveryDetails({Map<String, dynamic> query}) =>
      _remote.getDeliveryDetails(null, query);

  Stream getCampaignInfo({Map<String, dynamic> query}) =>
      _remote.getCampaignInfo(null, query);


}

class WeatherService {
  ///获取天气信息
  Stream getWeatherInfo(dynamic request, Map<String, dynamic> query) {
    var url = Api.Weather_Info;
    var response = get(url, params: query);
    return response;
  }
}

class WeatherRepo {
  final WeatherService _remote = WeatherService();
  Stream getWeatherInfo({Map<String, dynamic> query}) =>
      _remote.getWeatherInfo(null, query);
}

///获取好友列表
class FriendListService {
  Stream getFriendList(dynamic request, Map<String, dynamic> query) {
    var url = Api.IM_FriendList;

    var response = get(url, params: query);
    return response;
  }
}

class FriendListRepo {
  final FriendListService _remote = FriendListService();
  Stream getFriendList({Map<String, dynamic> query}) =>
      _remote.getFriendList(null, query);
}

///搜索用户
class SearchUserInfo {
  Stream getSearchUserInfo(dynamic request, Map<String, dynamic> query) {
    var url = Api.IM_SearchUserInfo;
    var response = get(url, params: query);
    return response;
  }
}

class SearchUserInfoRepo {
  final SearchUserInfo _remote = SearchUserInfo();
  Stream getSearchUserInfo({Map<String, dynamic> query}) =>
      _remote.getSearchUserInfo(null, query);
}

///申请好友
class ApplyFriend {
  ///申请好友
  Stream postApplyFriend(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.IM_ApplyFriend;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  ///查询申请消息
  Stream getApplyMessage(dynamic request, Map<String, dynamic> query) {
    var url = Api.IM_ApplyMessage;

    var response = get(url, params: query);
    return response;
  }

  ///好友申请验证
  Stream postApplyMessage(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.IM_JudgeApplyMessage;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  ///删除好友
  Stream postDeleteFriend(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.IM_DeleteUserFriend;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }
}

class ApplyFriendRepo {
  final ApplyFriend _remote = ApplyFriend();
  Stream postApplyFriend(dynamic request) => _remote.postApplyFriend(request);

  Stream getApplyMessage({Map<String, dynamic> query}) =>
      _remote.getApplyMessage(null, query);

  Stream postApplyMessage(dynamic request) => _remote.postApplyMessage(request);

  Stream postDeleteFriend(dynamic request) => _remote.postDeleteFriend(request);
}

class SettlementPage {
  Stream getSettlementList(Map<String, dynamic> query) {
    var url = Api.Settlement_SettlementList;

    var response = get(url, params: query);
    return response;
  }

  Stream getSettlementDetailsService(Map<String, dynamic> query) {
    var url = Api.Settlement_ServiceList;

    var response = get(url, params: query);
    return response;
  }

  Stream postSettlementDetailsAmount(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.Settlement_AmountDetails;

    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream getUserCardInfo(Map<String, dynamic> query) {
    var url = Api.Settlement_GetMember;

    var response = get(url, params: query);
    return response;
  }

  Stream getCouponList(Map<String, dynamic> query) {
    var url = Api.Settlement_PreferentialCard;

    var response = get(url, params: query);
    return response;
  }

  Stream postPayment(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.Settlement_Payment;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postAllSettlementDetails(dynamic request,
      {Map<String, dynamic> query}) {
    var url = Api.Settlement_OnAccountAmountDetails;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postAllPayment(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.Settlement_OnAccountPayment;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }
}

class SettlementPageRepo {
  final SettlementPage _remote = SettlementPage();

  Stream getSettlementList({Map<String, dynamic> query}) =>
      _remote.getSettlementList(query);

  Stream getSettlementDetailsService({Map<String, dynamic> query}) =>
      _remote.getSettlementDetailsService(query);

  Stream postSettlementDetailsAmount(dynamic request) =>
      _remote.postSettlementDetailsAmount(request);

  Stream getUserCardInfo({Map<String, dynamic> query}) =>
      _remote.getUserCardInfo(query);

  Stream getCouponList({Map<String, dynamic> query}) =>
      _remote.getCouponList(query);

  Stream postPayment(dynamic request) => _remote.postPayment(request);

  Stream postAllSettlementDetails(dynamic request) =>
      _remote.postAllSettlementDetails(request);

  Stream postAllPayment(dynamic request) => _remote.postAllPayment(request);
}

class PreferentialCardPage {
  Stream getCouponList(Map<String, dynamic> query) {
    var url = Api.Settlement_PreferentialCard;

    var response = get(url, params: query);
    return response;
  }
}

class PreferentialCardPageRepo {
  final PreferentialCardPage _remote = PreferentialCardPage();

  Stream getCouponList({Map<String, dynamic> query}) =>
      _remote.getCouponList(query);
}

class ShareRedPage {
  Stream getShareRedList(Map<String, dynamic> query) {
    var url = Api.Settlement_ServiceList;
    var response = get(url, params: query);
    return response;
  }

  Stream postShareRedList(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.Settlement_SaveShare;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }
}

class ShareRedPageRepo {
  final ShareRedPage _remote = ShareRedPage();

  Stream getShareRedList({Map<String, dynamic> query}) =>
      _remote.getShareRedList(query);

  Stream postShareRedList(dynamic request) => _remote.postShareRedList(request);
}


class InventoryManagePage {
  Stream getInventoryManageTypeNumber(Map<String , dynamic> query) {
    var url = Api.InventoryManage_TypeNumber;
    var response = get(url , params: query);
    return response;
  }

  Stream getInventoryManageContentList(Map<String , dynamic> query) {
    var url = Api.InventoryManage_ContentList;
    var response = get(url , params: query);
    return response;
  }

  Stream getGoodsTypeList(Map<String , dynamic> query) {
    var url = Api.InventoryManage_GoodsType;
    var response = get(url , params: query);
    return response;
  }

  Stream postSetGoodsTypeName(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.Add_GoodsType;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream getInventoryLocationList(Map<String , dynamic> query) {
    var url = Api.InventoryManage_Location;
    var response = get(url , params: query);
    return response;
  }

  Stream postSetInventoryLocation(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.Add_Location;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postAddGoods(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.Add_Goods;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postAddSecondHand(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.Add_SecondHand;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postAddEquipment(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.Add_AddEquipment;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream getInventoryDetails(Map<String , dynamic> query) {
    var url = Api.InventoryManage_GoodsDetails;
    var response = get(url , params: query);
    return response;
  }

  Stream getInventoryEquipmentDetails(Map<String , dynamic> query) {
    var url = Api.InventoryManage_Equipment;
    var response = get(url , params: query);
    return response;
  }

  Stream postModifyGoods(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.InventoryManage_ModifyGoods;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postModifyEquipment(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.InventoryManage_ModifyEquipment;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }


}

class InventoryManageRepo {
  final InventoryManagePage _remote = InventoryManagePage();
  Stream getInventoryManageTypeNumber({Map<String , dynamic> query}) => _remote.getInventoryManageTypeNumber(query);
  Stream getInventoryManageContentList({Map<String , dynamic> query}) => _remote.getInventoryManageContentList(query);
  Stream getGoodsTypeList({Map<String , dynamic> query}) => _remote.getGoodsTypeList(query);
  Stream postSetGoodsTypeName(dynamic request) => _remote.postSetGoodsTypeName(request);
  Stream getInventoryLocationList({Map<String , dynamic> query}) => _remote.getInventoryLocationList(query);
  Stream postSetInventoryLocation(dynamic request) => _remote.postSetInventoryLocation(request);
  Stream postAddGoods(dynamic request) => _remote.postAddGoods(request);
  Stream postAddSecondHand(dynamic request) => _remote.postAddSecondHand(request);
  Stream postAddEquipment(dynamic request) => _remote.postAddEquipment(request);

  Stream getInventoryDetails({Map<String , dynamic> query}) => _remote.getInventoryDetails(query);
  Stream getInventoryEquipmentDetails({Map<String , dynamic> query}) => _remote.getInventoryEquipmentDetails(query);

  Stream postModifyGoods(dynamic request) => _remote.postModifyGoods(request);

  Stream postModifyEquipment(dynamic request) => _remote.postModifyEquipment(request);
}

class ShareShopPage {
  Stream getShareShopPageList(Map<String, dynamic> query) {
    var url = Api.ShareShopPage_List;
    var response = get(url, params: query);
    return response;
  }

  Stream getShareShopServiceDetails(Map<String, dynamic> query) {
    var url = Api.ShareShopPage_ServiceDetails;
    var response = get(url, params: query);
    return response;
  }

  Stream getShareShopGoodsDetails(Map<String, dynamic> query) {
    var url = Api.ShareShopPage_GoodsDetails;
    var response = get(url, params: query);
    return response;
  }

  Stream getShareShopGoodsSpec(Map<String, dynamic> query) {
    var url = Api.ShareShopPage_GoodsSpec;
    var response = get(url, params: query);
    return response;
  }

  Stream getShareShopOtherDetails(Map<String, dynamic> query) {
    var url = Api.ShareShopPage_OtherDetails;
    var response = get(url, params: query);
    return response;
  }

  Stream postSubmitOrder(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.ShareShopPage_SubmitOrder;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream getPasswordStatus(Map<String, dynamic> query) {
    var url = Api.ShareShopPage_PasswordStatus;
    var response = get(url, params: query);
    return response;
  }

  Stream postPaymentOrder(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.ShareShopPage_PaymentOrder;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postPaymentOtherOrder(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.ShareShopPage_PaymentOtherOrder;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream getWeChatPaymentInfo(Map<String, dynamic> query) {
    var url = Api.ShareShopPage_WeChatPaymentInfo;
    var response = get(url, params: query);
    return response;
  }

}

class ShareShopPageRepo {

  final ShareShopPage _remote = ShareShopPage();

  Stream getShareShopPageList({Map<String, dynamic> query}) =>
      _remote.getShareShopPageList(query);

  Stream getShareShopServiceDetails({Map<String, dynamic> query}) =>
      _remote.getShareShopServiceDetails(query);

  Stream getShareShopGoodsDetails({Map<String, dynamic> query}) =>
      _remote.getShareShopGoodsDetails(query);

  Stream getShareShopGoodsSpec({Map<String, dynamic> query}) =>
      _remote.getShareShopGoodsSpec(query);

  Stream getShareShopOtherDetails({Map<String, dynamic> query}) =>
      _remote.getShareShopOtherDetails(query);

  Stream postSubmitOrder(dynamic request) => _remote.postSubmitOrder(request);

  Stream getPasswordStatus({Map<String, dynamic> query}) =>
      _remote.getPasswordStatus(query);

  Stream postPaymentOrder(dynamic request) => _remote.postPaymentOrder(request);

  Stream postPaymentOtherOrder(dynamic request) => _remote.postPaymentOtherOrder(request);

  Stream getWeChatPaymentInfo(dynamic request) => _remote.getWeChatPaymentInfo(request);

}

class SpannerStore {

  Stream getTypeList(Map<String, dynamic> query) {
    var url = Api.SpannerStorePage_TypeList;
    var response = get(url, params: query);
    return response;
  }

  Stream getContentList(Map<String, dynamic> query) {
    var url = Api.SpannerStorePage_ContentList;
    var response = get(url, params: query);
    return response;
  }

  Stream getGoodsList(Map<String, dynamic> query) {
    var url = Api.SpannerStorePage_GoodsList;
    var response = get(url, params: query);
    return response;
  }

  Stream getSpannerGoodsDetails(Map<String, dynamic> query) {
    var url = Api.SpannerStorePage_GoodsDetails;
    var response = get(url, params: query);
    return response;
  }

  Stream getSpannerGoodsSpec(Map<String, dynamic> query) {
    var url = Api.SpannerStorePage_GoodsSpec;
    var response = get(url, params: query);
    return response;
  }


  Stream postAddStoreCar(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.SpannerStorePage_AddStoreCar;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postSubmitSpannerShopOrder(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.SpannerStorePage_SubmitOrder;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream getShopCartInfo(Map<String, dynamic> query) {
    var url = Api.SpannerStorePage_CartInfo;
    var response = get(url, params: query);
    return response;
  }

  Stream postChangeCount(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.SpannerStorePage_ChangeCartCount;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postAllDelete(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.SpannerStorePage_AllDelete;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postPaymentOrder(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.SpannerStorePage_PaymentOrder;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postPaymentOtherOrder(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.SpannerStorePage_PaymentOtherOrder;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream getWeChatPaymentInfo(Map<String, dynamic> query) {
    var url = Api.SpannerStorePage_WeChatPaymentInfo;
    var response = get(url, params: query);
    return response;
  }

}

class SpannerStoreRepo {

  final SpannerStore _remote = SpannerStore();

  Stream getTypeList({Map<String, dynamic> query}) => _remote.getTypeList(query);

  Stream getContentList({Map<String, dynamic> query}) => _remote.getContentList(query);

  Stream getGoodsList({Map<String, dynamic> query}) => _remote.getGoodsList(query);

  Stream getSpannerGoodsDetails({Map<String, dynamic> query}) => _remote.getSpannerGoodsDetails(query);

  Stream getSpannerGoodsSpec({Map<String, dynamic> query}) => _remote.getSpannerGoodsSpec(query);

  Stream postAddStoreCar(dynamic request) => _remote.postAddStoreCar(request);

  Stream postSubmitSpannerShopOrder(dynamic request) => _remote.postSubmitSpannerShopOrder(request);

  Stream getShopCartInfo({Map<String, dynamic> query}) => _remote.getShopCartInfo(query);

  Stream postChangeCount(dynamic request) => _remote.postChangeCount(request);

  Stream postAllDelete(dynamic request) => _remote.postAllDelete(request);

  Stream postPaymentOrder(dynamic request) => _remote.postPaymentOrder(request);

  Stream postPaymentOtherOrder(dynamic request) => _remote.postPaymentOtherOrder(request);

  Stream getWeChatPaymentInfo(dynamic request) => _remote.getWeChatPaymentInfo(request);

}

class StoreOrder {

  Stream getStoreOrderList(Map<String, dynamic> query) {
    var url = Api.StoreOrder_list;
    var response = get(url, params: query);
    return response;
  }

  Stream postDeleteOrder(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.StoreOrder_delete;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream getStoreOrderDetails(Map<String, dynamic> query) {
    var url = Api.StoreOrder_details;
    var response = get(url, params: query);
    return response;
  }

  Stream postConfirm(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.StoreOrder_Confirm;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream postRemind(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.StoreOrder_Remind;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

}

class StoreOrderRepo {

  final StoreOrder _remote = StoreOrder();

  Stream getStoreOrderList({Map<String, dynamic> query}) => _remote.getStoreOrderList(query);

  Stream postDeleteOrder(dynamic request) => _remote.postDeleteOrder(request);

  Stream getStoreOrderDetails({Map<String, dynamic> query}) => _remote.getStoreOrderDetails(query);

  Stream postConfirm(dynamic request) => _remote.postConfirm(request);

  Stream postRemind(dynamic request) => _remote.postRemind(request);

}


class ShareOrder {

  Stream getOrderCount(Map<String, dynamic> query) {
    var url = Api.ShareOrder_OrderCount;
    var response = get(url, params: query);
    return response;
  }

  Stream getOrderList(Map<String, dynamic> query) {
    var url = Api.ShareOrder_OrderList;
    var response = get(url, params: query);
    return response;
  }

  Stream postDeleteOrder(dynamic request, {Map<String, dynamic> query}) {
    var url = Api.StoreOrder_delete;
    var response = post(url, body: request, queryParameters: null);
    return response;
  }

  Stream getStoreOrderDetails(Map<String, dynamic> query) {
    var url = Api.StoreOrder_details;
    var response = get(url, params: query);
    return response;
  }

  Stream getCheckPickupCode(Map<String, dynamic> query) {
    var url = Api.ShareOrder_CheckPickupCode;
    var response = get(url, params: query);
    return response;
  }

}

class ShareOrderRepo {

  final ShareOrder _remote = ShareOrder();

  Stream getOrderCount({Map<String, dynamic> query}) => _remote.getOrderCount(query);

  Stream getOrderList({Map<String, dynamic> query}) => _remote.getOrderList(query);


  Stream postDeleteOrder(dynamic request) => _remote.postDeleteOrder(request);

  Stream getStoreOrderDetails({Map<String, dynamic> query}) => _remote.getStoreOrderDetails(query);

  Stream getCheckPickupCode({Map<String, dynamic> query}) => _remote.getCheckPickupCode(query);

}