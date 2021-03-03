
import 'package:bot_toast/bot_toast.dart';

bool isPhone(String input) {
  RegExp mobile = RegExp(r"1[0-9]\d{9}$");
  if(!mobile.hasMatch(input)){
    BotToast.showText(text: '请输入正确的手机号 ！');
  }
  return mobile.hasMatch(input);
}

String multiplyTotalPrices(String num, String prices) {
  double results = double.parse(num) * double.parse(prices);
  return results.toString();
}