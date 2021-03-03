import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class NetWorkManager {
  static NetWorkManager instance;
  Dio dio;
  BaseOptions options;

  static NetWorkManager getInstance() {
    if (instance == null) {
      instance = new NetWorkManager();
    }
    return instance;
  }

  var cookieJar = CookieJar();
  NetWorkManager() {
    dio =  Dio()
      ..options = BaseOptions(
         baseUrl: 'http://192.168.31.61:8087/api/',
//          baseUrl: 'http://39.99.181.83:8087/api/',
//          baseUrl: 'http://192.168.31.23:8087/api/',

          connectTimeout: 150000,
          receiveTimeout: 150000,
          responseType: ResponseType.json,
          headers: httpHeaders)
    ..interceptors.add(CookieManager(cookieJar));
//      ..interceptors.add(HeaderInterceptor());
//      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
}

/// 自定义Header
Map<String, dynamic> httpHeaders = {
  'Accept': 'application/json,*/*',
  'Content-Type': 'application/json',
  // 'application / x-www-form-urlencoded', //'application/json',
  'token': '215675f09968463f8339cb89a4592a6a'
};

//class HeaderInterceptor extends Interceptor {
//  @override
//  onRequest(RequestOptions options) {
//    final token = AppConfig.userTools.getUserToken();
//    if (token != null && token.length > 0) {
//      options.headers
//          .putIfAbsent('Authorization', () => 'Bearer' + ' ' + token);
//    }
////    if (options.uri.path.indexOf('api/user/advice/Imgs') > 0 || options.uri.path.indexOf('api/user/uploadUserHeader') > 0) { // 上传图片
////      options.headers.putIfAbsent('Content-Type', () => 'multipart/form-data');
////      print('上传图片');
////    } else {
////    }
////    options.headers.putIfAbsent('Content-Type', () => 'application/json;charset=UTF-8');
//
//    return super.onRequest(options);
//  }
//}
