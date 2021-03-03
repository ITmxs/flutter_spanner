import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/notificationCenter.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/delivery_check/model/dc_list_model.dart';
import 'package:spanners/spannerHome/delivery_check/provide/delivery_check_provide.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/spannerHome/delivery_check/view/dc_details_page.dart';

class DeliveryCheckPage extends StatefulWidget {
  @override
  _DeliveryCheckPageState createState() => _DeliveryCheckPageState();
}

class _DeliveryCheckPageState extends State<DeliveryCheckPage> {
  DeliveryCheckProvide _provide;
  final _subscriptions = CompositeSubscription();
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _provide = DeliveryCheckProvide();
    _textEditingController = TextEditingController();

    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.dispose();
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
            appBar: BaseAppBar(context, title: '交验看板'),
            body: _initViews(),
          ),
        ));
  }

  _initViews() => Consumer<DeliveryCheckProvide>(
        builder: (_, provide, child) {
          return Container(
            color: AppColors.ViewBackgroundColor,
            child: _provide.modelList.length > 0
                ? _listViews()
                : GestureDetector(
                    child: Center(
                      child: Image.asset('Assets/alartIcon/alartIcon.png'),
                    ),
                    onTap: () {
                      _loadData();
                    },
                  ),
          );
        },
      );

  Widget _buildListItem(BuildContext context, int index) => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          margin: EdgeInsets.fromLTRB(23, 10, 23, 0),
          color: Colors.white,
          child: Column(
            children: _itemContentList(index),
          ),
        ),
      );

  List<Widget> _itemContentList(int index) {
    List<DCListItemMode> itemModeList = _provide.modelList[index].itemListMode;
    List<Widget> itemList = List();
    itemList.add(_itemTop(index));

    bool hideCell = _provide.hideCellList[index];
    if (hideCell) {
      return itemList;
    } else {
      for (int i = 0; i < itemModeList.length; i++) {
        itemList.add(Container(
          child: _itemContent(itemModeList[i]),
        ));
        itemList.add(Container(
          height: 5,
          color: AppColors.ViewBackgroundColor,
        ));
      }
    }
    return itemList;
  }

  _itemTop(int index) => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: AppColors.primaryColor,
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  List tempList = _provide.hideCellList;
                  bool hideCell = _provide.hideCellList[index];
                  tempList[index] = !hideCell;
                  _provide.hideCellList = tempList;
                },
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: Image.asset(_provide.hideCellList[index]
                          ? 'Assets/delivery_check_page/show_cell.png'
                          : 'Assets/delivery_check_page/hide_cell.png'),
                    ),
                    Text(
                      _provide.modelList[index].vehicleLicence,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _gotoDetailsPage(_provide.modelList[index]);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 22),
                  width: 30,
                  height: 30,
                  child:
                      Image.asset('Assets/delivery_check_page/cell_more.png'),
                ),
              ),
            ],
          ),
        ),
      );

  _itemContent(DCListItemMode itemMode) => Container(
        margin: EdgeInsets.only(bottom: 21),
        child: Column(
          children: _entryWidgetList(itemMode),
        ),
      );

  List<Widget> _entryWidgetList(DCListItemMode itemMode) {
    List<Widget> itemList = List();
    for (int i = 0; i < 3; i++) {
      switch (i) {
        case 0:
          itemList.add(Container(
            child: _entryWidget('服务项目', content: itemMode.secondaryService),
          ));
          break;
        case 1:
          itemList.add(Container(
            child: _entryWidget('施工人员', content: itemMode.executor),
          ));
          break;
        default:
          switch (itemMode.status) {
            case '4':
              if (itemMode.remark != null && itemMode.remark.length > 1) {
                itemList.add(Container(
                  child: _entryWidget('拒绝原因'),
                ));
              }
              break;
            case '5':
              itemList.add(Container(
                child: _entryWidget('施工状态', content: '已通过交验'),
              ));
              break;
            default:
          }
          break;
      }
    }

    itemList.add(_entryBottomWidget(itemMode));

    return itemList;
  }

  _entryWidget(String title, {String content}) => Container(
        padding: EdgeInsets.only(left: 21, right: 21, top: 21),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  color: AppColors.primaryColor,
                  width: 3,
                  height: 14,
                  margin: EdgeInsets.only(right: 5),
                ),
                Text(title),
              ],
            ),
            content != null ? Text(content) : Text(''),
          ],
        ),
      );

  _entryBottomWidget(DCListItemMode itemMode) => Container(
        margin: EdgeInsets.only(top: 16, left: 21, right: 21),
        child: Column(
          children: [
            itemMode.remark != null && itemMode.remark.length > 1
                ? Container(
                    padding: EdgeInsets.all(11),
                    width: MediaQuery.of(context).size.width - 21 * 2 - 23 * 2,
                    child: Text(itemMode.remark),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      //设置四周边框
                      border: Border.all(
                        width: 1,
                        color: Color(0xFFEEEEEE),
                      ),
                    ),
                  )
                : Container(),
            itemMode.status == '5'
                ? Container()
                : SizedBox(
                    height: 21,
                  ),
            itemMode.status == '5'
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _refused(itemMode);
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: 84,
                              height: 28,
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  '拒绝验收',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          _refuseBecauseRequest(itemMode, true);
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: 84,
                              height: 28,
                              color: AppColors.primaryColor,
                              child: Center(
                                child: Text(
                                  '同意验收',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
          ],
        ),
      );

  _listViews() => ListView.builder(
        itemBuilder: _buildListItem,
        itemCount: _provide.modelList.length,
      );

  _loadData() {
    var s = _provide
        .getList()
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  _gotoDetailsPage(DCListModel model) {
    print(model.workOrderId);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DCDetailsPage(
                workOrderId: model.workOrderId,
                detailsType: DetailsType.DetailsTypeDelivery,
              )),
    );
  }

  _refused(DCListItemMode itemMode) {
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Container(
                color: AppColors.primaryColor,
                width: 3,
                height: 14,
                margin: EdgeInsets.only(right: 5),
              ),
              Text('拒绝原因'),
            ],
          ),
          content: SingleChildScrollView(
            child: TextField(
              controller: _textEditingController,
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '请输入拒绝派遣原因......',
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              child: FlatButton(
                color: AppColors.primaryColor,
                child: Text(
                  '确认提交',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _refuseBecauseRequest(itemMode, false);
                },
              ),
              color: Colors.white,
              width: 1000,
              height: 30,
            ),
          ],
        );
      },
    ).then((val) {});
  }

  _refuseBecauseRequest(DCListItemMode itemMode, bool deliveryCheck) {
    String remark = _textEditingController.text.length >= 0
        ? _textEditingController.text
        : ' ';
    _textEditingController.clear();
    var query = {
      'id': itemMode.serviceId,
      'btnKbn': deliveryCheck ? '0' : '1',
      'remark': remark,
    };

    var s = _provide
        .refuseBecauseRequest(query)
        .doOnData((event) {
          _loadData();

          ///重新请求数据 刷新列表
        })
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {}, onError: (e) {});
    _subscriptions.add(s);
    if (!deliveryCheck) {
      Navigator.of(context).pop();
    }
  }
}
