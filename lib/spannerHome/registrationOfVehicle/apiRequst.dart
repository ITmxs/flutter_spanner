import 'package:spanners/AfNetworking/requestDio.dart';

class ApiDio {
  //--> 车辆管理列表 信息获取
  static void vehicleListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.vehicleManagementList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //--> 车辆管理详细 信息获取
  static void vehicleDetailListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.vehicleListDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }
}
