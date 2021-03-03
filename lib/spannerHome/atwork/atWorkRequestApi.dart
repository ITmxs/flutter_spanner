import 'package:spanners/AfNetworking/requestDio.dart';

class UntilApi {
  //--> 派工 列表
  static void atworkRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getWorkLookListPG,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('成功--->$param');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error');
      onError(error);
    });
  }

  //--> 派工 人员 列表
  static void atworkPeopleRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getUserList,
        parameters: {'shopId': ''}, method: DioUtils.GET, onSuccess: (data) {
      print('人员列表--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error');
      onError(error);
    });
  }

  //--> 派工
  static void atworkPostRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.updateWorkAll,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('派工成功--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error');
      onError(error);
    });
  }

  //--> 删除
  static void atworkDeletRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.delWorkAll,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('删除成功--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error');
      onError(error);
    });
  }
}
