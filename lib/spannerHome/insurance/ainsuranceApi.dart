import 'package:spanners/AfNetworking/requestDio.dart';

class InsureDio {
  //--> 列表
  static void newInsureListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.newInsureList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('列表--->$error');
      onError(error);
    });
  }

  //--> 详情
  static void newInsureInfoRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.newInsureInfo,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('详情--->$error');
      onError(error);
    });
  }

  //--> 保存/修改
  static void newInsureSaveRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.newInsureSave,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('保存/修改--->$error');
      onError(error);
    });
  }
}
