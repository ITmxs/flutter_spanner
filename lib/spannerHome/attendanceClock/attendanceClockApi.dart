import 'package:spanners/AfNetworking/requestDio.dart';

class AttendanceApi {
  //--> 考勤打卡初始化
  static void attendanceClockInitRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.attendanceClockInit,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('考勤分析初期 日--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('考勤分析初期 日--->$error');
      onError(error);
    });
  }

  //--> 考勤打卡
  static void attendanceClockInRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.attendanceClockIn,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('考勤分析初期 月--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('考勤分析初期 月--->$error');
      onError(error);
    });
  }

}
