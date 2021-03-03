import 'package:spanners/AfNetworking/requestDio.dart';

class SaleApiRequst {
  //--> 销售任务首页
  static void salesTaskRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.salesTask,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('销售任务首页--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('销售任务首页--->$error');
      onError(error);
    });
  }

  //--> 获取员工列表
  static void employeeListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.employeeList,
        parameters: {'': ''}, method: DioUtils.GET, onSuccess: (data) {
      print('获取员工列表--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('获取员工列表--->$error');
      onError(error);
    });
  }

  //-->  员工销售记录分页
  static void recordListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.recordList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('员工销售记录分页--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('员工销售记录分页--->$error');
      onError(error);
    });
  }

  //-->  通过 拒绝
  static void reviewRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.review,
        parameters: param, method: DioUtils.PUT, onSuccess: (data) {
      print('通过 拒绝--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('通过 拒绝--->$error');
      onError(error);
    });
  }

  //-->  删除
  static void deleteRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.deleteRecord,
        parameters: param, method: DioUtils.DELETE, onSuccess: (data) {
      print('删除--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('删除--->$error');
      onError(error);
    });
  }

  //-->  删除 任务
  static void salesTaskDeleteRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.salesTaskDelete,
        parameters: param, method: DioUtils.DELETE, onSuccess: (data) {
      print('删除--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('删除--->$error');
      onError(error);
    });
  }

  //-->  保存销售任务
  static void saveRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.saveRecord,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('保存销售任务--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('保存销售任务--->$error');
      onError(error);
    });
  }

  //-->  任务list
  static void taskListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getTaskList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('任务list--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('任务list--->$error');
      onError(error);
    });
  }

  //-->  店内任务list
  static void editTaskListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.taskDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('店内任务list--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('店内任务list--->$error');
      onError(error);
    });
  }

  //-->  保存
  static void salesTaskSaveRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.salesTaskSave,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('保存--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('保存--->$error');
      onError(error);
    });
  }

  //-->  任务详情+员工任务详情
  static void taskInfoRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.taskInfo,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('任务详情+员工任务详情--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('任务详情+员工任务详情--->$error');
      onError(error);
    });
  }
}
