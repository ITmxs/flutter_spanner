import 'package:spanners/AfNetworking/requestDio.dart';

class PerformanceDio {
//--> 首页 全部 信息获取
  static void performanceRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.performanceList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      //  print('${param}');
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }

  static void dayPerformanceRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.dayPerformanceList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      //  print('${param}');
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }

  static void toBonusListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.toBonusList,
        method: DioUtils.GET, parameters: {'': ''}, onSuccess: (data) {
      //  print('${param}');
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }

  static void individualPerformance<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.individualPerformance,
        method: DioUtils.GET, parameters: param, onSuccess: (data) {
      //  print('${param}');
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }

  static void individualDayPerformance<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.individualDayPerformance,
        method: DioUtils.GET, parameters: param, onSuccess: (data) {
      //  print('${param}');
      onSuccess(data);
    }, onError: (error) {
      print('${error}');
      //onError(error);
    });
  }
}
