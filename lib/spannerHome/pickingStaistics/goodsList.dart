import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/showAlart.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/inventory_manager/page/inventory_add_page.dart';
import 'package:spanners/inventory_manager/page/inventory_manage_page.dart';
import 'package:spanners/spannerHome/pickingStaistics/apickingStaisticsApi.dart';
import 'package:spanners/spannerHome/share_shop/page/ss_goods_details_page.dart';

class GoodsListPage extends StatefulWidget {
  final ValueChanged<List> onChanged;

  const GoodsListPage({Key key, this.onChanged}) : super(key: key);
  @override
  _GoodsListPageState createState() => _GoodsListPageState();
}

class _GoodsListPageState extends State<GoodsListPage> {
  int page = 1;
  String key = '';
  List goodsList = List();
  ScrollController scrollController = ScrollController();

  //
  _getGoodsList() {
    PackingDio.pickingGoodsListRequest(
      param: {'goodsName': key, 'current': page, 'size': 10},
      onSuccess: (data) {
        setState(() {
          if (page == 1) {
            goodsList = data['records'];
          } else {
            if (data['records'].length == 0) {
              Alart.showAlartDialog('没有更多了', 1);
              return;
            }
            goodsList.addAll(data['records']);
          }
        });
      },
    );
  }

/*
下拉刷新
*/
  Future _toRefresh() async {
    page = 1;
    _getGoodsList();
    return null;
  }

/*
加载更多
*/
  _loadMore() {
    //滑动到底部监听
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page++;
        _getGoodsList();
      }
    });
  }

  // data 非空判断
  int isNull(List list) {
    if (list == null) {
      print('--->null');
      return 0;
    } else if (list.length == 0) {
      print('--->0');
      return 0;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getGoodsList();
    _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 1,
          title: Text(
            '库存商品',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Column(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(children: [
                SizedBox(
                  height: 10,
                ),
                //搜索
                Row(
                  children: [
                    SizedBox(
                      width: 23,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(238, 238, 238, 1),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: 33,
                            maxWidth: MediaQuery.of(context).size.width - 46),
                        child: TextFormField(
                          onFieldSubmitted: (value) {
                            page = 1;
                            _getGoodsList();
                          },
                          onChanged: (value) {
                            setState(() {
                              //搜索 值
                              key = value;
                            });
                          },
                          maxLines: 1,
                          style: TextStyle(fontSize: 13, color: Colors.black),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 20,
                              ),
                              onPressed: () {
                                //更���状态控制密码显示或隐藏
                                page = 1;
                                _getGoodsList();
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20),
                            hintText: '请输入商品名称',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            fillColor: Color.fromRGBO(238, 238, 238, 1),
                            filled: true,
                            border: new OutlineInputBorder(
                                //添加边框
                                gapPadding: 10.0,
                                borderRadius: BorderRadius.circular(17.0),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 23,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ])),
          SizedBox(
            height: 15,
          ),
          Expanded(child: list())
        ]));
  }

  //商品
  list() {
    return RefreshIndicator(
        onRefresh: _toRefresh,
        child: isNull(goodsList) == 0
            ? ScrollConfiguration(
                behavior: NeverScrollBehavior(),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: ShowNullDataAlart(
                        alartText: '当前无数据',
                      ),
                    )
                  ],
                ))
            : ScrollConfiguration(
                behavior: NeverScrollBehavior(),
                child: ListView(
                  controller: scrollController,
                  shrinkWrap: true,
                  children: List.generate(
                      goodsList.length,
                      (index) => InkWell(
                          onTap: () {
                            if (goodsList[index]['stock'] == 0) {
                              Alart.showAlartDialog('当前库存商品为0', 1);
                              return;
                            }
                            //选择 跳转
                            List arr = [
                              {
                                'count': 1,
                                'stock': goodsList[index]['stock'],
                                'goodsName': goodsList[index]['goodsName'],
                                'img': goodsList[index]['img'],
                                'applyTo': goodsList[index]['applyTo'],
                                'stockId': goodsList[index]['shopGoodsId'],
                              }
                            ];
                            widget.onChanged(arr);
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    // height: 130,
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color:
                                            Color.fromRGBO(255, 255, 255, 1)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              width: 90,
                                              height: 90,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.network(
                                                  goodsList[index]['img'] ==
                                                          null
                                                      ? ''
                                                      : goodsList[index]['img'],
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 11,
                                            ),
                                            Expanded(
                                                child: Column(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      goodsList[index]
                                                          ['goodsName'],
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    goodsList[index]
                                                                ['applyTo'] ==
                                                            null
                                                        ? ''
                                                        : goodsList[index]
                                                            ['applyTo'],
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          151, 151, 151, 1),
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '库存数：${goodsList[index]['stock']}',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            151, 151, 151, 1),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        InventoryAddPage(
                                                                          inventoryManageType:
                                                                              InventoryManageType.InventoryManageNormal,
                                                                          shopGoodsId:
                                                                              goodsList[index]['shopGoodsId'],
                                                                          isDetails:
                                                                              true,
                                                                          //合代码 解开
                                                                          // hideChangeBtn:true
                                                                        )));
                                                      },
                                                      child: Container(
                                                        width: 68,
                                                        height: 30,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              39, 153, 93, 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Text(
                                                          '详情',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    )
                                                  ],
                                                )
                                              ],
                                            )),
                                            SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ))),
                )));
  }
}
