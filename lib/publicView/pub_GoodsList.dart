import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/inventory_manager/page/inventory_add_page.dart';
import 'package:spanners/inventory_manager/page/inventory_manage_page.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/newOrder/carARquestApi.dart'; //->接车确认 配件联想

class GoodsList extends StatefulWidget {
  /*
   传输类型  (这里可以根据type 类型做区分，可自行加入)
    1->配件联想
   */
  final int type;
  //->接车确认 配件联想
  final String carBrand;
  final String carModel;
  final ValueChanged<Map> onChangedCarMater;

  const GoodsList(
      {Key key,
      this.carBrand,
      this.carModel,
      this.onChangedCarMater,
      this.type})
      : super(key: key);
  @override
  _GoodsListState createState() => _GoodsListState();
}

class _GoodsListState extends State<GoodsList> {
  //配件 list
  List materList = List();
  String params;
  String serch;
  /* 配件；联想*/
  _getMaterialList(String value) {
    if (widget.type == 1) {
      //->接车确认 配件联想

      RecCarDio.materialListRequest(
        param: value,
        onSuccess: (data) {
          setState(() {
            materList.clear();
            materList.addAll(data);
          });
        },
      );
    } else {
      //->自定义
      print('type为2，配件列表');
    }
  }

  //商品图片展示 根据不同 type 展示不同 结果
  String _returnTitle() {
    if (widget.type == 1) {
      //->接车确认 标题名
      String title = '选择配件';
      return title;
    } else {
      //->自定义
    }
  }

  //商品图片展示 根据不同 type 展示不同 结果
  String _returnShowImage(int index) {
    if (widget.type == 1) {
      //->接车确认 配件联想
      String image = '${materList[index]['primaryPicUrl']}';
      return image;
    } else {
      //->自定义
    }
  }

  //商品title展示 根据不同 type 展示不同 结果
  String _returnShowTitle(int index) {
    if (widget.type == 1) {
      //->接车确认 配件联想
      String title =
          '${materList[index]['goodsName']}/${materList[index]['model']}/${(materList[index]['specName'])}';

      return title;
    } else {
      //->自定义
      return '';
    }
  }

  //商品库存展示 根据不同 type 展示不同 结果
  String _returnShowCount(int index) {
    if (widget.type == 1) {
      //->接车确认 配件联想
      String count = '库存数：${materList[index]['stock'].toString()}';
      return count;
    } else {
      //->自定义
      return '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == 1) {
      RecCarDio.materialListRequest(
        param: '',
        onSuccess: (data) {
          setState(() {
            materList.clear();
            materList.addAll(data);
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        title: Text(
          _returnTitle(),
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
      body: Column(
        children: [
          SizedBox(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 55,
            color: Color.fromRGBO(255, 255, 255, 1),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 23,
                    ),
                    //搜索
                    Container(
                      width: MediaQuery.of(context).size.width - 46,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: 30,
                            maxWidth: MediaQuery.of(context).size.width - 46),
                        child: TextFormField(
                          onChanged: (value) {
                            serch = value;
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              //搜索 值
                              //->接车确认 配件联想
                              _getMaterialList(value);
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
                                //搜索 值
                                //->接车确认 配件联想
                                _getMaterialList(serch);
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20),
                            hintText: '请输入商品名',
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
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
              child: ListView(
            shrinkWrap: true,
            children: List.generate(
                materList.length,
                (index) => InkWell(
                    onTap: () {
                      if (materList[index]['stock'] == 0) {
                        Alart.showAlartDialog('当前商品库存为0，不能添加', 1);
                      } else {
                        Navigator.pop(context);
                        widget.onChangedCarMater(materList[index]);
                      }
                      //->接车确认 配件联想
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromRGBO(255, 255, 255, 1)),
                              child: Column(
                                children: [
                                  materList[index]['secondHand'] == 1
                                      ? Row(
                                          children: [
                                            Container(
                                              width: 68,
                                              height: 21,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 183, 0, 1),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Text(
                                                '二手配件',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            )
                                          ],
                                        )
                                      : SizedBox(
                                          height: 12,
                                        ),
                                  SizedBox(
                                    height: 3,
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
                                            _returnShowImage(index),
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
                                            // height: 40,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                _returnShowTitle(index),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
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
                                              '适用车型：${materList[index]['applyto']}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    151, 151, 151, 1),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  _returnShowCount(index),
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        151, 151, 151, 1),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  //权限处理 详细参考 后台Excel
                                                  PermissionApi.whetherContain(
                                                          'new_order_price')
                                                      ? print('')
                                                      : Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  InventoryAddPage(
                                                                    inventoryManageType:
                                                                        InventoryManageType
                                                                            .InventoryManageNormal,
                                                                    shopGoodsId:
                                                                        materList[index]
                                                                            [
                                                                            'shopGoodsId'],
                                                                    isDetails:
                                                                        true,
                                                                    //合代码 解开
                                                                    // hideChangeBtn:true
                                                                  )));
                                                },
                                                child: Container(
                                                  width: 70,
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          39, 153, 93, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    '详情',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ))),
          )),
        ],
      ),
    );
  }
}
