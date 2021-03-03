import 'package:flutter/material.dart';
import 'package:spanners/ob_networking/network_service.dart';

///常量
class AppColors {
  static const AppBarColor = Colors.white;
  static const primaryColor = Color.fromRGBO(39, 153, 93, 1); //主题色
  static const ViewBackgroundColor = Color.fromRGBO(238, 238, 238, 1); //背景灰色色
  static const TextColor = Color(0xFF1E1E1E); //文字色
  static const SubTextColor =  Color.fromRGBO(145,145,145,1);//文字色灰色
  static const backgroundColor = Color.fromRGBO(233,245,238,1); //主题色
}

///枚举
enum Pages {
  PagesDeliveryCheckPage,
  PagesSettlementPage,
  PagesWeatherPage,
  PagesInventoryManagePage,
  PagesPerformanceStatisticsPage,

}

///常量
class AppConst {
  static const wxAppId = "wxe803b61757e98b96";
}

///api常量
class Api {
  static const port = ''; //':8080';
  static const servicePath = '/api';

  // static const port = ''; //':8080';
  // static const servicePath = 'api'; //'/api';

  ///交验
  //获取列表
  static const Delivery_InspectionList =
      port + servicePath + '/workorder/getDeliveryInspectionList';
  //拒绝原因
  static const Delivery_RefuseBecause =
      port + servicePath + '/workorder/updateWorkCheck';
  //获取详情
  static const Delivery_Details =
      port + servicePath + '/workorder/getDeliveryInspectionDetail';
  //获取优惠卡详情
  static const Delivery_QueryCampaign =
      port + servicePath + '/settlement/queryCampaignInfo';

  ///天气
  //获取天气信息
  static const Weather_Info = port + servicePath + '/weather/query';

  ///IM聊天
  //好友列表
  static const IM_FriendList = port + servicePath + '/im/getFriendsList';
  //搜索用户
  static const IM_SearchUserInfo =
      port + servicePath + '/user/getUserInfoByUsername';
  //申请好友
  static const IM_ApplyFriend = port + servicePath + '/applyFriend';
  //查询申请消息
  static const IM_ApplyMessage =
      port + servicePath + '/applyFriend/getApplyListByUsername';
  //好友申请验证
  static const IM_JudgeApplyMessage =
      port + servicePath + '/applyFriend/updateApplyStatus';
  //删除好友
  static const IM_DeleteUserFriend =
      port + servicePath + '/im/deleteUserFriend';

  ///结算
  //结算列表
  static const Settlement_SettlementList =
      port + servicePath + '/settlement/list';
  //服务列表
  static const Settlement_ServiceList =
      port + servicePath + '/settlement/query/serviceList';
  //结算金额详情
  static const Settlement_AmountDetails =
      port + servicePath + '/settlement/query/amountDetails';
  //会员用户详情
  static const Settlement_GetMember =
      port + servicePath + '/receiveCar/getMember';
  //优惠列表
  static const Settlement_PreferentialCard =
      port + servicePath + '/coupon/list';
  //结算
  static const Settlement_Payment = port + servicePath + '/settlement/payment';
  //获取统一挂账金额
  static const Settlement_OnAccountAmountDetails =
      port + servicePath + '/settlement/query/onAccountAmountDetails';
  //获取统一结算
  static const Settlement_OnAccountPayment =
      port + servicePath + '/settlement/onAccountPayment';
  //分红保存
  static const Settlement_SaveShare =
      port + servicePath + '/settlement/saveShare';

  ///库存
  //库存数量
  static const InventoryManage_TypeNumber = port + servicePath +'/inventory/query/count';
  //内容列表
  static const InventoryManage_ContentList = port + servicePath +'/inventory/query/list';
  //物品分类列表
  static const InventoryManage_GoodsType = port + servicePath +'/inventory/query/category';
  //添加商品分类
  static const Add_GoodsType = port + servicePath +'/category/add';
  //库位列表
  static const InventoryManage_Location = port + servicePath +'/goodsLocation/query/list';
  //添加库位
  static const Add_Location = port + servicePath +'/goodsLocation/add';
  //添加商品
  static const Add_Goods = port + servicePath +'/inventory/add/goods';
  //添加二手
  static const Add_SecondHand = port + servicePath +'/inventory/add/secondHand';
  //添加设备
  static const Add_AddEquipment = port + servicePath +'/inventory/add/equipment';
  //库存详情
  static const InventoryManage_GoodsDetails = port + servicePath +'/inventory/query/shareGoods';
  //库存工具详情
  static const InventoryManage_Equipment = port + servicePath +'/inventory/query/equipment';
  //修改库存商品
  static const InventoryManage_ModifyGoods = port + servicePath +'/inventory/modify/goods';
  //修改工具设备
  static const InventoryManage_ModifyEquipment = port + servicePath +'/inventory/modify/equipment';


  ///共享商城
  //共享商城列表
  static const ShareShopPage_List = port + servicePath +'/share/shop/query/list';
  //共享商城服务详情
  static const ShareShopPage_ServiceDetails = port + servicePath +'/share/shop/query/service';
  //共享商城商品详情
  static const ShareShopPage_GoodsDetails = port + servicePath +'/share/shop/query/shareGoods';
  //共享商品规格
  static const ShareShopPage_GoodsSpec = port + servicePath +'/share/shop/query/shareGoods/spec';
  //共享商城工具二手详情
  static const ShareShopPage_OtherDetails = port + servicePath +'/share/shop/query/shareEquipment';
  //提交订单
  static const ShareShopPage_SubmitOrder = port + servicePath +'/share/shop/submit/order';
  //判断是否设置密码
  static const ShareShopPage_PasswordStatus = port + servicePath +'/share/shop/order/balance';
  //订单支付
  static const ShareShopPage_PaymentOrder = port + servicePath +'/share/shop/order/payment';
  //订单支付其他支付方式
  static const ShareShopPage_PaymentOtherOrder = port + servicePath +'/share/shop/order/payment/already';
  //获取微信支付信息
  static const ShareShopPage_WeChatPaymentInfo = port + servicePath +'/share/shop/order/payment/wechat/status';


  ///扳手商城
  //1级分类列表
  static const SpannerStorePage_TypeList = port + servicePath +'/spanner/shop/index/category/first';
  //2级分类列表
  static const SpannerStorePage_ContentList = port + servicePath +'/spanner/shop/index/category/second';
  //获取商品列表
  static const SpannerStorePage_GoodsList = port + servicePath +'/spanner/shop/index/goods/list';
  //获取商品详情
  static const SpannerStorePage_GoodsDetails = port + servicePath +'/spanner/shop/goods/query';
  //获取商品规格
  static const SpannerStorePage_GoodsSpec = port + servicePath +'/spanner/shop/goods/spec';
  //加入购物车
  static const SpannerStorePage_AddStoreCar = port + servicePath +'/spanner/shop/cart/add';
  //提交订单
  static const SpannerStorePage_SubmitOrder = port + servicePath +'/spanner/shop/order/submit';
  //购物车信息
  static const SpannerStorePage_CartInfo = port + servicePath +'/spanner/shop/cart/list';
  //修改购物车数量
  static const SpannerStorePage_ChangeCartCount = port + servicePath +'/spanner/shop/cart/modify';
  //批量删除购物车
  static const SpannerStorePage_AllDelete = port + servicePath +'/spanner/shop/cart/remove';
  //订单支付
  static const SpannerStorePage_PaymentOrder = port + servicePath +'/spanner/shop/order/payment';
  //订单支付其他支付方式
  static const SpannerStorePage_PaymentOtherOrder = port + servicePath +'/spanner/shop/order/payment/already';
  //获取微信支付信息
  static const SpannerStorePage_WeChatPaymentInfo = port + servicePath +'/spanner/shop/order/payment/wechat/status';

  ///商城订单
  //1级分类列表
  static const StoreOrder_list = port + servicePath +'/shopOrder/page';
  //删除订单
  static const StoreOrder_delete = port + servicePath +'/shopOrder/cancelOrder';
  //订单详情
  static const StoreOrder_details = port + servicePath +'/share/shop/trade/query/goods/info';
  //确认收货
  static const StoreOrder_Confirm = port + servicePath +'/spanner/shop/order/receive/delivery';
  //提醒发货
  static const StoreOrder_Remind = port + servicePath +'/spanner/shop/order/remind/delivery';


  ///共享订单
  //共享订单数量
  static const ShareOrder_OrderCount = port + servicePath +'/share/shop/trade/query/count';
  //共享订单列表
  static const ShareOrder_OrderList = port + servicePath +'/share/shop/trade/query/goods/list';
  //共享订单验证取货码
  static const ShareOrder_CheckPickupCode = port + servicePath +'/share/shop/trade/query/goods/checkPickupCode';

}
