import 'package:flutter/material.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/registrationOfVehicle/apiRequst.dart';
import 'package:spanners/spannerHome/registrationOfVehicle/vehicleDetail.dart';

class RegistrationOfVehicle extends StatefulWidget {
  @override
  _RegistrationOfVehicleState createState() => _RegistrationOfVehicleState();
}

class _RegistrationOfVehicleState extends State<RegistrationOfVehicle> {
  //车辆List
  List vehicleList = [];
  //下拉列表框显示隐藏标志
  bool selectShowFlag = false;
  //下拉列表框显示内容
  String selectContent = "全部";
  //搜索条件集合
  Map searchList = {"type": ""};
  //文本框Controller
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    initData();
  }

  initData() {
    ApiDio.vehicleListRequest(
        param: {
          'vehicleLicence': '',
          'type': '',
        },
        onSuccess: (data) {
          print(data);
          vehicleList = data;
          setState(() {});
        });
  }

  tapSelect(String selectId, String selectValue) {
    searchList["type"] = selectId;
    selectShowFlag = false;
    selectContent = selectValue;
    setState(() {});
  }

  search() {
    searchList["vehicleLicence"] = (textEditingController.text) ?? "";

    ApiDio.vehicleListRequest(
        param: searchList,
        onSuccess: (data) {
          print(data);
          vehicleList = data;
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.iconAppBar(context, "车辆管理",
          rIcon: GestureDetector(
            onTap: () {
              //CommonRouter.push(context, widget: AddMember());
            },
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 31.s, 0),
                child: Image.asset(
                  "",
                  width: 25.s,
                  height: 25.s,
                )),
          )),
      body: Stack(
        children: [
          Column(
            children: [
              head(),
              content(),
            ],
          ),
          CommonWidget.dropDownChoice(
              showFlag: selectShowFlag,
              top: 50.s,
              left: 22.s,
              itemList: [
                {"": '全部'},
                {"0": "储值"},
                {"1": "非储值"},
                {"2": "临时车辆"}
              ],
              width: 90.s,
              height: 120.s,
              tapSelect: tapSelect)
        ],
      ),
    );
  }

  head() {
    return Column(
      children: [
        SizedBox(
          height: 1.s,
        ),
        Container(
          width: 375.s,
          height: 56.s,
          color: Colors.white,
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.s),
              color: Color.fromRGBO(238, 238, 238, 1),
            ),
            width: 330.s,
            height: 30.s,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    selectShowFlag = !selectShowFlag;
                    setState(() {});
                  },
                  child: Container(
                      width: 100.s,
                      padding: EdgeInsets.fromLTRB(20.s, 0, 0, 0),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          CommonWidget.font(text: selectContent, size: 13),
                          SizedBox(
                            width: 7.s,
                          ),
                          Image.asset(
                            "Assets/members/down.png",
                            width: 10.s,
                            height: 18.s,
                          )
                        ],
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 1.s,
                          height: 20.s,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10.s,
                        ),
                        Container(
                          width: 180.s,
                          margin: EdgeInsets.fromLTRB(0, 0, 20.s, 0),
                          child: CommonWidget.textField(
                              onEditingCompletes: () {
                                search();
                              },
                              maxLines: 1,
                              hintText: "请输入车牌号",
                              textController: textEditingController),
                        ),
                        GestureDetector(
                          onTap: () {
                            search();
                          },
                          child: Image.asset(
                            "Assets/members/search.png",
                            width: 17.s,
                            height: 17.s,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  content() {
    print(vehicleList.length);
    return Expanded(
        child: ScrollConfiguration(
      behavior: NeverScrollBehavior(),
      child: ListView(
        children: [
          for (int i = 0; i < vehicleList.length; i++)
            Container(
              // height: 124.s,
              width: 345.s,
              margin: EdgeInsets.fromLTRB(15.s, 10.s, 15.s, 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3.s)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.s, 15.s, 0, 11.s),
                    child: CommonWidget.font(
                        text: "${vehicleList[i]["vehicleLicence"]}",
                        size: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.s, 0, 15.s, 10.s),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Visibility(
                              child: Image.asset(
                                "Assets/members/vip.png",
                                width: 24.s,
                                height: 19.s,
                              ),
                              visible:
                                  ((vehicleList[i]["accountBalances"] ?? 0) >
                                          0) ||
                                      vehicleList[i]["trhId"] != null,
                            ),
                            SizedBox(
                              width: 5.s,
                            ),
                            Visibility(
                              visible: vehicleList[i]["type"] == 1,
                              child: Image.asset(
                                "Assets/members/group.png",
                                width: 40.s,
                                height: 20.s,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          child: CommonWidget.font(
                              text: "详情",
                              color: Color.fromRGBO(39, 153, 93, 1)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VehicleDetail(
                                          isVip: ((vehicleList[i]
                                                          ["accountBalances"] ??
                                                      0) >
                                                  0) ||
                                              vehicleList[i]["trhId"] != null,
                                          vehicleId: vehicleList[i]
                                              ["vehicleId"],
                                          vehicleLicence: vehicleList[i]
                                              ["vehicleLicence"],
                                        ))).then((value) => initData());
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.s, 0.s, 0, 11.s),
                    child: CommonWidget.font(
                      text: '${vehicleList[i]['model'] == null ? '' : vehicleList[i]['model']}' +
                          '${vehicleList[i]['model'] == null ? '' : '/'}' +
                          '${vehicleList[i]['brand'] == null ? '' : vehicleList[i]['brand']}' +
                          '${vehicleList[i]['carColor'] == null ? '' : '/'}' +
                          '${vehicleList[i]['carColor'] == null ? '' : vehicleList[i]['carColor']}',
                      size: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    color: Color.fromRGBO(238, 238, 238, 1),
                    height: 1.s,
                    width: 345.s,
                  ),
                  SizedBox(
                    height: 15.s,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(20.s, 5.s, 0, 0),
                          child: Container(
                              child: CommonWidget.font(
                            fontWeight: FontWeight.w400,
                            text: '上次进厂时间',
                          ))),
                      Expanded(child: SizedBox()),
                      GestureDetector(
                        child: CommonWidget.font(
                          text: vehicleList[i]['enterTime'] == null
                              ? ''
                              : vehicleList[i]['enterTime'].toString(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.s,
                  )
                ],
              ),
            ),
          SizedBox(
            height: 40.s,
          )
        ],
      ),
    ));
  }
}
