import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/weCenter/weCenterRequestApi.dart';

import 'model/shop_info_model.dart';

/// Copyright (C), 2015-2020, spanners
/// FileName: share_setting
/// Author: Jack
/// Date: 2020/12/3
/// Description:
class ShareSetting extends StatefulWidget {
  @override
  _ShareSettingState createState() => _ShareSettingState();
}

class _ShareSettingState extends State<ShareSetting> {
  bool flag = true;
  Map info;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    info = json.decode(SynchronizePreferences.Get("userInfo"));
    initData();
  }

  initData() {
    WeCenterDio.myInfoRequest(
      param: info["shopId"],
      onError: (error) {
        print(error);
      },
      onSuccess: (data) {
        (data["shareBonusFlag"] == "0") ? flag = true : flag = false;
        setState(() {});
      },
    );
  }

  setShare() async {
    await WeCenterDio.shareSettingRequest(
      param: {"flag": flag ? '0' : '1'},
      onError: (error) {},
      onSuccess: (data) {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "分红设置"),
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
                          text: "分红设置",
                          color: Color.fromRGBO(39, 153, 93, 1),
                          size: 18)
                    ],
                  ),
                ),
                Container(
                  width: 345.s,
                  height: 50.s,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3.s)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "分红"),
                      Container(
                        width: 52.s,
                        child: Switch(
                          value: flag,
                          onChanged: (nowBool) {
                            flag = !flag;
                            setShare();
                          },
                          activeColor: Color.fromRGBO(39, 153, 93, 1),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
