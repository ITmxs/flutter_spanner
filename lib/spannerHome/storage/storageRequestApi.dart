import 'package:spanners/AfNetworking/requestDio.dart';

class StorageRequestApi {
  static void addStorageRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.addStorage,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }

  static void deleteStorage<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.deleteStorage,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }

  static void findItemRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.findStorage,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }

  static void getStorageDetailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.storageDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }

  static void getStorageListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.storageList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }

  static void takeItem<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.takeOutItem,
        parameters: param,
        method: DioUtils.POST,
         onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }

  static void findUser<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.findUser,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }

  static void updateComment<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.updateComment,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }
}
