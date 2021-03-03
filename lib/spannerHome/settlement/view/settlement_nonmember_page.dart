import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/preview_images_page.dart';
import 'package:spanners/publicView/pub_CostPriceView.dart';
import 'package:spanners/publicView/pub_MaintenanceCreat.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/newOrder/newOrder.dart';
import 'package:spanners/spannerHome/settlement/provide/settlement_nonmember_provide.dart';
import 'dart:convert' as convert;

class SettlementNonmemberPage extends StatefulWidget {
  final String orderId;
  final String vehicleLicence;
  final bool showDelay;

  const SettlementNonmemberPage(
      this.orderId, this.vehicleLicence, this.showDelay,
      {Key key})
      : super(key: key);

  @override
  _SettlementNonmemberPageState createState() =>
      _SettlementNonmemberPageState();
}

class _SettlementNonmemberPageState extends State<SettlementNonmemberPage> {
  SettlementNonmemberProvide _provide;
  final _subscriptions = CompositeSubscription();
  TextEditingController _textEditingController;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _provide = SettlementNonmemberProvide();
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
        .getDeliveryDetails(widget.orderId)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);
    _loadPrice();

    var s1 = _provide
        .getSettlementDetailsService(widget.orderId)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s1);
  }

  ///计算价格
  _loadPrice() {
    List cardIdList = [];
    var s = _provide
        .getAllPrice(widget.orderId, cardIdList)
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

  _initViews() => Consumer<SettlementNonmemberProvide>(
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

    widgetList.add(
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
    );

    ///成为VIP
    widgetList.add(SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          print('成为会员！！！！！');
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('Assets/vip_icon.png'),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '成为会员',
                  style: TextStyle(fontSize: 13, color: AppColors.TextColor),
                ),
              ],
            ),
          ),
        ),
      ),
    ));

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
                      onTap: () {},
                      child: Image.asset(
                        'Assets/settlement/select_btn_yes.png',
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
                        : _payment(true);
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
          color: index==1?AppColors.backgroundColor:Colors.white,
          height: 50,
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
    print('完成时调用');
    print(double.parse(messageStr).toString());
    double inputAmount = double.parse(messageStr);
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
                      _provide.userInfoContent.first,
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
              '照片',
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
}
