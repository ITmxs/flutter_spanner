import 'package:flutter/material.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/newOrder/carARquestApi.dart';
import 'package:spanners/spannerHome/newOrder/carCheckAllRec.dart';

class CheckHistory extends StatefulWidget {
  final String vehicleLicence;

  const CheckHistory({Key key, this.vehicleLicence}) : super(key: key);
  @override
  _CheckHistoryState createState() => _CheckHistoryState();
}

class _CheckHistoryState extends State<CheckHistory> {
  List dataList = List();
  //获取历史
  _getHistory() {
    RecCarDio.getCheckHistoryRequest(
      param: {'vehicleLicence': widget.vehicleLicence},
      onSuccess: (data) {
        setState(() {
          dataList = data;
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        centerTitle: true,
        title: Text('检查历史',
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
      ),
      body: Column(
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
                  width: MediaQuery.of(context).size.width - 30,
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      56 -
                      10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: ScrollConfiguration(
                    behavior: NeverScrollBehavior(),
                    child: ListView(
                      shrinkWrap: true,
                      children: List.generate(
                          dataList.length,
                          (index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CheckAllRec(
                                              grandId: dataList[index]
                                                  ['grandId'],
                                              vehicleLicence: dataList[index]
                                                  ['vehicleLicence'],
                                            )));
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  dataList[index]['checkName'],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
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
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  dataList[index]['createTime'],
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          159, 159, 159, 1),
                                                      fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Expanded(child: SizedBox()),
                                      Icon(
                                        Icons.chevron_right,
                                        size: 30,
                                        color:
                                            Color.fromRGBO(159, 159, 159, 0.7),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    height: 1,
                                    color: Color.fromRGBO(238, 238, 238, 1),
                                  )
                                ],
                              ))),
                    ),
                  )),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
