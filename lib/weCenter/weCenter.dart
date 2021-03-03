import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:spanners/AfNetworking/requestDio.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/weCenter/share_order/page/share_order_page.dart';
import 'package:spanners/weCenter/store_order_page/page/store_order_page.dart';
import 'package:spanners/weCenter/weCenterRequestApi.dart';
import 'package:spanners/weCenter/weSetting.dart';

// ignore: camel_case_types
class WeCenter extends StatefulWidget {
  @override
  _WeCenterState createState() => _WeCenterState();
}

// ignore: camel_case_types
class _WeCenterState extends State<WeCenter> {
  List titleList = ['车主订单', '门店订单', '共享订单', '余额管理'];
  List iconList = [
    'Assets/wecenter/carmenu.png',
    'Assets/wecenter/storemenu.png',
    'Assets/wecenter/sharemenu.png',
    'Assets/wecenter/moneymenu.png'
  ];
  List itemList = ['个人信息', '门店信息', '分红设置', '意见反馈', '关于我们'];
  List itemImages = [
    'Assets/wecenter/usercenter.png',
    'Assets/wecenter/storemessage.png',
    'Assets/wecenter/sharemoney.png',
    'Assets/wecenter/idercenter.png',
    'Assets/wecenter/aboutas.png'
  ];
  Map info = {};
  Map nameData;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    info = json.decode(SynchronizePreferences.Get("userInfo"));
    initData();
  }

  initData() async {
    String url = "${DioUtils.baseURL}api/storeshop/queryShopInfoById";

    ///创建Dio
    Dio dio = Dio();

    ///创建Map 封装参数
    String shopId = await SharedManager.getShopIdString();
    dio.interceptors.add(CookieManager((await Cook.cookieJar)));
    Response response = await dio.get(url + '/' + shopId.toString());
    nameData = response.data["data"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(49, 58, 67, 1),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 305,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('Assets/wecenter/centertopback.png'),
                      fit: BoxFit.fill)),
              child: Column(
                children: [
                  SizedBox(
                    height: 54,
                  ),
                  Row(
                    children: [
                      Expanded(child: SizedBox()),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Settings()));
                        },
                        child: Image.asset(
                          'Assets/wecenter/centerset.png',
                          width: 25,
                          height: 25,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //头像信息设置
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            image: DecorationImage(
                                //做网络 本地判断
                                image: AssetImage(
                                    'Assets/Technology/3.0x/headimage.png'))),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${info["realName"] ?? ""}',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 16),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '', //'${(nameData != null) ? nameData["shopname"] : ""}',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(255, 192, 0, 1)),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '  ${(nameData != null) ? nameData["type"] : ""}  ',
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 171, 0, 1),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          )
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      Column(
                        children: [
                          SizedBox(
                            height: 55,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //功能菜单
                  Row(children: [
                    SizedBox(
                      width: 45,
                    ),
                    Expanded(
                      child: GridView.builder(
                          shrinkWrap: true,
                          //禁止滑动
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            //横轴元素个数
                            crossAxisCount: 4,
                            //纵轴间距
                            mainAxisSpacing: 0.0,
                            //横轴间距
                            crossAxisSpacing: 10,
                            // MediaQuery.of(context).size.width / 3 -
                            //     90 / 3,
                            //子组件宽高长度比例
                            //  childAspectRatio: 1.0
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                print('进入功能菜单');
                                if (index == 0) {
                                  PermissionApi.whetherContain(
                                          'vehicle_owner_order_view')
                                      ? print('')
                                      : print('车主订单');
                                }
                                if (index == 1) {
                                  print('门店订单');
                                  PermissionApi.whetherContain(
                                          'shop_order_view')
                                      ? print('')
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StoreOrderPage(),
                                          ),
                                        );
                                }
                                if (index == 2) {
                                  print('共享订单');
                                  PermissionApi.whetherContain(
                                          'share_order_view')
                                      ? print('')
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ShareOrderPage(),
                                          ),
                                        );
                                }
                                switch (titleList[index]) {
                                  case '余额管理':
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             BalanceReviewPage()));
                                    break;
                                  default:
                                }
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    iconList[index],
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      titleList[index],
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      width: 45,
                    ),
                  ])
                ],
              ),
            ),
            //items
            Expanded(
              child: Container(
                  height: MediaQuery.of(context).size.height - 305,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.white),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      ScrollConfiguration(
                          behavior: NeverScrollBehavior(),
                          child: ListView(
                            shrinkWrap: true,
                            children: List.generate(
                                itemList.length,
                                (index) => InkWell(
                                      onTap: () {
                                        print('进入item');
                                        if (itemList[index] == '个人信息') {
                                          RouterUtil.push(context,
                                              routerName: "myInfo");
                                        }
                                        if (itemList[index] == '门店信息') {
                                          RouterUtil.push(context,
                                              routerName: "shopInfo");
                                        }
                                        if (itemList[index] == '分红设置') {
                                          PermissionApi.whetherContain(
                                                  'bonus_setting_view')
                                              ? print('')
                                              : RouterUtil.push(context,
                                                  routerName: "shareSetting");
                                        }
                                        if (itemList[index] == '意见反馈') {
                                          RouterUtil.push(context,
                                              routerName: "addFeedback");
                                        }
                                        if (itemList[index] == '关于我们') {
                                          RouterUtil.push(context,
                                              routerName: "aboutUs");
                                        }
                                      },
                                      child: Container(
                                          height: 50,
                                          child: Column(
                                            children: [
                                              // SizedBox(
                                              //   height: 13,
                                              // ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 18,
                                                  ),
                                                  Image.asset(
                                                    itemImages[index],
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                  SizedBox(
                                                    width: 9,
                                                  ),
                                                  Text(
                                                    itemList[index],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(
                                                            45, 45, 45, 1)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 13,
                                              ),
                                              itemList[index] == '分红设置'
                                                  ? Container(
                                                      height: 8,
                                                      color: Color.fromRGBO(
                                                          229, 229, 229, 1),
                                                    )
                                                  : Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            height: 1,
                                                            color:
                                                                Color.fromRGBO(
                                                                    229,
                                                                    229,
                                                                    229,
                                                                    1),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        )
                                                      ],
                                                    )
                                            ],
                                          )),
                                    )),
                          ))
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
