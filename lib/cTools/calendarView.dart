import 'package:flutter/material.dart';

/*
       日历选择器
*/
class CalendarView extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const CalendarView({Key key, this.onChanged}) : super(key: key);
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List week = [
    '日',
    '一',
    '二',
    '三',
    '四',
    '五',
    '六',
  ];

  /* 选中 标识*/
  int selectValue = 40; // 天
  int monthValue = 13; // 月
  int yearValue = 100; // 年
  /* 左右月份 选择*/
  int monthIn = 0;
  //创建时间对象，获取当前时间
  DateTime now = DateTime.now();

  /* 获取这个月的天数   ⬇️*/
  List<int> _monthDays = <int>[31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      if (isLeapYear) return 29;
      return 28;
    }
    return _monthDays[month - 1];
  }
  /* 获取这个月的天数   ⬆️*/

  /* 得到这个月的第一天是星期几（0 是星期日 1 是星期一...）⬇️*/
  int computeFirstDayOffset(
      int year, int month, MaterialLocalizations localizations) {
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;

    final int firstDayOfWeekFromSunday = localizations.firstDayOfWeekIndex;

    final int firstDayOfWeekFromMonday = (firstDayOfWeekFromSunday - 1) % 7;

    return (weekdayFromMonday - firstDayOfWeekFromMonday) % 7;
  }
  /* 得到这个月的第一天是星期几（0 是星期日 1 是星期一...）⬆️*/

  /* 排版从 周几 开始  一个 多少单元格⬇️ */
  int fromLocationNums(int year, int month) {
    var day = getDaysInMonth(year, month);
    var index =
        computeFirstDayOffset(year, month, MaterialLocalizations.of(context));
    var nums = day + index;
    return nums;
  }
  /* 排版  从周几 开始  一共 多少单元格 ⬆️ */

  /* 排版  动态添加 day 数组 ⬇️ */
  List getDays(int year, int month) {
    var nums =
        computeFirstDayOffset(year, month, MaterialLocalizations.of(context));
    List day = [
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
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List one = [
      '',
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
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List two = [
      '',
      '',
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
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List three = [
      '',
      '',
      '',
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
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List four = [
      '',
      '',
      '',
      '',
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
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List five = [
      '',
      '',
      '',
      '',
      '',
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
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    List six = [
      '',
      '',
      '',
      '',
      '',
      '',
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
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
    ];
    if (nums == 1) {
      return one;
    } else if (nums == 2) {
      return two;
    } else if (nums == 3) {
      return three;
    } else if (nums == 4) {
      return four;
    } else if (nums == 5) {
      return five;
    } else if (nums == 6) {
      return six;
    } else {
      return day;
    }
  }
  /* 排版  动态添加 day 数组 ⬆️ */

  /* 标示 今天 日期 */
  bool today(int index) {
    if (monthIn == 0) {
      var todays = getDays(now.year, now.month)[index];
      var nowday = now.day > 9 ? now.day.toString() : '0${now.day}';
      if (todays == nowday) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /* 当前选中日期 */
  bool selectDay(int index) {
    var years = (now.month + monthIn) > 12 ? now.year + 1 : now.year;
    var months = (now.month + monthIn) > 12
        ? (now.month + monthIn) - 12
        : now.month + monthIn;
    if (years == yearValue && monthValue == months && index == selectValue) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        monthIn == 0 ? monthIn = 0 : monthIn = monthIn - 1;
                      });
                    },
                    child: Icon(
                      Icons.chevron_left,
                      color: monthIn == 0
                          ? Colors.transparent
                          : Color.fromRGBO(39, 153, 93, 0.4),
                      size: 35,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${(now.month + monthIn) > 12 ? now.year + 1 : now.year}年${(now.month + monthIn) > 12 ? (now.month + monthIn) - 12 : now.month + monthIn}月',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      )),
                  Expanded(child: SizedBox()),
                  InkWell(
                      onTap: () {
                        setState(() {
                          monthIn == 6 ? monthIn = 6 : monthIn = monthIn + 1;
                        });
                      },
                      child: Icon(
                        Icons.chevron_right,
                        color: monthIn == 6
                            ? Colors.transparent
                            : Color.fromRGBO(39, 153, 93, 0.4),
                        size: 35,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: new NeverScrollableScrollPhysics(), //禁止滑动
                  itemCount: 7,
                  //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 7,
                      //纵轴间距
                      mainAxisSpacing: 10.0,
                      //横轴间距
                      crossAxisSpacing: 10.0,
                      //子组件宽高长度比例
                      childAspectRatio: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    //Widget Function(BuildContext context, int index)
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        week[index],
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    );
                  }),
              GridView.builder(
                  shrinkWrap: true,
                  physics: new NeverScrollableScrollPhysics(), //禁止滑动
                  itemCount: fromLocationNums(
                      (now.month + monthIn) > 12 ? now.year + 1 : now.year,
                      (now.month + monthIn) > 12
                          ? (now.month + monthIn) - 12
                          : now.month + monthIn),
                  //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 7,
                      //纵轴间距
                      mainAxisSpacing: 0.0,
                      //横轴间距
                      crossAxisSpacing: 20.0,
                      //子组件宽高长度比例
                      childAspectRatio: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    //
                    return InkWell(
                      onTap: () {
                        getDays(
                                    (now.month + monthIn) > 12
                                        ? now.year + 1
                                        : now.year,
                                    (now.month + monthIn) > 12
                                        ? (now.month + monthIn) - 12
                                        : now.month + monthIn)[index] ==
                                ''
                            ? print('')
                            : setState(() {
                                selectValue = index;
                                monthValue = (now.month + monthIn) > 12
                                    ? (now.month + monthIn) - 12
                                    : now.month + monthIn;
                                yearValue = (now.month + monthIn) > 12
                                    ? now.year + 1
                                    : now.year;
                                String month = monthValue > 9
                                    ? '$monthValue'
                                    : '0$monthValue';

                                widget.onChanged(
                                    '$yearValue-$month-${getDays((now.month + monthIn) > 12 ? now.year + 1 : now.year, (now.month + monthIn) > 12 ? (now.month + monthIn) - 12 : now.month + monthIn)[index]}');
                              });
                      },
                      child: Container(
                        // width: 25,
                        // height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:
                                /*  对 月和日 做判断   */
                                selectDay(index)
                                    ? Color.fromRGBO(39, 153, 93, 0.1)
                                    : Colors.transparent),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            getDays(
                                (now.month + monthIn) > 12
                                    ? now.year + 1
                                    : now.year,
                                (now.month + monthIn) > 12
                                    ? (now.month + monthIn) - 12
                                    : now.month + monthIn)[index],
                            style: today(index)
                                ?
                                /* today */
                                TextStyle(
                                    color: Color.fromRGBO(39, 153, 93, 0.7),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)
                                :
                                /*正常日期  显示*/
                                TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
