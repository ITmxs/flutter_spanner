import 'package:spanners/AfNetworking/requestDio.dart';

class PackingDio {
  //--> 领料管理列表
  static void pickingListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.pickingList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('领料管理列表--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('领料管理列表--->$error');
      onError(error);
    });
  }

  //--> 内部领料管理列表
  static void pickingListNeiRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.pickingListNei,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('内部领料管理列表--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('内部领料管理列表--->$error');
      onError(error);
    });
  }

  //--> 领料单保存
  static void pickingSaveRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.pickingSave,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('领料单保存--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('领料单保存--->$error');
      onError(error);
    });
  }

  //--> 领料单库存商品
  static void pickingGoodsListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.pickingGoodsList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('领料单库存商品--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('领料单库存商品--->$error');
      onError(error);
    });
  }
}
