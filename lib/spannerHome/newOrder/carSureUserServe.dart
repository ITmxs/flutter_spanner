import 'package:flutter/material.dart';

class CarSureUserServe extends StatefulWidget {
  final Map serMap;
  final ValueChanged<double> onChanged;

  const CarSureUserServe({
    Key key,
    this.serMap,
    this.onChanged,
  }) : super(key: key);
  @override
  _CarSureUserServeState createState() => _CarSureUserServeState();
}

class _CarSureUserServeState extends State<CarSureUserServe>
    with SingleTickerProviderStateMixin {
  bool isActive = false;

  List showList = List();
  double sums = 0;

  String _getSumPrice(String count, String price) {
    var c = double.parse(count);
    var p = double.parse(price);
    var s = c * p;
    sums = sums + s;
    widget.onChanged(sums);
    return '¥$s';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sums = 0;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(
                    widget.serMap['receiveCarServiceList'].length,
                    (index) => Container(
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Column(
                            children: [
                              ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: List.generate(
                                      widget.serMap['receiveCarServiceList']
                                                  [index]
                                              .containsKey(
                                                  'receiveCarMaterialList')
                                          ? 2 +
                                              widget
                                                  .serMap[
                                                      'receiveCarServiceList']
                                                      [index]
                                                      ['receiveCarMaterialList']
                                                  .length
                                          : 2,
                                      (indexs) => InkWell(
                                          onTap: () {},
                                          child: Stack(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: //服务  清单  列表
                                                      Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 1,
                                                        child: Container(
                                                          color: Color.fromRGBO(
                                                              238, 238, 238, 1),
                                                        ),
                                                      ),
                                                      Container(
                                                        color: indexs == 1
                                                            ? Color.fromRGBO(
                                                                233,
                                                                245,
                                                                238,
                                                                1)
                                                            : Colors.white,
                                                        child: Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                if (indexs >
                                                                    0) {
                                                                  //展示配件 详细 名称型号
                                                                  setState(() {
                                                                    // showList = [
                                                                    //   index,
                                                                    //   indexs
                                                                    // ];
                                                                    // _width = 200;
                                                                  });
                                                                }
                                                              },
                                                              child: Container(
                                                                  width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          5 -
                                                                      30 / 5,
                                                                  height: 40,
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Text(
                                                                            indexs == 0
                                                                                ? '名称'
                                                                                : indexs == 1
                                                                                    ? widget.serMap['receiveCarServiceList'][index]['secondaryService']
                                                                                    : widget.serMap['receiveCarServiceList'][index]['receiveCarMaterialList'][indexs - 2]['itemMaterial'],
                                                                            maxLines:
                                                                                1,
                                                                            softWrap:
                                                                                false,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: indexs == 0
                                                                                    ? Color.fromRGBO(0, 0, 0, 1)
                                                                                    : indexs == 1
                                                                                        ? Color.fromRGBO(0, 0, 0, 1)
                                                                                        : Color.fromRGBO(39, 153, 93, 1),
                                                                                fontSize: 12),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )),
                                                            ),
                                                            //
                                                            Container(
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      5 -
                                                                  30 / 5,
                                                              height: 40,
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  indexs == 0
                                                                      ? '规格'
                                                                      : indexs ==
                                                                              1
                                                                          ? '/'
                                                                          : widget.serMap['receiveCarServiceList'][index]['receiveCarMaterialList'][indexs - 2]
                                                                              [
                                                                              'spec'],
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            ),
                                                            //
                                                            Container(
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      5 -
                                                                  30 / 5,
                                                              height: 40,
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  indexs == 0
                                                                      ? '单价'
                                                                      : indexs ==
                                                                              1
                                                                          ? '¥' +
                                                                              widget.serMap['receiveCarServiceList'][index]['price']
                                                                                  .toString()
                                                                          : '¥' +
                                                                              widget.serMap['receiveCarServiceList'][index]['receiveCarMaterialList'][indexs - 2]['itemPrice'].toString(),
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            ),
                                                            //
                                                            Container(
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      5 -
                                                                  30 / 5,
                                                              height: 40,
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  indexs == 0
                                                                      ? '数量'
                                                                      : indexs ==
                                                                              1
                                                                          ? 'x' +
                                                                              widget.serMap['receiveCarServiceList'][index]['count']
                                                                                  .toString()
                                                                          : 'x' +
                                                                              widget.serMap['receiveCarServiceList'][index]['receiveCarMaterialList'][indexs - 2]['itemNumber'].toString(),
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            ),
                                                            //
                                                            Container(
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      5 -
                                                                  30 / 5,
                                                              height: 40,
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  indexs == 0
                                                                      ? '总价'
                                                                      : indexs ==
                                                                              1
                                                                          ? _getSumPrice(
                                                                              widget.serMap['receiveCarServiceList'][index]['count']
                                                                                  .toString(),
                                                                              widget.serMap['receiveCarServiceList'][index]['price']
                                                                                  .toString())
                                                                          : _getSumPrice(
                                                                              widget.serMap['receiveCarServiceList'][index]['receiveCarMaterialList'][indexs - 2]['itemNumber'].toString(),
                                                                              widget.serMap['receiveCarServiceList'][index]['receiveCarMaterialList'][indexs - 2]['itemPrice'].toString()),
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                child: AnimatedContainer(
                                                  curve: Curves.linearToEaseOut,
                                                  duration: Duration(
                                                      milliseconds: 1000),
                                                  width: indexs == 1
                                                      ? 60
                                                      : showList.length == 0
                                                          ? 60
                                                          : showList[0] == index
                                                              ? showList[1] ==
                                                                      indexs
                                                                  ? isActive
                                                                      ? 200
                                                                      : 60
                                                                  : 60
                                                              : 60,

                                                  // isActive ? 200 : 60,
                                                  decoration: BoxDecoration(
                                                      color: indexs == 1
                                                          ? Colors.transparent
                                                          : showList.length == 0
                                                              ? Colors
                                                                  .transparent
                                                              : showList[0] ==
                                                                      index
                                                                  ? showList[1] ==
                                                                          indexs
                                                                      ? isActive
                                                                          ? Color.fromRGBO(
                                                                              39,
                                                                              153,
                                                                              93,
                                                                              1)
                                                                          : Colors
                                                                              .transparent
                                                                      : Colors
                                                                          .transparent
                                                                  : Colors
                                                                      .transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  onEnd: () {},
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        showList = [
                                                          index,
                                                          indexs
                                                        ];
                                                        isActive = !isActive;
                                                      });
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      width: 40,
                                                      height: 40,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.close,
                                                            color: Colors
                                                                .transparent,
                                                            size: 20,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Expanded(
                                                              child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              indexs == 0
                                                                  ? ''
                                                                  : indexs == 1
                                                                      ? ''
                                                                      : showList.length ==
                                                                              0
                                                                          ? ''
                                                                          : showList[0] == index
                                                                              ? showList[1] == indexs
                                                                                  ? widget.serMap['receiveCarServiceList'][index]['receiveCarMaterialList'][indexs - 2]['itemMaterial'] + '/' + widget.serMap['receiveCarServiceList'][index]['receiveCarMaterialList'][indexs - 2]['itemModel'] + '/' + widget.serMap['receiveCarServiceList'][index]['receiveCarMaterialList'][indexs - 2]['spec']
                                                                                  : ''
                                                                              : '',
                                                              maxLines: 2,
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )))),
                              SizedBox(
                                height: 10,
                                child: Container(
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                ),
                              ),
                            ],
                          ),
                        )),
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),

        SizedBox(
          height: 10,
        ),
        //消费金额
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: 3,
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                color: Color.fromRGBO(39, 153, 93, 1),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '消费金额',
              style: TextStyle(color: Colors.black, fontSize: 18),
              textAlign: TextAlign.left,
            ),
            Expanded(child: SizedBox()),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                sums.toString(), //widget.allPrice,
                style: TextStyle(
                    color: Color.fromRGBO(255, 51, 51, 1), fontSize: 18),
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
      ],
    );
  }
}
