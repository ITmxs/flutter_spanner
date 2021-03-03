import 'package:spanners/AfNetworking/requestDio.dart';

class AescueDio {
  //--> 列表
  static void rescueListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.rescueList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('救援列表--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('救援列表--->$error');
      onError(error);
    });
  }

  //--> 更新
  static void rescueUpdateRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.rescueUpdate,
        parameters: param, method: DioUtils.PUT, onSuccess: (data) {
      print('更新--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('更新--->$error');
      onError(error);
    });
  }
}
