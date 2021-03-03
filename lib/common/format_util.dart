/// Copyright (C), 2020-2020, spanners
/// FileName: format_util
/// Author: Jack
/// Date: 2020/12/21
/// Description:
class FormatUtil {
  static String formatDateYMD(DateTime time) {
    if (time == null) {
      time = DateTime.now();
    }
    return "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}";
  }
  static String formatDateYM(DateTime time) {
    if (time == null) {
      time = DateTime.now();
    }
    return "${time.year}-${time.month.toString().padLeft(2, '0')}";
  }

  static String formatDateYMDHM(DateTime time) {
    if (time == null) {
      time = DateTime.now();
    }
    return "${time.year}-${time.month}-${time.day} ${time.hour.toString().padLeft(2, '0')}-${time.second.toString().padLeft(2, '0')}";
  }
}
