import 'package:flutter/material.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/members/membersRequestApi.dart';
import 'package:spanners/spannerHome/members/view/addCar.dart';

class EditCar extends StatefulWidget {
  final String userId;

  const EditCar({Key key, this.userId}) : super(key: key);
  @override
  _EditCarState createState() => _EditCarState();
}

class _EditCarState extends State<EditCar> {
  List vehicle = List();
  String member;
  // 获取会员车辆
  _getCarList() {
    MembersDio.memberDetailRequest(
      param: {'userId': widget.userId},
      onSuccess: (data) {
        setState(() {
          member = data['member']['realName'].toString();
          vehicle = data['vehicle'];
        });
      },
    );
  }

  // 删除会员车辆
  _deleteCar(String vehicleId) {
    MembersDio.deleteRequest(
      param: {'vehicleId': vehicleId},
      onSuccess: (data) {
        setState(() {
          _getCarList();
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCarList();
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
            '车辆编辑',
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
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: [
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(39, 153, 93, 1)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '会员车辆',
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1), fontSize: 18),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              //会员车辆列表展示
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: vehicle.length,
                  itemBuilder: (BuildContext context, int item) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    vehicle[item]['vehicleLicence'],
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 15),
                                  ),
                                  Expanded(child: SizedBox()),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AddCar(
                                                        vehicleId: vehicle[item]
                                                            ['vehicleId'],
                                                        title: '修改车辆',
                                                      )))
                                          .then((value) => _getCarList());
                                    },
                                    child: Text(
                                      '修改',
                                      style: TextStyle(
                                          color: Color.fromRGBO(39, 153, 93, 1),
                                          fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: Routers.navigatorState
                                              .currentState.context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                content: Container(
                                                    width: 100,
                                                    height: 90,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          '确定删除当前车辆？',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Container(
                                                          height: 1,
                                                          color: Color.fromRGBO(
                                                              41, 39, 39, 1),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        '取消',
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                41,
                                                                                39,
                                                                                39,
                                                                                1),
                                                                            fontSize:
                                                                                14),
                                                                      ),
                                                                    ))),
                                                            Container(
                                                              width: 1,
                                                              height: 20,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      41,
                                                                      39,
                                                                      39,
                                                                      1),
                                                            ),
                                                            Expanded(
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      // _delete(dataList[index]['workOrderId']);
                                                                      _deleteCar(
                                                                          vehicle[item]
                                                                              [
                                                                              'vehicleId']);
                                                                    },
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        '确定',
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                41,
                                                                                39,
                                                                                39,
                                                                                1),
                                                                            fontSize:
                                                                                14),
                                                                      ),
                                                                    )))
                                                          ],
                                                        ),
                                                      ],
                                                    )));
                                          });
                                    },
                                    child: Text(
                                      '删除',
                                      style: TextStyle(
                                          color: Color.fromRGBO(39, 153, 93, 1),
                                          fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  }),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCar(
                                    userId: widget.userId,
                                    userName: member,
                                    title: '添加车辆',
                                  ))).then((value) => _getCarList());
                    },
                    child: Text(
                      '添加车辆+',
                      style: TextStyle(
                          color: Color.fromRGBO(39, 153, 93, 1), fontSize: 15),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 150,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: 108,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(39, 153, 93, 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '完成',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 15),
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 150,
              ),
            ],
          ),
        ));
  }
}
