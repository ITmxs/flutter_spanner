import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cModel/storeActivityModel.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/share_shop/page/ss_goods_details_page.dart';
import 'package:spanners/spannerHome/storeActivity/astoreActivityApi.dart';
import 'package:spanners/spannerHome/storeActivity/storeActivityAdd.dart';
import 'package:spanners/spannerHome/storeActivity/storeActivityEdit.dart';

class StoreActivityPage extends StatefulWidget {
  @override
  _StoreActivityPageState createState() => _StoreActivityPageState();
}

class _StoreActivityPageState extends State<StoreActivityPage> {
  bool all = false;
  bool showIn = true; //卡劵 商品
  bool review = false; //管理
  List idList = List(); //卡劵id
  List campaignList = List(); //卡劵
  List campaignGoodsList = List(); //商品
  String ids = ''; //卡劵id集合
  //获取数据
  _getData() {
    ActivityDio.campaignListRequest(
      param: {'goodsName': ''},
      onSuccess: (data) {
        setState(() {
          campaignList = data['campaignList'];
          campaignGoodsList = data['campaignGoodsList'];
        });
      },
    );
  }

  //删除卡劵
  _deleteData() {
    String ids;
    if (idList.length > 0) {
      ids = idList.join(',');
    }
    ActivityDio.deleteCampaignRequest(
      param: {'ids': ids},
      onSuccess: (data) {
        setState(() {
          _getData();
        });
      },
    );
  }

  //all in
  _allin() {
    setState(() {
      if (showIn) {
        if (idList.length > 0) {
          idList.clear();
        } else {
          idList.clear();
          if (campaignList.length > 0) {
            for (var i = 0; i < campaignList.length; i++) {
              idList.add(ActivityModel.fromJson(campaignList[i]).id);
            }
          }
        }
      } else {
        if (idList.length > 0) {
          idList.clear();
        } else {
          idList.clear();
          if (campaignGoodsList.length > 0) {
            for (var i = 0; i < campaignGoodsList.length; i++) {
              idList.add(ActivityGoodsModel.fromJson(campaignGoodsList[i]).id);
            }
          }
        }
      }
    });
  }

  //搜索
  _search(value) {
    ActivityDio.campaignListRequest(
      param: {'goodsName': value},
      onSuccess: (data) {
        setState(() {
          campaignGoodsList = data['campaignGoodsList'];
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          brightness: Brightness.light,
          title: Text(
            '门店活动',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
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
            Expanded(
              child: ScrollConfiguration(
                  behavior: NeverScrollBehavior(),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      // 卡劵  活动商品 切换
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 30,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromRGBO(233, 245, 238, 1)),
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        showIn = true;
                                        review = false;
                                        idList.clear();
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          15 -
                                          1,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            '卡劵',
                                            style: TextStyle(
                                                color: showIn
                                                    ? Color.fromRGBO(
                                                        39, 153, 93, 1)
                                                    : Color.fromRGBO(
                                                        35, 33, 33, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          showIn
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  width: 62,
                                                  height: 15,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Color.fromRGBO(
                                                          39, 153, 93, 1)),
                                                  child: Text(
                                                    '${campaignList.length}张',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  '${campaignList.length}张',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        35, 33, 33, 1),
                                                    fontSize: 11,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    )),
                                Container(
                                  width: 2,
                                  height: 41,
                                  color: Color.fromRGBO(39, 153, 93, 1),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      15 -
                                      1,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showIn = false;
                                        review = false;
                                        idList.clear();
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          '活动商品',
                                          style: TextStyle(
                                              color: showIn
                                                  ? Color.fromRGBO(
                                                      35, 33, 33, 1)
                                                  : Color.fromRGBO(
                                                      39, 153, 93, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        showIn
                                            ? Text(
                                                '${campaignGoodsList.length}件',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 33, 33, 1),
                                                  fontSize: 11,
                                                ),
                                              )
                                            : Container(
                                                alignment: Alignment.center,
                                                width: 62,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Color.fromRGBO(
                                                        39, 153, 93, 1)),
                                                child: Text(
                                                  '${campaignGoodsList.length}件',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //卡劵管理，商品管理
                      showIn
                          ? Row(
                              children: [
                                Expanded(child: SizedBox()),
                                review
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          //权限处理 详细参考 后台Excel
                                          PermissionApi.whetherContain(
                                                  'campaign_opt')
                                              ? print('')
                                              : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              StoreActivityAdd()))
                                                  .then((value) => _getData());
                                        },
                                        child: Text(
                                          '添加卡券',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                // /*  管理  暂时隐藏  */
                                // SizedBox(
                                //   width: 29,
                                // ),
                                // GestureDetector(
                                //   onTap: () {
                                //     setState(() {
                                //       //权限处理 详细参考 后台Excel
                                //       PermissionApi.whetherContain(
                                //               'campaign_opt')
                                //           ? print('')
                                //           : review
                                //               ? review = false
                                //               : review = true;
                                //     });
                                //   },
                                //   child: Text(
                                //     review ? '完成' : '管理',
                                //     style: TextStyle(
                                //         color: Colors.black,
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                SizedBox(
                                  width: 25,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromRGBO(239, 238, 238, 1)),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 33, maxWidth: 200),
                                    child: TextFormField(
                                      onFieldSubmitted: (value) {
                                        _search(value);
                                      },
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black),
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.search,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            //更���状态控制密码显示或隐藏
                                            setState(() {});
                                          },
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5.0, horizontal: 20),
                                        hintText: '  快速搜索',
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                        ),
                                        fillColor:
                                            Color.fromRGBO(238, 238, 238, 1),
                                        filled: true,
                                        border: OutlineInputBorder(
                                            //添加边框
                                            gapPadding: 10.0,
                                            borderRadius:
                                                BorderRadius.circular(17.0),
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      review ? review = false : review = true;
                                    });
                                  },
                                  child: Text(
                                    review ? '完成' : '管理',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      showIn ? cardsList() : goodsList(),
                    ],
                  )),
            ),
            // Expanded(child: SizedBox()),
            //全选 删除
            review
                ? Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Color.fromRGBO(220, 220, 220, 1),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          GestureDetector(
                            onTap: () {
                              _allin();
                              all ? all = false : all = true;
                            },
                            child: Row(
                              children: [
                                Icon(
                                  all ? Icons.check : Icons.panorama_fish_eye,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '全选',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          GestureDetector(
                              onTap: () {
                                //权限处理 详细参考 后台Excel
                                PermissionApi.whetherContain('campaign_opt')
                                    ? print('')
                                    : _deleteData();
                              },
                              child: Container(
                                width: 92,
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(255, 77, 76, 1)),
                                child: Text(
                                  '删除',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              )),
                          SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )
                : Container()
          ],
        ));
  }

  //卡劵
  cardsList() {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: campaignList.length,
          itemBuilder: (BuildContext context, int a) {
            return
                // Stack(
                //   children: [
                Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    review
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                if (idList.contains(
                                    ActivityModel.fromJson(campaignList[a])
                                        .id)) {
                                  idList.remove(
                                      ActivityModel.fromJson(campaignList[a])
                                          .id);
                                  all = false;
                                } else {
                                  idList.add(
                                      ActivityModel.fromJson(campaignList[a])
                                          .id);
                                  idList.length == campaignList.length
                                      ? all = true
                                      : all = false;
                                }
                              });
                            },
                            child: Icon(
                              idList.contains(
                                      ActivityModel.fromJson(campaignList[a])
                                          .id)
                                  ? Icons.check
                                  : Icons.panorama_fish_eye,
                              color: Colors.black,
                              size: 24,
                            ),
                          )
                        : Container(),
                    review
                        ? SizedBox(
                            width: 6,
                          )
                        : SizedBox(
                            width: 0,
                          ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (review) {
                            if (idList.contains(
                                ActivityModel.fromJson(campaignList[a]).id)) {
                              idList.remove(
                                  ActivityModel.fromJson(campaignList[a]).id);
                              all = false;
                            } else {
                              idList.add(
                                  ActivityModel.fromJson(campaignList[a]).id);
                              idList.length == campaignList.length
                                  ? all = true
                                  : all = false;
                            }
                          }
                        });
                      },
                      child: Container(
                          width: review
                              ? MediaQuery.of(context).size.width - 30 - 15
                              : MediaQuery.of(context).size.width - 30,
                          height: 110,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: campaignList[a]['status'] == 0
                                  ? Color.fromRGBO(254, 245, 240, 1)
                                  : Color.fromRGBO(138, 138, 138, 0.1)),
                          child: Row(children: [
                            //优惠卡
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 95.s,
                                      height: 15.s,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          color:
                                              Color.fromRGBO(255, 229, 230, 1)),
                                      child: Text(
                                        ActivityModel.fromJson(campaignList[a])
                                                    .type ==
                                                0
                                            ? '优惠卡'
                                            : '优惠次卡',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(255, 77, 75, 1),
                                            fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Column(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [],
                                //     ),
                                //   ],
                                // ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                // SizedBox(
                                //   height: 28.s,
                                // ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15.s,
                                    ),
                                    CommonWidget.font(
                                        text: "充¥",
                                        color: Color.fromRGBO(255, 77, 76, 1)),
                                    CommonWidget.font(
                                        text: ActivityModel.fromJson(
                                                campaignList[a])
                                            .buyPrice,
                                        color: Color.fromRGBO(255, 77, 76, 1),
                                        fontWeight: FontWeight.bold,
                                        size: 18),
                                  ],
                                ),
                                ActivityModel.fromJson(campaignList[a]).type ==
                                        0
                                    ? Row(
                                        children: [
                                          SizedBox(
                                            width: 15.s,
                                          ),
                                          CommonWidget.font(
                                              text: "赠¥",
                                              color: Color.fromRGBO(
                                                  255, 77, 76, 1)),
                                          CommonWidget.font(
                                              text: ActivityModel.fromJson(
                                                      campaignList[a])
                                                  .accountPrice,
                                              color: Color.fromRGBO(
                                                  255, 77, 76, 1)),
                                        ],
                                      )
                                    : Container(),
                                Expanded(
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 5.s,
                            ),
                            //日期
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10.s),
                                          Container(
                                            width: 170.s,
                                            child: CommonWidget.font(
                                              size: 15,
                                              number: 1,
                                              text: ActivityModel.fromJson(
                                                      campaignList[a])
                                                  .campaignName,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  255, 77, 75, 1),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    //yuan
                                  ],
                                ),
                                SizedBox(
                                  height: 20.s,
                                ),
                                Container(
                                  child: CommonWidget.font(
                                    size: 12,
                                    number: 2,
                                    text: ActivityModel.fromJson(
                                                    campaignList[a])
                                                .type ==
                                            0
                                        ? '使用期至：${ActivityModel.fromJson(campaignList[a]).endTime}'
                                        : '购买日起，使用期限：${ActivityModel.fromJson(campaignList[a]).periodUse}',
                                    color: Color.fromRGBO(255, 77, 75, 1),
                                  ),
                                ),
                                SizedBox(
                                  height: 6.s,
                                ),
                                Container(
                                  // width: MediaQuery.of(context).size.width -
                                  //     30 -
                                  //     48 -
                                  //     105 -
                                  //     15 -
                                  //     3,
                                  child: CommonWidget.font(
                                    size: 12,
                                    number: 2,
                                    text:
                                        ActivityModel.fromJson(campaignList[a])
                                            .remarks,
                                    color: Color.fromRGBO(255, 77, 75, 1),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            review
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      //权限处理 详细参考 后台Excel
                                      PermissionApi.whetherContain(
                                              'campaign_opt')
                                          ? print('')
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          StoreActivityEdite(
                                                            edit: 1,
                                                            title: ActivityModel.fromJson(
                                                                            campaignList[a])
                                                                        .type ==
                                                                    0
                                                                ? '充值优惠'
                                                                : '项目次卡',
                                                            campaignId: ActivityModel
                                                                    .fromJson(
                                                                        campaignList[
                                                                            a])
                                                                .id,
                                                          ))).then(
                                              (value) => _getData());
                                    },
                                    child: Container(
                                      width: 48,
                                      height: 22,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                          border: Border.all(
                                              color: Color.fromRGBO(
                                                  255, 77, 76, 1))),
                                      child: Text(
                                        '去修改',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(255, 77, 75, 1),
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              width: 10.s,
                            ),
                          ])),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                //   ],
                // ),
                // Padding(
                //   padding:
                //       EdgeInsets.fromLTRB(review ? 30 + 15.0 : 15.0, 0, 0, 0),
                //   child: Container(
                //     width: 95.s,
                //     height: 15.s,
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.only(
                //             topLeft: Radius.circular(10),
                //             bottomRight: Radius.circular(10)),
                //         color: Color.fromRGBO(255, 229, 230, 1)),
                //     child: Text(
                //       ActivityModel.fromJson(campaignList[a]).type == 0
                //           ? '优惠卡'
                //           : '优惠次卡',
                //       style: TextStyle(
                //           color: Color.fromRGBO(255, 77, 75, 1), fontSize: 11),
                //     ),
                //   ),
                // )
              ],
            );
          }),
    );
  }

  //商品
  goodsList() {
    return ListView(
      shrinkWrap: true,
      children: List.generate(
          campaignGoodsList.length,
          (index) => InkWell(
              onTap: () {
                setState(() {
                  if (review) {
                    if (idList.contains(
                        ActivityGoodsModel.fromJson(campaignGoodsList[index])
                            .id)) {
                      idList.remove(
                          ActivityGoodsModel.fromJson(campaignGoodsList[index])
                              .id);
                      all = false;
                    } else {
                      idList.add(
                          ActivityGoodsModel.fromJson(campaignGoodsList[index])
                              .id);
                      idList.length == campaignGoodsList.length
                          ? all = true
                          : all = false;
                    }
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SSGoodsDetailsPage(
                                shopGoodsId: ActivityGoodsModel.fromJson(
                                        campaignGoodsList[index])
                                    .shopGoodsId,
                              )),
                    );
                  }
                });
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      review
                          ? Icon(
                              idList.contains(ActivityGoodsModel.fromJson(
                                          campaignGoodsList[index])
                                      .id)
                                  ? Icons.check
                                  : Icons.panorama_fish_eye,
                              color: Colors.black,
                              size: 24,
                            )
                          : Container(),
                      review
                          ? SizedBox(
                              width: 6,
                            )
                          : SizedBox(
                              width: 0,
                            ),
                      Container(
                        height: 130,
                        width: review
                            ? MediaQuery.of(context).size.width - 30 - 15
                            : MediaQuery.of(context).size.width - 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromRGBO(255, 255, 255, 1)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  width: 90,
                                  height: 90,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      ActivityGoodsModel.fromJson(
                                              campaignGoodsList[index])
                                          .picUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 11,
                                ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Container(
                                      height: 35,
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          ActivityGoodsModel.fromJson(
                                                  campaignGoodsList[index])
                                              .goodsName,
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        ActivityGoodsModel.fromJson(
                                                campaignGoodsList[index])
                                            .applyto,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(151, 151, 151, 1),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '上架数：${ActivityGoodsModel.fromJson(campaignGoodsList[index]).quantity}',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                151, 151, 151, 1),
                                            fontSize: 13,
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        Container(
                                          width: 48,
                                          height: 22,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    63, 107, 255, 1)),
                                            borderRadius:
                                                BorderRadius.circular(11),
                                          ),
                                          child: Text(
                                            ActivityGoodsModel.fromJson(
                                                    campaignGoodsList[index])
                                                .statusName,
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  63, 107, 255, 1),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    )
                                  ],
                                )),
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: review
                                      ? MediaQuery.of(context).size.width -
                                          30 -
                                          30
                                      : MediaQuery.of(context).size.width - 30,
                                  height: 1,
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      review
                          ? SizedBox(
                              width: 0,
                            )
                          : SizedBox(
                              width: 15,
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ))),
    );
  }
}
