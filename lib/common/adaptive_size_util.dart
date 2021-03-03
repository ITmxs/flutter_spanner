import 'dart:ui' as ui;

class SizeAdaptiveUtil {
  static SizeAdaptiveUtil _instance;
  factory SizeAdaptiveUtil() => _getInstance();
  static double windowWidth;
  static double windowHeight;
  static double _widthPercentage;
  static double _scaling = 1.0;
  setScaling(double num) {
    _scaling = num;
  }


  SizeAdaptiveUtil._();
  static void init({double width = 375, double height = 812}) {
    windowWidth = ui.window.physicalSize.width / ui.window.devicePixelRatio;
    windowHeight = ui.window.physicalSize.height / ui.window.devicePixelRatio;
    _widthPercentage = windowWidth / width;
  }

  static SizeAdaptiveUtil _getInstance() {
    if (_instance == null) {
      _instance = SizeAdaptiveUtil._();
      SizeAdaptiveUtil.init();
      return _instance;
    }
    return _instance;
  }

  double size(num designSize) => designSize * _widthPercentage;
  double fontSize(num designFontSize) =>
      designFontSize * _widthPercentage * _scaling;
}
