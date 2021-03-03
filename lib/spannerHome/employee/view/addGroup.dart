import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/common/commonTools.dart';

import '../employeeRequestApi.dart';

class AddGroup extends StatefulWidget {
  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  //文本框controller
  TextEditingController textEditingController = TextEditingController();

  //添加分组
  addGroup() {
    if (textEditingController.text == "") {
      CommonWidget.showAlertDialog("分组名称不能为空");
      return;
    }
    EmployeeRequestApi.addGroupRequest(
        param: {"groupName": textEditingController.text},
        onSuccess: (data) {
          if (data == "数据记录已存在") return;
          Navigator.pop(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "添加分组"),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(40.s, 30.s, 0, 10.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [CommonWidget.font(text: "分组名称")],
                ),
              ),
              Container(
                width: 345.s,
                height: 45.s,
                padding: EdgeInsets.fromLTRB(0, 10.s, 20.s, 0),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(5.s)),
                child: CommonWidget.textField(
                    hintText: "分组名称",
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    textController: textEditingController),
              ),
              SizedBox(
                height: 200.s,
              ),
              GestureDetector(
                child:
                    CommonWidget.button(text: "确认新建", width: 110.s, height: 30.s),
                onTap: () {
                  addGroup();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
