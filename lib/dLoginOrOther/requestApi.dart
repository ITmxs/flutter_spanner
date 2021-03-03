import 'package:spanners/AfNetworking/requestDio.dart';
import 'package:spanners/cModel/loginModel.dart';

class DioRequest {
//--> 登录
  static void loginRequest<T>({
    param,
    Function(LoginMessage) onSuccess,
    Function(String error) onError,
  }) async {
    print('网络请求');
    DioUtils.requestHttp('api/auth/login',
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('网络请求回调');
      var loginMessage = LoginMessage.fromJson(data);
      print('店铺--->${loginMessage.shopId}');
      print('用户--->${loginMessage.userid}');

      onSuccess(loginMessage);
    }, onError: (error) {
      onError(error);
    });
  }

//--> 发送验证码
  static void phoneRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp('api/register/sendMsg',
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      onError(error);
    });
  }
  static void msgRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp('api/register/sendMsgByPay',
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
          onSuccess(data);
        }, onError: (error) {
          onError(error);
        });
  }
  static void checkMsgRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp('api/register/checkMsg',
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
          onSuccess(data);
        }, onError: (error) {
          onError(error);
        });
  }
//--> 确认修改密码
  static void sureRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp('api/register/updatePassword',
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      onError(error);
    });
  }
}
