import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/base/kapp_bar.dart';
import 'package:spanners/inventory_manager/model/inventory_goods_type_model.dart';
import 'package:spanners/inventory_manager/model/inventory_manage_model.dart';
import 'package:spanners/inventory_manager/provide/inventory_manage_provide.dart';
import 'package:spanners/publicView/pud_permission.dart';

import 'inventory_add_page.dart';
import 'inventory_goods_type.dart';

class InventoryManagePage extends StatefulWidget {
  @override
  _InventoryManagePageState createState() => _InventoryManagePageState();
}

class _InventoryManagePageState extends State<InventoryManagePage>
    with SingleTickerProviderStateMixin {
  // 选项卡控制器
  TabController _tabController;
  InventoryManageProvide _provide;
  InventoryManageType _inventoryManageType;
  ScrollController _typeScrollController;
  ScrollController _contentScrollController;
  final _subscriptions = CompositeSubscription();
  bool _isLoad = false;
  String _stockDistinguish;
  String _shareType;
  String _typeText = '全部库存';
  String _goodsTypeText = '全部商品';
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _provide = InventoryManageProvide();
    _inventoryManageType = InventoryManageType.InventoryManageNormal;
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        _provide.showInventoryType = 0;
        _provide.hideSelectType = _tabController.index == 3;
        _typeText = '全部库存';
        _goodsTypeText = '全部商品';
        switch (_tabController.index) {
          case 0:
            _inventoryManageType = InventoryManageType.InventoryManageNormal;
            print('选择库存');
            if (!_isLoad) {
              _isLoad = true;
              _loadContentList('0');
            }
            break;
          case 1:
            _inventoryManageType =
                InventoryManageType.InventoryManageSecondHand;
            print('选择二手');
            if (!_isLoad) {
              _isLoad = true;
              _loadContentList('1');
            }
            break;
          case 2:
            _inventoryManageType = InventoryManageType.InventoryManageEquipment;
            print('选择设备');
            if (!_isLoad) {
              _isLoad = true;
              _loadContentList('2');
            }
            break;
        }
      });
    _typeScrollController = ScrollController();
    _contentScrollController = ScrollController();
    _loadContentList('0');
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  _loadContentList(String distinguish,
      {String stockDistinguish = '0',
      String categoryId = '0',
      String shareType = '0',
      String searchKey = ''}) {
    _stockDistinguish = stockDistinguish;
    _shareType = shareType;
    var s1 = _provide
        .getInventoryManageContentList(distinguish,
            stockDistinguish: stockDistinguish,
            categoryId: categoryId,
            shareType: shareType,
            searchKey: searchKey)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
      _isLoad = false;
    }, onError: (e) {});
    _subscriptions.add(s1);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '库存管理'),
        body: _initViews(),
      ),
    );
  }

  final List<Tab> tabs = <Tab>[
    Tab(
      text: '库存商品',
    ),
    Tab(
      text: '二手配件',
    ),
    Tab(
      text: '工具设备',
    ),
  ];

  _initViews() => SafeArea(
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
                          child: _searchWidget(),
                        ),
                        KSliverAppBar(
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          backgroundColor: Colors.white,
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
                                fontSize: 15, fontWeight: FontWeight.w500),
                            unselectedLabelColor: Colors.black54,
                            unselectedLabelStyle: TextStyle(fontSize: 13),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(controller: _tabController,
                        // physics: NeverScrollableScrollPhysics(),禁止侧滑
                        children: [
                          _inventorySelector(),
                          _secondHandSelector(),
                          _equipmentSelector(),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  _searchWidget() => Selector<InventoryManageProvide, bool>(
      builder: (_, hideType, child) {
        return Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 23, right: 23),
          height: 50,
          color: Colors.white,
          child: GestureDetector(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.ViewBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onSubmitted: _doneButtonAction,
                            controller: controller,
                            textAlignVertical: TextAlignVertical.bottom,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.TextColor,
                            ),
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              print(value);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: '快速搜索',
                              hintStyle: TextStyle(
                                  fontSize: 13, color: AppColors.TextColor),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _loadContentList(_tabController.index.toString(),
                                stockDistinguish: _stockDistinguish,
                                searchKey: controller.text);
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Icon(Icons.search),
                        ),
                      ],
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: 20),
                    padding: EdgeInsets.only(left: 39, right: 24),
                  ),
                ),
                hideType
                    ? Container()
                    : GestureDetector(
                        onTap: () async {
                          //权限处理 详细参考 后台Excel
                          if (!PermissionApi.whetherContain(
                              'stock_management_opt')) {
                            final value = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InventoryGoodsType()),
                            );
                            if (value != null) {
                              InventoryGoodsTypeModel model = value;
                              _loadContentList(_tabController.index.toString(),
                                  stockDistinguish: _stockDistinguish,
                                  categoryId: model.id,
                                  shareType: _shareType);
                            }
                          }
                        },
                        child: Image.asset(
                          'Assets/inventory/inventory_type.png',
                          width: 20,
                        ),
                      ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
      selector: (_, provide) => _provide.hideSelectType);

  _doneButtonAction(String messageStr) {
    if (messageStr == null || messageStr.length <= 0) {
      print('不能为空');
      return;
    }
    controller.text = messageStr;
    _loadContentList(_tabController.index.toString(),
        stockDistinguish: _stockDistinguish, searchKey: messageStr);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  ///库存商品
  Widget _inventorySelector() => Selector<InventoryManageProvide, int>(
      builder: (_, modelList, child) {
        return Container(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 40,
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_provide.showInventoryType == 2) {
                          _provide.showInventoryType = 0;
                        } else {
                          _provide.showInventoryType = 2;
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 40),
                        child: Text(
                          _typeText +
                              (_provide.showInventoryType == 2 ? '∨' : '∧'),
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_provide.showInventoryType == 1) {
                          _provide.showInventoryType = 0;
                        } else {
                          _provide.showInventoryType = 1;
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 40),
                        child: Text(
                          _goodsTypeText +
                              (_provide.showInventoryType == 1 ? '∨' : '∧'),
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //权限处理 详细参考 后台Excel
                        PermissionApi.whetherContain('stock_management_opt')
                            ? print('')
                            : Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => InventoryAddPage(
                                      inventoryManageType: InventoryManageType
                                          .InventoryManageNormal,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 24),
                        width: 58,
                        height: 28,
                        child: Text(
                          '添加',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _provide.showInventoryType != 0
                  ? _inventoryType()
                  : Expanded(
                      child: _contentList(),
                    ),
            ],
          ),
        );
      },
      selector: (_, provide) => _provide.showInventoryType);

  ///展示下拉库存标签
  Widget _inventoryType() => Expanded(
        child: Stack(
          children: [
            _contentList(),
            GestureDetector(
              onTap: () {
                _provide.showInventoryType = 0;
              },
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
            ),
            Container(
              color: Colors.white,
              height: 150,
              child: ListView.builder(
                controller: _typeScrollController,
                itemBuilder: _provide.showInventoryType == 1
                    ? _goodsTypeItem
                    : _typeItem,
                itemCount: _provide.showInventoryType == 1
                    ? _provide.shareGoodsTypeList.length
                    : _provide.inventoryTypeList.length,
              ),
            )
          ],
        ),
      );

  ///二手配件
  Widget _secondHandSelector() => Selector<InventoryManageProvide, int>(
      builder: (_, modelList, child) {
        return Container(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 40,
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //权限处理 详细参考 后台Excel
                        PermissionApi.whetherContain('stock_management_opt')
                            ? print('')
                            : Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => InventoryAddPage(
                                      inventoryManageType: InventoryManageType
                                          .InventoryManageSecondHand,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 24),
                        width: 58,
                        height: 28,
                        child: Text(
                          '添加',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _provide.showInventoryType != 0
                  ? Expanded(
                      child: Stack(
                        children: [
                          _contentList(),
                          Container(
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                          ),
                          Container(
                            color: Colors.white,
                            height: 150,
                            child: ListView.builder(
                              controller: _typeScrollController,
                              itemBuilder: _typeItem,
                              itemCount: 10,
                            ),
                          )
                        ],
                      ),
                    )
                  : Expanded(
                      child: _contentList(),
                    ),
            ],
          ),
        );
      },
      selector: (_, provide) => _provide.showInventoryType);

  ///设备管理
  Widget _equipmentSelector() => Selector<InventoryManageProvide, int>(
      builder: (_, modelList, child) {
        return Container(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 40,
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //权限处理 详细参考 后台Excel
                        PermissionApi.whetherContain('stock_management_opt')
                            ? print('')
                            : Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => InventoryAddPage(
                                      inventoryManageType: InventoryManageType
                                          .InventoryManageEquipment,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 24),
                        width: 58,
                        height: 28,
                        child: Text(
                          '添加',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _provide.showInventoryType != 0
                  ? Expanded(
                      child: Stack(
                        children: [
                          _contentList(),
                          Container(
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                          ),
                          Container(
                            color: Colors.white,
                            height: 150,
                            child: ListView.builder(
                              controller: _typeScrollController,
                              itemBuilder: _typeItem,
                              itemCount: 10,
                            ),
                          )
                        ],
                      ),
                    )
                  : Expanded(
                      child: _contentList(),
                    ),
            ],
          ),
        );
      },
      selector: (_, provide) => _provide.showInventoryType);

  ///内容
  Widget _contentList() => Selector<InventoryManageProvide, List>(
        selector: (_, provide) => _provide.inventoryCountList,
        builder: (_, modelList, child) => ListView.builder(
          controller: _contentScrollController,
          itemBuilder: _listItem,
          itemCount: _provide.inventoryCountList.length,
        ),
      );

  Widget _typeItem(BuildContext context, int index) => GestureDetector(
        onTap: () {
          _provide.showInventoryType = 0;
          _loadContentList(_tabController.index.toString(),
              stockDistinguish: index.toString(), shareType: _shareType);
          _typeText = _provide.inventoryTypeList[index];
        },
        child: Container(
          margin: EdgeInsets.only(left: 40, bottom: 25),
          child: Text(_provide.inventoryTypeList[index]),
        ),
      );

  Widget _goodsTypeItem(BuildContext context, int index) => GestureDetector(
        onTap: () {
          _provide.showInventoryType = 0;
          _loadContentList(_tabController.index.toString(),
              shareType: index.toString(), stockDistinguish: _stockDistinguish);
          _goodsTypeText = _provide.shareGoodsTypeList[index];
        },
        child: Container(
          margin: EdgeInsets.only(left: 40, bottom: 25),
          child: Text(_provide.shareGoodsTypeList[index]),
        ),
      );

  Widget _listItem(BuildContext context, int index) => Container(
        margin: EdgeInsets.only(left: 17, right: 15, bottom: 10, top: 9),
        height: 135,
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
        child: GestureDetector(
          onTap: () {
            InventoryManageContentListModel model =
                _provide.inventoryCountList[index];
            if (_tabController.index == 0) {
              //权限处理 详细参考 后台Excel
              PermissionApi.whetherContain('stock_management_opt')
                  ? print('')
                  : Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => InventoryAddPage(
                            inventoryManageType: model.shareFlag
                                ? InventoryManageType.InventoryManageShare
                                : _inventoryManageType,
                            shopGoodsId: model.shopGoodsId,
                            isDetails: true,
                          )));
            } else {
              //权限处理 详细参考 后台Excel
              PermissionApi.whetherContain('stock_management_opt')
                  ? print('')
                  : Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => InventoryAddPage(
                            inventoryManageType: _inventoryManageType,
                            shopGoodsId: _inventoryManageType ==
                                    InventoryManageType.InventoryManageEquipment
                                ? model.goodsId
                                : model.shopGoodsId,
                            isDetails: true,
                          )));
            }
          },
          child: _itemCell(_provide.inventoryCountList[index]),
        ),
      );

  _itemCell(InventoryManageContentListModel model) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.only(right: 10),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, top: 23, bottom: 23),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(model.primaryPicUrl,
                    width: 90, height: 90, fit: BoxFit.fill),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.goodsName,
                    maxLines: 2,
                    style: TextStyle(fontSize: 14),
                  ),
                  _inventoryManageType !=
                          InventoryManageType.InventoryManageEquipment
                      ? Text(
                          model.applyto,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 13, color: AppColors.SubTextColor),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        '库存数：' + model.stock,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 13, color: AppColors.SubTextColor),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          model.shareFlag ? ' 共享 ' : '',
                          maxLines: 1,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

enum InventoryManageType {
  /// 库存商品
  InventoryManageNormal,

  /// 库存商品
  InventoryManageShare,

  /// 二手配件
  InventoryManageSecondHand,

  /// 设备管理
  InventoryManageEquipment,
}
