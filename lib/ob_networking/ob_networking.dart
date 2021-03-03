import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/AfNetworking/requestDio.dart';
import 'network_manager.dart';
import 'dart:convert' as convert;

Stream get(String url, {Map<String, dynamic> params}) =>
    Stream.fromFuture(_get(url, params: params))
        .delay(Duration(milliseconds: 500))
        .asBroadcastStream();

Future _get(String url, {Map<String, dynamic> params}) async {
  var response = await DioUtils.requestHttp(url, parameters: params, method: DioUtils.GET,
      onSuccess: (data) {
        // onSuccess(data);
      }, onError: (error) {
        // onError(error);
      });
  var res = convert.jsonDecode(response.toString()); //转json
  if (res['code'] != 0) {
    print('网络请求错误' + res['msg']);
  }
  return response;
}

Stream post(String url, {dynamic body, Map<String, dynamic> queryParameters}) =>
    Stream.fromFuture(_post(url, body, queryParameters: queryParameters))
        .delay(Duration(milliseconds: 500))
        .asBroadcastStream();

Future _post(String url, dynamic body, {Map<String, dynamic> queryParameters}) async {
  var response = await DioUtils.requestHttp(url, parameters: body, method: DioUtils.POST,
      onSuccess: (data) {
        // onSuccess(data);
      }, onError: (error) {
        // onError(error);
      });
  var res = convert.jsonDecode(response.toString()); //转json
  if (res['code'] != 0) {
    print('网络请求错误' + res['msg']);
    BotToast.showText(text: '网络请求错误' + res['msg']);
  }else {
    return response;
  }
}

