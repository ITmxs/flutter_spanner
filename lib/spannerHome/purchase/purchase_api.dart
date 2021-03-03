import 'package:spanners/AfNetworking/requestDio.dart';

/// Copyright (C), 2020-2020, spanners
/// FileName: purchase_api
/// Author: Jack
/// Date: 2020/12/18c
/// Description:
class PurchaseApi {
  static void addPurchase<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.addPurchase,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
    });
  }

  static void deleteItem<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.deleteItem,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
    });
  }

  static void getMaterialList<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getMaterialList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
    });
  }

  static void getPurchaseDetail<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getPurchaseDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
    });
  }

  static void getPurchaseList<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getPurchaseList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
    });
  }

  static void getServiceMaterialDetail<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getServiceMaterialDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
    });
  }

  static void getStockShopList<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getStockShopList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
    });
  }

  static void itemInStore<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.itemInStore,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
    });
  }

  static void updateMaterial<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.updateMaterial,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
    });
  }

  static void updatePurchase<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.updatePurchase,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
    });
  }
}
