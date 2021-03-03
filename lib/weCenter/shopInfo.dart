import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/weCenter/weCenterRequestApi.dart';
import 'package:spanners/common/commonTools.dart';

import 'model/shop_info_model.dart';

/// Copyright (C), 2015-2020, spanners
/// FileName: shopInfo
/// Author: Jack
/// Date: 2020/12/2
/// Description:

class ShopInfo extends StatefulWidget {
  @override
  _ShopInfoState createState() => _ShopInfoState();
}

class _ShopInfoState extends State<ShopInfo> {
  //员工详情
  Map shopDetail = {};
  ShopInfoModel shopInfoModel = ShopInfoModel();
  Map info;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    info = json.decode(SynchronizePreferences.Get("userInfo"));
    initData();
  }

  initData()  {
     WeCenterDio.myInfoRequest(
      param: info["shopId"],
      onError: (error) {
        print(error);
      },
      onSuccess: (data) {
        shopInfoModel = ShopInfoModel.fromJson(data);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "门店信息"),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20.s,
                ),
                Column(
                  children: [
                    Container(
                      width: 345.s,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.s),
                          color: Colors.white),
                      padding: EdgeInsets.fromLTRB(15.s, 15.s, 0, 0.s),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidget.font(text: "门店照片"),
                          SizedBox(
                            height: 15.s,
                          ),
                          Visibility(
                            visible: shopInfoModel.logo != null,
                            child: CommonWidget.imageWithLine(
                                imageUrl: "${shopInfoModel.logo}"),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.s,
                    ),
                    Container(
                      width: 345.s,
                      color: Colors.white,
                      child: CommonWidget.simpleList(keyList: [
                        "门店名称",
                        "门店类型",
                      ], valueList: [
                        shopInfoModel.shopname,
                        shopInfoModel.type,
                      ], mustFlag: false),
                    ),
                    SizedBox(
                      height: 5.s,
                    ),
                    Container(
                      width: 345.s,
                      color: Colors.white,
                      child: CommonWidget.simpleList(keyList: [
                        "所在地区",
                        "详细地址"
                      ], valueList: [
                        "${shopInfoModel.provinceName} ${shopInfoModel.cityName} ${shopInfoModel.countyName}",
                        shopInfoModel.address
                      ], mustFlag: false),
                    ),
                    SizedBox(
                      height: 5.s,
                    ),
                    Container(
                      width: 345.s,
                      color: Colors.white,
                      child: CommonWidget.simpleList(
                          keyList: ["门店手机", "门店固话"],
                          valueList: [shopInfoModel.mobile, shopInfoModel.tel],
                          mustFlag: false),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
