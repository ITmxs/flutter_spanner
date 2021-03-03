import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/base/kapp_bar.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/delivery_check/view/dc_details_page.dart';
import 'package:spanners/spannerHome/settlement/model/settlement_list_model.dart';
import 'package:spanners/spannerHome/settlement/provide/settlement_provide.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_delay_page.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_details_page.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_nonmember_page.dart';

class SettlementPage extends StatefulWidget {
  @override
  _SettlementPageState createState() => _SettlementPageState();
}

class _SettlementPageState extends State<SettlementPage>
    with SingleTickerProviderStateMixin {
  SettlementType _settlementType = SettlementType.SettlementTypeNo;

  final _subscriptions = CompositeSubscription();

  // 选项卡控制器
  TabController _tabController;

  SettlementProvide _provide;

  String _lastRequest = '7';

  @override
  void initState() {
    super.initState();
    _provide = SettlementProvide();
    _provide.selectSearchType = '';
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        switch (_tabController.index) {
          case 0:
            setState(() {});
            _settlementType = SettlementType.SettlementTypeNo;
            if (_lastRequest != '7') {
              _loadData('7');
              _lastRequest = '7';
            }
            break;
          case 1:
            setState(() {});
            _settlementType = SettlementType.SettlementTypeYes;
            if (_lastRequest != '8') {
              _loadData('8');
              _lastRequest = '8';
            }
            break;
          case 2:
            setState(() {});
            _settlementType = SettlementType.SettlementTypeDelay;
            if (_lastRequest != '9') {
              _loadData('9');
              _lastRequest = '9';
            }
            break;
        }
      });
    _loadData('7');
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.dispose();
    _tabController.dispose();
  }

  _loadData(String type) {
    var s = _provide
        .getSettlementList(type)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          Navigator.pop(context);
        },
        child: ChangeNotifierProvider.value(
          value: _provide,
          child: Scaffold(
            appBar: BaseAppBar(context, title: '结算看板'),
            body: _initViews(),
          ),
        ));
  }

  final List<Tab> tabs = <Tab>[
    Tab(
      text: '未结算',
    ),
    Tab(
      text: '已结算',
    ),
    Tab(
      text: '挂账',
    ),
  ];
  SafeArea _initViews() => SafeArea(
        child: Container(
          color: AppColors.ViewBackgroundColor,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 23, right: 23),
                            height: 50,
                            color: AppColors.ViewBackgroundColor,
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '搜索车牌号/手机号/公司名',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Image.asset(
                                      'Assets/friend/search_friend.png',
                                      width: 15,
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 39, right: 24),
                              ),
                              onTap: () {
                                switch (_settlementType) {
                                  case SettlementType.SettlementTypeNo:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SettlementDelayPage(
                                              SettlementDelaySearchType
                                                  .SettlementDelaySearchTypeNo)),
                                    );
                                    break;
                                  case SettlementType.SettlementTypeYes:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SettlementDelayPage(
                                              SettlementDelaySearchType
                                                  .SettlementDelaySearchTypeYes)),
                                    );
                                    break;
                                  case SettlementType.SettlementTypeDelay:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SettlementDelayPage(
                                              SettlementDelaySearchType
                                                  .SettlementDelaySearchTypeDelayAll)),
                                    );
                                    break;
                                }
                              },
                            ),
                          ),
                        ),
                        KSliverAppBar(
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          backgroundColor: AppColors.ViewBackgroundColor,
                          pinned: true,
                          floating: true,
                          expandedHeight: 30,
                          bottom: TabBar(
                            controller: _tabController,
                            tabs: tabs,
                            isScrollable: false,
                            indicatorColor: AppColors.primaryColor,
                            indicatorWeight: 3,
                            indicatorPadding: EdgeInsets.only(bottom: 10),
                            labelColor: Colors.black,
                            labelStyle: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w500),
                            unselectedLabelColor: Colors.black54,
                            unselectedLabelStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(controller: _tabController, children: [
                      Selector<SettlementProvide, List>(
                          builder: (_, modelList, child) {
                            return Container(
                              child: ListView.builder(
                                itemBuilder: _buildListItem,
                                itemCount: modelList.length,
                              ),
                            );
                          },
                          selector: (_, provide) =>
                              _provide.notSettlementModelList),
                      Selector<SettlementProvide, List>(
                          builder: (_, modelList, child) {
                            return Container(
                              child: ListView.builder(
                                itemBuilder: _overBuildListItem,
                                itemCount: modelList.length,
                              ),
                            );
                          },
                          selector: (_, provide) =>
                              _provide.yesSettlementModelList),
                      selectWidget(),
                    ]),
                  ),
                ),
              ),
              _settlementType == SettlementType.SettlementTypeDelay
                  ? Container(
                      padding: EdgeInsets.only(left: 34, right: 30),
                      height: 50,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettlementDelayPage(
                                        SettlementDelaySearchType
                                            .SettlementDelaySearchTypeDelay)),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                '统一进入结算页面',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );

  selectWidget() {
    return Selector<SettlementProvide, List>(
        builder: (_, modelList, child) {
          return Container(
            child: ListView.builder(
              itemBuilder: _selectBuildListItem,
              itemCount: modelList.length,
            ),
          );
        },
        selector: (_, provide) => _provide.delaySettlementModelList);
  }

  Widget _buildListItem(BuildContext context, int index) => Container(
        margin: EdgeInsets.only(left: 17, right: 15, bottom: 21),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 3.0),
                blurRadius: 3.0,
                spreadRadius: 1.0)
          ],
        ),
        child: Column(
          children: _itemCell(index, SettlementType.SettlementTypeNo),
        ),
      );

  Widget _overBuildListItem(BuildContext context, int index) => Container(
        margin: EdgeInsets.only(left: 17, right: 15, bottom: 21),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 3.0),
                blurRadius: 3.0,
                spreadRadius: 1.0)
          ],
        ),
        child: Column(
          children: _itemCell(index, SettlementType.SettlementTypeYes),
        ),
      );

  Widget _selectBuildListItem(BuildContext context, int index) => Container(
        margin: EdgeInsets.only(left: 17, right: 15, bottom: 21),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 3.0),
                blurRadius: 3.0,
                spreadRadius: 1.0)
          ],
        ),
        child: Column(
          children: _itemCell(index, SettlementType.SettlementTypeDelay),
        ),
      );

  List<Widget> _itemCell(int index, SettlementType settlementType) {
    List<Widget> widgetList = [];
    SettlementListModel model = SettlementListModel();

    if (settlementType == SettlementType.SettlementTypeNo) {
      model = _provide.notSettlementModelList[index];
    } else if (settlementType == SettlementType.SettlementTypeYes) {
      model = _provide.yesSettlementModelList[index];
    } else {
      model = _provide.delaySettlementModelList[index];
    }

    ///顶部车牌号
    widgetList.add(Container(
      height: 45,
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
              child: Row(
                children: [
                  Container(
                    color: AppColors.primaryColor,
                    width: 3,
                    height: 14,
                    margin: EdgeInsets.only(right: 5),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    model.vehicleLicence,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.ViewBackgroundColor,
            height: 1,
          ),
        ],
      ),
    ));

    List contentList = [
      model.consumeAmount,
      model.prepaymentAmount,
      model.balancePaymentAmount,
      (double.parse(model.finalPayment) + double.parse(model.prepaymentAmount)).toString(),
      model.orderSn,
      model.createDate
    ];
    for (int i = 0; i < _provide.itemInfoTitle.length; i++) {
      String title = _provide.itemInfoTitle[i];

      widgetList.add(Container(
        height: 45,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 21),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 21),
                    child: Text(contentList[i], style: TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),
            Container(
              color: AppColors.ViewBackgroundColor,
              height: 1,
            ),
          ],
        ),
      ));
    }

    ///底部按钮
    widgetList.add(Container(
      height: 74,
      child: settlementType == SettlementType.SettlementTypeYes
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _pushDetails(model, settlementType);
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
                      '详情',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    //权限处理 详细参考 后台Excel
                    if (!PermissionApi.whetherContain('check_opt_customer')) {
                      if (model.memberFlag == '0') {
                        final value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettlementNonmemberPage(
                                  model.workOrderId,
                                  model.vehicleLicence,
                                  _settlementType ==
                                      SettlementType.SettlementTypeDelay)),
                        );
                        if (value) {
                          _loadData('7');
                        }
                      } else {

                        final value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettlementDetailsPage(
                                    model.workOrderId,
                                    model.vehicleLicence,
                                    _settlementType ==
                                        SettlementType.SettlementTypeDelay,
                                  )),
                        );
                        if (value) {
                          _loadData('7');
                        }
                      }
                    }
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
                      '客户结算',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _pushDetails(model, settlementType);
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
                      '详情',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    ));
    return widgetList;
  }

  _pushDetails(SettlementListModel model, SettlementType settlementType) async {
    if (settlementType == SettlementType.SettlementTypeNo) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DCDetailsPage(
                  workOrderId: model.workOrderId,
                  detailsType: DetailsType.DetailsTypeNoSettlement,
                )),
      );
    }
    if (settlementType == SettlementType.SettlementTypeYes) {
      final value = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DCDetailsPage(
                  workOrderId: model.workOrderId,
                  detailsType: DetailsType.DetailsTypeYesSettlement,
                  showShareRed: model.popShow,
                )),
      );
      if (value) {
        _loadData('8');
        _lastRequest = '8';
      }
    }
    if (settlementType == SettlementType.SettlementTypeDelay) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DCDetailsPage(
                  workOrderId: model.workOrderId,
                  detailsType: DetailsType.DetailsTypeDelaySettlement,
                )),
      );
    }
  }
}

enum SettlementType {
  /// 未结算
  SettlementTypeNo,

  /// 已结算
  SettlementTypeYes,

  /// 挂账
  SettlementTypeDelay,
}
