import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:spanners/cTools/Alart.dart';

class Scan {
  //  扫描二维码/条形码
  static Future<String> scan() async {
    try {
      // 此处为扫码结果，barcode为二维码的内容
      String barcode = await BarcodeScanner.scan();
      print('扫码结果: ' + barcode);
      return barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // 未授予APP相机权限

        Alart.showAlartDialog('未授予APP相机权限', 1);
      } else {
        // 扫码错误
        // Alart.showAlartDialog('扫码错误: $e', 1);
      }
    } on FormatException {
      // 进入扫码页面后未扫码就返回
      //Alart.showAlartDialog('进入扫码页面后未扫码就返回', 1);
    } catch (e) {
      // 扫码错误
      // Alart.showAlartDialog('扫码错误: $e', 1);
    }
    return null;
  }
}
