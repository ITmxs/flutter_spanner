import 'package:flutter/material.dart';
import 'package:spanners/spannerHome/newOrder/vipTopView.dart';

class CarSureUserMessage extends StatefulWidget {
  final Map carMap;
  final vipMap;
  final types;
  const CarSureUserMessage({Key key, this.carMap, this.types, this.vipMap})
      : super(key: key);

  @override
  _CarSureUserMessageState createState() => _CarSureUserMessageState();
}

class _CarSureUserMessageState extends State<CarSureUserMessage> {
  List titleList = [
    '车牌号',
    '车辆品牌',
    '车辆型号',
    '车主姓名',
    '手机号',
    'VIN码',
    '车辆颜色',
    '发动机型号'
  ];
  List title = ['行驶里程', '送修人姓名', '油表数', '接车员姓名'];
  bool showBool = false;
  @override
  Widget build(BuildContext context) {
    return //用户信息
        Column(
      children: [
        widget.types == 0
            ? Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                            titleList.length,
                            (index) => InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '  ',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 42, 42, 1),
                                                fontSize: 15),
                                          ),
                                          Text(
                                            titleList[index],
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    30, 30, 30, 1),
                                                fontSize: 15),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                titleList[index] == '车牌号'
                                                    ? widget.carMap.containsKey(
                                                            'vehicleLicence')
                                                        ? widget
                                                            .carMap[
                                                                'vehicleLicence']
                                                            .toString()
                                                        : ''
                                                    : titleList[index] == '车辆品牌'
                                                        ? widget
                                                                .carMap
                                                                .containsKey(
                                                                    'brand')
                                                            ? widget
                                                                .carMap['brand']
                                                                .toString()
                                                            : ''
                                                        : titleList[index] ==
                                                                '车辆型号'
                                                            ? widget
                                                                    .carMap
                                                                    .containsKey(
                                                                        'model')
                                                                ? widget
                                                                    .carMap[
                                                                        'model']
                                                                    .toString()
                                                                : ''
                                                            : titleList[index] ==
                                                                    '车主姓名'
                                                                ? widget.carMap
                                                                        .containsKey(
                                                                            'vehicleOwners')
                                                                    ? widget.carMap['vehicleOwners'].toString() ==
                                                                            'null'
                                                                        ? ''
                                                                        : widget.carMap['vehicleOwners']
                                                                            .toString()
                                                                    : ''
                                                                : titleList[index] ==
                                                                        '手机号'
                                                                    ? widget.carMap
                                                                            .containsKey('customerMobile')
                                                                        ? widget.carMap['customerMobile'].toString() == 'null'
                                                                            ? ''
                                                                            : widget.carMap['customerMobile'].toString()
                                                                        : ''
                                                                    : titleList[index] == 'VIN码'
                                                                        ? widget.carMap.containsKey('carVin')
                                                                            ? widget.carMap['carVin'].toString() == 'null'
                                                                                ? ''
                                                                                : widget.carMap['carVin'].toString()
                                                                            : ''
                                                                        : titleList[index] == '车辆颜色'
                                                                            ? widget.carMap.containsKey('carColor')
                                                                                ? widget.carMap['carColor'].toString() == 'null'
                                                                                    ? ''
                                                                                    : widget.carMap['carColor'].toString()
                                                                                : ''
                                                                            : titleList[index] == '发动机型号'
                                                                                ? widget.carMap.containsKey('carEngine')
                                                                                    ? widget.carMap['carEngine'].toString() == 'null'
                                                                                        ? ''
                                                                                        : widget.carMap['carEngine'].toString()
                                                                                    : ''
                                                                                : '',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 1,
                                        color: Color.fromRGBO(229, 229, 229, 1),
                                      ),
                                    ],
                                  ),
                                ))),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              )
            : //会员
            VipTopView(
                type: widget.types,
                vipMap: widget.vipMap,
              ),

        // 送修人 接车员 备注 照片 展示区域
        showBool
            ? Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    //行驶里程 送修人姓名
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: List.generate(
                                  title.length,
                                  (index) => InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '  ',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 42, 42, 1),
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  title[index],
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          30, 30, 30, 1),
                                                      fontSize: 15),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      title[index] == '行驶里程'
                                                          ? widget.carMap
                                                                  .containsKey(
                                                                      'roadHaulString')
                                                              ? widget.carMap[
                                                                      'roadHaulString'] //roadHaul
                                                                  .toString()
                                                              : ''
                                                          : title[index] ==
                                                                  '送修人姓名'
                                                              ? widget.carMap
                                                                      .containsKey(
                                                                          'sendUser')
                                                                  ? widget.carMap['sendUser']
                                                                      .toString()
                                                                  : ''
                                                              : title[index] ==
                                                                      '油表数'
                                                                  ? widget.carMap
                                                                          .containsKey(
                                                                              'oilMeters')
                                                                      ? widget
                                                                          .carMap[
                                                                              'oilMeters']
                                                                          .toString()
                                                                      : ''
                                                                  : title[index] ==
                                                                          '接车员姓名'
                                                                      ? widget.carMap.containsKey(
                                                                              'requestUser')
                                                                          ? widget
                                                                              .carMap['requestUser']
                                                                          : ''
                                                                      : '',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Color.fromRGBO(
                                                  229, 229, 229, 1),
                                            ),
                                          ],
                                        ),
                                      ))),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //备注
                    widget.carMap.containsKey('remark')
                        ? widget.carMap['remark'] == '' ||
                                widget.carMap['remark'] == null
                            ? Container()
                            : Column(children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '备注',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: Text(
                                        widget.carMap['remark'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                              ])
                        : Container(),
                    //照片
                    widget.carMap.containsKey('imageList')
                        ? Container(
                            child: Column(children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '车辆照片',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            //iamge add part
                            Row(children: [
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        new NeverScrollableScrollPhysics(), //禁止滑动
                                    itemCount: widget
                                        .carMap['imageList'].length, //做多6个
                                    //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            //横轴元素个数
                                            crossAxisCount: 3,
                                            //纵轴间距
                                            mainAxisSpacing: 10.0,
                                            //横轴间距
                                            crossAxisSpacing: 15.0,
                                            //子组件宽高长度比例
                                            childAspectRatio: 1.0),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      //Widget Function(BuildContext context, int index)
                                      return InkWell(
                                        onTap: () {},
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3 -
                                              50 / 3,
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3 -
                                              50 / 3,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints
                                                                .expand(),
                                                        child: Image.network(
                                                          widget.carMap[
                                                                  'imageList']
                                                              [index],
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )),
                                                ],
                                              )),
                                        ),
                                      );
                                    }),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ])
                          ]))
                        : Container()
                  ],
                ),
              )
            : Container(),
        SizedBox(
          height: 10,
        ),
        InkWell(
            onTap: () {
              setState(() {
                showBool ? showBool = false : showBool = true;
              });
            },
            child: Column(children: [
              Text(showBool ? '隐藏更多信息' : '显示更多信息',
                  style: TextStyle(
                      color: Color.fromRGBO(178, 178, 178, 1), fontSize: 12)),
              Icon(
                showBool ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Color.fromRGBO(178, 178, 178, 1),
              ),
            ]))
      ],
    );
  }
}
