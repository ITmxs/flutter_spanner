import 'package:spanners/AfNetworking/requestDio.dart';

class ServiceApi {
  //--> 搜索 列表获取
  static void serchServiceListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.serviceDictLists,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('搜索--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('搜索--->$error');
      onError(error);
    });
  }

  //--> 添加服务
  static void addServiceRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.postServiceDict,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('添加服务--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('添加服务--->$error');
      onError(error);
    });
  }

  //--> 开启关闭
  static void isOpenRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.updateStatus,
        parameters: param, method: DioUtils.PUT, onSuccess: (data) {
      print('开启关闭--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('开启关闭--->$error');
      onError(error);
    });
  }

  //--> 获取 门店详情
  static void getShopMessageRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.serviceDictShopDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('门店详情--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('门店详情--->$error');
      onError(error);
    });
  }

  //--> 获取 服务详情
  static void getServiceMessageRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.dictDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('服务详情--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('服务详情--->$error');
      onError(error);
    });
  }

  //--> 修改 服务
  static void putRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.postServiceDict,
        parameters: param, method: DioUtils.PUT, onSuccess: (data) {
      print('修改 服务--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('修改 服务--->$error');
      onError(error);
    });
  }

  //--> 删除服务
  static void deletRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.postServiceDict,
        parameters: param, method: DioUtils.DELETE, onSuccess: (data) {
      print('修改 服务--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('修改 服务--->$error');
      onError(error);
    });
  }
}
