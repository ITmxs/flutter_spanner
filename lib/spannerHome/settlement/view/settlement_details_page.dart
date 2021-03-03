import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/publicView/pub_CostPriceView.dart';
import 'package:spanners/publicView/pub_MaintenanceCreat.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/newOrder/newOrder.dart';
import 'package:spanners/spannerHome/settlement/model/preferential_card_model.dart';
import 'package:spanners/spannerHome/settlement/provide/settlement_details_provide.dart';
import 'package:spanners/spannerHome/settlement/view/preferential_card_page.dart';
import 'dart:convert' as convert;

class SettlementDetailsPage extends StatefulWidget {
  final String orderId;
  final String vehicleLicence;
  final bool showDelay;

  const SettlementDetailsPage(this.orderId, this.vehicleLicence, this.showDelay,
      {Key key})
      : super(key: key);
  @override
  _SettlementDetailsPageState createState() => _SettlementDetailsPageState();
}

class _SettlementDetailsPageState extends State<SettlementDetailsPage> {
  SettlementDetailsProvide _provide;
  final _subscriptions = CompositeSubscription();
  TextEditingController _textEditingController;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _provide = SettlementDetailsProvide();
    _textEditingController = TextEditingController();
    _loadData();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        print('弹出键盘');
      }
    });
  }

  //页面销毁
  @override
  void dispose() {
    super.dispose();
    //释放
    _focusNode.dispose();
  }

  _loadData() {
    var s = _provide
        .getSettlementDetailsService(widget.orderId)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);

    var s2 = _provide
        .getUserCardInfo(widget.vehicleLicence)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s2);
    _loadPrice();
  }

  ///计算价格
  _loadPrice() {
    List cardIdList = [];
    _provide.cardSelectList.forEach((element) {
      PreferentialCardModel model = element;
      cardIdList.add(model.campaignServiceId);
    });
    var s = _provide
        .postAllPrice(widget.orderId, campaignServiceId: cardIdList)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '结算看板'),
        body: _initViews(),
      ),
    );
  }

  _initViews() => Consumer<SettlementDetailsProvide>(
        builder: (_, provide, child) {
          return Container(
            color: AppColors.ViewBackgroundColor,
            child: Container(
              color: AppColors.ViewBackgroundColor,
              padding: EdgeInsets.only(left: 15, right: 15, top: 6),
              child: CustomScrollView(
                slivers: _sliverWidget(),
              ),
            ),
          );
        },
      );

  List<Widget> _sliverWidget() {
    List<Widget> widgetList = [
      ///vip卡
      SliverToBoxAdapter(
        child: _initVipCard(),
      ),
    ];

    if (_provide.showCardDetails) {
      widgetList.add(SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Image.asset(
                'Assets/settlement/person_card_bottom.png',
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width - 30,
              ),
              Container(
                padding:
                    EdgeInsets.only(right: 22, left: 22, top: 17, bottom: 5),
                child: Column(
                  children: _initVipCardSetMeal(),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    widgetList.add(
      ///服务清单
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 26),
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
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );

    for (int i = 0; i < _provide.serviceList.length; i++) {
      widgetList.add(
        SliverPadding(
          padding: EdgeInsets.only(top: 10),
          sliver: SliverFixedExtentList(
            itemExtent: 50,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue),
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
        ),
      );
    }

    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewOrder(
                                type: 'NO',
                                workOrderId: widget.orderId,
                              )));
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primaryColor,
                  ),
                  child: Text(
                    '新增',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  PermissionApi.whetherContain(
                      'check_opt_maintenance_manual')
                      ? print('')
                      :Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MaintenanceCareat(
                                workOrderId: widget.orderId,
                              )));
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primaryColor,
                  ),
                  child: Text(
                    '创建保养手册',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  //权限处理 详细参考 后台Excel
                  PermissionApi.whetherContain('check_opt_price')
                      ? print('')
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CostPriceView(
                                    workOrderId: widget.orderId,
                                  )));
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primaryColor,
                  ),
                  child: Text(
                    '查看成本',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    ///优惠卡
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
            children: _selectCard(),
          ),
        ),
      ),
    );

    widgetList.add(SliverPadding(
      padding: EdgeInsets.only(top: 21, bottom: 21),
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

    ///支付方式
    widgetList.add(
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
              '支付方式',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );

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
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '线下支付',
                      style: TextStyle(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        _provide.payType = !_provide.payType;
                      },
                      child: Image.asset(
                        _provide.payType
                            ? 'Assets/settlement/select_btn_no.png'
                            : 'Assets/settlement/select_btn_yes.png',
                        width: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppColors.ViewBackgroundColor,
              ),
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '余额支付',
                      style: TextStyle(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        _provide.payType = !_provide.payType;
                      },
                      child: Image.asset(
                        _provide.payType
                            ? 'Assets/settlement/select_btn_yes.png'
                            : 'Assets/settlement/select_btn_no.png',
                        width: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.showDelay) {
      widgetList.add(
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 72, bottom: 98),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    PermissionApi.whetherContain(
                        'check_opt_customer')
                        ? print('')
                        :_payment(true);
                  },
                  child: Container(
                    width: 75,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      '结算',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      widgetList.add(
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 72, bottom: 98),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    PermissionApi.whetherContain(
                        'check_opt_customer')
                        ? print('')
                        :_payment(false);
                  },
                  child: Container(
                    width: 75,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      '挂账',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _submittedMessage(_textEditingController.text);
                    PermissionApi.whetherContain(
                        'check_opt_customer')
                        ? print('')
                        :_payment(true);
                  },
                  child: Container(
                    width: 75,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      '结算',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
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
          width: (MediaQuery.of(context).size.width - 17 - 13) /
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

  _initVipCard() {
    double setWidth = MediaQuery.of(context).size.width - 30;
    double setHeight = 180.0;
    return Container(
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            width: setWidth,
            height: setHeight,
            child: Stack(
              children: [
                Image.asset(
                  _provide.showCardDetails
                      ? 'Assets/settlement/person_card_show.png'
                      : 'Assets/settlement/person_card.png',
                  width: setWidth,
                  height: setHeight,
                  fit: BoxFit.fill,
                ),
                Container(
                  padding: EdgeInsets.only(left: 27, top: 20, right: 23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'VIP',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          GestureDetector(
                            onTap: () {
                              print('客户详情客户详情客户详情客户详情客户详情客户详情客户详情客户详情客户详情客户详情');
                            },
                            child: Image.asset(
                                'Assets/settlement/card_userDetails.png'),
                          )
                        ],
                      ),
                      Text(
                        widget.vehicleLicence,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        _provide.userInfoModel.realName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _provide.userInfoModel.brand +
                                '(' +
                                _provide.userInfoModel.model +
                                ')',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '余额 / ¥' + _provide.userInfoModel.accountBalances,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _provide.showCardDetails
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _provide.showCardDetails =
                                        !_provide.showCardDetails;
                                  },
                                  child: Image.asset(
                                    'Assets/settlement/card_show.png',
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _initVipCardSetMeal() {
    List<Widget> itemList = [];
    _provide.setMealList.forEach((element) {
      itemList.add(Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              element[0],
              style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              '剩余${element[1]}次',
              style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ));
      itemList.add(
        SizedBox(
          height: 5,
        ),
      );
    });
    itemList.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _provide.showCardDetails = !_provide.showCardDetails;
          },
          child: Image.asset(
            'Assets/settlement/card_hide.png',
          ),
        ),
      ],
    ));
    return itemList;
  }

  List<Widget> _selectCard() {
    List<Widget> widgetList = [
      ///优惠卡顶部
      GestureDetector(
        onTap: () async {
          final cardServiceList = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreferentialCardPage(
                    widget.orderId, _provide.cardSelectList)),
          );
          _provide.cardSelectList = cardServiceList;
          _loadPrice();
        },
        child: Container(
          color: Colors.white,
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
              Row(
                children: [
                  Text(
                    _provide.cardSelectList.length > 0
                        ? '— ¥' + _provide.disCountAmount.toString()
                        : _provide.couponCount.toString() + ' 张可用',
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '>',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];

    _provide.cardSelectList.forEach((element) {
      PreferentialCardModel model = element;
      widgetList.add(
        Container(
          height: 1,
          color: AppColors.ViewBackgroundColor,
        ),
      );
      widgetList.add(
        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.campaignName,
                style: TextStyle(fontSize: 15),
              ),
              Text(
                '抵扣 1 次',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            ],
          ),
        ),
      );
    });
    return widgetList;
  }

  List<Widget> _moneyInfo() {
    _textEditingController.text = _provide.repairAmount.toString();
    List<Widget> widgetList = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '消费金额',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            '¥' + _provide.consumeAmount.toString(),
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
            '¥' + _provide.prepaymentAmount.toString(),
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
            '尾款金额',
            style: TextStyle(fontSize: 15),
          ),
          Container(
            height: 30,
            width: 100,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              onChanged: (String text) {},
              inputFormatters: [
                //只允许输入小数
                WhitelistingTextInputFormatter(RegExp("[0-9.]")),
              ],
              onSubmitted: _submittedMessage,
              focusNode: _focusNode,
              controller: _textEditingController,
              style: TextStyle(fontSize: 13, color: AppColors.primaryColor),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: '¥',
                hintStyle:
                    TextStyle(fontSize: 13, color: AppColors.primaryColor),
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    ];

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
            '¥' + _provide.realDiscountAmount.toString(),
            style: TextStyle(fontSize: 13, color: Colors.red),
          ),
          Text(
            '实收',
            style: TextStyle(fontSize: 13),
          ),
          Text(
            '¥' + _provide.allAmount.toString(),
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red),
          ),
        ],
      )
    ]);
    return widgetList;
  }

  _submittedMessage(String messageStr) {
    double inputAmount = double.parse(messageStr);
    print(inputAmount.toString());
    print(_provide.consumeAmount.toString());
    if (inputAmount <= _provide.fixedRepairAmount) {
      _provide.changeRepairAmount(
          inputAmount, _provide.repairAmount - inputAmount);
    }
  }

  _payment(bool type) {
    bool status = false;
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '车牌号',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.vehicleLicence,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '消费金额',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '¥' + _provide.consumeAmount.toString(),
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '预付金额',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '¥' + _provide.prepaymentAmount.toString(),
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '尾款金额',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '¥' + _provide.repairAmount.toString(),
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Container(
                  height: 1,
                  color: AppColors.ViewBackgroundColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '已优惠',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      '¥' + _provide.realDiscountAmount.toString(),
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                    Text(
                      '   实收',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      '¥' + _provide.allAmount.toString(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primaryColor),
                alignment: Alignment.center,
                width: 60,
                height: 28,
                child: Text(
                  '取消',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                status = true;
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primaryColor),
                alignment: Alignment.center,
                width: 60,
                height: 28,
                child: Text(
                  type ? '结算' : '挂账',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ],
        );
      },
    ).then((val) {
      if (status) {
        var s = _provide
            .payment(type, widget.orderId)
            .doOnData((event) {})
            .doOnListen(() {})
            .doOnCancel(() {})
            .listen((data) {
          Map res = convert.jsonDecode(data.toString());
          print(data);
          var results = res['data'];
          if (results is String) {
            BotToast.showText(text: results);
          } else {
            Navigator.of(context).pop(true);
          }
        }, onError: (e) {});
        _subscriptions.add(s);
      }
    });
  }
}
