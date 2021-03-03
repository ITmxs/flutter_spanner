import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
       时间选择器
*/
class TimerPicker extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const TimerPicker({
    Key key,
    this.onChanged,
  }) : super(key: key);
  @override
  _TimerPickerState createState() => _TimerPickerState();
}

class _TimerPickerState extends State<TimerPicker> {
  //创建时间对象，获取当前时间
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return CupertinoTimerPicker(
      initialTimerDuration: Duration(
        hours: now.hour,
        minutes: now.minute,
      ),
      alignment: Alignment.center,
      mode: CupertinoTimerPickerMode.hm,
      onTimerDurationChanged: (value) {
        setState(() {
          print('${value.toString().substring(0, 8)}');
          widget.onChanged('${value.toString().substring(0, 8)}');
        });
      },
    );
  }
}
