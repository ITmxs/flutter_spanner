import 'package:flutter/material.dart';
import 'package:spanners/cTools/yPickerTime.dart';

class InsuranceAddFirst extends StatefulWidget {
  @override
  _InsuranceAddFirstState createState() => _InsuranceAddFirstState();
}

class _InsuranceAddFirstState extends State<InsuranceAddFirst> {
  List carTitles = ['被保车辆', '被保险人姓名', '联系人姓名', '联系人电话', '商业险到期日', '交强险到期日'];
  DateTime nowTime = DateTime.now();
  String startTime = ''; //商业险到期日
  String endTime = ''; //交强险到期日
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        centerTitle: true,
        title: Text('扳手保险',
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
      body: ListView(
        children: [carList(), photoArea()],
      ),
    );
  }

  //车辆信息填写
  carList() {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            SizedBox(
              width: 21,
            ),
            Text('车辆信息',
                style: TextStyle(
                  color: Color.fromRGBO(39, 153, 93, 1),
                  fontSize: 18,
                )),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: carTitles.length,
                itemBuilder: (BuildContext context, int item) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 26,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 11,
                          ),
                          Text(carTitles[item],
                              style: TextStyle(
                                color: Color.fromRGBO(30, 30, 30, 1),
                                fontSize: 15,
                              )),
                          Expanded(
                            child: SizedBox(),
                          ),
                          carTitles[item] == '商业险到期日'
                              ? GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    YinPicker.showDatePicker(context,
                                        nowTimes: nowTime,
                                        dateType: DateType.YMD,
                                        title: "",
                                        minValue: DateTime(
                                          2015,
                                          10,
                                        ),
                                        maxValue: DateTime(
                                          2023,
                                          10,
                                        ),
                                        value: DateTime(nowTime.year,
                                            nowTime.month, nowTime.day),
                                        clickCallback: (var str, var time) {
                                      setState(() {
                                        var month = time.month < 10
                                            ? '0${time.month}'
                                            : time.month.toString();
                                        startTime =
                                            '${time.year}-$month-${time.day}';
                                        // dataMap['beginTime'] = startTime;
                                      });
                                    });
                                  },
                                  child: Text(
                                    startTime == '' ? '请选择' : startTime,
                                    style: TextStyle(
                                        color: startTime == ''
                                            ? Color.fromRGBO(164, 164, 164, 1)
                                            : Color.fromRGBO(40, 40, 40, 1),
                                        fontSize: 14),
                                  ),
                                )
                              : carTitles[item] == '交强险到期日'
                                  ? GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        YinPicker.showDatePicker(context,
                                            nowTimes: nowTime,
                                            dateType: DateType.YMD,
                                            title: "",
                                            minValue: DateTime(
                                              2015,
                                              10,
                                            ),
                                            maxValue: DateTime(
                                              2023,
                                              10,
                                            ),
                                            value: DateTime(nowTime.year,
                                                nowTime.month, nowTime.day),
                                            clickCallback: (var str, var time) {
                                          setState(() {
                                            var month = time.month < 10
                                                ? '0${time.month}'
                                                : time.month.toString();
                                            endTime =
                                                '${time.year}-$month-${time.day}';
                                          });
                                        });
                                      },
                                      child: Text(
                                        endTime == '' ? '请选择' : endTime,
                                        style: TextStyle(
                                            color: endTime == ''
                                                ? Color.fromRGBO(
                                                    164, 164, 164, 1)
                                                : Color.fromRGBO(40, 40, 40, 1),
                                            fontSize: 14),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.centerRight,
                                      child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: 20, maxWidth: 100),
                                          child: TextFormField(
                                            // controller: _czpriceController,
                                            // inputFormatters: [KeyboardLimit(1)],
                                            // keyboardType:
                                            //     TextInputType.numberWithOptions(decimal: true),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 0),
                                              hintText: '请输入',
                                              hintStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      164, 164, 164, 1),
                                                  fontSize: 14),
                                              border: new OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                            ),
                                            onChanged: (value) {
                                              //dataMap['accountPrice'] = value;
                                            },
                                          ))),
                          carTitles[item] == '商业险到期日'
                              ? Icon(
                                  Icons.chevron_right,
                                  color: startTime == ''
                                      ? Color.fromRGBO(164, 164, 164, 1)
                                      : Color.fromRGBO(40, 40, 40, 1),
                                )
                              : carTitles[item] == '交强险到期日'
                                  ? Icon(
                                      Icons.chevron_right,
                                      color: endTime == ''
                                          ? Color.fromRGBO(164, 164, 164, 1)
                                          : Color.fromRGBO(40, 40, 40, 1),
                                    )
                                  : Icon(Icons.chevron_right,
                                      color: Colors.white)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      item == carTitles.length - 1
                          ? Container()
                          : Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 1,
                              color: Color.fromRGBO(238, 238, 238, 1),
                            )
                    ],
                  );
                },
              ),
            )
          ],
        )
      ],
    );
  }

  //证件照
  photoArea() {
    return Container();
  }
}
