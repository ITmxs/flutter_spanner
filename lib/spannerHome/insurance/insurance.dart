import 'package:flutter/material.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cTools/yin_dropFilter/yin_dropDownFilter.dart';
import 'package:spanners/spannerHome/insurance/ainsuranceApi.dart';
import 'package:spanners/cModel/insureModel.dart';
import 'package:spanners/spannerHome/insurance/insuranceAddFirst.dart';

class InsurancePage extends StatefulWidget {
  @override
  _InsurancePageState createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  String priceTitle = '';
  String timeTitle = '';
  String stustTitle = '';
  String key = '';
  String inquiry = '';
  String month = '';
  String inquiryStatus = '';
  int page = 1;
  List dataList = List();
  ScrollController scrollController = ScrollController();
  //获取列表数据
  _getList() {
    InsureDio.newInsureListRequest(
        param: {
          'current': page,
          'size': '10',
          'vehicleLicence': key,
          'inquiry': inquiry, //全部 '' 门店 0 车主 1
          'month': month, //全部 '' 一 0 三 1  六 2
          'inquiryStatus': inquiryStatus, //全部'' 已报价 0 报价中 1  成交 2 流失 3
        },
        onSuccess: (data) {
          setState(() {
            page == 1
                ? dataList = data['records']
                : dataList.addAll(data['records']);
          });
        });
  }

/*
下拉刷新
*/
  Future _toRefresh() async {
    page = 1;
    _getList();
    return null;
  }

/*
加载更多
*/
  _loadMore() {
    //滑动到底部监听
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page++;
        _getList();
      }
    });
  }

  // data 非空判断
  int isNull(List list) {
    if (list == null) {
      print('--->null');
      return 0;
    } else if (list.length == 0) {
      print('--->0');
      return 0;
    } else {
      return 1;
    }
  }

  initState() {
    // TODO: implement initState
    super.initState();
    _getList();
    _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        centerTitle: true,
        title: Text('扳手保险',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500)),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InsuranceAddFirst()))
                  .then((value) => _getList());
            },
            child: Image.asset(
              'Assets/Home/appointadd.png',
              width: 26,
              height: 26,
            ),
          ),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      body: Stack(
        children: [
          //列表展示
          Padding(padding: EdgeInsets.fromLTRB(0, 110, 0, 20), child: list()),
          //搜索 筛选
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              //搜索
              Row(
                children: [
                  SizedBox(
                    width: 23,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromRGBO(238, 238, 238, 1),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: 33,
                          maxWidth: MediaQuery.of(context).size.width - 46),
                      child: TextFormField(
                        onFieldSubmitted: (value) {
                          _getList();
                        },
                        onChanged: (value) {
                          setState(() {
                            //搜索 值
                            key = value;
                            page = 1;
                            // inquiry = '';
                            // month = '';
                            // inquiryStatus = '';
                          });
                        },
                        maxLines: 1,
                        style: TextStyle(fontSize: 13, color: Colors.black),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 20,
                            ),
                            onPressed: () {
                              //更���状态控制密码显示或隐藏
                              setState(() {
                                _getList();
                              });
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          hintText: '搜索车牌号',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                          fillColor: Color.fromRGBO(238, 238, 238, 1),
                          filled: true,
                          border: new OutlineInputBorder(
                              //添加边框
                              gapPadding: 10.0,
                              borderRadius: BorderRadius.circular(17.0),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 23,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              //外部领料  内部领料
              /*  此处筛选   */

              DropFilter(
                buttons: [
                  FilterModel(
                      title: priceTitle == '' ? '全部询价' : priceTitle,
                      titleColor: Color.fromRGBO(10, 10, 10, 1),
                      titleSize: 13.0,
                      type: 'ColumnLayout',
                      contents: ['全部询价', '门店询价', '车主询价'],
                      onChangedVideo: (value) {
                        setState(() {
                          priceTitle = value;
                          page = 1;
                          if (value == '全部询价') {
                            inquiry = '';
                          }
                          if (value == '门店询价') {
                            inquiry = '0';
                          }
                          if (value == '车主询价') {
                            inquiry = '1';
                          }
                          _getList();
                        });
                      }),
                  FilterModel(
                      title: timeTitle == '' ? '时间' : timeTitle,
                      titleColor: Color.fromRGBO(10, 10, 10, 1),
                      titleSize: 13.0,
                      type: 'ColumnLayout',
                      contents: ['全部时间', '一个月内', '三个月内', '六个月内'],
                      onChangedVideo: (value) {
                        setState(() {
                          timeTitle = value;
                          page = 1;
                          if (value == '全部时间') {
                            month = '';
                          }
                          if (value == '一个月内') {
                            month = '0';
                          }
                          if (value == '三个月内') {
                            month = '1';
                          }
                          if (value == '六个月内') {
                            month = '2';
                          }
                          _getList();
                        });
                      }),
                  FilterModel(
                      title: stustTitle == '' ? '询价状态' : stustTitle,
                      titleColor: Color.fromRGBO(10, 10, 10, 1),
                      titleSize: 13.0,
                      type: 'ColumnLayout',
                      contents: ['全部状态', '已报价', '报价中', '成交', '流失'],
                      onChangedVideo: (value) {
                        setState(() {
                          stustTitle = value;
                          page = 1;
                          if (value == '全部状态') {
                            inquiryStatus = '';
                          }
                          if (value == '已报价') {
                            inquiryStatus = '0';
                          }
                          if (value == '报价中') {
                            inquiryStatus = '1';
                          }
                          if (value == '成交') {
                            inquiryStatus = '2';
                          }
                          if (value == '流失') {
                            inquiryStatus = '3';
                          }
                          _getList();
                        });
                      })
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  list() {
    return RefreshIndicator(
      onRefresh: _toRefresh,
      child: isNull(dataList) == 0
          ? ListView(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: ShowNullDataAlart(
                    alartText: '当前无数据',
                  ),
                )
              ],
            )
          : ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int item) {
                return GestureDetector(
                  onTap: () {
                    print(InsureModel.fromJson(dataList[item]).id);
                  },
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
                          Container(
                            width: MediaQuery.of(context).size.width - 30,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(229, 229, 229, 1),
                                    width: 1),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 3,
                                      height: 12,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color:
                                              Color.fromRGBO(39, 153, 93, 1)),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      InsureModel.fromJson(dataList[item])
                                          .vehicleLicence,
                                      style: TextStyle(
                                          color: Color.fromRGBO(10, 10, 10, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Container(
                                      width: 66,
                                      height: 18,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: InsureModel.fromJson(
                                                              dataList[item])
                                                          .type ==
                                                      0
                                                  ? Color.fromRGBO(
                                                      30, 141, 255, 1)
                                                  : Color.fromRGBO(
                                                      255, 77, 76, 1),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        InsureModel.fromJson(dataList[item])
                                                    .type ==
                                                0
                                            ? '门店询价'
                                            : '车主询价',
                                        style: TextStyle(
                                          color: InsureModel.fromJson(
                                                          dataList[item])
                                                      .type ==
                                                  0
                                              ? Color.fromRGBO(30, 141, 255, 1)
                                              : Color.fromRGBO(255, 77, 76, 1),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 19,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Text(
                                      '创建时间',
                                      style: TextStyle(
                                          color: Color.fromRGBO(10, 10, 10, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Text(
                                      InsureModel.fromJson(dataList[item])
                                          .updTime,
                                      style: TextStyle(
                                        color: Color.fromRGBO(10, 10, 10, 1),
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 21,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 11,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 30,
                                  height: 1,
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                ),
                                SizedBox(
                                  height: 19,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Text(
                                      '询价状态',
                                      style: TextStyle(
                                          color: Color.fromRGBO(10, 10, 10, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Text(
                                      //0:询价中;1:流失;2:成交;3已报价
                                      InsureModel.fromJson(dataList[item])
                                                  .state ==
                                              0
                                          ? '询价中'
                                          : InsureModel.fromJson(dataList[item])
                                                      .state ==
                                                  1
                                              ? '流失'
                                              : InsureModel.fromJson(
                                                              dataList[item])
                                                          .state ==
                                                      2
                                                  ? InsureModel.fromJson(dataList[item])
                                                                  .commercialInsuranceNumber ==
                                                              'null' &&
                                                          InsureModel.fromJson(dataList[item])
                                                                  .compulsoryInsuranceNumber ==
                                                              'null'
                                                      ? '成交（未上传保单）'
                                                      : '成交（已上传保单）'
                                                  : InsureModel.fromJson(
                                                                  dataList[item])
                                                              .state ==
                                                          3
                                                      ? '已报价'
                                                      : '',
                                      style: TextStyle(
                                        color: Color.fromRGBO(10, 10, 10, 1),
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 21,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 11,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}
