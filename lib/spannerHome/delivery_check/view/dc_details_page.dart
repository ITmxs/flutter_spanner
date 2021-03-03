import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/preview_images_page.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/share_red/view/share_red_page.dart';
import 'package:spanners/spannerHome/delivery_check/provide/dc_details_provide.dart';

class DCDetailsPage extends StatefulWidget {
  final String workOrderId;
  final DetailsType detailsType;
  final String showShareRed;
  final String showShareButton;

  const DCDetailsPage(
      {Key key,
      this.workOrderId,
      this.detailsType,
      this.showShareRed,
      this.showShareButton})
      : super(key: key);

  @override
  _DCDetailsPageState createState() => _DCDetailsPageState();
}

class _DCDetailsPageState extends State<DCDetailsPage> {
  DCDetailsProvide _provide;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();

    _provide = DCDetailsProvide();
    _provide.showShareRed = widget.showShareRed == '0';
    _loadData();
    _loadCampaignInfo();

  }

  _loadData() {
    var s = _provide
        .getDeliveryDetails(widget.workOrderId)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  _loadCampaignInfo(){
    var s = _provide
        .getCampaignInfo(widget.workOrderId)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
          setState(() {
          });
    }, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar:  AppBar(
          title: Text(
            _getTitleString(),
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
          ),
          backgroundColor: AppColors.AppBarColor,
          elevation: 0,
          leading: FlatButton(
            child: Image(
              image: AssetImage('Assets/appbar/back.png'),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ),
        body: _initViews(),
      ),
    );
  }

  _getTitleString() {
    switch (widget.detailsType) {
      case DetailsType.DetailsTypeDelivery:
        return '交验详情';
        break;
      case DetailsType.DetailsTypeNoSettlement:
        return '结算详情';
        break;
      case DetailsType.DetailsTypeYesSettlement:
        return '结算详情';
        break;
      case DetailsType.DetailsTypeDelaySettlement:
        return '结算详情';
        break;
    }
  }

  _initViews() => Consumer<DCDetailsProvide>(
        builder: (_, provide, child) {
          return Stack(
            children: [
              Container(
                color: AppColors.ViewBackgroundColor,
                child: Container(
                  color: AppColors.ViewBackgroundColor,
                  padding: EdgeInsets.only(left: 17, right: 15),
                  child: CustomScrollView(
                    slivers: _sliverWidget(),
                  ),
                ),
              ),
              _provide.showShareRed
                  ? Container(
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: EdgeInsets.only(left: 45, right: 45),
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '此订单还有未分红的服务/配件 请及时处理',
                                style: TextStyle(fontSize: 13),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _provide.showShareRed =
                                          !_provide.showShareRed;
                                      PermissionApi.whetherContain(
                                          'check_opt_bonus')
                                          ? print('')
                                          :Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShareRedPage(
                                                  workOrderId:
                                                      widget.workOrderId,
                                                )),
                                      );
                                    },
                                    child: Container(
                                      width: 92,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        '填写分红',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _provide.showShareRed =
                                          !_provide.showShareRed;
                                    },
                                    child: Container(
                                      width: 92,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        '稍后处理',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        },
      );

  List<Widget> _sliverWidget() {
    List<Widget> widgetList = [
      SliverToBoxAdapter(
        child: SizedBox(
          height: 25,
        ),
      ),

      ///用户信息
      SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              color: AppColors.primaryColor,
              width: 3,
              height: 14,
              margin: EdgeInsets.only(right: 5),
            ),
            Text(
              '用户信息',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.only(
          top: 10,
        ),
        sliver: SliverFixedExtentList(
          itemExtent: 50,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 21,
                          right: 21,
                        ),
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: SliverFixedExtentListItem(
                            _provide.userInfoTitle[index],
                            _provide.userInfoContent.length > 0
                                ? _provide.userInfoContent[index]
                                : ''),
                      ),
                    ),
                    Container(
                      color: AppColors.ViewBackgroundColor,
                      height: 1,
                    ),
                  ],
                ),
              );
            },
            childCount: _provide.userInfoTitle.length, //50个列表项
          ),
        ),
      ),
    ];
    if (_provide.showAllInfo) {
      widgetList.addAll(_allInfo());
    }

    widgetList.addAll([
      ///隐藏按钮
      SliverToBoxAdapter(
        child: GestureDetector(
          onTap: () {
            _provide.showAllInfo = !_provide.showAllInfo;
          },
          child: Column(
            children: [
              Text(
                _provide.showAllInfo ? '隐藏更多信息' : '显示更多信息',
                style: TextStyle(color: Colors.black26),
              ),
              Text(
                _provide.showAllInfo ? '^' : '>',
                style: TextStyle(color: Colors.black26),
              )
            ],
          ),
        ),
      ),

      ///服务清单
      SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              color: AppColors.primaryColor,
              width: 3,
              height: 14,
              margin: EdgeInsets.only(right: 5),
            ),
            Text(
              '服务清单',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    ]);

    ///优惠卡
    if(_provide.memberFlag) {
      if (widget.detailsType == DetailsType.DetailsTypeYesSettlement ||
          widget.detailsType == DetailsType.DetailsTypeDelaySettlement) {
        widgetList.add(
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.only(left: 12, right: 26),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  ///优惠卡顶部
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('Assets/details_card.png'),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '优惠卡',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Text(
                          '— ¥' + _provide.campaignString,
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: AppColors.ViewBackgroundColor,
                  ),
                ],
              ),
            ),
          ),
        );

        _provide.campaignInfoList.forEach((element) {
          Map dataMap = element;
          widgetList.add(
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(left: 12, right: 26),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dataMap['campaignName'],
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            '抵扣 1 次',
                            style: TextStyle(fontSize: 15, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });


      }
    }




    for (int i = 0; i < _provide.serviceList.length; i++) {
      widgetList.add(SliverPadding(
        padding: EdgeInsets.only(top: 10),
        sliver: SliverFixedExtentList(
          itemExtent: 50,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: Row(children: _itemWidget(i, index)),
                      ),
                    ),
                    Container(
                      color: AppColors.ViewBackgroundColor,
                      height: 1,
                    ),
                  ],
                ),
              );
            },
            childCount: _provide.serviceList[i].length + 1,
          ),
        ),
      ));
    }
    widgetList.add(SliverPadding(
      padding: EdgeInsets.only(top: 21, bottom: 80),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 19, top: 12, right: 26, bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _moneyInfo(),
          ),
        ),
      ),
    ));
    if(widget.showShareButton == "0")widgetList.add(SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                PermissionApi.whetherContain(
                    'check_opt_bonus')
                    ? print('')
                    :Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShareRedPage(
                            workOrderId: widget.workOrderId,
                          )),
                );
              },
              child: Container(
                width: 92,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '填写分红',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
    return widgetList;
  }

  List<Widget> _allInfo() {
    List<Widget> widgetList = [
      ///用户信息2
      SliverPadding(
        padding: EdgeInsets.only(top: 15, bottom: 10),
        sliver: SliverFixedExtentList(
          itemExtent: 50,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 21,
                          right: 21,
                        ),
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: SliverFixedExtentListItem(
                            _provide.otherUserInfoTitle[index],
                            _provide.otherUserInfoContent.length > 0
                                ? _provide.otherUserInfoContent[index]
                                : ''),
                      ),
                    ),
                    Container(
                      color: AppColors.ViewBackgroundColor,
                      height: 1,
                    ),
                  ],
                ),
              );
            },
            childCount: _provide.otherUserInfoTitle.length, //50个列表项
          ),
        ),
      ),

      ///备注
      SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              color: Colors.transparent,
              width: 3,
              height: 14,
              margin: EdgeInsets.only(right: 5),
            ),
            Text(
              '备注',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 7, bottom: 22),
          padding: EdgeInsets.all(7.5),
          child: Text(_provide.remark),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),

      ///添加照片
      SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              color: Colors.transparent,
              width: 3,
              height: 14,
              margin: EdgeInsets.only(right: 5),
            ),
            Text(
              '添加照片',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 6, bottom: 26),
          child: Wrap(
            spacing: 9, //主轴上子控件的间距
            runSpacing: 10, //交叉轴上子控件之间的间距
            children: _imageItemWidget(), //要显示的子控件集合
          ),
        ),
      ),
    ];
    return widgetList;
  }

  List<Widget> _imageItemWidget() {
    List<Widget> widgetList = [];
    for (int i = 0; i < _provide.carImages.length; i++) {
      widgetList.add(GestureDetector(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (c, a, s) => PreviewImagesWidget(
                    _provide.carImages,
                    initialPage: i,
                  )));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: (MediaQuery.of(context).size.width - 17 - 15 - 10 * 2) / 3.0,
            height:
                (MediaQuery.of(context).size.width - 17 - 15 - 10 * 2) / 3.0,
            child: networkImage(context, _provide.carImages[i]),
          ),
        ),
      ));
    }
    return widgetList;
  }

  List<Widget> _itemWidget(int page, int index) {
    List textList = _provide.serviceTitle;
    String showText = '';
    if (index != 0) {
      textList = _provide.serviceList[page][index - 1];
      if (textList.length > 5) {
        showText = textList.first + ' ' + textList.last;
      } else {
        showText = textList.first;
      }
    }

    List<Widget> widgetList = [];
    for (int i = 0; i < _provide.serviceTitle.length; i++) {
      widgetList.add(
        Container(
          height: 50,
          color: index==1?AppColors.backgroundColor:Colors.white,
          width: (MediaQuery.of(context).size.width - 17 - 15) /
              _provide.serviceTitle.length,
          child: Center(
            child: PopupMenuButton(
              child: Text(
                textList[i],
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              elevation: 5.0,
              color: AppColors.primaryColor,
              padding: EdgeInsets.only(left: 10, right: 10),
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    child: Text(
                      i == 0 ? showText : textList[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    value: "hot",
                  ),
                ];
              },
              onSelected: (String action) {},
              onCanceled: () {},
            ),
          ),
        ),
      );
    }
    return widgetList;
  }

  List<Widget> _moneyInfo() {
    List<Widget> widgetList = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '消费金额',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            '¥' + _provide.consumeAmount,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      SizedBox(
        height: 23,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '预付金额',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            '¥' + _provide.prepaymentAmount,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      SizedBox(
        height: 23,
      ),
    ];
    if (widget.detailsType == DetailsType.DetailsTypeYesSettlement ||
        widget.detailsType == DetailsType.DetailsTypeDelaySettlement) {
      widgetList.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '尾款金额',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            '¥' +
                _provide.finalPayment,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ));
    }
    if (widget.detailsType == DetailsType.DetailsTypeDelaySettlement) {
      widgetList.addAll([
        SizedBox(
          height: 30,
        ),
        Container(
          color: AppColors.ViewBackgroundColor,
          height: 1,
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '已优惠',
              style: TextStyle(fontSize: 13),
            ),
            Text(
              '¥200',
              style: TextStyle(fontSize: 13, color: Colors.red),
            ),
            Text(
              '合计',
              style: TextStyle(fontSize: 13),
            ),
            Text(
              '¥1000',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red),
            ),
          ],
        )
      ]);
    }
    return widgetList;
  }
}

enum DetailsType {
  /// 交验
  DetailsTypeDelivery,

  /// 未结算
  DetailsTypeNoSettlement,

  /// 已结算
  DetailsTypeYesSettlement,

  /// 挂账
  DetailsTypeDelaySettlement,
}
