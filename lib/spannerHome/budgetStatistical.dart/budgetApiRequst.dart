import 'package:spanners/AfNetworking/requestDio.dart';

class BudgetApi {
  //--> 根据月份获取收支统计
  static void accounttantRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.accounttantDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('根据月份获取收支统计--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('根据月份获取收支统计失败--->$error');
      onError(error);
    });
  }

  //--> 创建统计
  static void creatAccounttantRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.accounttantSave,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('创建统计--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('创建统计失败--->$error');
      onError(error);
    });
  }

  //--> 根据月份获取收支统计详情
  static void getDetailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.accounttantExplicit,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('根据月份获取收支统计--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('根据月份获取收支统计失败--->$error');
      onError(error);
    });
  }
}
