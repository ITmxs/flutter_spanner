import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/members/membersRequestApi.dart';
import 'package:spanners/spannerHome/members/view/addVipCar.dart';

class AddCar extends StatefulWidget {
  final Map data;
  final userId;
  final userName;
  final vehicleId;
  final title;
  const AddCar(
      {Key key,
      this.data,
      this.userId,
      this.userName,
      this.vehicleId,
      this.title})
      : super(key: key);
  // AddCar(this.data);
  @override
  _AddCarState createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  //展示车辆信息
  Map carMeassge = Map();
  //上传 upmap
  Map vipCarMap = Map();
  //车牌号用
  List vecList = [];
  //
  String dateText = '请输入';
  //商业险到期时间
  String commercialInsurance;
  //交强险到期时间
  String compulsoryDate;
  //年审日
  String annualExpiryDate;
  //行驶证到期日
  String verificationDate;
  TextEditingController commercialInsuranceTextEditingController =
      TextEditingController(); //商业险承保
  TextEditingController compulsoryDateTextEditingController =
      TextEditingController(); //交强险承保
  TextEditingController remarkTextController = TextEditingController();

  //添加车辆
  _addCar() {
    vipCarMap['userId'] = widget.userId;
    vipCarMap['vehicleOwners'] = widget.userName;
    MembersDio.addVipCarRequest(
      param: vipCarMap,
      onSuccess: (data) {
        if (data == null) {
          Navigator.pop(context);
        } else {
          Alart.showAlartDialog('车牌号重复，请核对后重新输入！', 1);
        }
      },
    );
  }

  //修改车辆
  _editCar() {
    vipCarMap['vehicleId'] = widget.vehicleId;
    MembersDio.editVipCarRequest(
      param: vipCarMap,
      onSuccess: (data) {
        if (data == null) {
          Navigator.pop(context);
        } else {
          Alart.showAlartDialog('车牌号重复，请核对后重新输入! ', 1);
        }
      },
    );
  }

  //车辆详情
  _getCarDetail() {
    MembersDio.vipCarDetailRequest(
      param: {'vehicleId': widget.vehicleId},
      onSuccess: (data) {
        setState(() {
          carMeassge = data;

          commercialInsurance = carMeassge['commercialInsurance'] == null
              ? ''
              : carMeassge['commercialInsurance'];
          compulsoryDate = carMeassge['compulsoryDate'] == null
              ? ''
              : carMeassge['compulsoryDate'];
          annualExpiryDate = carMeassge['annualExpiryDate'] == null
              ? ''
              : carMeassge['annualExpiryDate'];
          verificationDate = carMeassge['verificationDate'] == null
              ? ''
              : carMeassge['verificationDate'];
          commercialInsuranceTextEditingController.text =
              carMeassge['commercialInsuranceCompany'] == null
                  ? ''
                  : carMeassge['commercialInsuranceCompany'];
          compulsoryDateTextEditingController.text =
              carMeassge['compulsoryDateCompany'] == null
                  ? ''
                  : carMeassge['compulsoryDateCompany'];
          remarkTextController.text =
              carMeassge['remark'] == null ? '' : carMeassge['remark'];
          vipCarMap['commercialInsurance'] = carMeassge['commercialInsurance'];
          vipCarMap['compulsoryDate'] = carMeassge['compulsoryDate'];
          vipCarMap['annualReviewExpiryDate'] =
              carMeassge['annualReviewExpiryDate'];
          vipCarMap['verificationDate'] = carMeassge['verificationDate'];
          vipCarMap['commercialInsuranceCompany'] =
              carMeassge['commercialInsuranceCompany'];
          vipCarMap['compulsoryDateCompany'] =
              carMeassge['compulsoryDateCompany'];
          vipCarMap['remark'] = carMeassge['remark'];
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.vehicleId == null ? print('') : _getCarDetail();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SharedManager.removeString('upVipCarMap');
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return GestureDetector(
        onTap: () {
          //点击空白处隐藏键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
            appBar: CommonWidget.simpleAppBar(context, title: widget.title),
            body: ScrollConfiguration(
              behavior: NeverScrollBehavior(),
              child: ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  AddVipCar(
                    valueMap: carMeassge,
                    onChanged: (value) {
                      vipCarMap.addAll(value);
                      print(vipCarMap);
                    },
                  ),
                  programInfo(),
                  SizedBox(
                    height: 90.s,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          print(vipCarMap);
                          widget.vehicleId == null ? _addCar() : _editCar();
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
                              '完成',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 190.s,
                  )
                ],
              ),
            )));
  }

  programInfo() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(15.s, 20.s, 0, 15.s),
          child: Row(
            children: [
              Image.asset(
                'Assets/apointMent/apointcar.png',
                width: 19.s,
                height: 16.s,
              ),
              SizedBox(
                width: 4.s,
              ),
              CommonWidget.font(
                  text: "智能提醒项目",
                  color: Color.fromRGBO(39, 153, 93, 1),
                  size: 18.s)
            ],
          ),
        ),
        Container(
            width: 345.s,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.s), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: CommonWidget.font(
                      text: "商业险", fontWeight: FontWeight.bold),
                  padding: EdgeInsets.fromLTRB(7.s, 20.s, 0, 0),
                ),
                CommonWidget.chooseDateRow(context,
                    rowText: "到期日期",
                    dateText: commercialInsurance == null
                        ? "请选择"
                        : commercialInsurance,
                    textColor: commercialInsurance == null
                        ? Color.fromRGBO(159, 159, 159, 1)
                        : Colors.black, onTap: (String text, time) {
                  setState(() {
                    commercialInsurance =
                        "${time.year}-${time.month}-${time.day}";

                    vipCarMap['commercialInsurance'] = commercialInsurance;
                  });
                }),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20.s, 0, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Visibility(
                            visible: false,
                            child: CommonWidget.mustInput(),
                            replacement: SizedBox(
                              width: 5.s,
                            ),
                          ),
                          CommonWidget.font(text: "承保公司")
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 240.s,
                            padding: EdgeInsets.fromLTRB(20.s, 0, 0.s, 0),
                            child: TextField(
                              //                      focusNode: textFocusNode,
                              controller:
                                  commercialInsuranceTextEditingController,
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              onChanged: (value) {
                                vipCarMap['commercialInsuranceCompany'] = value;
                              },
                              style: TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  hintText: '请输入',
                                  hintStyle: TextStyle(
                                      fontSize: 13.s,
                                      color: Color.fromRGBO(129, 129, 129, 1))),
                            ),
                          ),
                          SizedBox(
                            width: SizeAdaptiveUtil().size(30),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
        SizedBox(
          height: 10.s,
        ),
        Container(
            width: 345.s,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.s), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: CommonWidget.font(
                      text: "交强险", fontWeight: FontWeight.bold),
                  padding: EdgeInsets.fromLTRB(7.s, 20.s, 0, 0),
                ),
                CommonWidget.chooseDateRow(context,
                    rowText: "到期日期",
                    dateText: compulsoryDate == null ? "请选择" : compulsoryDate,
                    textColor: compulsoryDate == null
                        ? Color.fromRGBO(159, 159, 159, 1)
                        : Colors.black, onTap: (String text, time) {
                  setState(() {
                    compulsoryDate = "${time.year}-${time.month}-${time.day}";
                    vipCarMap['compulsoryDate'] = compulsoryDate;
                  });
                }),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20.s, 0, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Visibility(
                            visible: false,
                            child: CommonWidget.mustInput(),
                            replacement: SizedBox(
                              width: 5.s,
                            ),
                          ),
                          CommonWidget.font(text: "承保公司")
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 240.s,
                            padding: EdgeInsets.fromLTRB(20.s, 0, 0.s, 0),
                            child: TextField(
                              //                      focusNode: textFocusNode,
                              controller: compulsoryDateTextEditingController,
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              onChanged: (value) {
                                vipCarMap['compulsoryDateCompany'] = value;
                              },
                              style: TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  hintText: '请输入',
                                  hintStyle: TextStyle(
                                      fontSize: 13.s,
                                      color: Color.fromRGBO(129, 129, 129, 1))),
                            ),
                          ),
                          SizedBox(
                            width: SizeAdaptiveUtil().size(30),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
        SizedBox(
          height: 10.s,
        ),
        Container(
          width: 345.s,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.s), color: Colors.white),
          child: CommonWidget.chooseDateRow(context,
              rowText: "下次检车日期",
              dateText: annualExpiryDate == null ? "请选择" : annualExpiryDate,
              textColor: annualExpiryDate == null
                  ? Color.fromRGBO(159, 159, 159, 1)
                  : Colors.black, onTap: (String text, time) {
            setState(() {
              annualExpiryDate = "${time.year}-${time.month}-${time.day}";
              vipCarMap['annualExpiryDate'] = annualExpiryDate;
            });
          }),
        ),
        SizedBox(
          height: 10.s,
        ),
        Container(
          width: 345.s,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.s), color: Colors.white),
          child: CommonWidget.chooseDateRow(context,
              rowText: "驾驶证到期日",
              dateText: verificationDate == null ? "请选择" : verificationDate,
              textColor: verificationDate == null
                  ? Color.fromRGBO(159, 159, 159, 1)
                  : Colors.black, onTap: (String text, time) {
            setState(() {
              verificationDate = "${time.year}-${time.month}-${time.day}";
              vipCarMap['verificationDate'] = verificationDate;
            });
          }),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(25.s, 20.s, 0, 10.s),
              child: CommonWidget.font(text: "备注"),
            ),
          ],
        ),
        Container(
          width: 345.s,
          height: 80.s,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.s), color: Colors.white),
          child: TextField(
            // focusNode: textFocusNode,
            controller: remarkTextController,
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.start,
            onChanged: (value) {
              vipCarMap['remark'] = value;
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                hintText: '请填写您需要备注的信息......',
                hintStyle: TextStyle(
                    fontSize: 13.s, color: Color.fromRGBO(129, 129, 129, 1))),
          ),
        )
      ],
    );
  }
}
