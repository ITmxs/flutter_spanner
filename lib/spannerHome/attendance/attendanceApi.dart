import 'package:spanners/AfNetworking/requestDio.dart';

class AttendanceApi {
  //--> 考勤分析初期 日
  static void initDetailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.initDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('考勤分析初期 日--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('考勤分析初期 日--->$error');
      onError(error);
    });
  }

  //--> 考勤分析初期 月
  static void attendancePersonMonthRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.attendancePersonMonth,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('考勤分析初期 月--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('考勤分析初期 月--->$error');
      onError(error);
    });
  }

  //--> 添加休假
  static void saveLeaveRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.saveLeave,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('添加休假--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('添加休假--->$error');
      onError(error);
    });
  }

  //--> 考勤规则表示
  static void attendanceRuleListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.attendanceRuleList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('考勤规则表示--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('考勤规则表示--->$error');
      onError(error);
    });
  }

  //--> 添加规则-----考勤人员一览接口
  static void getWorkgroupAttListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getWorkgroupAttList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('添加规则-----考勤人员一览接口--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('添加规则-----考勤人员一览接口--->$error');
      onError(error);
    });
  }

  //--> 删除考勤规则
  static void deleteRuleRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.deleteRule,
        parameters: param, method: DioUtils.DELETE, onSuccess: (data) {
      print('删除考勤规则--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('删除考勤规则--->$error');
      onError(error);
    });
  }

  static void attendanceDetailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.attendanceDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('考勤规则详细--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('考勤规则详细--->$error');
      onError(error);
    });
  }
  static void attendanceDayDetailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.attendanceDayDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
          print('考勤规则详细--->$data');
          onSuccess(data);
        }, onError: (error) {
          print('考勤规则详细--->$error');
          onError(error);
        });
  }

  static void updateAttRuleRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.updAttRule,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('考勤规则详细--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('考勤规则详细--->$error');
      onError(error);
    });
  }
  static void addAttRuleRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.addAttRule,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
          print('考勤规则详细--->$data');
          onSuccess(data);
        }, onError: (error) {
          print('考勤规则详细--->$error');
          onError(error);
        });
  }

  static void getAttRuleRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getAttRule,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('考勤规则详细--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('考勤规则详细--->$error');
      onError(error);
    });
  }
}
