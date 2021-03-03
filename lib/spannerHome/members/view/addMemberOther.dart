import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';

import 'addCar.dart';

class AddMemberOther extends StatefulWidget {
  Map data;
  AddMemberOther(this.data);
  @override
  _AddMemberOtherState createState() => _AddMemberOtherState();
}

class _AddMemberOtherState extends State<AddMemberOther> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonWidget.simpleAppBar(context, title: "创建会员"),
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(30.s, 26.s, 0, 23.s),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        widget.data["typeFlag"] == 'person'
                            ? CommonWidget.font(text: "个人账户")
                            : CommonWidget.font(text: "企业账户"),
                      ],
                    ),
                  ),
                  content(),
                  SizedBox(
                    height: 200.s,
                  ),
                  Container(
                    width: 260.s,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: CommonWidget.button(
                              text: "添加车辆", width: 105.s, height: 30.s),
                          onTap: () {
                            //CommonRouter.push(context,widget: AddCar(widget.data));
                          },
                        ),
                        CommonWidget.button(
                            text: "去充值", width: 105.s, height: 30.s),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  content() {
    return widget.data["typeFlag"] == 'person'
        ? CommonWidget.simpleList(
            keyList: ["车主姓名", "手机号"],
            valueList: [widget.data["realName"], widget.data["mobile"]])
        : CommonWidget.simpleList(keyList: [
            "企业名称",
            "手机号",
            "管理员姓名"
          ], valueList: [
            widget.data["company"],
            widget.data["mobile"],
            widget.data["realName"]
          ]);
  }
}
