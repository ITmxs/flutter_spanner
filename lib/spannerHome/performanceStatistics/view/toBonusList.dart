import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/common/commonRouter.dart';
import 'package:spanners/common/commonWidget.dart';
import 'package:spanners/spannerHome/delivery_check/view/dc_details_page.dart';
import 'package:spanners/spannerHome/performanceStatistics/view/toBonusDetail.dart';

import '../performanceRequestApi.dart';

class ToBonusList extends StatefulWidget {
  @override
  _ToBonusListState createState() => _ToBonusListState();
}

class _ToBonusListState extends State<ToBonusList> {
  List workOrderEntityList = [];

  @override
  void initState() {
    initData();
  }

  //初始化数据
  initData() async {
    await PerformanceDio.toBonusListRequest(onSuccess: (data) {
      workOrderEntityList = data["workOrderEntityList"];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "待分红订单"),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
              ),
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: ListView(
                children: [
                  for (int i = 0; i < workOrderEntityList.length; i++)
                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(15, 0, 40, 0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(229, 229, 229, 1),
                      ))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonWidget.font(
                              text:
                                  "${workOrderEntityList[i]["vehicleLicence"]}"),
                          GestureDetector(
                            child: CommonWidget.font(
                                text: "详情",
                                color: Color.fromRGBO(39, 153, 93, 1),
                                size: 14.0),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DCDetailsPage(
                                          workOrderId: workOrderEntityList[i]
                                              ["workOrderId"],
                                          detailsType: DetailsType
                                              .DetailsTypeNoSettlement,
                                          showShareRed: "0",
                                          showShareButton:"0")));
                            },
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
