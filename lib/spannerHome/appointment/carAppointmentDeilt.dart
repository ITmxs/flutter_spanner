import 'package:flutter/material.dart';
import 'package:spanners/cModel/appointmentModel.dart';
import 'package:spanners/AfNetworking/requestDio.dart';
import 'package:spanners/cTools/callIphone.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/appointment/appointmentRequestApi.dart';
import 'package:spanners/spannerHome/newOrder/newOrder.dart';

class CarAppointmenDeilt extends StatefulWidget {
  final String workorderid;
  final String id;
  final Map<String, dynamic> dataList = Map();

  CarAppointmenDeilt({Key key, this.workorderid, this.id}) : super(key: key);
  @override
  _CarAppointmenDeiltState createState() => _CarAppointmenDeiltState();
}

class _CarAppointmenDeiltState extends State<CarAppointmenDeilt> {
  var _dataModel;
  var dateValue = '';
  List title = [
    '手机号',
    '预约车牌',
    '车辆品牌',
    '车辆型号',
    'VIN码',
    '车辆颜色',
    '项目种类',
    '项目名称',
    '服务时间',
    '备注',
  ];

  _getData() {
    DioUtils.requestHttp(
        '${DioUtils.appointmentDetail}/${widget.id.toString()}',
        method: DioUtils.NEWGET, onSuccess: (data) {
      setState(() {
        print('详情--->$data');
        _dataModel = AppointMessageModel.fromJson(data);
        print('model--->${_dataModel.vehicleLicence.toString()}');
        widget.dataList['手机号'] = _dataModel.mobile.toString();
        widget.dataList['预约车牌'] = _dataModel.vehicleLicence;
        widget.dataList['车辆品牌'] = _dataModel.brand;
        widget.dataList['车辆型号'] = _dataModel.model;
        widget.dataList['VIN码'] = _dataModel.vin;
        widget.dataList['车辆颜色'] = _dataModel.carColor;
        widget.dataList['项目种类'] = _dataModel.dictName;
        widget.dataList['项目名称'] = _dataModel.secondaryService;
        widget.dataList['服务时间'] = _dataModel.appointmentTime;
        widget.dataList['备注'] = _dataModel.remark;
        print('字典--->${widget.dataList}');
      });
    }, onError: (error) {
      print('错误--->$error');
    });
  }

  _putEditTime(String time, String id) {
    ApiDio.detailEditTimeRequests(
      pragm: {'id': id, 'delFlag': 0, 'appointmentTime': time},
      onSuccess: (data) {
        setState(() {
          dateValue = time;
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          // elevation: 0,
          brightness: Brightness.light,
          title: Text(
            '预约详情',
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
        body: _dataModel == null
            ? Container()
            : ScrollConfiguration(
                behavior: NeverScrollBehavior(),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          width: 53,
                          height: 53,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: _dataModel.img == null
                              ? Image.asset(
                                  'Assets/Technology/headimage.png',
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  _dataModel.imgUrl.toString(),
                                  fit: BoxFit.fill,
                                ),
                        ),
                        Stack(
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(11, 0, 12, 25),
                                child: Container(
                                  width: 60,
                                  height: 22,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _dataModel.appointmentName.toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.fromLTRB(73, 4, 12, 25),
                              child: Container(
                                width: 44,
                                height: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Color.fromRGBO(30, 141, 255, 1),
                                        width: 1)),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    _dataModel.appointmentStatusName.toString(),
                                    style: TextStyle(
                                        color: Color.fromRGBO(30, 141, 255, 1),
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(
                          title.length,
                          (index) => Column(
                                children: [
                                  title[index] == '项目种类'
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              height: 6,
                                              color: Color.fromRGBO(
                                                  229, 229, 229, 1),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          title[index],
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(30, 30, 30, 1),
                                              fontSize: 15),
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      title[index] == '备注'
                                          ? Text('')
                                          : title[index] == '手机号'
                                              ? InkWell(
                                                  onTap: () {
                                                    CallIphone.callPhone(widget
                                                        .dataList[title[index]]
                                                        .toString());
                                                  },
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      widget.dataList[
                                                              title[index]]
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              39, 153, 93, 1),
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                )
                                              : title[index] == '服务时间'
                                                  ? Row(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            dateValue == ''
                                                                ? widget
                                                                    .dataList[
                                                                        title[
                                                                            index]]
                                                                    .toString()
                                                                : dateValue,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        30,
                                                                        30,
                                                                        30,
                                                                        1),
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              isDismissible:
                                                                  true,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return DatePickerView(
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      _putEditTime(
                                                                          value,
                                                                          _dataModel
                                                                              .id
                                                                              .toString());
                                                                      print(
                                                                          value);
                                                                    });
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '修改',
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          39,
                                                                          153,
                                                                          93,
                                                                          1),
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        widget.dataList[title[
                                                                        index]]
                                                                    .toString() ==
                                                                'null'
                                                            ? ''
                                                            : widget.dataList[
                                                                    title[
                                                                        index]]
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    30,
                                                                    30,
                                                                    30,
                                                                    1),
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                      SizedBox(
                                        width: 28,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  title[index] == '服务时间'
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              height: 6,
                                              color: Color.fromRGBO(
                                                  229, 229, 229, 1),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        )
                                      : title[index] == '备注'
                                          ? Container()
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      30,
                                                  height: 1,
                                                  color: Color.fromRGBO(
                                                      229, 229, 229, 1),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                ],
                              )),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: new Border.all(
                                width: 1,
                                color: Color.fromRGBO(238, 238, 238, 1)),
                          ),
                          child: Text(
                            widget.dataList[title[9]] == null
                                ? '无备注'
                                : widget.dataList[title[9]].toString(),
                            style: TextStyle(
                                color: Color.fromRGBO(30, 30, 30, 1),
                                fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewOrder(
                                        workOrderId: widget.workorderid,
                                      )));
                        },
                        child: Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(39, 153, 93, 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '接车',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ));
  }
}
