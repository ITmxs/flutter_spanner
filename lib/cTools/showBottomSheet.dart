import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:spanners/cTools/notificationCenter.dart';
import './calendarView.dart';
import './dateTimerPicker.dart';

/*   
 单 种类  选择器  
*/
class ShowBottomSheet extends StatefulWidget {
  final int type; //1,一级分类  2，二级分类 3.派工人员 4.统计分类
  final List dataList; //
  final Function(String name, String id) onChanges;
  final ValueChanged<String> onChanged;

  const ShowBottomSheet({
    Key key,
    this.onChanged,
    this.dataList,
    this.type,
    this.onChanges,
  }) : super(key: key);

  @override
  _ShowBottomSheetState createState() => _ShowBottomSheetState();
}

class _ShowBottomSheetState extends State<ShowBottomSheet> {
  int selectValue = 0;
  List mapList = List(); //之外的
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('传输${widget.dataList}');
    if (widget.type == 3 || widget.type == 13) {
      for (var i = 0; i < widget.dataList.length; i++) {
        mapList.add(widget.dataList[i]['realName']);
      }
    }
    if (widget.type == 14) {
      for (var i = 0; i < widget.dataList.length; i++) {
        mapList.add(widget.dataList[i]['shopname']);
      }
    }
    if (widget.type == 9 || widget.type == 10) {
      if (widget.type == 9) {
        mapList.add('全部员工');
      }
      for (var i = 0; i < widget.dataList.length; i++) {
        mapList.add(widget.dataList[i]['realName']);
      }
    }
    if (widget.type == 11) {
      for (var i = 0; i < widget.dataList.length; i++) {
        mapList.add(widget.dataList[i]['taskName']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 - 70 / 2,
              height: 50,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.type == 1
                          ? '项目种类'
                          : widget.type == 2
                              ? '项目名称'
                              : widget.type == 3
                                  ? '派工人员'
                                  : widget.type == 4
                                      ? '统计分类'
                                      : widget.type == 5
                                          ? '配件来源'
                                          : widget.type == 6
                                              ? '性别'
                                              : widget.type == 7
                                                  ? '角色'
                                                  : widget.type == 8
                                                      ? '组别'
                                                      : widget.type == 9 ||
                                                              widget.type == 10
                                                          ? '员工'
                                                          : widget.type == 11
                                                              ? '销售任务'
                                                              : widget.type ==
                                                                      12
                                                                  ? '使用期限'
                                                                  : widget.type ==
                                                                          13
                                                                      ? '领料人员'
                                                                      : widget.type ==
                                                                              14
                                                                          ? '门店切换'
                                                                          : '',
                      style: TextStyle(
                          color: Color.fromRGBO(58, 57, 57, 1), fontSize: 16),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 70 / 2,
                    height: 3,
                    color: Color.fromRGBO(39, 153, 93, 1),
                  )
                ],
              ),
            ),
            Container(
              width: 70,
              height: 50,
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(child: SizedBox()),
                  Container(
                      width: 70,
                      height: 3,
                      color: Color.fromRGBO(220, 220, 220, 1))
                ],
              ),
            ),
            InkWell(
              onTap: () {
                /*  点击确定的 相关操作  */
                if (widget.type == 3 || widget.type == 13) {
                  if (selectValue == 0) {
                    for (var i = 0; i < widget.dataList.length; i++) {
                      if (mapList[0] == widget.dataList[i]['realName']) {
                        widget.onChanges(widget.dataList[i]['realName'],
                            widget.dataList[i]['id']);
                      }
                    }
                  } else {
                    for (var i = 0; i < widget.dataList.length; i++) {
                      if (mapList[selectValue] ==
                          widget.dataList[i]['realName']) {
                        widget.onChanges(widget.dataList[i]['realName'],
                            widget.dataList[i]['id']);
                      }
                    }
                  }
                } else if (widget.type == 14) {
                  if (selectValue == 0) {
                    for (var i = 0; i < widget.dataList.length; i++) {
                      if (mapList[0] == widget.dataList[i]['shopname']) {
                        widget.onChanges(widget.dataList[i]['shopname'],
                            widget.dataList[i]['shopId']);
                      }
                    }
                  } else {
                    for (var i = 0; i < widget.dataList.length; i++) {
                      if (mapList[selectValue] ==
                          widget.dataList[i]['shopname']) {
                        widget.onChanges(widget.dataList[i]['shopname'],
                            widget.dataList[i]['shopId']);
                      }
                    }
                  }
                } else if (widget.type == 9 || widget.type == 10) {
                  if (selectValue == 0) {
                    if (widget.type == 9) {
                      widget.onChanges('全部员工', '');
                    }
                    if (widget.type == 10) {
                      for (var i = 0; i < widget.dataList.length; i++) {
                        if (mapList[0] == widget.dataList[i]['realName']) {
                          widget.onChanges(widget.dataList[i]['realName'],
                              widget.dataList[i]['userId']);
                        }
                      }
                    }
                  } else {
                    for (var i = 0; i < widget.dataList.length; i++) {
                      if (mapList[selectValue] ==
                          widget.dataList[i]['realName']) {
                        widget.onChanges(widget.dataList[i]['realName'],
                            widget.dataList[i]['userId']);
                      }
                    }
                  }
                } else if (widget.type == 11) {
                  if (selectValue == 0) {
                    for (var i = 0; i < widget.dataList.length; i++) {
                      if (mapList[0] == widget.dataList[i]['taskName']) {
                        widget.onChanges(widget.dataList[i]['taskName'],
                            widget.dataList[i]['id']);
                      }
                    }
                  } else {
                    for (var i = 0; i < widget.dataList.length; i++) {
                      if (mapList[selectValue] ==
                          widget.dataList[i]['taskName']) {
                        widget.onChanges(widget.dataList[i]['taskName'],
                            widget.dataList[i]['id']);
                      }
                    }
                  }
                } else {
                  if (selectValue == 0) {
                    widget.onChanged(widget.dataList[0].toString());
                  } else {
                    widget.onChanged(widget.dataList[selectValue].toString());
                  }
                }

                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 70 / 2,
                height: 50,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '确定      ',
                        style: TextStyle(
                            color: Color.fromRGBO(44, 44, 44, 1), fontSize: 16),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 70 / 2,
                      height: 3,
                      color: Color.fromRGBO(220, 220, 220, 1),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 250,
          child: CupertinoPicker(
            itemExtent: 25,
            onSelectedItemChanged: (value) {
              setState(() {
                selectValue = value;
              });
            },
            children: widget.type == 3 ||
                    widget.type == 9 ||
                    widget.type == 10 ||
                    widget.type == 11 ||
                    widget.type == 13 ||
                    widget.type == 14
                ? mapList.map((data) {
                    return Text(
                      data,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    );
                  }).toList()
                : widget.dataList.map((data) {
                    return Text(
                      data,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    );
                  }).toList(),
          ),
        )
      ],
    ));
  }
}

/*

 日期(日历) 时间 选择器

*/
class DatePickerView extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const DatePickerView({Key key, this.onChanged}) : super(key: key);

  @override
  _DatePickerViewState createState() => _DatePickerViewState();
}

class _DatePickerViewState extends State<DatePickerView> {
  bool pickerBool = true;
  String years = '';
  String times = '';

  //创建时间对象，获取当前时间
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: pickerBool ? 400 : 250,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              /*
        日期（日历） 选择器
        */
              InkWell(
                onTap: () {
                  setState(() {
                    pickerBool = true;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 70 / 2,
                  height: 50,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          years == ''
                              ? '${now.year}年${now.month}月${now.day}日'
                              : years,
                          style: TextStyle(
                              color: pickerBool
                                  ? Color.fromRGBO(58, 57, 57, 1)
                                  : Color.fromRGBO(97, 97, 97, 1),
                              fontSize: 16),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 70 / 2,
                        height: 3,
                        color: pickerBool
                            ? Color.fromRGBO(39, 153, 93, 1)
                            : Color.fromRGBO(220, 220, 220, 1),
                      )
                    ],
                  ),
                ),
              ),
              /*
        时间  选择器
        */
              InkWell(
                onTap: () {
                  setState(() {
                    pickerBool = false;
                  });
                },
                child: Container(
                  width: 70,
                  height: 50,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          times == '' ? '${now.hour}:${now.minute}' : times,
                          style: TextStyle(
                              color: pickerBool
                                  ? Color.fromRGBO(220, 220, 220, 1)
                                  : Color.fromRGBO(58, 57, 57, 1),
                              fontSize: 16),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        width: 70,
                        height: 3,
                        color: pickerBool
                            ? Color.fromRGBO(220, 220, 220, 1)
                            : Color.fromRGBO(39, 153, 93, 1),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  /* 确定 回调 参数 */
                  var nowmonth =
                      now.month > 9 ? '${now.month}' : '0${now.month}';
                  var nowday = now.day > 9 ? '${now.day}' : '0${now.day}';
                  var nowhour = now.hour > 9 ? '${now.hour}' : '0${now.hour}';
                  var nowmin =
                      now.minute > 9 ? '${now.minute}' : '0${now.minute}';
                  if (years == '' && times == '') {
                    widget.onChanged(
                        '${now.year}-$nowmonth-$nowday $nowhour:$nowmin:00');
                  } else if (years == '') {
                    widget.onChanged('${now.year}-$nowmonth-$nowday $times:00');
                  } else if (times == '') {
                    widget.onChanged('$years $nowhour:$nowmin:00');
                  } else {
                    widget.onChanged('$years $times:00');
                  }

                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 70 / 2,
                  height: 50,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '确定      ',
                          style: TextStyle(
                              color: Color.fromRGBO(44, 44, 44, 1),
                              fontSize: 16),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 70 / 2,
                        height: 3,
                        color: Color.fromRGBO(220, 220, 220, 1),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          pickerBool
              ?
              /* 日历*/
              CalendarView(
                  onChanged: (value) {
                    setState(() {
                      years = value;
                      pickerBool = false;
                    });
                  },
                )
              :
              /* 时间*/
              Container(
                  height: 200,
                  child: TimerPicker(
                    onChanged: (value) {
                      setState(() {
                        times = value.substring(0, 5);
                      });
                    },
                  ),
                )
        ],
      ),
    );
  }
}

// 年 月 选择
class YearMonth extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const YearMonth({Key key, this.onChanged}) : super(key: key);

  @override
  _YearMonthState createState() => _YearMonthState();
}

class _YearMonthState extends State<YearMonth> {
  String years = '';
  String times = '';

  //创建时间对象，获取当前时间
  DateTime now = DateTime.now();
  List yearList = [
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
  ];
  List monthList = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              /*
        日期（日历） 选择器
        */
              InkWell(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 70 / 2,
                  height: 50,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          years == ''
                              ? '${now.year}年${now.month}月${now.day}日'
                              : years,
                          style: TextStyle(
                              color: Color.fromRGBO(58, 57, 57, 1),
                              fontSize: 16),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 70 / 2,
                        height: 3,
                        color: Color.fromRGBO(39, 153, 93, 1),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 70,
                height: 50,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(child: SizedBox()),
                    Container(
                        width: 70,
                        height: 3,
                        color: Color.fromRGBO(220, 220, 220, 1))
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  /* 确定 回调 参数 */
                  var nowmonth =
                      now.month > 9 ? '${now.month}' : '0${now.month}';
                  var nowday = now.day > 9 ? '${now.day}' : '0${now.day}';
                  var nowhour = now.hour > 9 ? '${now.hour}' : '0${now.hour}';
                  var nowmin =
                      now.minute > 9 ? '${now.minute}' : '0${now.minute}';
                  if (years == '' && times == '') {
                    widget.onChanged(
                        '${now.year}-$nowmonth-$nowday $nowhour:$nowmin:00');
                  } else if (years == '') {
                    widget.onChanged('${now.year}-$nowmonth-$nowday $times:00');
                  } else if (times == '') {
                    widget.onChanged('$years $nowhour:$nowmin:00');
                  } else {
                    widget.onChanged('$years $times:00');
                  }

                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 70 / 2,
                  height: 50,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '确定      ',
                          style: TextStyle(
                              color: Color.fromRGBO(44, 44, 44, 1),
                              fontSize: 16),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 70 / 2,
                        height: 3,
                        color: Color.fromRGBO(220, 220, 220, 1),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 230 / 2,
              ),
              /* 年*/
              Container(
                width: 100,
                height: 200,
                child: CupertinoPicker(
                  itemExtent: 22,
                  onSelectedItemChanged: (value) {
                    setState(() {});
                  },
                  children: yearList.map((data) {
                    return Text(
                      data,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text('年'),
              SizedBox(
                width: 20,
              ),
              /* 月*/
              Container(
                width: 60,
                height: 200,
                child: CupertinoPicker(
                  itemExtent: 22,
                  onSelectedItemChanged: (value) {
                    setState(() {});
                  },
                  children: monthList.map((data) {
                    return Text(
                      data,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text('月'),
            ],
          )
        ],
      ),
    );
  }
}

const PROVINCES = [
  '京',
  '沪',
  '粤',
  '浙',
  '津',
  '渝',
  '川',
  '苏',
  '鄂',
  '皖',
  '湘',
  '闽',
  '黑',
  '吉',
  '辽',
  '鲁',
  '冀',
  '甘',
  '陕',
  '宁',
  '豫',
  '晋',
  '赣',
  '琼',
  '桂',
  '黔',
  '云',
  '贵',
  '青',
  '新',
  '蒙',
  '藏',
  '使',
  '临'
];
const ALPHABETS = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '0',
  'Q',
  'W',
  'E',
  'R',
  'T',
  'Y',
  'U',
  'I',
  'O',
  'P',
  'A',
  'S',
  'D',
  'F',
  'G',
  'H',
  'J',
  'K',
  'L',
  '',
  '',
  '',
  'Z',
  'X',
  'C',
  'V',
  'B',
  'N',
  'M',
  '',
  '',
  '',
  '学',
  '港',
  '澳',
  '警',
  '领'
];

class CarKeyboard extends StatefulWidget {
  final ValueChanged<String> onChanged; //传值
  final int type; //
  const CarKeyboard({
    Key key,
    this.onChanged,
    this.type,
  }) : super(key: key);

  @override
  _CarKeyboardState createState() => _CarKeyboardState();
}

class _CarKeyboardState extends State<CarKeyboard> {
  bool showBool = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.type == 1 ? showBool = false : showBool = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //移除监听
    NotificationCenter.instance.removeNotification('change');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            color: Color.fromRGBO(192, 198, 199, 0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          width: 50,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(164, 170, 174, 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '收起',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      '选择车牌号',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () {
                        widget.onChanged('del');
                        //添加监听者
                        NotificationCenter.instance.addObserver('change',
                            (object) {
                          setState(() {
                            if (object == 0) {
                              showBool = true;
                            }

                            if (object == 1) {
                              showBool = false;
                            }
                          });
                        });
                      },
                      child: Container(
                          width: 50,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(164, 170, 174, 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '删除',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: GridView.builder(
                          shrinkWrap: true,
                          // physics:  NeverScrollableScrollPhysics(),
                          //禁止滑动
                          itemCount:
                              showBool ? PROVINCES.length : ALPHABETS.length,
                          //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  //横轴元素个数
                                  crossAxisCount: showBool ? 8 : 10,
                                  //纵轴间距
                                  mainAxisSpacing: 10.0,
                                  //横轴间距
                                  crossAxisSpacing: 10.0,
                                  //子组件宽高长度比例
                                  childAspectRatio: 30 / 30),
                          itemBuilder: (BuildContext context, int item) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (showBool) {
                                    widget.onChanged(showBool
                                        ? PROVINCES[item]
                                        : ALPHABETS[item]);

                                    if (showBool) {
                                      showBool = false;
                                    }
                                  } else {
                                    if (ALPHABETS[item] == '') {
                                    } else {
                                      widget.onChanged(showBool
                                          ? PROVINCES[item]
                                          : ALPHABETS[item]);

                                      if (showBool) {
                                        showBool = false;
                                      }
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: showBool
                                        ? Colors.white
                                        : ALPHABETS[item] == ''
                                            ? Colors.transparent
                                            : Colors.white),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    showBool
                                        ? PROVINCES[item]
                                        : ALPHABETS[item],
                                    style: TextStyle(
                                        color: Color.fromRGBO(8, 8, 8, 1),
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            );
                          })),
                  SizedBox(
                    width: 10,
                  ),
                ]),
                SizedBox(
                  height: 10,
                ),
              ],
            )));
  }
}
