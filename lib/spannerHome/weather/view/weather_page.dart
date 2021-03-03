import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/weather/model/city_model.dart';
import 'package:spanners/spannerHome/weather/model/weather_model.dart';
import 'package:spanners/spannerHome/weather/provide/weather_provide.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  WeatherProvide _provide;

  final _subscriptions = CompositeSubscription();

  TextEditingController _textEditingController;

  ScrollController _scrollController;

  List<CityInfo> _cityList = List();

  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = "";
  List _cityListString;


  @override
  void initState() {
    super.initState();

    _provide = WeatherProvide();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
    _loadData('大连市');
    loadData();
    loadListData();
  }

  void loadData() async {
    //加载城市列表
    rootBundle.loadString('Assets/data/china.json').then((value) {
      Map countyMap = json.decode(value);
      List list = countyMap['china'];
      list.forEach((value) {
        _cityList.add(CityInfo(name: value['name']));
      });
      _handleList(_cityList);
      setState(() {});
    });
  }

  void loadListData() async {
    //加载城市列表
    rootBundle.loadString('Assets/data/china_list.json').then((value) {
      Map countyMap = json.decode(value);
      _cityListString = countyMap['china'];
    });
  }

  _loadData(String city) {
    var s = _provide
        .getWeatherInfo(city)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  void _handleList(List<CityInfo> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(_cityList);
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  Widget _buildHeader() {
    List<CityInfo> hotCityList = List();
    hotCityList.addAll([
      CityInfo(name: "上海市"),
      CityInfo(name: "北京市"),
      CityInfo(name: "广州市"),
      CityInfo(name: "深圳市"),
      CityInfo(name: "南京市"),
      CityInfo(name: "杭州市"),
      CityInfo(name: "武汉市"),
      CityInfo(name: "成都市"),
    ]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _weather(),
            Row(
              children: [
                Container(
                  color: AppColors.primaryColor,
                  width: 3,
                  height: 15,
                  margin: EdgeInsets.only(right: 5),
                ),
                Text(
                  '定位城市',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: Color(0xFF494949),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                OutlineButton(
                  borderSide: BorderSide(color: Colors.grey[300], width: .5),
                  child: Row(
                    children: [
                    Icon(Icons.location_on,color: AppColors.primaryColor, size: ScreenUtil().setHeight(20),),
                    Text('大连市'),
                  ],),
                  onPressed: () {
                    _loadData('大连市');
                  },
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  color: AppColors.primaryColor,
                  width: 3,
                  height: ScreenUtil().setHeight(14),
                  margin: EdgeInsets.only(right: 5),
                ),
                Text(
                  '热门城市',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: Color(0xFF494949),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              spacing: 10.0,
              children: hotCityList.map((e) {
                return OutlineButton(
                  borderSide: BorderSide(color: Colors.grey[300], width: .5),
                  child: Text(e.name),
                  onPressed: () {
                    _loadData(e.name);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  _weather() => Selector<WeatherProvide, WeatherModel>(
        selector: (_, provide) => _provide.weatherModel,
        builder: (_, model, child) {
          return model.date != null
              ? Container(
                  margin:
                      EdgeInsets.only(top: 10, bottom: 20, left: 35, right: 35),
                  padding:
                      EdgeInsets.only(top: 15, bottom: 10, left: 21, right: 21),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE5E5E5), width: 0.5),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular((5.0))),
                  height: 170,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 45,
                            child: Text(
                              model.temp,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            height: 45,
                            child: Text(
                              '℃',
                              style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(5),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 120,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'Assets/weather/${model.img}.png',
                                        width: 20,
                                      ),
                                      Text(model.weather),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  child: Text(
                                    model.date,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topRight,
                              height: 45,
                              child: Text(
                                model.city,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        color: AppColors.ViewBackgroundColor,
                        height: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: weekItem(model.weekListMode),
                      ),
                    ],
                  ),
                )
              : Container(
                  margin:
                      EdgeInsets.only(top: 10, bottom: 21, left: 35, right: 35),
                  padding:
                      EdgeInsets.only(top: 19, bottom: 11, left: 21, right: 21),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE5E5E5), width: 0.5),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular((5.0))),
                  height: ScreenUtil().setHeight(150.0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: ScreenUtil().setHeight(45.0),
                            child: Text(
                              '',
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            height: ScreenUtil().setHeight(45.0),
                            child: Text(
                              '℃',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 120,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'Assets/weather/0.png',
                                        width: 20,
                                      ),
                                      Text(''),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  child: Text(
                                    '',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topRight,
                              height: ScreenUtil().setHeight(45.0),
                              child: Text(
                                '',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        color: AppColors.ViewBackgroundColor,
                        height: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
        },
      );

  List<Widget> weekItem(List modelList) {
    List<Widget> itemList = [];
    List newModelList = modelList.sublist(1, 5);
    newModelList.forEach((model) {
      WeekWeatherModel weekModel = model;
      itemList.add(Column(
        children: [
          Text(
            weekModel.week,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 5,),
          Image.asset(
            'Assets/weather/${weekModel.img}.png',
            width: 20,
          ),
          SizedBox(height: 5,),
          Text(
            '${weekModel.temphigh}℃/${weekModel.templow}℃',
            style: TextStyle(fontSize: 10),
          ),
        ],
      ));
    });
    return itemList;
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            color: AppColors.primaryColor,
            width: 3,
            height: 14,
            margin: EdgeInsets.only(right: 5),
          ),
          Text(
            '$susTag',
            softWrap: false,
            style: TextStyle(
              fontSize: 15.0,
              color: Color(0xFF494949),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(CityInfo model) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        Container(
          color: Colors.white,
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Text(model.name),
            onTap: () {
              _loadData(model.name);
              _scrollController.jumpTo(0.0);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              left: 20,
            ),
            height: 33,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0), //灰色的一层边框
              color: Color.fromRGBO(255, 255, 255, 0.7),
              borderRadius: BorderRadius.all(Radius.circular(16.5)),
            ),
            child: TextFormField(
              controller: _textEditingController,
              onChanged: (value) {
                if (value.length > 0) {
                  List nameList = [];
                  _cityListString.forEach((string) {
                    String cityName = string;
                    if (cityName.contains(value)) {
                      nameList.add(string);
                    }else {
                      nameList.add(string);
                    }
                  });
                  _provide.searchList = nameList;
                } else {
                  _provide.searchList = [];
                }
              },
              maxLines: 1,
              style: TextStyle(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                  // size: 20,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                hintText: '请输入城市名',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
//              fillColor: Color.fromRGBO(
//                  255, 255, 255, 0.7),
//              filled: true,
                border: OutlineInputBorder(
                    //添加边框
                    gapPadding: 10.0,
                    borderRadius: BorderRadius.circular(17.0),
                    borderSide: BorderSide.none),
                // prefixIcon: Padding(
                //   padding: EdgeInsets.all(10),
                // ),
                //Image.asset('assets/images/user.png',cacheWidth: 25,cacheHeight: 25,),//ImageIcon(AssetImage('assets/images/user.png',),color: Colors.white,),//Image.asset('assets/images/user.png',fit: BoxFit.fitHeight,)
              ),
            ),
          ),
        ),
        body: _initViews(),
      ),
    );
  }

  _initViews() => GestureDetector(
    onTap: (){
    FocusScope.of(context).unfocus();
  },
    onVerticalDragDown: (details) {
      FocusScope.of(context).unfocus();
    },
  child: Stack(
    children: [
      Container(
        child: Column(
          children: <Widget>[
            Divider(
              height: .0,
            ),
            Expanded(
                flex: 1,
                child: AzListView(
                  controller: _scrollController,
                  data: _cityList,
                  itemBuilder: (context, model) => _buildListItem(model),
                  suspensionWidget: _buildSusWidget(_suspensionTag),
                  isUseRealIndex: true,
                  itemHeight: _itemHeight,
                  suspensionHeight: _suspensionHeight,
                  onSusTagChanged: _onSusTagChanged,
                  header: AzListViewHeader(
                      tag: "热",
                      height: 470,
                      builder: (context) {
                        return _buildHeader();
                      }),
                  indexHintBuilder: (context, hint) {
                    return Container(
                      alignment: Alignment.center,
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle),
                      child: Text(hint,
                          style: TextStyle(
                              color: Colors.white, fontSize: 30.0)),
                    );
                  },
                )),
          ],
        ),
      ),
      Selector<WeatherProvide, List>(selector: (_, provide)=>_provide.searchList, builder: (_, list, child){

        return list.length>0?Container(
          color: Colors.white,
          child: ListView.builder(
              itemCount: list.length, itemBuilder: this._searchBuildListItem),
        ):Container();
      }),
    ],
  ),);

  // item build 方法
  Widget _searchBuildListItem(BuildContext context, int index) {
    return Container(
      color: Colors.white,
      height: _itemHeight.toDouble(),
      child: ListTile(
        title: Text(_provide.searchList[index]),
        onTap: () {
          _loadData(_provide.searchList[index]);
          _scrollController.jumpTo(0.0);
          _provide.searchList = [];
          _textEditingController.text = '';
        },
      ),
    );
  }
}
