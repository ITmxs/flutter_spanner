import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/inventory_manager/provide/inventory_add_location_provide.dart';

class InventoryAddLocationPage extends StatefulWidget {
  @override
  _InventoryAddLocationState createState() => _InventoryAddLocationState();
}

class _InventoryAddLocationState extends State<InventoryAddLocationPage> {

  InventoryAddLocationProvide _provide;
  final _subscriptions = CompositeSubscription();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _provide = InventoryAddLocationProvide();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '新建库位',
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
        body: _initSubviews(),
      ),
    );
  }

  _initSubviews() => Container(
    margin: EdgeInsets.only(left: 23, right: 23),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 11, top: 20, bottom: 10),
          child: Text('新建库位'),
        ),
        Container(
          height: 46,
          color: Colors.white,
          padding: EdgeInsets.only(
            left: 11,
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              hintText: '库位名称',
              border: InputBorder.none,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
                _addGoodsType();
              },
              child: Container(
                width: 110,
                height: 30,
                margin: EdgeInsets.only(bottom: 200, top: 40),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '确认新建',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],),
      ],
    ),
  );

  _addGoodsType(){
    if (controller.text == null || controller.text.length <= 0) {
      print('不能为空');
      return;
    }
    var s1 = _provide
        .postSetGoodsTypeName(controller.text)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {
    }, onError: (e) {});
    _subscriptions.add(s1);

  }
}
