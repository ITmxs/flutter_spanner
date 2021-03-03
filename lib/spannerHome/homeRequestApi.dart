import 'package:spanners/AfNetworking/requestDio.dart';

class HomeDio {
//--> 首页 全部 信息获取
  static void homeRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.homeURL,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('店铺--->$param');
      onSuccess(data);
    }, onError: (error) {
      print('店铺--->$error');
      onError(error);
    });
  }

  //--> 首页 全部 信息获取
  static void shopRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.shopList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('门店--->$param');
      onSuccess(data);
    }, onError: (error) {
      print('门店--->$error');
      onError(error);
    });
  }

  //--> 首页  删除智能提醒
  static void deleteWarning<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.deleteWarning,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('删除智能提醒--->$param');
      onSuccess(data);
    }, onError: (error) {
      print('删除智能提醒--->$error');
      onError(error);
    });
  }
}
