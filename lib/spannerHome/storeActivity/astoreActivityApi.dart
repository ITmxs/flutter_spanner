import 'package:spanners/AfNetworking/requestDio.dart';

class ActivityDio {
  //--> 门店活动 搜索
  static void campaignListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.campaignList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('门店活动--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('门店活动--->$error');
      onError(error);
    });
  }

  //--> 卡劵详情
  static void campaignDetailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.campaignDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('卡劵详情--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('卡劵详情--->$error');
      onError(error);
    });
  }

  //--> 门店活动 保存
  static void campaignSaveRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.campaignSave,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('保存--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('保存--->$error');
      onError(error);
    });
  }

  //--> 卡劵 删除
  static void deleteCampaignRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.deleteCampaign,
        parameters: param, method: DioUtils.DELETE, onSuccess: (data) {
      print('卡劵 删除--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('卡劵 删除--->$error');
      onError(error);
    });
  }

  //--> 商品 删除
  static void deleteCampaignGoodsRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.deleteCampaignGoods,
        parameters: param, method: DioUtils.DELETE, onSuccess: (data) {
      print('商品 删除--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('商品 删除--->$error');
      onError(error);
    });
  }
}
