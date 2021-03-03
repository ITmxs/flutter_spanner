import 'package:spanners/AfNetworking/requestDio.dart';

class ReciveDio {
  //--> 接车看板
  static void secondaryListRequest<T>({
    String flag,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.receiveCarPage + '/' + flag,
        parameters: '', method: DioUtils.NEWGET, onSuccess: (data) {
      print('接车看板--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('接车看板--->$error');
      onError(error);
    });
  }

  //--> 接车看板 删除操作
  static void deleteListRequest<T>({
    String workOrderId,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.receiveCar + '/' + workOrderId,
        parameters: {'': ''}, method: DioUtils.DELETE, onSuccess: (data) {
      print('接车看板--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('接车看板--->$error');
      onError(error);
    });
  }
}
