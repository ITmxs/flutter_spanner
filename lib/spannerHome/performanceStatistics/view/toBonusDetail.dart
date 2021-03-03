import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/common/commonWidget.dart';

class ToBonusDetail extends StatefulWidget {
  @override
  _ToBonusDetailState createState() => _ToBonusDetailState();
}

class _ToBonusDetailState extends State<ToBonusDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "结算详情"),
      body: ListView(
        children: [
          userInfo(),
          serverList(),
        ],
      ),

    );


  }
  userInfo(){
    return Column(
      children: [
        SizedBox(
          height: 26,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: [
              Container(
                color: AppColors.primaryColor,
                width: 4,
                height: 16,
                margin: EdgeInsets.only(right: 10,top: 2),
              ),
              CommonWidget.font(text: "用户信息",size: 18.0)
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.white,
          ),
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),

          child:Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "车牌号"),
                      CommonWidget.font(text: ""),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "车辆品牌"),
                      CommonWidget.font(text: ""),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "车辆型号"),
                      CommonWidget.font(text: ""),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "车主姓名"),
                      CommonWidget.font(text: ""),
                    ],
                  ),
                ),
              ),
              Container(
                height: 46,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CommonWidget.font(text: "显示更多信息",size: 12.0,color: Color.fromRGBO(178, 178, 178, 1)),
                    SizedBox(height: 5,),
                    Image.asset("Assets/performance/down.png",width: 14,height: 6,),
                    SizedBox(height: 5,),

                  ],
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }
  serverList(){
    return Column(
      children: [
        SizedBox(
          height: 26,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: [
              Container(
                color: AppColors.primaryColor,
                width: 4,
                height: 16,
                margin: EdgeInsets.only(right: 10,top: 2),
              ),
              CommonWidget.font(text: "服务清单",size: 18.0)
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),

          child:Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "名称"),
                      CommonWidget.font(text: "规格"),
                      CommonWidget.font(text: "单价"),
                      CommonWidget.font(text: "数量"),
                      CommonWidget.font(text: "总价"),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: ""),
                      CommonWidget.font(text: ""),
                      CommonWidget.font(text: ""),
                      CommonWidget.font(text: ""),
                      CommonWidget.font(text: ""),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "机油"),
                      CommonWidget.font(text: "040"),
                      CommonWidget.font(text: "¥400"),
                      CommonWidget.font(text: "1"),
                      CommonWidget.font(text: "¥400"),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "机油"),
                      CommonWidget.font(text: "040"),
                      CommonWidget.font(text: "¥400"),
                      CommonWidget.font(text: "1"),
                      CommonWidget.font(text: "¥400"),
                    ],
                  ),
                ),
              ),



            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),

          child:Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "名称"),
                      CommonWidget.font(text: "规格"),
                      CommonWidget.font(text: "单价"),
                      CommonWidget.font(text: "数量"),
                      CommonWidget.font(text: "总价"),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "普通机车",size: 12.0),
                      CommonWidget.font(text: "/",size: 12.0),
                      CommonWidget.font(text: "¥400",size: 12.0),
                      CommonWidget.font(text: "1",size: 12.0),
                      CommonWidget.font(text: "¥400",size: 12.0),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "机油"),
                      CommonWidget.font(text: "040"),
                      CommonWidget.font(text: "¥400"),
                      CommonWidget.font(text: "1"),
                      CommonWidget.font(text: "¥400"),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "机油"),
                      CommonWidget.font(text: "040"),
                      CommonWidget.font(text: "¥400"),
                      CommonWidget.font(text: "1"),
                      CommonWidget.font(text: "¥400"),
                    ],
                  ),
                ),
              ),



            ],
          ),
        ),
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),

          child:Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset("Assets/performance/card.png",width: 15,height: 20,),
                          SizedBox(width: 5,),
                          CommonWidget.font(text: "优惠卡"),
                        ],
                      ),
                    
                      CommonWidget.font(text: "-¥200",color: Color.fromRGBO(255, 77, 76, 1)),

                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "洗车优惠卡"),
                      CommonWidget.font(text: "抵扣1次",color: Color.fromRGBO(255, 77, 76, 1)),

                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "保养优惠卡"),
                      CommonWidget.font(text: "抵扣1次",color: Color.fromRGBO(255, 77, 76, 1)),
                    ],
                  ),
                ),
              ),




            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),

          child:Column(
            children: [
              Container(
                height: 45,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CommonWidget.font(text: "消费金额"),
                        ],
                      ),

                      CommonWidget.font(text: "¥1200"),

                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CommonWidget.font(text: "预付金额"),
                        ],
                      ),

                      CommonWidget.font(text: "¥1200"),

                    ],
                  ),
                ),
              ),
              Container(
                height: 45,

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CommonWidget.font(text: "尾款金额"),
                        ],
                      ),

                      CommonWidget.font(text: "¥1200"),

                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border:Border(top: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CommonWidget.font(text: "已优惠",size: 13.0),
                      CommonWidget.font(text: "¥200",color: Color.fromRGBO(255, 48, 48, 1),size: 13.0),
                      SizedBox(width: 15,),
                      CommonWidget.font(text: "合计",size: 13.0),
                      CommonWidget.font(text: "¥200",color: Color.fromRGBO(255, 48, 48, 1),size: 18.0),


                    ],
                  ),
                ),
              )





            ],
          ),
        ),
        SizedBox(height: 40),
        CommonWidget.button(text: "填写分红",width: 84.0,height: 28.0),
        SizedBox(height: 110),

      ],
    );
  }
}
