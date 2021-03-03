import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/weCenter/weCenterRequestApi.dart';

/// Copyright (C), 2020-2020, spanners
/// FileName: add_feedback
/// Author: Jack
/// Date: 2020/12/3
/// Description:
class AddFeedback extends StatefulWidget {
  @override
  _AddFeedbackState createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
  TextEditingController feedbackController = TextEditingController();
  //BigInt a = BigInt.from(1513213511341531315);
  double a = 1.11581313131315313513;
  addFeedback() async {
    await WeCenterDio.addFeedbackRequest(
      param: {
        "userId": json.decode(SynchronizePreferences.Get("userInfo"))["id"],
        "content": feedbackController.text
      },
      onError: (error) {
        print(error);
      },
      onSuccess: (data) {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(a);
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "意见反馈"),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25.s, 20.s, 0, 10.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonWidget.font(
                          text: "反馈内容",
                          color: Color.fromRGBO(39, 153, 93, 1),
                          size: 18)
                    ],
                  ),
                ),
                Container(
                  width: 345.s,
                  height: 150.s,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.s),
                      color: Colors.white),
                  child: CommonWidget.textField(
                      hintText: "请简要描述您的问题和意见，以便我们提供更好的帮助",
                      maxLines: 9,
                      textController: feedbackController),
                ),
                SizedBox(
                  height: 50.s,
                ),
                GestureDetector(
                  child:
                      CommonWidget.button(text: "确定", width: 90.s, height: 30.s),
                  onTap: () {
                    addFeedback();
                  },
                ),
                SizedBox(
                  height: 200.s,
                ),
                CommonWidget.font(
                    text: "致电客服 ： 400-1085488",
                    color: Color.fromRGBO(39, 153, 93, 1))
              ],
            )
          ],
        ),
      ),
    );
  }
}
