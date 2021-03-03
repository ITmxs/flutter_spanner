import 'package:amap_base/amap_base.dart';

class GetLocation {
  static final _amapLocation = AMapLocation();
  /*  定位信息 */
  static void getlocations<T>({
    Function(Location) onValue,
    Function(String error) onError,
  }) async {
    _amapLocation.init();
    final options = LocationClientOptions(
      isOnceLocation: true, //获取位置标题
      locatingWithReGeocode: true, //获取坐标点
    );

    if (await Permissions().requestPermission()) {
      _amapLocation.startLocate(options).listen((_) => {
            onValue(_),
          });
    } else {
      onError('无定位权限');
    }
  }
}
