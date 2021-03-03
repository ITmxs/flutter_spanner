import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/imageChange.dart';
import 'package:spanners/cTools/photoSelect.dart';
import 'package:spanners/cTools/scan.dart';
import 'package:spanners/inventory_manager/model/inventory_add_model.dart';
import 'package:spanners/inventory_manager/model/inventory_goods_type_model.dart';
import 'package:spanners/inventory_manager/model/inventory_location_model.dart';
import 'package:spanners/inventory_manager/provide/inventory_add_provide.dart';
import 'package:spanners/talkingOnline/about/imageView.dart';
import 'package:rxdart/rxdart.dart';
import 'inventory_goods_type.dart';
import 'inventory_location_page.dart';
import 'inventory_manage_page.dart';
import 'dart:convert' as convert;

class InventoryAddPage extends StatefulWidget {
  final InventoryManageType inventoryManageType;
  final bool isDetails;
  final String shopGoodsId;
  final bool hideChangeBtn;

  const InventoryAddPage(
      {Key key,
      this.inventoryManageType,
      this.isDetails = false,
      this.shopGoodsId,
      this.hideChangeBtn = false})
      : super(key: key);

  @override
  _InventoryAddPageState createState() => _InventoryAddPageState();
}

class _InventoryAddPageState extends State<InventoryAddPage> {
  InventoryAddProvide _provide;
  double _cellWidth = 0;
  final List _imagesList = List();
  final _subscriptions = CompositeSubscription();

  _InventoryAddPageState();

  bool _isChange = false;
  bool _isDetails;

  @override
  void initState() {
    super.initState();
    _isDetails = widget.isDetails;
    _provide = InventoryAddProvide();

    switch (widget.inventoryManageType) {
      case InventoryManageType.InventoryManageNormal:
      case InventoryManageType.InventoryManageShare:
        _provide.titleList = [
          '商品分类',
          '商品名称',
          '商品品牌',
          '商品型号',
          '商品规格',
          '商品单位',
          '商品条码',
        ];
        _provide.titleSubList = [
          '商品成本',
          '零售价格',
          '商品分红',
        ];
        if (_isDetails) {
          _loadInventoryData();
        }
        break;
      case InventoryManageType.InventoryManageSecondHand:
        _provide.titleList = [
          '商品分类',
          '商品名称',
          '商品品牌',
          '商品型号',
          '商品规格',
          '商品单位',
          '商品条码',
        ];
        _provide.titleSubList = [
          '配件成本',
          '零售价格',
        ];
        if (_isDetails) {
          _loadInventoryData();
        }
        break;
      case InventoryManageType.InventoryManageEquipment:
        _provide.titleList = [
          '工具名称',
          '工具品牌',
          '工具型号',
          '工具规格',
          '工具单位',
          '工具条码',
        ];
        if (_isDetails) {
          _loadInventoryEquipmentData();
        }
        break;
    }
  }

  _loadInventoryData() {
    var s1 = _provide
        .getInventoryDetails(widget.shopGoodsId)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s1);
  }

  _loadInventoryEquipmentData() {
    var s1 = _provide
        .getInventoryEquipmentDetails(widget.shopGoodsId)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s1);
  }

  @override
  Widget build(BuildContext context) {
    _cellWidth = MediaQuery.of(context).size.width - 30;
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '库存管理'),
        body: _initViews(),
      ),
    );
  }

  _initViews() => Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 15,
          right: 15,
        ),
        child: CustomScrollView(
          slivers: _sliverWidget(),
        ),
      );

  List<Widget> _sliverWidget() {
    List<Widget> widgetList = [];

    if (widget.isDetails) {
      widgetList.add(
        SliverToBoxAdapter(
            child: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 45, bottom: 13),
          child: widget.hideChangeBtn?Container():GestureDetector(
            onTap: () {
              setState(() {
                _isChange = !_isChange;
                _isDetails = !_isDetails;
              });
            },
            child: Text(
              _isChange ? '取消' : '修改',
              style: TextStyle(fontSize: 18),
            ),
          ),
        )),
      );
    }

    widgetList.add(
      SliverPadding(
        padding: EdgeInsets.only(),
        sliver: SliverFixedExtentList(
          itemExtent: 50,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _cellItemConfig(index);
            },
            childCount: _provide.titleList.length, //50个列表项
          ),
        ),
      ),
    );

    if (widget.inventoryManageType !=
        InventoryManageType.InventoryManageEquipment) {
      widgetList.add(SliverToBoxAdapter(
          child: Container(
        padding: EdgeInsets.only(left: 11, top: 20, bottom: 10),
        child: Text('适用车型'),
      )));

      widgetList.add(SliverToBoxAdapter(
          child: Container(
        height: 40,
        color: Colors.white,
        padding: EdgeInsets.only(
          left: 11,
        ),
        child: TextField(
          enabled: !_isDetails,
          controller: _provide.applyToTextController,
          style: TextStyle(fontSize: 13),
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: '未填写默认适用所有车型',
            border: InputBorder.none,
          ),
        ),
      )));
    }

    widgetList.add(SliverToBoxAdapter(
      child: Container(
        height: 10,
      ),
    ));

    widgetList.add(SliverToBoxAdapter(
      child: _cellItem(
          redStar: false,
          itemName: '库存数量',
          contentEdit: widget.inventoryManageType != InventoryManageType.InventoryManageShare && widget.inventoryManageType != InventoryManageType.InventoryManageNormal && !_isDetails,
          textController: _provide.inventoryQuantityTextController,
          camera: false,
          right: false),
    ));

    if (widget.inventoryManageType ==
            InventoryManageType.InventoryManageNormal ||
        widget.inventoryManageType ==
            InventoryManageType.InventoryManageShare) {
      widgetList.add(SliverToBoxAdapter(
        child: _cellItem(
            redStar: false,
            itemName: '最低库存',
            contentEdit: !_isDetails,
            textController: _provide.inventoryQuantityLowTextController,
            camera: false,
            right: false),
      ));
    }

    widgetList.add(SliverToBoxAdapter(
      child: Container(
        height: 10,
      ),
    ));

    widgetList.add(
      SliverPadding(
        padding: EdgeInsets.only(),
        sliver: SliverFixedExtentList(
          itemExtent: 50,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _cellSubItemConfig(index);
            },
            childCount: _provide.titleSubList.length, //50个列表项
          ),
        ),
      ),
    );

    widgetList.add(SliverToBoxAdapter(
      child: Container(
        height: 10,
      ),
    ));
    widget.inventoryManageType == InventoryManageType.InventoryManageEquipment
        ? widgetList.add(SliverToBoxAdapter(
            child: _cellItem(
                redStar: false,
                itemName: '设备成本',
                contentEdit: !_isDetails,
                textController: _provide.inventoryEquipmentCostTextController,
                camera: false,
                right: false),
          ))
        : widgetList.add(SliverToBoxAdapter(
            child: _cellItem(
                redStar: false,
                itemName: '库位',
                contentEdit: false,
                textController: _provide.inventoryLocationTextController,
                camera: false,
                right: true),
          ));
    if (widget.inventoryManageType !=
        InventoryManageType.InventoryManageShare) {

      if(!_isDetails) {
        widgetList.add(SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 11, top: 20, bottom: 10),
              child: Text('添加照片'),
            )));
      }else {
        widgetList.add(SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 11, top: 20, bottom: 10),
              child: Text('商品照片'),
            )));
      }
      int imgNumber = 1;
      widgetList.add(SliverToBoxAdapter(
        child: Selector<InventoryAddProvide, String>(
            builder: (_, picUrl, child) {
              if (_isDetails) {
                if (picUrl.length > 0) {
                  _imagesList.add(picUrl);
                }
              }
              return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  //禁止滑动
                  itemCount: _returnInt(_imagesList) > imgNumber
                      ? imgNumber
                      : _returnInt(_imagesList),
                  //做多9个
                  //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //横轴元素个数
                      crossAxisCount: 3,
                      //纵轴间距
                      mainAxisSpacing: 10.0,
                      //横轴间距
                      crossAxisSpacing: 15.0,
                      //子组件宽高长度比例
                      childAspectRatio: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    //Widget Function(BuildContext context, int index)
                    return InkWell(
                      onTap: () {
                        _returnChangeInt(_returnInt(_imagesList), index) == 0
                            ?
                        /*     发布 图片的      */
                        showModalBottomSheet(
                          isDismissible: true,
                          enableDrag: false,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return new Container(
                              height: 160.0,
                              child: PhotoSelect(
                                isScan: false,
                                isVin: false,
                                imageNumber: 9,
                                type: 1,
                                imageList: _imagesList.length == 0
                                    ? null
                                    : _imagesList,
                                onChanged: (value) {
                                  setState(
                                        () {
                                      _imagesList.addAll(value);
                                      print('成功上传的图片地址：${_imagesList}');
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        )
                            :
                        /*     图片点击方法     */
                        Navigator.of(context).push(new FadeRoute(
                            page: PhotoViewSimpleScreen(
                              imageProvider: NetworkImage(
                                _imagesList[index],
                              ),
                              heroTag: 'simple',
                            )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3 - 50 / 3,
                        height: MediaQuery.of(context).size.width / 3 - 50 / 3,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: index + 1 == _returnInt(_imagesList)
                                ? Image.asset(
                              'Assets/Home/image_add.png',
                              fit: BoxFit.cover,
                            )
                                : Stack(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(0),
                                    child: ConstrainedBox(
                                      constraints:
                                      BoxConstraints.expand(),
                                      child: Image.network(
                                        _imagesList[index],
                                        fit: BoxFit.fill,
                                      ),
                                    )),
                                _isDetails
                                    ? Container()
                                    : Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context)
                                          .size
                                          .width /
                                          3 -
                                          50 / 3 -
                                          20 -
                                          2,
                                      2,
                                      2,
                                      MediaQuery.of(context)
                                          .size
                                          .width /
                                          3 -
                                          50 / 3 -
                                          20 -
                                          2),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          /*  删除 图片操作  */
                                          _imagesList
                                              .removeAt(index);
                                        });
                                      },
                                      child: Image.asset(
                                        'Assets/Technology/deletclose.png',
                                        width: 20,
                                        height: 20,
                                      )),
                                ),
                              ],
                            )),
                      ),
                    );
                  });
            },
            selector: (_, provide) => _provide.picUrl),
      ));
    }

    if (widget.inventoryManageType ==
        InventoryManageType.InventoryManageEquipment) {
      widgetList.add(SliverToBoxAdapter(
          child: Container(
        padding: EdgeInsets.only(left: 11, top: 20, bottom: 10),
        child: Text('备注'),
      )));
      widgetList.add(SliverToBoxAdapter(
        child: Container(
          height: 90,
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  enabled: !_isDetails,
                  maxLines: 5,
                  controller: _provide.equipmentNoteTextController,
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: '请填写您需要备注的信息......',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: AppColors.ViewBackgroundColor, width: 1), // 边色与边宽度
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ));
    }

    if (widget.inventoryManageType ==
            InventoryManageType.InventoryManageSecondHand ||
        widget.inventoryManageType ==
            InventoryManageType.InventoryManageEquipment) {
      widgetList.add(
        SliverToBoxAdapter(
          child: Selector<InventoryAddProvide, bool>(
              builder: (_, showShare, child) {
                return Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '共享上架',
                            style: TextStyle(fontSize: 17),
                          ),
                          GestureDetector(
                            onTap: () {
                              if(_isDetails) return;
                              _provide.showShare = !_provide.showShare;
                              _provide.submitMap['shareSwitch'] =
                                  _provide.showShare ? '1' : '0';
                              _provide.submitEquipmentMap['share'] =
                                  _provide.showShare ? '1' : '0';
                            },
                            child: Image.asset(
                              _provide.showShare
                                  ? 'Assets/settlement/select_btn_yes.png'
                                  : 'Assets/settlement/select_btn_no.png',
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                      _provide.showShare
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.only(top: 40, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        color: AppColors.primaryColor,
                                        width: 3.5,
                                        height: 16,
                                      ),
                                      Text(
                                        '  商品描述',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 90,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            enabled: !_isDetails,
                                            maxLines: 5,
                                            controller: _provide
                                                .shareDescribeTextController,
                                            style: TextStyle(fontSize: 13),
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                              hintText:
                                                  '请编辑商品描述信息（品牌型号、新旧程度、入手渠道）',
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.ViewBackgroundColor,
                                          width: 1), // 边色与边宽度
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      //禁止滑动
                                      itemCount:
                                          _isDetails?_provide.shareImagesList.length:_returnInt(_provide.shareImagesList) > 9
                                              ? 9
                                              : _returnInt(_provide.shareImagesList),
                                      //做多9个
                                      //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              //横轴元素个数
                                              crossAxisCount: 3,
                                              //纵轴间距
                                              mainAxisSpacing: 10.0,
                                              //横轴间距
                                              crossAxisSpacing: 15.0,
                                              //子组件宽高长度比例
                                              childAspectRatio: 1.0),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        //Widget Function(BuildContext context, int index)
                                        return InkWell(
                                          onTap: () {
                                            _returnChangeInt(_returnInt(_provide.shareImagesList), index) == 0 ?
                                                /*     发布 图片的      */
                                                showModalBottomSheet(
                                                    isDismissible: true,
                                                    enableDrag: false,
                                                    context: context,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        height: 160.0,
                                                        child: PhotoSelect(
                                                          isScan: false,
                                                          isVin: false,
                                                          imageNumber: 9,
                                                          type: 1,
                                                          imageList: _provide.shareImagesList.length == 0
                                                              ? null : _provide.shareImagesList,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              // _provide.shareImagesList.clear();
                                                              _provide.shareImagesList.addAll(value);
                                                              print('----- ----- -------- --- --');
                                                              print(_provide.shareImagesList);
                                                                print('成功上传的图片地址：${_provide.shareImagesList}');
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  )
                                                :
                                                /*     图片点击方法     */
                                                Navigator.of(context).push(
                                                    new FadeRoute(
                                                        page:
                                                            PhotoViewSimpleScreen(
                                                    imageProvider: NetworkImage(
                                                        _provide.shareImagesList[index]
                                                    ),
                                                    heroTag: 'simple',
                                                  )));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 3 - 50 / 3,
                                            height: MediaQuery.of(context).size.width / 3 - 50 / 3,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: _isDetails?Padding(
                                                    padding: EdgeInsets.all(0),
                                                    child: ConstrainedBox(
                                                      constraints: BoxConstraints.expand(),
                                                      child: Image.network(_provide.shareImagesList[index],
                                                        fit: BoxFit.fill,
                                                      ),
                                                    )) : index + 1 == _returnInt(_provide.shareImagesList)
                                                    ? Image.asset(
                                                        'Assets/Home/image_add.png',
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Stack(
                                                        children: [
                                                          Padding(
                                                              padding: EdgeInsets.all(0),
                                                              child: ConstrainedBox(
                                                                constraints: BoxConstraints.expand(),
                                                                child: Image.network(_provide.shareImagesList[index],
                                                                  fit: BoxFit.fill,
                                                                ),
                                                              )),
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(
                                                                MediaQuery.of(context).size.width / 3 - 50 / 3 - 20 - 2, 2, 2,
                                                                MediaQuery.of(context).size.width / 3 - 50 / 3 - 20 - 2),
                                                            child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    /*  删除 图片操作  */
                                                                    _provide.shareImagesList
                                                                        .removeAt(
                                                                            index);
                                                                  });
                                                                },
                                                                child:
                                                                    Image.asset(
                                                                  'Assets/Technology/deletclose.png',
                                                                  width: 20,
                                                                  height: 20,
                                                                )),
                                                          ),
                                                        ],
                                                      )),
                                          ),
                                        );
                                      }),
                                  widget.inventoryManageType ==
                                          InventoryManageType
                                              .InventoryManageSecondHand
                                      ? _cellItem(
                                          redStar: false,
                                          itemName: '上架数量',
                                          contentEdit: !_isDetails,
                                          textController: _provide
                                              .shareNumberTextController,
                                          camera: false,
                                          right: false)
                                      : Container(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        color: AppColors.primaryColor,
                                        width: 3.5,
                                        height: 16,
                                      ),
                                      Text(
                                        '  商品价格',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  widget.inventoryManageType ==
                                          InventoryManageType
                                              .InventoryManageSecondHand
                                      ? _cellItem(
                                          redStar: false,
                                          itemName: '入手价格',
                                          contentEdit: !_isDetails,
                                          textController: _provide
                                              .shareOriginalPriceTextController,
                                          camera: false,
                                          right: false)
                                      : Container(),
                                  _cellItem(
                                      redStar: false,
                                      itemName: '共享价格',
                                      contentEdit: !_isDetails,
                                      textController:
                                          _provide.sharePriceTextController,
                                      camera: false,
                                      right: false),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                );
              },
              selector: (_, provide) => _provide.showShare),
        ),
      );
    }

    if (widget.isDetails && !widget.hideChangeBtn) {
      widgetList.add(SliverToBoxAdapter(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              if(_isChange){
                if(widget.inventoryManageType == InventoryManageType.InventoryManageNormal || widget.inventoryManageType == InventoryManageType.InventoryManageShare) {
                  Map changeMap = _provide.detailsModel.toJson();
                  if(_provide.submitMap['categoryId'].toString().length>0){
                    changeMap['categoryId'] = _provide.submitMap['categoryId'];
                  }
                  changeMap['applyto'] = _provide.applyToTextController.text;
                  changeMap['warningValue'] = _provide.inventoryQuantityLowTextController.text;
                  TextEditingController partsCostController =
                  _provide.textSubControllerList[0];
                  changeMap['partsCost'] = partsCostController.text;
                  TextEditingController goodsPriceController =
                  _provide.textSubControllerList[1];
                  changeMap['goodsPrice'] = goodsPriceController.text;
                  TextEditingController bonusController = _provide.textSubControllerList[2];
                  changeMap['bonus'] = bonusController.text;
                  if(_provide.submitMap['locationId'].toString().length>0){
                    changeMap['locationId'] = _provide.submitMap['locationId'];
                  }
                  changeMap['picUrl'] = _imagesList.length >0 ?_imagesList.first:'';
                  _modifyGoods(changeMap);
                }else if(widget.inventoryManageType == InventoryManageType.InventoryManageSecondHand){
                  _setInventoryManageMap();
                }else {
                  _setInventoryEquipmentMap();
                }

              }
            },
            child: Container(
              width: 105,
              height: 30,
              margin: EdgeInsets.only(bottom: 65, top: 40),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '保存',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 115,
              height: 30,
              margin: EdgeInsets.only(bottom: 65, top: 40),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '查看采购记录',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      )));
    } else {
      widgetList.add(SliverToBoxAdapter(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.inventoryManageType ==
                  InventoryManageType.InventoryManageEquipment) {
                _setInventoryEquipmentMap();
              } else {
                _setInventoryManageMap();
              }
            },
            child: Container(
              width: 105,
              height: 30,
              margin: EdgeInsets.only(bottom: 100, top: 40),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '保存',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      )));
    }

    if (widget.inventoryManageType ==
        InventoryManageType.InventoryManageShare) {
      widgetList.add(
        SliverToBoxAdapter(
            child: Selector<InventoryAddProvide, InventoryManageGoodsModel>(
                builder: (_, model, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(bottom: 200),
                    padding: EdgeInsets.only(
                      top: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '共享上架',
                          style: TextStyle(
                              color: AppColors.primaryColor, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              color: AppColors.primaryColor,
                              width: 3.5,
                              height: 16,
                            ),
                            Text(
                              '  商品图片',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            /*     图片点击方法     */
                            Navigator.of(context).push(new FadeRoute(
                                page: PhotoViewSimpleScreen(
                              imageProvider: NetworkImage(
                                _provide.detailsModel.picUrl,
                              ),
                              heroTag: 'simple',
                            )));
                          },
                          child: Container(
                            width: 75,
                            height: 75,
                            margin: EdgeInsets.only(top: 16, bottom: 21),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      _provide.detailsModel.picUrl),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              color: AppColors.primaryColor,
                              width: 3.5,
                              height: 16,
                            ),
                            Text(
                              '  商品描述',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16, bottom: 21),
                          padding: EdgeInsets.only(
                              top: 12, bottom: 21, left: 13, right: 17),
                          child: Text(
                              _provide.detailsModel.remarks),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 1, color: AppColors.ViewBackgroundColor),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              color: AppColors.primaryColor,
                              width: 3.5,
                              height: 16,
                            ),
                            Text(
                              '  列表图片',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        _provide.detailsModel.listPics != null
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                //禁止滑动
                                itemCount:
                                    _provide.detailsModel.listPics.length,
                                //做多9个
                                //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        //横轴元素个数
                                        crossAxisCount: 3,
                                        //纵轴间距
                                        mainAxisSpacing: 10.0,
                                        //横轴间距
                                        crossAxisSpacing: 15.0,
                                        //子组件宽高长度比例
                                        childAspectRatio: 1.0),
                                itemBuilder: (BuildContext context, int index) {
                                  //Widget Function(BuildContext context, int index)
                                  return InkWell(
                                    onTap: () {
                                      /*     图片点击方法     */
                                      Navigator.of(context).push(new FadeRoute(
                                          page: PhotoViewSimpleScreen(
                                        imageProvider: NetworkImage(
                                          _provide.detailsModel.listPics[index],
                                        ),
                                        heroTag: 'simple',
                                      )));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                              3 -
                                          50 / 3,
                                      height:
                                          MediaQuery.of(context).size.width /
                                                  3 -
                                              50 / 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.expand(),
                                              child: Image.network(
                                                _provide.detailsModel
                                                    .listPics[index],
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                      ),
                                    ),
                                  );
                                })
                            : Container(),
                        Row(
                          children: [
                            Container(
                              color: AppColors.primaryColor,
                              width: 3.5,
                              height: 16,
                            ),
                            Text(
                              '  详情图片',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        _provide.detailsModel.infoPics != null
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                //禁止滑动
                                itemCount:
                                    _provide.detailsModel.infoPics.length,
                                //做多9个
                                //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        //横轴元素个数
                                        crossAxisCount: 3,
                                        //纵轴间距
                                        mainAxisSpacing: 10.0,
                                        //横轴间距
                                        crossAxisSpacing: 15.0,
                                        //子组件宽高长度比例
                                        childAspectRatio: 1.0),
                                itemBuilder: (BuildContext context, int index) {
                                  //Widget Function(BuildContext context, int index)
                                  return InkWell(
                                    onTap: () {
                                      /*     图片点击方法     */
                                      Navigator.of(context).push(new FadeRoute(
                                          page: PhotoViewSimpleScreen(
                                        imageProvider: NetworkImage(
                                          _provide.detailsModel.infoPics[index],
                                        ),
                                        heroTag: 'simple',
                                      )));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                              3 -
                                          50 / 3,
                                      height:
                                          MediaQuery.of(context).size.width /
                                                  3 -
                                              50 / 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.expand(),
                                              child: Image.network(
                                                _provide.detailsModel
                                                    .infoPics[index],
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                      ),
                                    ),
                                  );
                                })
                            : Container(),
                        Row(
                          children: [
                            Container(
                              color: AppColors.primaryColor,
                              width: 3.5,
                              height: 16,
                            ),
                            Text(
                              '  商品价格',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        _cellItem(
                            redStar: false,
                            itemName: '市场价格',
                            contentEdit: false,
                            textController: TextEditingController(
                                text:
                                    "¥" + _provide.detailsModel.startingPrise),
                            camera: false,
                            right: false),
                        _cellItem(
                            redStar: false,
                            itemName: '共享价格',
                            contentEdit: false,
                            textController: TextEditingController(
                                text: "¥" + _provide.detailsModel.sharePrice),
                            camera: false,
                            right: false),
                      ],
                    ),
                  );
                },
                selector: (_, provide) => _provide.detailsModel)),
      );
    }

    return widgetList;
  }

  _cellItemConfig(int index) {
    String title = _provide.titleList[index];
    bool redStar = title.contains('名称');
    bool contentEdit = !title.contains('商品分类') && !_isDetails;
    if (!_isDetails && widget.isDetails && widget.inventoryManageType !=
        InventoryManageType.InventoryManageSecondHand) {
      contentEdit = widget.inventoryManageType !=
              InventoryManageType.InventoryManageNormal &&
          widget.inventoryManageType !=
              InventoryManageType.InventoryManageShare;
    }
    bool camera = title.contains('条码');
    bool right = title.contains('商品分类');

    return _cellItem(
        redStar: redStar,
        itemName: title,
        contentEdit: contentEdit,
        textController: _provide.textControllerList[index],
        camera: camera,
        right: right);
  }

  _cellSubItemConfig(int index) {
    String title = _provide.titleSubList[index];
    bool contentEdit = !_isDetails;
    return _cellItem(
      redStar: false,
      itemName: title,
      contentEdit: contentEdit,
      textController: _provide.textSubControllerList[index],
    );
  }

  _cellItem(
          {bool redStar = false,
          String itemName = '',
          bool contentEdit,
          TextEditingController textController,
          bool camera = false,
          bool right = false}) =>
      Container(
        width: _cellWidth,
        height: 50,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 39,
              child: Row(
                children: [
                  Container(
                    width: _cellWidth / 2,
                    child: Row(
                      children: [
                        redStar
                            ? Image.asset(
                                'Assets/redStart.png',
                                width: 10,
                              )
                            : Container(),
                        SizedBox(
                          width: redStar ? 5 : 15,
                        ),
                        Text(
                          itemName,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _cellWidth / 2,
                    child: GestureDetector(
                      onTap: () async {
                        if (!contentEdit && !_isDetails) {
                          if (itemName.contains('商品分类')) {
                            final value = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InventoryGoodsType()),
                            );
                            if (value != null) {
                              InventoryGoodsTypeModel model = value;
                              TextEditingController controller =
                                  _provide.textControllerList[0];
                              controller.text = model.name;
                              _provide.submitMap['categoryId'] = model.id;
                            }
                          } else if (itemName.contains('库位')) {
                            final value = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InventoryLocationPage()),
                            );
                            if (value != null) {
                              InventoryLocationModel model = value;
                              TextEditingController controller =
                                  _provide.inventoryLocationTextController;
                              controller.text = model.name;
                              _provide.submitMap['locationId'] = model.id;
                            }
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            width: _cellWidth / 2 - 18 - 5 - 5,
                            child: TextField(
                              enabled: contentEdit,
                              controller: textController,
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: '请输入',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          camera
                              ? GestureDetector(
                                  onTap: () {
                                    if(!_isDetails) {
                                      Scan.scan().then((value) {
                                        setState(() {
                                          textController.text = value;
                                        });
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.center_focus_strong,
                                    size: 18,
                                  ),
                                )
                              : Container(),
                          right
                              ? Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                )
                              : Container(),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
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
      );

  /* 九张图 与 add 图 逻辑 */
  int _returnInt(List imagelist) {
    return imagelist.length == 0 ? 1 : imagelist.length + 1;
  }

  /* 图片点击放大 逻辑 */
  int _returnChangeInt(int returnInt, int index) {
    return index == returnInt - 1 ? 0 : 1;
  }

  _setInventoryManageMap() {

    _provide.submitMap['shopGoodsId'] = _provide.detailsModel.shopGoodsId;

    TextEditingController goodsNameController = _provide.textControllerList[1];
    _provide.submitMap['goodsName'] = goodsNameController.text;
    TextEditingController brandController = _provide.textControllerList[2];
    _provide.submitMap['brand'] = brandController.text;
    TextEditingController modelController = _provide.textControllerList[3];
    _provide.submitMap['model'] = modelController.text;
    TextEditingController specNameController = _provide.textControllerList[4];
    _provide.submitMap['specName'] = specNameController.text;
    TextEditingController unitNameController = _provide.textControllerList[5];
    _provide.submitMap['unitName'] = unitNameController.text;
    TextEditingController barCodeController = _provide.textControllerList[6];
    _provide.submitMap['barcode'] = barCodeController.text;

    ///适用车型
    _provide.submitMap['applyto'] = _provide.applyToTextController.text;

    ///库存数量
    _provide.submitMap['stock'] = _provide.inventoryQuantityTextController.text;

    ///最低库存
    _provide.submitMap['warningValue'] =
        _provide.inventoryQuantityLowTextController.text;

    ///图片
    _provide.submitMap['picUrl'] = _imagesList.length >0 ?_imagesList.first:'';

    TextEditingController partsCostController =
        _provide.textSubControllerList[0];
    _provide.submitMap['partsCost'] = partsCostController.text;
    TextEditingController goodsPriceController =
        _provide.textSubControllerList[1];
    _provide.submitMap['goodsPrice'] = goodsPriceController.text;
    TextEditingController bonusController = _provide.textSubControllerList[2];
    _provide.submitMap['bonus'] = bonusController.text;
    _provide.submitMap['secondHand'] = _provide.detailsModel.secondHand;
    ///共享商品描述
    _provide.submitMap['remarks'] = _provide.shareDescribeTextController.text;

    List picList = [];
    _provide.shareImagesList.forEach((element) {
      picList.add(element);
    });
    _provide.submitMap['infoPics'] = picList;

    ///上架数量
    _provide.submitMap['shareStock'] = _provide.shareNumberTextController.text;

    ///入手价格
    _provide.submitMap['startingPrise'] =
        _provide.shareOriginalPriceTextController.text;

    ///共享价格
    _provide.submitMap['sharePrice'] = _provide.sharePriceTextController.text;

    print(_provide.submitMap);
    if (widget.inventoryManageType ==
        InventoryManageType.InventoryManageNormal) {
      _addGoodsType();
    } else if (widget.inventoryManageType ==
        InventoryManageType.InventoryManageSecondHand) {
      if(widget.isDetails) {
        _modifyGoods(_provide.submitMap);
      }else {
        _addSecondHand();
      }
    }
  }

  _setInventoryEquipmentMap() {

    _provide.submitEquipmentMap['id'] = _provide.equipmentDetailsModel.id;
    TextEditingController goodsNameController = _provide.textControllerList[0];
    _provide.submitEquipmentMap['name'] = goodsNameController.text;
    TextEditingController brandController = _provide.textControllerList[1];
    _provide.submitEquipmentMap['brand'] = brandController.text;
    TextEditingController modelController = _provide.textControllerList[2];
    _provide.submitEquipmentMap['model'] = modelController.text;
    TextEditingController specNameController = _provide.textControllerList[3];
    _provide.submitEquipmentMap['specName'] = specNameController.text;
    TextEditingController unitNameController = _provide.textControllerList[4];
    _provide.submitEquipmentMap['organization'] = unitNameController.text;
    TextEditingController barCodeController = _provide.textControllerList[5];
    _provide.submitEquipmentMap['barcode'] = barCodeController.text;
    _provide.submitEquipmentMap['stock'] =
        _provide.inventoryQuantityTextController.text;
    _provide.submitEquipmentMap['cost'] =
        _provide.inventoryEquipmentCostTextController.text;
    _provide.submitEquipmentMap['picUrl'] = _imagesList.first;
    _provide.submitEquipmentMap['remarks'] =
        _provide.equipmentNoteTextController.text;
    ///共享商品描述
    _provide.submitEquipmentMap['shareDescription'] = _provide.shareDescribeTextController.text;
    List picList = [];
    _provide.shareImagesList.forEach((element) {
      picList.add(element);
    });
    _provide.submitEquipmentMap['sharePics'] = picList;

    _provide.submitEquipmentMap['sharePrice'] =
        _provide.sharePriceTextController.text;
    if(widget.isDetails) {
      _modifyEquipment(_provide.submitEquipmentMap);
    }else {
      _addEquipment();
    }
  }

  _addGoodsType() {
    var s1 = _provide.postAddGoods().doOnListen(() {}).doOnCancel(() {}).listen(
        (event) {
      Navigator.of(context).pop();
    }, onError: (e) {});
    _subscriptions.add(s1);
  }

  _addSecondHand() {
    var s1 = _provide
        .postAddSecondHand()
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
      Map res = convert.jsonDecode(event.toString());
      var data = res['data'];
      if (data) {
        Navigator.of(context).pop();
      }
    }, onError: (e) {});
    _subscriptions.add(s1);
  }

  _addEquipment() {
    var s1 = _provide
        .postAddEquipment()
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
      Map res = convert.jsonDecode(event.toString());
      var data = res['data'];
      if (data) {
        Navigator.of(context).pop();
      }
    }, onError: (e) {});
    _subscriptions.add(s1);
  }

  _modifyGoods(Map modifyGoodsMap) {
    var s1 = _provide
        .postModifyGoods(modifyGoodsMap)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
      Map res = convert.jsonDecode(event.toString());
      var data = res['data'];
      if (data) {
        setState(() {
          _isChange = !_isChange;
          _isDetails = !_isDetails;
        });
      }
    }, onError: (e) {});
    _subscriptions.add(s1);
  }

  _modifyEquipment(Map modifyEquipmentMap) {
    var s1 = _provide
        .postModifyEquipment(modifyEquipmentMap)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
      Map res = convert.jsonDecode(event.toString());
      var data = res['data'];
      if (data) {
        setState(() {
          _isChange = !_isChange;
          _isDetails = !_isDetails;
        });
      }
    }, onError: (e) {});
    _subscriptions.add(s1);
  }


}
