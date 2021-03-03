import 'package:spanners/AfNetworking/requestDio.dart';
import 'package:spanners/cTools/sharedPreferences.dart';

class ApiDio {
/*
预约看板
*/
  static void appointRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getAppointmentListURL,
        parameters: param, method: DioUtils.NEWGET, onSuccess: (data) {
      print('预约--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('预约--->$error');
      onError(error);
    });
  }

/*
接车
*/
  static void getCarRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getAllCarURL,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('接车--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('接车--->$error');
      onError(error);
    });
  }

/*
删除
*/
  static void deleteCarRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.workorderURL,
        parameters: param, method: DioUtils.DELETE, onSuccess: (data) {
      print('接车--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('接车--->$error');
      onError(error);
    });
  }

/*
预约看板详情
*/
  static void detailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.appointmentDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('详情--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('--->$error');
      onError(error);
    });
  }

/*
预约看板详情
*/

  static void detailRequests<T>({
    String workorderid,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp('workorder/getAppointmentDetail/$workorderid',
        method: DioUtils.GET, onSuccess: (data) {
      print('详情--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('--->$error');
      onError(error);
    });
  }
/*
 预约看板详情 修改时间
*/

  static void detailEditTimeRequests<T>({
    pragm,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.appointment,
        parameters: pragm, method: DioUtils.PUT, onSuccess: (data) {
      print('详情--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('--->$error');
      onError(error);
    });
  }
/*
 预约看板 新建预约
*/

  static void newApointMentRequests<T>({
    pragm,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.appointment,
        parameters: pragm, method: DioUtils.POST, onSuccess: (data) {
      print('新增--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('--->$error');
      onError(error);
    });
  }

/*
 新建预约 一二级分类
*/
  static void getserviceDictList<T>({
    pragm,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.serviceDictList,
        parameters: {'': ''}, method: DioUtils.GET, onSuccess: (data) {
      print('一二级分类--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('--->$error');
      onError(error);
    });
  }

  /*
 新建预约 一二级分类
*/
  static void getServiceDict<T>({
    pragm,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.serviceDictList,
        parameters: pragm, method: DioUtils.GET, onSuccess: (data) {
      print('一二级分类--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('--->$error');
      onError(error);
    });
  }

  /*
   新建预约 根据车牌号查询
*/
  static void getVehicleLicenceDictList<T>({
    pragm,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getVehicle + '/' + pragm,
        method: DioUtils.NEWGET, onSuccess: (data) {
      print('车牌号查询--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('--->$error');
      onError(error);
    });
  }
}
