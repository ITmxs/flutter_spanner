import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/weather/model/weather_model.dart';

class WeatherProvide extends BaseProvide {
  final WeatherRepo _repo = WeatherRepo();

  ///天气数据model
  WeatherModel _weatherModel = WeatherModel();
  WeatherModel get weatherModel => _weatherModel;
  set weatherModel(WeatherModel weatherModel) {
    _weatherModel = weatherModel;
    notifyListeners();
  }

  ///搜索数组
  List _searchList = [];
  List get searchList => _searchList;
  set searchList(List searchList) {
    _searchList = searchList;
    notifyListeners();
  }

  Stream getWeatherInfo(String city) {
    return _repo
        .getWeatherInfo(query: {'city': city})
        .doOnData((result) {
          Map res = convert.jsonDecode(result.toString());
          WeatherModel weatherModel = WeatherModel.fromJson(res['result']);
          weatherModel.setWeekListMode(res['result']);
          this.weatherModel = weatherModel;
          notifyListeners();
        })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }
}
