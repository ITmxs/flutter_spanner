import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';

/// Copyright (C), 2020-2020, spanners
/// FileName: about_us
/// Author: Jack
/// Date: 2020/12/4
/// Description:

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "关于我们"),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            Column(
              children:
              [
                SizedBox(
                  height: 50.s,
                ),
                CommonWidget.font(text: "扫描下载扳手兄弟IOS"),
                SizedBox(
                  height: 10.s,
                ),
                Container(
                  width: 180.s,
                  height: 180.s,
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 50.s,
                ),
                CommonWidget.font(text: "扫描下载扳手兄弟Android"),
                SizedBox(
                  height: 10.s,
                ),
                Container(
                  width: 180.s,
                  height: 180.s,
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 50.s,
                ),
                CommonWidget.font(text: "《软件许可及服务协议》"),
                SizedBox(
                  height: 5.s,
                ),
                CommonWidget.font(text: "《隐私保护指引》"),



              ],
            )
          ],
        ),
      ),
    );
  }
}
