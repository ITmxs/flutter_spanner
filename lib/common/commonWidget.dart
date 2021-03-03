import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/common/commonTools.dart';

class CommonWidget {
  //不变的组件可以自定义成final widget类型的类属性
  //这样进行直接调用    CommonWidget.sizedBox,
  static final Widget sizedBox = SizedBox(
    height: 20.s,
  );

  //字体
  static font(
          {text = "",
          color = Colors.black,
          size = 15,
          fontWeight = FontWeight.w300,
          textAlign = TextAlign.start,
          decoration: TextDecoration.none,
          number}) =>
      Text(
        text,
        textAlign: textAlign,
        maxLines: number,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: SizeAdaptiveUtil().size(size),
            color: color,
            fontWeight: fontWeight,
            decoration: decoration),
      );

  //带图标的appbar
  static iconAppBar(
    context,
    String text, {
    textColor = Colors.black,
    elevation = 0.3,
    imageUrl = "images/appbarBack.png",
    rIcon,
  }) =>
      AppBar(
        title: Container(
            child: Text(
          text,
          style: TextStyle(
              color: Colors.black, fontSize: 20.s, fontWeight: FontWeight.w400),
        )),
        actions: <Widget>[rIcon],
        elevation: 0,
        leading: GestureDetector(
          child: Container(
            color: Colors.white,
            child: Container(
              child: Image(
                image: AssetImage('Assets/appbar/back.png'),
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      );

  //普通的appbar
  static simpleAppBar(BuildContext context,
          {String title = '', double elevationInt}) =>
      AppBar(
        title: Container(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.s,
                fontWeight: FontWeight.w400),
          ),
        ),
        elevation: elevationInt,
        leading: FlatButton(
          child: Image(
            width: 10.s,
            height: 17.s,
            image: AssetImage(
              'Assets/appbar/back.png',
            ),
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      );

  //绿色按钮
  static button({String text, double width, double height}) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.s),
            color: Color.fromRGBO(39, 153, 93, 1)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.s,
                fontFamily: 'PingFang SC Bold',
                decoration: TextDecoration.none),
          ),
        ),
      );

  //自定义按钮
  static customButton(
          {String text,
          double width,
          double height,
          textColor,
          buttonColor,
          circular,
          fontSize}) =>
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: circular ?? BorderRadius.circular(5.s),
            color: buttonColor ?? Color.fromRGBO(39, 153, 93, 1)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: fontSize ?? 16.s,
                fontFamily: 'PingFang SC Bold'),
          ),
        ),
      );

  //底部灰线
  static grayBottomBorder({colorIntValue = 220}) => BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 1.s,
        color: Color.fromRGBO(colorIntValue, colorIntValue, colorIntValue, 1),
      )));

  //顶部灰线
  static grayTopBorder({colorIntValue = 220}) => BoxDecoration(
          border: Border(
              top: BorderSide(
        width: 1.s,
        color: Color.fromRGBO(colorIntValue, colorIntValue, colorIntValue, 1),
      )));

  //文本输入框
  static textField(
          {textController,
          textFocusNode,
          hintText,
          textAlign = TextAlign.start,
          onEditingCompletes,
          maxLines,
          hintSize = 13}) =>
      TextField(
        focusNode: textFocusNode,
        controller: textController,
        textAlign: textAlign,
        maxLines: maxLines,
        onEditingComplete: onEditingCompletes,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: ScreenUtil().setWidth(hintSize),
                color: Color.fromRGBO(129, 129, 129, 1))),
      );

  //下拉列表框
  static dropDownChoice(
          {showFlag = false,
          top,
          left,
          bottom,
          right,
          @required itemList,
          width,
          height,
          tapSelect}) =>
      Visibility(
        visible: showFlag,
        child: Positioned(
          top: top,
          left: left,
          bottom: bottom,
          right: right,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.s), color: Colors.white),
            child: Column(
              children: [
                for (int i = 0; i < itemList.length; i++)
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(5.s, 0, 5.s, 0),
                        width: width,
                        height: height / itemList.length,
                        alignment: Alignment.center,
                        decoration:
                            (i != 0) ? CommonWidget.grayTopBorder() : null,
                        child: CommonWidget.font(
                            text: itemList[i].values.elementAt(0))),
                    onTap: () {
                      tapSelect(itemList[i].keys.elementAt(0),
                          itemList[i].values.elementAt(0));
                    },
                  ),
              ],
            ),
          ),
        ),
      );

  //圆形checkBox
  static circleCheckBox(
      {onTap, checkFlag, unCheckColor = Colors.black12, checkColor}) {
    if (checkColor == null) checkColor = Color.fromRGBO(39, 153, 93, 1);
    return GestureDetector(
      child: checkFlag == true
          ? Icon(
              Icons.check_circle,
              color: checkColor,
              size: 20.s,
            )
          : Icon(
              Icons.panorama_fish_eye,
              color: unCheckColor,
              size: 20.s,
            ),
      onTap: () {
        onTap();
      },
    );
  }

  //图片checkBox
  static picCheckBox({onTap, checkFlag}) {
    return GestureDetector(
      child: checkFlag == true
          ? Image.asset("Assets/storage/check.png", width: 20.s, height: 20.s)
          : Image.asset("Assets/storage/unCheck.png",
              width: 20.s, height: 20.s),
      onTap: () {
        if (onTap != null) onTap();
      },
    );
  }

  //必填项红点
  static mustInput() => Column(
        children: [
          SizedBox(
            height: 6.s,
          ),
          Container(
            child: CommonWidget.font(
                text: "*", color: Color.fromRGBO(255, 42, 42, 1)),
          ),
        ],
      );

  //列表组件
  static simpleList(
          {List keyList,
          valueList,
          mustFlag = true,
          valueColor = Colors.black,
          chooseFlag = false,
          chooseFlagList,
          sizeWidth = 25,
          onTapCheck,
          bottomLineFlag = false}) =>
      Container(
        width: 345.s,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.s), color: Colors.white),
        child: Column(
          children: [
            for (int i = 0; i < keyList.length; i++)
              Container(
                decoration: (i < keyList.length - 1)
                    ? CommonWidget.grayBottomBorder()
                    : (bottomLineFlag ? CommonWidget.grayBottomBorder() : null),
                padding: EdgeInsets.fromLTRB(0, 20.s, 0, 10.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        (mustFlag == true && chooseFlag == false)
                            ? CommonWidget.mustInput()
                            : ((chooseFlag == true && keyList[i] != "未分组")
                                ? Row(
                                    children: [
                                      CommonWidget.circleCheckBox(
                                          checkFlag: chooseFlagList[i],
                                          onTap: () {
                                            chooseFlagList[i] =
                                                !chooseFlagList[i];
                                            onTapCheck(chooseFlagList[i], i);
                                          }),
                                      SizedBox(
                                        width: 5.s,
                                      )
                                    ],
                                  )
                                : SizedBox(
                                    width: ScreenUtil().setWidth(sizeWidth),
                                  )),
                        CommonWidget.font(text: keyList[i] ?? "")
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
                      child: Row(
                        children: [
                          CommonWidget.font(
                              text: valueList[i] ?? "", color: valueColor),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      );

  //整行输入组件
  static inputRow(
          {rowName,
          textController,
          sizedWidth = 30,
          mustFlag = false,
          lineFlag = true}) =>
      Container(
        padding: EdgeInsets.fromLTRB(0, 20.s, 10.s, 10.s),
        decoration: lineFlag ? CommonWidget.grayBottomBorder() : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 90.s,
              child: Row(
                children: [
                  Visibility(
                    visible: mustFlag,
                    child: CommonWidget.mustInput(),
                    replacement: SizedBox(
                      width: 5.s,
                    ),
                  ),
                  CommonWidget.font(text: rowName)
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  width: 180.s,
                  padding: EdgeInsets.fromLTRB(20.s, 0, 0.s, 0),
                  child: CommonWidget.textField(
                      hintSize: 14,
                      hintText: "请输入",
                      textAlign: TextAlign.end,
                      textController: textController,
                      maxLines: 1),
                ),
                SizedBox(
                  width: SizeAdaptiveUtil().size(sizedWidth),
                ),
              ],
            ),
          ],
        ),
      );

  //底部弹出选择列表组件
  static chooseRow(
          {rowName,
          rowValue,
          rowValueColor = Colors.black,
          textColor = Colors.black,
          textController,
          sizedWidth = 30,
          mustFlag = false,
          lineFlag = true,
          onChoose}) =>
      Container(
        padding: EdgeInsets.fromLTRB(0, 20.s, 0, 10.s),
        decoration: lineFlag ? CommonWidget.grayBottomBorder() : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Visibility(
                  visible: mustFlag,
                  child: CommonWidget.mustInput(),
                  replacement: SizedBox(
                    width: 5.s,
                  ),
                ),
                CommonWidget.font(text: rowName)
              ],
            ),
            GestureDetector(
              onTap: () {
                onChoose();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 240.s,
                    padding: EdgeInsets.fromLTRB(20.s, 0, 0.s, 0),
                    child: CommonWidget.font(
                        text: rowValue,
                        textAlign: TextAlign.end,
                        size: 14,
                        color: rowValueColor),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: textColor,
                  ),
                  SizedBox(
                    width: SizeAdaptiveUtil().size(5),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  //选择日期列表组件
  static chooseDateRow(context,
          {dateText, onTap, rowText, textColor, dateType = DateType.YMD}) =>
      Container(
        padding: EdgeInsets.fromLTRB(0, 20.s, 0, 10.s),
        decoration: CommonWidget.grayBottomBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 6.s,
                ),
                CommonWidget.font(text: rowText)
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    YinPicker.showDatePicker(context,
                        nowTimes: DateTime.now(),
                        dateType: dateType,
                        title: "",
                        minValue: DateTime(
                          2015,
                          10,
                        ),
                        maxValue: DateTime(
                          2023,
                          10,
                        ), clickCallback: (var str, var time) {
                      onTap(str, time);
                    });
                  },
                  child: Container(
                    width: 200.s,
                    padding: EdgeInsets.fromLTRB(20.s, 0, 0.s, 0),
                    child: CommonWidget.font(
                        text: dateText,
                        color: textColor,
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w500,
                        size: 13),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: textColor,
                ),
                SizedBox(
                  width: 5.s,
                ),
              ],
            ),
          ],
        ),
      );

  //文字左侧带绿块
  static greenFont({String text}) => Row(
        children: [
          Container(
            color: AppColors.primaryColor,
            width: 4.s,
            height: 16.s,
            margin: EdgeInsets.only(right: 10.s, top: 2.s),
          ),
          CommonWidget.font(text: text, size: 15, fontWeight: FontWeight.bold)
        ],
      );

  //四周带线的图片
  static imageWithLine({imageUrl}) => Container(
      width: 91.s,
      height: 91.s,
      decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromRGBO(238, 238, 238, 1), width: 1.s)),
      child: Image.network(imageUrl));

  //check提示
  static Future showAlertDialog(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowAlart(
          backLart: 1,
          title: message,
        );
      },
    );
  }
}
