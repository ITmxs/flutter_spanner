import 'package:spanners/AfNetworking/requestDio.dart';

class WorkingDio {
  //--> 施工看板一览
  static void workingListRequest<T>({
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getWorkLookList,
        parameters: {'': ''}, method: DioUtils.GET, onSuccess: (data) {
      print('施工看板一览--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('施工看板一览--->$error');
      onError(error);
    });
  }

  //--> 施工看板搜索
  static void workingSerchRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getWorkLookList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('施工看板搜索--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('施工看板搜索--->$error');
      onError(error);
    });
  }

  //--> 施工看板修改
  static void workingEditRequest<T>({
    param,
    Function(bool) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.modifyWorkLookInfo,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('施工看板修改--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('施工看板修改--->$error');
      onError(error);
    });
  }

  //--> 施工看板开始 完成
  static void workingStutsRequest<T>({
    param,
    Function(bool) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.modifyWorkLookStatus,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('施工看板状态--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('施工看板状态--->$error');
      onError(error);
    });
  }
}
