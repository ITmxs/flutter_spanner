import 'package:spanners/AfNetworking/requestDio.dart';

class PubDio {
  //--> 派工 人员 列表
  static void pubCostRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.costList,
        parameters: {'workOrderId': param},
        method: DioUtils.GET, onSuccess: (data) {
      print('成本清单--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('成本清单失败--->$error');
      onError(error);
    });
  }

  //--> 保养手册筛选
  static void pubMainterRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.maintenanceServiceList,
        parameters: {'workOrderId': param},
        method: DioUtils.GET, onSuccess: (data) {
      print('保养手册筛选--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('保养手册筛选失败--->$error');
      onError(error);
    });
  }

  //--> 创建保养手册
  static void pubMainterCreatRequest<T>({
    Map param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.maintenanceSave,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('创建保养手册--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('创建保养手册失败--->$error');
      onError(error);
    });
  }

  //--> 保养手册列表
  static void pubMainterListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.maintenanceList,
        parameters: {'vehicleLicence': param},
        method: DioUtils.GET, onSuccess: (data) {
      print('保养手册列表--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('保养手册列表失败--->$error');
      onError(error);
    });
  }

  //--> 权限列表获取
  static void getPermissionRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.permissions,
        parameters: {'': ''}, method: DioUtils.GET, onSuccess: (data) {
      print('权限列表获取--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('权限列表获取--->$error');
      onError(error);
    });
  }
}
