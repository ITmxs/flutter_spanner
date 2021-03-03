import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/notificationCenter.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/members/view/memberDetail.dart';

import '../membersRequestApi.dart';
import 'addMemberOther.dart';

class AddMember extends StatefulWidget {
  final Map memmber; //会员信息
  const AddMember({Key key, this.memmber}) : super(key: key);
  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  //个人账户
  bool personCheckFlag = true;
  //企业账户
  bool groupCheckFlag = false;
  //输入框controller
  TextEditingController realNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  //传输数组
  Map param = {};
  create() async {
    if (check() == false) {
      return;
    }
    // return;
    await MembersDio.addMemberRequest(
        param: {
          "realName": realNameController.text,
          "mobile": mobileController.text,
          "company": companyController.text ?? null,
          "type": personCheckFlag == true ? 0 : 1
        },
        onSuccess: (data) {
          if (data == "号码已经被注册，请核对！") {
            _showAlartDialog("号码已经被注册，请核对！");
            return;
          }
          param["userId"] = data;
          if (personCheckFlag == true) {
            param["typeFlag"] = "person";
            param["realName"] = realNameController.text;
            param["mobile"] = mobileController.text;
          }
          if (groupCheckFlag == true) {
            param["typeFlag"] = "group";
            param["realName"] = realNameController.text;
            param["mobile"] = mobileController.text;
            param["company"] = companyController.text;
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MemberDetail(
                        userId: data,
                      )));
        });
  }

  //会员信息更改
  put() {
    MembersDio.memberRequest(
      param: {
        "memberId": widget.memmber['memberId'],
        "userId": widget.memmber['userId'],
        "realName": realNameController.text,
        "mobile": mobileController.text,
        "company": companyController.text ?? null,
      },
      onSuccess: (data) {
        print(data);
        Navigator.pop(context);
        // NotificationCenter.instance.postNotification('detail', 0);
      },
    );
  }

  check() {
    if (groupCheckFlag == true && realNameController.text == '') {
      _showAlartDialog("企业名称不能为空");
      return false;
    }
    if (realNameController.text == '') {
      _showAlartDialog("姓名不能为空");
      return false;
    }
    if (mobileController.text == '') {
      _showAlartDialog("手机号不能为空");
      return false;
    }
  }

  static Future _showAlartDialog(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowAlart(
          backLart: 1,
          title: message,
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.memmber != null) {
      //企业
      if (widget.memmber['type'].toString() == '1') {
        personCheckFlag = false;
        companyController.text = widget.memmber['company'];
        mobileController.text = widget.memmber['mobile'];
        realNameController.text = widget.memmber['realName'];
      }
      //个人
      if (widget.memmber['type'].toString() == '0') {
        personCheckFlag = true;
        realNameController.text = widget.memmber['realName'];
        mobileController.text = widget.memmber['mobile'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //点击空白处隐藏键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
            appBar: CommonWidget.simpleAppBar(context,
                title: widget.memmber == null ? '创建会员' : "会员修改"),
            body: ScrollConfiguration(
              behavior: NeverScrollBehavior(),
              child: ListView(
                children: [
                  Column(
                    children: [
                      widget.memmber == null ? head() : heads(),
                      input(),
                      SizedBox(
                        height: 200.s,
                      ),
                      GestureDetector(
                        child: CommonWidget.button(
                            text: widget.memmber == null ? "创建" : '完成',
                            width: 105.s,
                            height: 30.s),
                        onTap: () {
                          widget.memmber == null ? create() : put();
                        },
                      )
                    ],
                  ),
                ],
              ),
            )));
  }

  heads() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.s, 25.s, 20.s, 20.s),
      child: Row(
        children: [
          Row(
            children: [
              CommonWidget.font(
                  text: widget.memmber['type'].toString() == '1'
                      ? '企业账户'
                      : "个人账户"),
            ],
          ),
        ],
      ),
    );
  }

  head() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.s, 25.s, 20.s, 20.s),
      child: Row(
        children: [
          Row(
            children: [
              CommonWidget.font(text: "个人账户"),
              CommonWidget.circleCheckBox(
                  checkFlag: personCheckFlag,
                  onTap: () {
                    if (personCheckFlag == true) return;
                    realNameController.text = '';
                    mobileController.text = '';
                    personCheckFlag = true;
                    groupCheckFlag = false;
                    setState(() {});
                  })
            ],
          ),
          SizedBox(
            width: 50.s,
          ),
          Row(
            children: [
              CommonWidget.font(text: "企业账户"),
              CommonWidget.circleCheckBox(
                  checkFlag: groupCheckFlag,
                  onTap: () {
                    if (groupCheckFlag == true) return;
                    realNameController.text = '';
                    mobileController.text = '';
                    groupCheckFlag = true;
                    personCheckFlag = false;
                    setState(() {});
                  })
            ],
          ),
        ],
      ),
    );
  }

  input() {
    return personCheckFlag
        ?
        //个人
        Container(
            width: 345.s,
            height: 110.s,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.s), color: Colors.white),
            child: Column(
              children: [
                Container(
                  decoration: CommonWidget.grayBottomBorder(),
                  padding: EdgeInsets.fromLTRB(0, 20.s, 0, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CommonWidget.mustInput(),
                          CommonWidget.font(text: "车主姓名")
                        ],
                      ),
                      Container(
                        width: 260.s,
                        padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
                        child: CommonWidget.textField(
                            maxLines: 1,
                            hintText: "请输入",
                            textAlign: TextAlign.end,
                            textController: realNameController),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20.s, 0, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CommonWidget.mustInput(),
                          CommonWidget.font(text: "手机号")
                        ],
                      ),
                      Container(
                        width: 260.s,
                        padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
                        child: CommonWidget.textField(
                            maxLines: 1,
                            hintText: "请输入",
                            textAlign: TextAlign.end,
                            textController: mobileController),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        :
        //企业
        Container(
            width: 345.s,
            height: 165.s,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.s), color: Colors.white),
            child: Column(
              children: [
                Container(
                  decoration: CommonWidget.grayBottomBorder(),
                  padding: EdgeInsets.fromLTRB(0, 20.s, 0, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CommonWidget.mustInput(),
                          CommonWidget.font(text: "企业名称")
                        ],
                      ),
                      Container(
                        width: 260.s,
                        padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
                        child: CommonWidget.textField(
                            hintText: "请输入",
                            textAlign: TextAlign.end,
                            textController: companyController),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: CommonWidget.grayBottomBorder(),
                  padding: EdgeInsets.fromLTRB(0, 20.s, 0, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CommonWidget.mustInput(),
                          CommonWidget.font(text: "手机号")
                        ],
                      ),
                      Container(
                        width: 260.s,
                        padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
                        child: CommonWidget.textField(
                            hintText: "请输入",
                            textAlign: TextAlign.end,
                            textController: mobileController),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20.s, 0, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CommonWidget.mustInput(),
                          CommonWidget.font(text: "管理员姓名")
                        ],
                      ),
                      Container(
                        width: 260.s,
                        padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
                        child: CommonWidget.textField(
                            hintText: "请输入",
                            textAlign: TextAlign.end,
                            textController: realNameController),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
