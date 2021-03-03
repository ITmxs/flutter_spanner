import 'adaptive_size_util.dart';

extension getSizeNum on num {
  num get s => SizeAdaptiveUtil().size(this);
  num get sp => SizeAdaptiveUtil().fontSize(this);
}
