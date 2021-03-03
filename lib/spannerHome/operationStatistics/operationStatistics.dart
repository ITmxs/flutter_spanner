import 'package:flutter/material.dart';
import 'package:spanners/cModel/operationStatisticsModel.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/operationStatistics/operationApi.dart';
import 'package:spanners/spannerHome/operationStatistics/puttingOnCredit.dart';
import 'package:spanners/spannerHome/operationStatistics/vipStatistics.dart';
import 'package:spanners/spannerHome/operationStatistics/yMonthStatistics.dart';

class OperationStatistics extends StatefulWidget {
  @override
  _OperationStatisticsState createState() => _OperationStatisticsState();
}

class _OperationStatisticsState extends State<OperationStatistics> {
  List items = [
    {
      'title': '利润统计',
      'list': ['本月利润总额', '工单实收金额', '工单配件成本', '员工绩效', '其他收入', '其他支出']
    },
    {
      'title': '会员储值',
      'list': ['本月新增储值', '本月消费储值', '储值剩余总额', '本月新增卡劵', '本月消费卡劵', '剩余卡劵总额']
    },
    {
      'title': '挂账情况',
      'list': ['本月新增挂账额', '挂账总额']
    },
    {
      'title': '客户数据分析',
      'list': ['新增绑定会员', '绑定会员总数', '新增储值会员', '储值会员总数', '客户总数']
    }
  ];
  List images = [
    'Assets/operationStatistics/2.0x/lrimage.png',
    'Assets/operationStatistics/vipimage.png',
    'Assets/operationStatistics/gzimage.png',
    'Assets/operationStatistics/memberimage.png'
  ];
  Map dataMap = Map();
  OperationModel model;
  //获取数据
  _getList() {
    OperationApi.operationstatisDetailRequest(
      param: {'': ''},
      onSuccess: (data) {
        setState(() {
          dataMap = data;
          model = OperationModel.fromJson(data);
        });
      },
    );
  }

  //返回 该有的 文字信息
  String _returnText(String value) {
    switch (value) {
      case '本月利润总额':
        return '¥' + model.nowMonthProfitSum;
        break;
      case '工单实收金额':
        return '¥' + model.nowMonthWorkPriceSum;
        break;
      case '工单配件成本':
        return '¥' + model.nowMonthPartsCostSum;
        break;
      case '员工绩效':
        return '¥' + model.personAchievementsSum;
        break;
      case '其他收入':
        return '¥' + model.otherIncomeSum;
        break;
      case '其他支出':
        return '¥' + model.otherExpenditureSum;
        break;
      case '本月新增储值':
        return '¥' + model.nowMonthStoredValueSum;
        break;
      case '本月消费储值':
        return '¥' + model.nowMonthConsumptionSum;
        break;
      case '储值剩余总额':
        return '¥' + model.accountBalanceSum;
        break;
      case '本月新增卡劵':
        return '¥' + '12';
        break;
      case '本月消费卡劵':
        return '¥' + '12';
        break;
      case '剩余卡劵总额':
        return '¥' + '12';
        break;
      case '本月新增挂账额':
        return '¥' + model.nowMonthOnAccountSum;
        break;
      case '挂账总额':
        return '¥' + model.onAccountSum;
        break;
      case '新增绑定会员':
        return model.nowMonthBindingPersonCount;
        break;
      case '绑定会员总数':
        return model.bindingPersonCount;
        break;
      case '新增储值会员':
        return model.nowMonthStorePersonCount;
        break;
      case '储值会员总数':
        return model.storePersonCount;
        break;
      case '客户总数':
        return model.customerCount;
        break;

      default:
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          title: Text(
            '运营统计',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: model == null
            ? Container()
            : ScrollConfiguration(
                behavior: NeverScrollBehavior(),
                child: ListView(
                  children: [
//top
                    SizedBox(
                      height: 10,
                    ),
                    //绿卡区域
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  image: AssetImage(
                                    'Assets/operationStatistics/topback.png',
                                  ),
                                  fit: BoxFit.cover)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text('今日数据',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.center,
                                    child: Text(model.nowDayPutFactoryCount,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold)),
                                  )),
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.center,
                                    child: Text(model.nowDayOutFactoryCount,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold)),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.center,
                                    child: Text('今日进厂',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                                  )),
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.center,
                                    child: Text('今日出厂',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    //数量统计区域
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 97,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              //第一行
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              15,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Image.asset(
                                                'Assets/operationStatistics/hot.png',
                                                width: 15,
                                                height: 17,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '月新增绑定车辆 ${model.nowMonthShopCarCount}',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 77, 76, 1),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  15 -
                                                  16,
                                              child: Row(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '月进厂台次  ${model.nowMonthPutFactoryCount}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              //第二行
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              15,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '绑定车辆总数 ${model.shopCarCount}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  15 -
                                                  16,
                                              child: Row(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '月出厂台次  ${model.nowMonthOutFactoryCount}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),

//底部 list
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(
                          4,
                          (index) => Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 13,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Image.asset(
                                                    images[index],
                                                    width: 35,
                                                    height: 35,
                                                  ),
                                                  Text(
                                                    items[index]['title'],
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            30, 30, 30, 1),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (index == 0) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MonthStatiotics())).then(
                                                            (value) =>
                                                                _getList());
                                                      }

                                                      if (index == 1) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        VipStatiotics())).then(
                                                            (value) =>
                                                                _getList());
                                                      }
                                                      if (index == 2) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PuttingOnCredit())).then(
                                                            (value) =>
                                                                _getList());
                                                      }
                                                    },
                                                    child: Text(
                                                      index == 3 ? '' : '详情',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              39, 153, 93, 1),
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 25,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1,
                                                color: Color.fromRGBO(
                                                    238, 238, 238, 1),
                                              ),
                                              GridView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(), //禁止滑动
                                                  itemCount: items[index]
                                                          ['list']
                                                      .length,
                                                  //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    //横轴元素个数
                                                    crossAxisCount: 3,
                                                    // //纵轴间距
                                                    // mainAxisSpacing: 10.0,
                                                    // //横轴间距
                                                    // crossAxisSpacing: 10.0,
                                                    //子组件宽高长度比例
                                                  ),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int item) {
                                                    return Container(
                                                        child: Stack(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        _returnText(items[index]['list']
                                                                            [
                                                                            item]),
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                41,
                                                                                157,
                                                                                96,
                                                                                1),
                                                                            fontSize:
                                                                                18),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        items[index]['list']
                                                                            [
                                                                            item],
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                53,
                                                                                59,
                                                                                56,
                                                                                1),
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                  ],
                                                                ),
                                                                item == 2 ||
                                                                        item ==
                                                                            5
                                                                    ? Container()
                                                                    :
                                                                    //分隔线
                                                                    Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            MediaQuery.of(context).size.width / 3 -
                                                                                30 / 3 -
                                                                                1,
                                                                            20,
                                                                            0,
                                                                            20),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              1,
                                                                          height:
                                                                              43,
                                                                          color: Color.fromRGBO(
                                                                              238,
                                                                              238,
                                                                              238,
                                                                              1),
                                                                        ),
                                                                      ),
                                                              ],
                                                            ),
                                                            //横线
                                                            item > 2
                                                                ? Container()
                                                                : Container(
                                                                    width: MediaQuery.of(context).size.width /
                                                                            3 -
                                                                        10,
                                                                    height: 1,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            238,
                                                                            238,
                                                                            238,
                                                                            1),
                                                                  )
                                                          ],
                                                        ),
                                                      ],
                                                    ));
                                                  }),
                                            ],
                                          ))
                                    ],
                                  )
                                ],
                              )),
                    ),

                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ));
  }
}
