import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/share_red/model/share_red_model.dart';
import 'package:spanners/share_red/provide/share_red_provide.dart';
import 'package:spanners/spannerHome/atwork/atWorkRequestApi.dart';
import 'dart:convert' as convert;

class ShareRedPage extends StatefulWidget {

  final String workOrderId;

  ShareRedPage({this.workOrderId});

  @override
  _ShareRedPageState createState() => _ShareRedPageState();
}

class _ShareRedPageState extends State<ShareRedPage> {

  ShareRedProvide _provide;
  final _subscriptions = CompositeSubscription();
  double _itemWidth;
  List peopleList = List(); // 派工人员列表

  @override
  void initState() {
    super.initState();

    _provide = ShareRedProvide();
    _getPeopleList();
    _loadData();
  }

  _loadData() {
    var s = _provide
        .getShareRedList(widget.workOrderId)
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((event) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    _itemWidth = (MediaQuery.of(context).size.width-15*2-18) / 5;
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '分红清单'),
        body: _initViews(),
      ),
    );
  }

  _initViews() => Consumer<ShareRedProvide>(
    builder: (_, provide, child) {
      return Stack(
        children: [
          Container(
            color: AppColors.ViewBackgroundColor,
            child: Container(
              color: AppColors.ViewBackgroundColor,
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Container(
                color: Colors.white,
                child: CustomScrollView(
                  slivers: _allSliverWidget(),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  List<Widget> _allSliverWidget() {

    ShareRedServiceModel fistModel = ShareRedServiceModel();
    if(_provide.serviceModelList.length > 0) {
      fistModel = _provide.serviceModelList.first;
    }


    List<Widget> widgetList = [SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 15),
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(judgeStringValue(fistModel.vehicleLicence), style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),),
      ),
    ),];


    for(int i=0; i<_provide.serviceModelList.length; i++) {
      widgetList.addAll(_sliverWidget(_provide.serviceModelList[i], _provide.serviceTextEditingControllerList[i], i));
    }

    widgetList.add(
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 72, bottom: 98),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  List dataList = [];
                  _provide.serviceModelList.forEach((element) {
                    ShareRedServiceModel model = element;
                    dataList.add(model.toJson());
                  });
                  _provide.postShareRedList(dataList).doOnListen(() {})
                      .doOnCancel(() {})
                      .listen((event) {
                    Map res = convert.jsonDecode(event.toString());
                    if(res['data']){
                      Navigator.of(context).pop();
                    }
                  }, onError: (e) {});
                },
                child: Container(
                  width: 90,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '完成分红',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return widgetList;
  }

  List<Widget> _sliverWidget(ShareRedServiceModel model, TextEditingController textEditingController, int serviceIndex) {

    List<Widget> widgetList = [];

    widgetList.add(
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 25),
            padding: EdgeInsets.only(right: 9, left: 9),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: _itemWidth,
                      child: Row(
                        children: [
                          Container(
                            width: 3,
                            height: 14,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          Text('服务项', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
                        ],
                      ),
                    ),

                    Container(
                      alignment: Alignment.center,
                      width: _itemWidth,
                      child: Text('施工人', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: _itemWidth,
                      child: Text('单价', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: _itemWidth,
                      child: Text('数量', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: _itemWidth,
                      child: Text('分红', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );

    widgetList.add(
      SliverPadding(
        padding: EdgeInsets.only(),
        sliver: SliverFixedExtentList(
          itemExtent:60,
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return _serveItemTitle(model, textEditingController);
            },
            childCount: 1,
          ),
        ),
      ),
    );

    if(model.materialModelList.length>0) {
      widgetList.add(
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(right: 9, left: 9),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: _itemWidth,
                      child: Row(
                        children: [
                          Container(
                            width: 3,
                            height: 14,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          Text('配件', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),),
                        ],
                      ),
                    ),

                    Container(
                      alignment: Alignment.center,
                      width: _itemWidth,
                      child: Text('所属人', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: _itemWidth,
                      child: Text('单价', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: _itemWidth,
                      child: Text('数量', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: _itemWidth,
                      child: Text('分红', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );

      List textEditingControllerList = [];
      for(int i=0;i<model.materialModelList.length;i++) {
        TextEditingController textE = TextEditingController();
        textEditingControllerList.add(textE);
      }
      _provide.textControllerList.add(textEditingControllerList);

      print('serviceIndex');
      print(serviceIndex);

      widgetList.add(
        SliverPadding(
          padding: EdgeInsets.only(),
          sliver: SliverFixedExtentList(
            itemExtent:60,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return _partsItemTitle(model.materialModelList[index], _provide.textControllerList[serviceIndex][index]);
              },
              childCount: model.materialModelList.length,
            ),
          ),
        ),
      );

      widgetList.add(
        SliverToBoxAdapter(
          child: Container(
            height: 5,
            color: AppColors.ViewBackgroundColor,
          ),
        ),
      );
    }else {
      _provide.textControllerList.add([]);
    }

    return widgetList;
  }

  _serveItemTitle(ShareRedServiceModel model, TextEditingController textEditingController) => Column(
    children: [
      SizedBox(height: 10,),
      Container(
        padding: EdgeInsets.only(right: 9, left: 9),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: _itemWidth,
              child: _popupText(judgeStringValue(model.secondaryService)),//Text('judgeStringValue(model.secondaryService)', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),),
            ),
            Container(
              alignment: Alignment.center,
              width: _itemWidth,
              child: Text(judgeStringValue(model.executorName), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),),
            ),
            Container(
              alignment: Alignment.center,
              width: _itemWidth,
              child: Text('¥'+judgeStringValue(model.price), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),),
            ),
            Container(
              alignment: Alignment.center,
              width: _itemWidth,
              child: Text(judgeStringValue(model.num), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),),
            ),
            Container(
              alignment: Alignment.center,
              width: _itemWidth,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: textEditingController,
                style: TextStyle(fontSize: 13, color: AppColors.primaryColor,),
                textAlign: TextAlign.center,
                onChanged: (value){
                  model.bonus = value;
                },
                decoration: InputDecoration(
                  hintText: '¥0',
                  hintStyle:
                  TextStyle(fontSize: 13, color: AppColors.primaryColor),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 5,),
      Container(color: AppColors.ViewBackgroundColor, height: 1,),
    ],
  );


  _popupText(String text)=> PopupMenuButton(
    child: Text(
      text,
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
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          value: "hot",
        ),
      ];
    },
    onSelected: (String action) {},
    onCanceled: () {},
  );

  _partsItemTitle(ShareRedMaterialModel model, TextEditingController textEditingController) => Column(
    children: [
      SizedBox(height: 10,),
      Container(
        padding: EdgeInsets.only(right: 9, left: 9),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: _itemWidth,
              child: Text(judgeStringValue(model.itemMaterial), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),),
            ),
            GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
                showModalBottomSheet(
                  isDismissible: true,
                  enableDrag: false,
                  context: context,
                  builder: (BuildContext context) {
                    return new Container(
                      height: 300.0,
                      child: ShowBottomSheet(
                        type: 3,
                        dataList: peopleList,
                        onChanges: (name, id) {
                          setState(() {
                            model.memberName = name;
                            model.memberID = id;
                          });
                        },
                      ),
                    );
                  },
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: _itemWidth,
                height: 30,
                child: Text(judgeStringValue(model.memberName)),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: _itemWidth,
              child: Text('¥'+model.itemPrice, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),),
            ),
            Container(
              alignment: Alignment.center,
              width: _itemWidth,
              child: Text(model.num, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),),
            ),
            Container(
              alignment: Alignment.center,
              width: _itemWidth,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: textEditingController,
                style: TextStyle(fontSize: 13, color: AppColors.primaryColor,),
                textAlign: TextAlign.center,
                onChanged: (value){
                  model.bonus = value;
                },
                decoration: InputDecoration(
                  hintText: '¥0',
                  hintStyle:
                  TextStyle(fontSize: 13, color: AppColors.primaryColor),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 5,),
      Container(color: AppColors.ViewBackgroundColor, height: 1,),
    ],
  );

  /* 获取 派工人员 列表*/
  _getPeopleList() {
    UntilApi.atworkPeopleRequest(
      onSuccess: (data) {
        peopleList = data;
      },
    );
  }
}


