import 'package:flutter/material.dart';
import 'package:spanners/cModel/budgetModel.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/budgetStatistical.dart/budgetApiRequst.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_details_page.dart';
import 'package:spanners/spannerHome/settlement/view/settlement_nonmember_page.dart';
import 'package:spanners/weCenter/share_order/page/share_goods_order_detals.dart';
import 'package:spanners/weCenter/share_order/page/share_goods_order_page.dart';

class DudgetDetail extends StatefulWidget {
  final String titles;
  final String types;
  final bool isof;
  final String nowMonth;
  final String serviceId;
  final serviceFlg;
  final int showThree; //展示行数
  const DudgetDetail(
      {Key key,
      this.titles,
      this.types,
      this.nowMonth,
      this.serviceId,
      this.serviceFlg,
      this.showThree,
      this.isof})
      : super(key: key);
  @override
  _DudgetDetailState createState() => _DudgetDetailState();
}

class _DudgetDetailState extends State<DudgetDetail> {
  DateTime date;
  DateTime nowTime = DateTime.now();
  DateTime now = DateTime.now();
  String timeShow; //用于选择展示
  List dataList = List(); //获取数据集
  String nowSumPrice = ''; //当前月总额
  //获取详情
  _getDetailRequestMessage(String yearMonth) {
    BudgetApi.getDetailRequest(
      param: {
        'nowMonth': yearMonth,
        'serviceId': widget.serviceId,
        'serviceFlg': widget.serviceFlg,
      },
      onSuccess: (data) {
        setState(() {
          nowSumPrice = '${data['nowMonthIncome']}';
          dataList = data['accountantExplicitDtoList'];
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDetailRequestMessage(widget.nowMonth);
    timeShow = widget.nowMonth;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.titles,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: [
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 33,
                  ),
                  Text(
                    widget.types,
                    style: TextStyle(
                        color: Color.fromRGBO(49, 46, 46, 1),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    nowSumPrice,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 77, 76, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      YinPicker.showDatePicker(context,
                          nowTimes: date == null ? nowTime : date,
                          dateType: DateType.YM,
                          // dateType: DateType.YM,
                          // dateType: DateType.YMD_HM,
                          // dateType: DateType.YMD_AP_HM,
                          title: "",
                          minValue: DateTime(
                            2015,
                            10,
                          ),
                          maxValue: DateTime(
                            2023,
                            10,
                          ),
                          value: date == null
                              ? DateTime(
                                  now.year,
                                  now.month,
                                )
                              : DateTime(
                                  date.year,
                                  date.month,
                                ), clickCallback: (var str, var time) {
                        print(str);
                        print(time);
                        setState(() {
                          var month = time.month < 10
                              ? '0${time.month}'
                              : time.month.toString();
                          timeShow = '${time.year}-$month';
                          _getDetailRequestMessage(timeShow);
                          date = time;
                        });
                      });
                      //日期时间选择 年月日
                    },
                    child: Container(
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromRGBO(195, 233, 213, 1),
                              width: 1.0),
                          color: Colors.white),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            timeShow,
                            style: TextStyle(
                              color: Color.fromRGBO(8, 8, 8, 1),
                              fontSize: 13,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Color.fromRGBO(8, 8, 8, 1),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 37,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),

              //收支统计
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        56 -
                        52,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: ListView(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      children: List.generate(
                          dataList.length,
                          (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  //时间详情
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 21,
                                      ),
                                      Text(
                                        BudgetDetailModel.fromJson(
                                                dataList[index])
                                            .createTime,
                                        style: TextStyle(
                                          color: Color.fromRGBO(30, 30, 30, 1),
                                          fontSize: 13,
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      widget.serviceFlg == '1'
                                          ? Container()
                                          : widget.serviceFlg == '6' ||
                                                  widget.serviceFlg == '3'
                                              ? BudgetDetailModel.fromJson(
                                                              dataList[index])
                                                          .serviceNameCn ==
                                                      '统计事项'
                                                  ? Container()
                                                  : InkWell(
                                                      onTap: () {
                                                        BudgetDetailModel.fromJson(
                                                                        dataList[
                                                                            index])
                                                                    .serviceNameCn ==
                                                                '车主订单'
                                                            ? Alart
                                                                .showAlartDialog(
                                                                    '暂未开放', 1)
                                                            : BudgetDetailModel.fromJson(dataList[index])
                                                                        .serviceNameCn ==
                                                                    '共享订单'
                                                                ? BudgetDetailModel.fromJson(dataList[index])
                                                                            .type ==
                                                                        '1' //共享商品
                                                                    ? Navigator
                                                                        .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ShareGoodsOrderDetailsPage(
                                                                                  tradeId: dataList[index]['tradeId'].toString(),
                                                                                  tradeStatus: '3',
                                                                                  shareGoodsOrderType: widget.isof ? ShareGoodsOrderType.ShareGoodsOrderBuy : ShareGoodsOrderType.ShareGoodsOrderSell,
                                                                                  shareType: '1',
                                                                                )),
                                                                      )
                                                                    : BudgetDetailModel.fromJson(dataList[index]).type ==
                                                                            '2' //共享工具
                                                                        ? Navigator
                                                                            .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => ShareGoodsOrderDetailsPage(
                                                                                      tradeId: dataList[index]['tradeId'].toString(),
                                                                                      tradeStatus: '8',
                                                                                      shareGoodsOrderType: widget.isof ? ShareGoodsOrderType.ShareGoodsOrderBuy : ShareGoodsOrderType.ShareGoodsOrderSell,
                                                                                      shareType: '2',
                                                                                    )),
                                                                          )
                                                                        : BudgetDetailModel.fromJson(dataList[index]).type ==
                                                                                '3' //共享配件
                                                                            ? Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => ShareGoodsOrderDetailsPage(
                                                                                          tradeId: dataList[index]['tradeId'].toString(),
                                                                                          tradeStatus: '3',
                                                                                          shareGoodsOrderType: widget.isof ? ShareGoodsOrderType.ShareGoodsOrderBuy : ShareGoodsOrderType.ShareGoodsOrderSell,
                                                                                          shareType: '3',
                                                                                        )),
                                                                              )
                                                                            : print('')
                                                                /** 
                                                           这里做 逻辑跳转 除了 个别项
                                                           都是跳转 结算详情
                                                            */
                                                                //跳转 结算详情
                                                                : dataList[index]['memberId'] == null
                                                                    ? Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => SettlementNonmemberPage(
                                                                                dataList[index]['workOrderId'].toString(),
                                                                                dataList[index]['vehicleLicence'],
                                                                                true)),
                                                                      )
                                                                    : Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => SettlementDetailsPage(
                                                                                dataList[index]['workOrderId'].toString(),
                                                                                dataList[index]['vehicleLicence'],
                                                                                true)),
                                                                      );
                                                      },
                                                      child: Text(
                                                        '详情',
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              39, 153, 93, 1),
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    )
                                              : InkWell(
                                                  onTap: () {
                                                    /** 
                                             这里做 逻辑跳转 除了 个别项
                                             都是跳转 结算详情
                                            */
                                                    BudgetDetailModel.fromJson(
                                                                    dataList[
                                                                        index])
                                                                .serviceNameCn ==
                                                            '采购入库'
                                                        ? RouterUtil.push(
                                                            context,
                                                            routerName:
                                                                "purchaseDetail",
                                                            data: {
                                                              "purchaseId":
                                                                  BudgetDetailModel
                                                                          .fromJson(
                                                                              dataList[index])
                                                                      .id,
                                                            },
                                                          )
                                                        : BudgetDetailModel.fromJson(
                                                                        dataList[
                                                                            index])
                                                                    .serviceNameCn ==
                                                                '即采即入'
                                                            ? RouterUtil.push(
                                                                context,
                                                                routerName:
                                                                    "materialDetail",
                                                                data: BudgetDetailModel.fromJson(
                                                                        dataList[
                                                                            index])
                                                                    .purchaseId)
                                                            :

                                                            //跳转 结算详情
                                                            dataList[index]
                                                                        ['memberId'] ==
                                                                    null
                                                                ? Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => SettlementNonmemberPage(
                                                                            dataList[index]['workOrderId'].toString(),
                                                                            dataList[index]['vehicleLicence'],
                                                                            true)),
                                                                  )
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => SettlementDetailsPage(
                                                                            dataList[index]['workOrderId'].toString(),
                                                                            dataList[index]['vehicleLicence'],
                                                                            true)),
                                                                  );
                                                  },
                                                  child: Text(
                                                    '详情',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          39, 153, 93, 1),
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                      SizedBox(
                                        width: 20,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  //名称 金额
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 21,
                                      ),
                                      widget.serviceFlg == '1' ||
                                              widget.serviceFlg == '3' ||
                                              widget.serviceFlg == '4' ||
                                              widget.serviceFlg == '6'
                                          ? Container()
                                          : Text(
                                              BudgetDetailModel.fromJson(
                                                      dataList[index])
                                                  .vehicleLicence,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      30, 30, 30, 1),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      widget.serviceFlg == '1' ||
                                              widget.serviceFlg == '3' ||
                                              widget.serviceFlg == '4' ||
                                              widget.serviceFlg == '6'
                                          ? Container()
                                          : SizedBox(
                                              width: 40,
                                            ),
                                      Container(
                                        width: 80,
                                        child: Text(
                                          BudgetDetailModel.fromJson(
                                                  dataList[index])
                                              .serviceNameCn,
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(30, 30, 30, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          '¥${BudgetDetailModel.fromJson(dataList[index]).price}',
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(30, 30, 30, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  // 判断展示 三行还是两行
                                  widget.showThree == 3
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              width: 21,
                                            ),
                                            /**   
                                         这里  展示内容还是 编号 共享订单等等 逻辑需要与后台沟通
                                         */
                                            Text(
                                              widget.types == '额外收入' ||
                                                      widget.types == '其他' ||
                                                      widget.types == '其他收入' ||
                                                      widget.types == '其他支出' ||
                                                      BudgetDetailModel.fromJson(
                                                                  dataList[
                                                                      index])
                                                              .serviceNameCn ==
                                                          '统计事项'
                                                  ? BudgetDetailModel.fromJson(
                                                          dataList[index])
                                                      .recordItem
                                                  : BudgetDetailModel.fromJson(
                                                          dataList[index])
                                                      .orderSn,
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    133, 133, 133, 1),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    height: 1,
                                    color: Color.fromRGBO(229, 229, 229, 1),
                                  ),
                                  index == 9
                                      ? SizedBox(
                                          height: 20,
                                        )
                                      : SizedBox(
                                          height: 0,
                                        ),
                                  index == dataList.length - 1
                                      ? SizedBox(
                                          height: 40,
                                        )
                                      : Container(),
                                ],
                              )),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
