import 'package:spanners/AfNetworking/requestDio.dart';
import 'dart:convert' as convert;

/*
    车牌，VIN ，
*/
class ScanDio {
/*
OCR 识别
*/
  static void ocrRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp('api/workorder/scanLicense',
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('OCR 识别--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('OCR 识别--->$error');
      onError(error);
    });
  }

/*
 vin 识别
*/
  static void vinRequest<T>({
    param,
    Function(String value) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp('api/workorder/scanLicenseVin',
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      Map<String, dynamic> dataMap = convert.jsonDecode(data);
      print(
          'vin 识别--->${dataMap['data'][0]['results'][0]['vehicleVinInfo']['vin']}');
      onSuccess(dataMap['data'][0]['results'][0]['vehicleVinInfo']['vin']);
    }, onError: (error) {
      print('vin err识别--->$error');
      onError(error);
    });
  }

  /*
   图片上传
*/
  static void imageRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp('api/shopcampaign/uploadFile?fileFlag=carfriend',
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('图片上传--->$data}');
      onSuccess(data);
    }, onError: (error) {
      print('图片上传失败--->$error');
      onError(error);
    });
  }

  /*
   视频上传
*/
  static void videoRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp('api/shopcampaign/uploadVideoFile?fileFlag=carfriend',
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('视频上传--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('视频上传失败--->$error');
      onError(error);
    });
  }
}
