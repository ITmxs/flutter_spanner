import 'package:flutter/material.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/keyboardLimit.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/spannerHome/budgetStatistical.dart/budgetApiRequst.dart';
import 'package:spanners/spannerHome/budgetStatistical.dart/budgetStatisticalView.dart';

class AddBudgetStatistical extends StatefulWidget {
  @override
  _AddBudgetStatisticalState createState() => _AddBudgetStatisticalState();
}

class _AddBudgetStatisticalState extends State<AddBudgetStatistical> {
  String categoryString = '';
  int category = 999;
  String recordItem = '';
  String money = '';
  //添加统计
  _creatSave() {
    BudgetApi.creatAccounttantRequest(
      param: {
        'category': category.toString(), //传入0或1    0：收入    1：支出
        'money': money,
        'recordItem': recordItem,
      },
      onSuccess: (data) {
        //创建成功
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BudgetStatisticalView()));
      },
    );
  }

  static Future _showDialog(String message, int value) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowAlart(
          title: message,
          backLart: value,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text('添加统计',
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
                height: 10,
              ),
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
                        10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 11,
                                  ),
                                  Text(
                                    '统计分类',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      showModalBottomSheet(
                                        isDismissible: true,
                                        enableDrag: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return new Container(
                                            height: 300.0,
                                            child: ShowBottomSheet(
                                              type: 4,
                                              dataList: ['收入', '支出'],
                                              onChanged: (name) {
                                                setState(() {
                                                  print(name);
                                                  categoryString = name;
                                                  if (name == '收入') {
                                                    category = 0;
                                                  }
                                                  if (name == '支出') {
                                                    category = 1;
                                                  }
                                                });
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        children: [
                                          Text(
                                            categoryString == ''
                                                ? '请选择'
                                                : categoryString,
                                            style: TextStyle(
                                                color: categoryString == ''
                                                    ? Color.fromRGBO(
                                                        159, 159, 159, 1)
                                                    : Color.fromRGBO(
                                                        8, 8, 8, 1),
                                                fontSize: 15),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color.fromRGBO(
                                                159, 159, 159, 1),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width - 30,
                                color: Color.fromRGBO(229, 229, 229, 1),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 11,
                                  ),
                                  Text(
                                    '统计事项',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: 20, maxWidth: 100),
                                      child: TextFormField(
                                        onChanged: (value) {
                                          print('名称== >:$value');
                                          recordItem = value;
                                        },

                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 0),
                                          hintText: '请输入',
                                          hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  164, 164, 164, 1),
                                              fontSize: 15),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        // keyboardType: TextInputType.multiline,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width - 30,
                                color: Color.fromRGBO(229, 229, 229, 1),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 11,
                                  ),
                                  Text(
                                    '金额  ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: 20, maxWidth: 100),
                                      child: TextFormField(
                                        inputFormatters: [KeyboardLimit(1)],
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        onChanged: (value) {
                                          print('名称== >:$value');
                                          money = value;
                                        },

                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 0),
                                          hintText: '请输入',
                                          hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  164, 164, 164, 1),
                                              fontSize: 15),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        // keyboardType: TextInputType.multiline,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width - 30,
                                color: Color.fromRGBO(229, 229, 229, 1),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              if (category == 999 ||
                                  recordItem == '' ||
                                  money == '') {
                                _showDialog('请确认填写项', 1);
                              } else {
                                _creatSave();
                              }
                            },
                            child: Container(
                              width: 102,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromRGBO(39, 153, 93, 1)),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '确认添加',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
