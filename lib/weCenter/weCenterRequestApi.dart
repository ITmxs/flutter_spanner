import 'package:spanners/AfNetworking/requestDio.dart';

class WeCenterDio {
  //登出接口
  static void logOutRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.logout,
        parameters: {'': ''}, method: DioUtils.GET, onSuccess: (data) {
      print('成功--->$param');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error');
      onError(error);
    });
  }

  //获取首页信息 && 门店详情
  static void myInfoRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.myInfo, method: DioUtils.NEWGET,
        onSuccess: (data) {
      print('wode 成功--->$param');
      onSuccess(data);
    }, onError: (error) {
      print('wode失败--->$error');
      onError(error);
    });
  }

  //个人信息
  static void getEmployeeDetailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.employeeDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //意见反馈
  static void addFeedbackRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.addFeedback,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //分红设置
  static void shareSettingRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.shareSetting,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //校验是否有支付密码
  static void hasPayPasswordRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.hasPayPassword,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //更新支付密码
  static void updatePayPasswordRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.updatePassword,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }
}
