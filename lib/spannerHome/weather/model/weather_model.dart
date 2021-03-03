
class WeatherModel {

  ///地区
  String city;
  ///时间
  String date;
  ///天气状态
  String weather;
  ///图片状态
  String img;
  ///当前温度
  String temp;

  WeatherModel({this.city, this.date, this.weather, this.img, this.temp});
  WeatherModel.fromJson(Map<String, dynamic> json)
      : city = json['city'],
        date = json['date'],
        weather = json['weather'],
        img = json['img'],
        temp = json['temp'];

  List<WeekWeatherModel> weekListMode;

  setWeekListMode(Map<String, dynamic> json) {
    List itemListJson = json['daily'];
    List<WeekWeatherModel> itemModel = List();
    itemListJson.forEach(
            (itemJson) => itemModel.add(WeekWeatherModel.fromJson(itemJson)));
    weekListMode = itemModel;
  }

}

class WeekWeatherModel {

  ///时间
  String date;
  ///星期
  String week;
  ///图片状态
  String img;
  ///最低温度
  String templow;
  ///最高温度
  String temphigh;

  WeekWeatherModel.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        week = json['week'],
        img = json['day']['img'],
        templow = json['night']['templow'],
        temphigh = json['day']['temphigh'];
}