import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/inventory_manager/page/inventory_add_page.dart';
import 'package:spanners/inventory_manager/page/inventory_manage_page.dart';
import 'package:spanners/spannerHome/purchase/model/PurchaseModel.dart';
import 'package:spanners/spannerHome/purchase/purchase_api.dart';

/// Copyright (C), 2020-2020, spanners
/// FileName: stock_list
/// Author: Jack
/// Date: 2020/12/24
/// Description:
class StockList extends StatefulWidget {
  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  List<StockModel> stockList = [];
  TextEditingController searchTextController = TextEditingController();
  List<StockModel> stockCopyList = [];

  @override
  void initState() {
    initData();
  }

  initData() {
    PurchaseApi.getStockShopList(
        param: {},
        onSuccess: (data) {
          stockList =
              List<StockModel>.from(data.map((e) => StockModel.fromJson(e)));
          print(stockList);
          if (stockList.length > stockCopyList.length &&
              stockCopyList.isNotEmpty) {
            stockCopyList.clear();
            stockCopyList.addAll(stockList);
            stockCopyList.first.chooseFlag = true;
          } else {
            stockCopyList.addAll(stockList);
          }
          setState(() {});
        });
  }

  search() async {
    if (searchTextController.text == "") {
      return;
    }

    stockList.clear();
    for (StockModel stockModel in stockCopyList) {
      if (stockModel.itemName.contains(searchTextController.text)) {
        stockList.add(stockModel);
      }
    }
    setState(() {});
  }

  done() {
    List<StockModel> chooseStockList = [];
    for (StockModel stock in stockList) {
      if (stock.chooseFlag) {
        chooseStockList.add(stock);
      }
    }
    Navigator.pop(context, chooseStockList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.iconAppBar(context, "库存商品",
          rIcon: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 30.s, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => InventoryAddPage(
                                  inventoryManageType:
                                      InventoryManageType.InventoryManageNormal,
                                )))
                        .then((value) {
                      stockList.clear();
                      initData();

                      setState(() {});
                    });
                    ;
                  },
                  child: Image.asset(
                    "Assets/employee/add.png",
                    width: 23.s,
                    height: 23.s,
                  ),
                ),
              ],
            ),
          )),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: 375.s,
            height: 80.s,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                  width: 330.s,
                  height: 30.s,
                  margin: EdgeInsets.fromLTRB(0.s, 10.s, 0.s, 0),
                  padding: EdgeInsets.fromLTRB(40.s, 0, 25.s, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.s),
                      color: Color.fromRGBO(238, 238, 238, 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200.s,
                        child: CommonWidget.textField(
                            hintText: "请输入商品名",
                            textController: searchTextController),
                      ),
                      GestureDetector(
                        onTap: () {
                          search();
                        },
                        child: Image.asset(
                          "Assets/storage/search.png",
                          width: 17.s,
                          height: 17.s,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 7.s,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: CommonWidget.button(
                          text: "完成", width: 70.s, height: 25.s),
                      onTap: () {
                        done();
                      },
                    ),
                    SizedBox(
                      width: 30.s,
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: NeverScrollBehavior(),
              child: ListView(
                children: [
                  Column(
                    children: [
                      for (StockModel stock in stockList)
                        GestureDetector(
                          onTap: () {
                            stock.chooseFlag = !stock.chooseFlag;
                            setState(() {});
                          },
                          child: Container(
                            width: 345.s,
                            margin: EdgeInsets.fromLTRB(0, 10.s, 0, 0),
                            padding:
                                EdgeInsets.fromLTRB(15.s, 30.s, 15.s, 20.s),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: stock.chooseFlag
                                        ? Color.fromRGBO(39, 153, 93, 1)
                                        : Colors.white,
                                    width: 1.s)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                stock.picUrl != null?Image.network(stock.picUrl,
                                    width: 100.s, height: 100.s):Container(),
                                Container(
                                  width: 210.s,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonWidget.font(
                                          text: stock.itemName??"", size: 14),
                                      CommonWidget.font(
                                          text: stock.applyTo??"",
                                          color:
                                              Color.fromRGBO(145, 145, 145, 1),
                                          size: 13),
                                      SizedBox(height: 20.s),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonWidget.font(
                                              text: "库存数: ${stock.stock}",
                                              color: Color.fromRGBO(
                                                  145, 145, 145, 1),
                                              size: 13),
                                          GestureDetector(
                                            child: CommonWidget.button(
                                                text: "详情",
                                                width: 70.s,
                                                height: 30.s),
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          InventoryAddPage(
                                                            inventoryManageType:
                                                                InventoryManageType
                                                                    .InventoryManageNormal,
                                                            shopGoodsId: stock
                                                                .shopGoodsId,
                                                            isDetails: true,
                                                          )))
                                                  .then((value) {
                                                stockList.clear();
                                                stockCopyList.clear();
                                                initData();
                                              });
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
