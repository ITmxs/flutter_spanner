import 'package:url_launcher/url_launcher.dart';

/* 
   拨打电话
*/
class CallIphone {
  static callPhone(String tel) {
    launch('tel://$tel');
  }
}
