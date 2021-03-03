import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/inventory_manager/model/inventory_location_model.dart';
import 'package:spanners/inventory_manager/provide/inventory_location_provide.dart';

import 'inventory_add_location.dart';
import 'inventory_add_type_page.dart';

class InventoryLocationPage extends StatefulWidget {
  @override
  _InventoryLocationPageState createState() => _InventoryLocationPageState();
}

class _InventoryLocationPageState extends State<InventoryLocationPage> {

  InventoryLocationProvide _provide;
  final _subscriptions = CompositeSubscription();
  final controller = TextEditingController();
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _provide = InventoryLocationProvide();
    _focusNode = FocusNode();
    _loadData('');
  }

  _loadData(String searchKey){
    var s = _provide
        .getInventoryLocationList(searchKey: searchKey)
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
        appBar: AppBar(
          title: Text(
            '库位',
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
              Navigator.maybePop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.black87,
              ),
              onPressed: () async {
                final value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InventoryAddLocationPage()),
                );
                if (value) {
                  _loadData('');
                }
              },
            ),
          ],
        ),
        body: _initSubviews(),
      ),
    );
  }

  _initSubviews() => Consumer<InventoryLocationProvide>(
    builder: (_, provide, child) {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 1,
              color: AppColors.ViewBackgroundColor,
            ),
            _searchView(),
            Expanded(
              child: _contentListWidget(),
            ),
          ],
        ),
      );
    },
  );


  _searchView() => Container(
    margin: EdgeInsets.only(top: 10, left: 23, right: 23),
    padding: EdgeInsets.only(left: 25, right: 25),
    height: 30,
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
              border: OutlineInputBorder(borderSide: BorderSide.none),
              hintText: '快速搜索',
              hintStyle:
              TextStyle(fontSize: 13, color: AppColors.TextColor),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            _loadData(controller.text);
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Icon(Icons.search),
        ),
      ],
    ),
  );

  _contentListWidget() => ListView.builder(
    itemBuilder: (BuildContext context, int index) {
      InventoryLocationModel model = _provide.locationList[index];
      return Container(
        margin: EdgeInsets.only(top: 10, left: 23, right: 23),
        height: 54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop(model);
              },
              child: Container(
                margin: EdgeInsets.only(left: 19, bottom: 10),
                child: Text(model.name),
              ),
            ),
            Container(
              height: 1,
              color: AppColors.ViewBackgroundColor,
            ),
          ],
        ),
      );
    },
    itemCount: _provide.locationList.length,
  );

  _doneButtonAction(String messageStr) {
    if (messageStr == null || messageStr.length <= 0) {
      print('不能为空');
      return;
    }
    controller.text = messageStr;
    _loadData(messageStr);
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
