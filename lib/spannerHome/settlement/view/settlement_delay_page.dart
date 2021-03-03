import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/delivery_check/view/dc_details_page.dart';
import 'package:spanners/spannerHome/settlement/model/settlement_list_model.dart';
import 'package:spanners/spannerHome/settlement/provide/settlement_provide.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_all_page.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_details_page.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_nonmember_page.dart';

class SettlementDelayPage extends StatefulWidget {
  final SettlementDelaySearchType settlementDelaySearchType;

  const SettlementDelayPage(this.settlementDelaySearchType, {Key key})
      : super(key: key);

  @override
  _SettlementDelayPage createState() => _SettlementDelayPage();
}

class _SettlementDelayPage extends State<SettlementDelayPage>
    with SingleTickerProviderStateMixin {
  final _subscriptions = CompositeSubscription();

  SettlementProvide _provide;

  List _selectList = [];

  bool _allSelect = false;

  TextEditingController _textEditingController;

  FocusNode _focusNode;

  bool _showKeyboard;

  @override
  void initState() {
    super.initState();

    _provide = SettlementProvide();
    _textEditingController = TextEditingController();
    _showKeyboard = true;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        print(
            '_focusNode.hasFocus_focusNode.hasFocus_focusNode.hasFocus_focusNode.hasFocus');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.dispose();
    _focusNode.dispose();
  }

  _loadData(String type, {String searchKey, String isAccurate}) {
    var s = _provide
        .getSettlementList(type, searchKey: searchKey, isAccurate: isAccurate)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    if (_showKeyboard) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '搜索'),
        body: _initViews(),
      ),
    );
  }

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
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 70,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Text(
                                          _provide.judgeText() + '    ',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            items: [
                                              DropdownMenuItem(
                                                  value: '0',
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '车牌号',
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 1,
                                                        color: AppColors
                                                            .ViewBackgroundColor,
                                                      )
                                                    ],
                                                  )),
                                              DropdownMenuItem(
                                                  value: '1',
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '手机号',
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 1,
                                                        color: AppColors
                                                            .ViewBackgroundColor,
                                                      )
                                                    ],
                                                  )),
                                              DropdownMenuItem(
                                                  value: '2',
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '公司名',
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 1,
                                                        color: AppColors
                                                            .ViewBackgroundColor,
                                                      )
                                                    ],
                                                  )),
                                            ],
                                            onChanged: (value) {
                                              print('onChanged:' + value);
                                              _provide.selectSearchType = value;
                                            },
                                            onTap: () {
                                              _focusNode.unfocus();
                                              _showKeyboard = false;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    color: Colors.black38,
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                  ),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width -
                                        23 * 2 -
                                        39 -
                                        24 -
                                        70,
                                    child: TextField(
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      onSubmitted: _searchMessage,
                                      controller: _textEditingController,
                                      focusNode: _focusNode,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.TextColor,
                                          backgroundColor: Colors.white),
                                      textAlign: TextAlign.left,
                                      onChanged: (value) {
                                        print(value);
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        hintText: '搜索' + _provide.judgeText(),
                                        hintStyle: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.TextColor),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Image.asset(
                                      'Assets/friend/search_friend.png',
                                      width: 15,
                                    ),
                                    onTap: () {
                                      _focusNode.unfocus();
                                      _searchMessage(
                                          _textEditingController.text);
                                    },
                                  )
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 5, right: 24),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: _itemWidgetType(),
                  ),
                ),
              ),
              widget.settlementDelaySearchType ==
                      SettlementDelaySearchType.SettlementDelaySearchTypeDelay
                  ? Container(
                      padding: EdgeInsets.only(left: 34, right: 30),
                      height: 50,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _allSelect = !_allSelect;
                                    if (_allSelect) {
                                      List selectList = [];
                                      _selectList.forEach((element) {
                                        selectList.add(true);
                                      });
                                      _selectList = selectList;
                                    } else {
                                      List selectList = [];
                                      _selectList.forEach((element) {
                                        selectList.add(false);
                                      });
                                      _selectList = selectList;
                                    }
                                  });
                                },
                                child: Image.asset(
                                  _allSelect
                                      ? 'Assets/settlement/select_btn_yes.png'
                                      : 'Assets/settlement/select_btn_no.png',
                                  width: 15,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '全选',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              List orderIdList = List();
                              _provide.delaySettlementModelList
                                  .forEach((element) {
                                SettlementListModel model = element;
                                orderIdList.add(model.workOrderId);
                              });
                              if (orderIdList.length > 0) {
                                final reloadList = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SettlementAllPage(
                                              orderIdList: orderIdList,
                                            )));
                                if (reloadList) {
                                  _searchMessage(_textEditingController.text);
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
                                '统一结算',
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

  _itemWidgetType() {
    switch (widget.settlementDelaySearchType) {
      case SettlementDelaySearchType.SettlementDelaySearchTypeNo:
        return Selector<SettlementProvide, List>(
            builder: (_, modelList, child) {
              return Container(
                child: ListView.builder(
                  itemBuilder: _buildListItem,
                  itemCount: modelList.length,
                ),
              );
            },
            selector: (_, provide) => _provide.notSettlementModelList);
        break;
      case SettlementDelaySearchType.SettlementDelaySearchTypeYes:
        return Selector<SettlementProvide, List>(
            builder: (_, modelList, child) {
              return Container(
                child: ListView.builder(
                  itemBuilder: _overBuildListItem,
                  itemCount: modelList.length,
                ),
              );
            },
            selector: (_, provide) => _provide.yesSettlementModelList);
        break;
      case SettlementDelaySearchType.SettlementDelaySearchTypeDelayAll:
        return Selector<SettlementProvide, List>(
            builder: (_, modelList, child) {
              return Container(
                child: ListView.builder(
                  itemBuilder: _buildListItem,
                  itemCount: modelList.length,
                ),
              );
            },
            selector: (_, provide) => _provide.delaySettlementModelList);
        break;
      case SettlementDelaySearchType.SettlementDelaySearchTypeDelay:
        return selectWidget();
        break;
    }
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
          children: _itemCell(index),
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
          children: _itemCell(index),
        ),
      );

  selectWidget() {
    for (int i = 0; i < 3; i++) {
      _selectList.add(false);
    }
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
          children: _selectItemCell(index),
        ),
      );

  List<Widget> _itemCell(int index) {
    List<Widget> widgetList = [];
    SettlementListModel model = SettlementListModel();
    if (widget.settlementDelaySearchType ==
        SettlementDelaySearchType.SettlementDelaySearchTypeNo) {
      model = _provide.notSettlementModelList[index];
    } else if (widget.settlementDelaySearchType ==
        SettlementDelaySearchType.SettlementDelaySearchTypeYes) {
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
      model.finalPayment,
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
      child: widget.settlementDelaySearchType ==
              SettlementDelaySearchType.SettlementDelaySearchTypeYes
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _pushDetails(model.workOrderId);
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
                    if (model.memberFlag == '0') {
                      final value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettlementNonmemberPage(
                                model.workOrderId,
                                model.vehicleLicence,
                                widget.settlementDelaySearchType ==
                                        SettlementDelaySearchType
                                            .SettlementDelaySearchTypeDelayAll ||
                                    widget.settlementDelaySearchType ==
                                        SettlementDelaySearchType
                                            .SettlementDelaySearchTypeDelay)),
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
                                widget.settlementDelaySearchType ==
                                        SettlementDelaySearchType
                                            .SettlementDelaySearchTypeDelayAll ||
                                    widget.settlementDelaySearchType ==
                                        SettlementDelaySearchType
                                            .SettlementDelaySearchTypeDelay)),
                      );
                      if (value) {
                        _loadData('7');
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
                    _pushDetails(model.workOrderId);
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

  List<Widget> _selectItemCell(int index) {
    List<Widget> widgetList = [];
    SettlementListModel model = SettlementListModel();
    if (widget.settlementDelaySearchType ==
        SettlementDelaySearchType.SettlementDelaySearchTypeNo) {
      model = _provide.notSettlementModelList[index];
      print('SettlementDelaySearchType.SettlementDelaySearchTypeNo');
    } else if (widget.settlementDelaySearchType ==
        SettlementDelaySearchType.SettlementDelaySearchTypeYes) {
      model = _provide.yesSettlementModelList[index];
      print('SettlementDelaySearchType.yesSettlementModelList');
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectList[index] = !_selectList[index];
                      });
                    },
                    child: Image.asset(
                      _selectList[index]
                          ? 'Assets/settlement/select_btn_yes.png'
                          : 'Assets/settlement/select_btn_no.png',
                      width: 15,
                    ),
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
      model.finalPayment,
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
    if (widget.settlementDelaySearchType ==
        SettlementDelaySearchType.SettlementDelaySearchTypeDelay) {}

    ///底部按钮
    widgetList.add(Container(
      height: 74,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              // //权限处理 详细参考 后台Excel
              // PermissionApi.whetherContain('check_opt_customer')
              //     ? print('')
              //     :
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettlementDetailsPage(
                        model.workOrderId, model.vehicleLicence, true)),
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
                '客户结算',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _pushDetails(model.workOrderId);
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

  _searchMessage(String message) {
    if (message == null || message.length <= 0) {
      print('不能为空');
      return;
    }
    String type;
    String isAccurate;
    switch (widget.settlementDelaySearchType) {
      case SettlementDelaySearchType.SettlementDelaySearchTypeNo:
        type = '7';
        break;
      case SettlementDelaySearchType.SettlementDelaySearchTypeYes:
        type = '8';
        break;
      case SettlementDelaySearchType.SettlementDelaySearchTypeDelayAll:
        type = '9';
        isAccurate = '0';
        break;
      case SettlementDelaySearchType.SettlementDelaySearchTypeDelay:
        type = '9';
        isAccurate = '1';
        break;
    }
    _loadData(type, searchKey: message, isAccurate: isAccurate);
    _showKeyboard = false;
  }

  _pushDetails(String workOrderId) {
    if (widget.settlementDelaySearchType ==
        SettlementDelaySearchType.SettlementDelaySearchTypeNo) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DCDetailsPage(
                  workOrderId: workOrderId,
                  detailsType: DetailsType.DetailsTypeNoSettlement,
                )),
      );
    }
    if (widget.settlementDelaySearchType ==
        SettlementDelaySearchType.SettlementDelaySearchTypeYes) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DCDetailsPage(
                  workOrderId: workOrderId,
                  detailsType: DetailsType.DetailsTypeYesSettlement,
                )),
      );
    }
    if (widget.settlementDelaySearchType ==
        SettlementDelaySearchType.SettlementDelaySearchTypeDelay) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DCDetailsPage(
                  workOrderId: workOrderId,
                  detailsType: DetailsType.DetailsTypeDelaySettlement,
                )),
      );
    }
  }
}

enum SettlementDelaySearchType {
  /// 未结算
  SettlementDelaySearchTypeNo,

  /// 已结算
  SettlementDelaySearchTypeYes,

  /// 挂账全部
  SettlementDelaySearchTypeDelayAll,

  /// 挂账
  SettlementDelaySearchTypeDelay,
}
