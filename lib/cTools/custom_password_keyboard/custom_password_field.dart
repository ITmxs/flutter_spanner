import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui';


///自定义 密码输入框
class CustomPasswordField extends StatelessWidget {

  ///传入当前密码
  String data;

  CustomPasswordField({Key key, this.data}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FieldCustomWidget(data),
    );
  }
}

class FieldCustomWidget extends CustomPainter {

  String password;

  FieldCustomWidget(this.password);

  @override
  void paint(Canvas canvas, Size size) {
    // 密码画笔
    Paint mPwdPaint;
    Paint mRectPaint;
    // 初始化密码画笔  
    mPwdPaint = Paint();
    mPwdPaint..color = Colors.black;
    // 初始化密码框  
    mRectPaint = new Paint();
    mRectPaint..color = Color(0xff707070);
    
    RRect r = RRect.fromLTRBR(0.0, 0.0, size.width, size.height, Radius.circular(size.height / 12));
    mRectPaint.style = PaintingStyle.stroke;
    canvas.drawRRect(r, mRectPaint);

    var per = size.width / 6.0;
    var offsetX = per;
    while (offsetX < size.width) {
      canvas.drawLine(
          new Offset(offsetX, 0.0), new Offset(offsetX, size.height), mRectPaint);
      offsetX += per;
    }

    var half = per/2;
    var radio = per/8;

    mPwdPaint.style = PaintingStyle.fill;
    for(int i =0; i< password.length && i< 6; i++){
      canvas.drawArc(new Rect.fromLTRB(i*per+half-radio, size.height/2-radio, i*per+half+radio, size.height/2+radio), 0.0, 2*pi, true, mPwdPaint);
    }
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }


}
