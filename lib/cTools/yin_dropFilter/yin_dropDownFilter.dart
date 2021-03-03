import 'package:flutter/material.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';

class FilterModel {
  String title; //按钮title
  List contents; //下拉列表
  String type; //下拉筛选类型 'ColumnLayout'、'RowLayout'
  Function callback; //按钮点击回调
  String direction; //下拉箭头方向
  Color titleColor;
  double titleSize;
  ValueChanged<String> onChangedVideo;

  FilterModel(
      {this.title,
      this.titleColor,
      this.titleSize,
      this.contents,
      this.type,
      this.callback,
      this.onChangedVideo,
      this.direction});
}

class DropFilter extends StatefulWidget {
  DropFilter({Key key, this.buttons});
  final List<FilterModel> buttons;

  @override
  _DropFilterState createState() => _DropFilterState();
}

class _DropFilterState extends State<DropFilter>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double innerHeight = 150.0;
  bool isMask = false; //下拉蒙层是否显示
  FilterModel curButton;
  int curFilterIndex;

  initState() {
    // TODO: implement initState
    super.initState();
    //初始化下拉列表
    curButton = widget.buttons[0];
    controller = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = new Tween(begin: 0.0, end: innerHeight).animate(controller)
      ..addListener(() {
        //这行如果不写，没有动画效果
        setState(() {});
      });
  }

  void triggerMask() {
    setState(() {
      isMask = !isMask;
    });
  }

  void triggerIcon(btn) {
    if (btn.direction == 'up') {
      btn.direction = 'down';
    } else {
      btn.direction = 'up';
    }
  }

  void initButtonStatus() {
    widget.buttons.forEach((i) {
      setState(() {
        i.direction = 'down';
      });
    });
  }

  //更新数据
  void updateData(i) {
    setState(() {
      curButton = widget.buttons[i];
      curFilterIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      //stack设置为overflow：visible之后，内部的元素中超出的部分就不能触发点击事件；所以尽量避免这种布局
      children: <Widget>[
        Column(
          children: <Widget>[
            _buttons(),
          ],
        ),
        _viewList(curButton),
      ],
    ));
  }

  //筛选按钮
  Widget _buttons() {
    return Row(
      children: List.generate(widget.buttons.length, (i) {
        final thisButton = widget.buttons[i];
        return SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width / widget.buttons.length,
          child: FlatButton(
            padding: EdgeInsets.only(top: 0, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  thisButton.title,
                  style: TextStyle(
                    color: thisButton.titleColor,
                    fontSize: thisButton.titleSize,
                  ),
                ),
                _rotateIcon(thisButton.direction)
              ],
            ),
            onPressed: () {
              //处理 下拉列表打开时，点击别的按钮
              if (isMask && i != curFilterIndex) {
                initButtonStatus();
                triggerIcon(widget.buttons[i]);
                updateData(i);
                return;
              }

              updateData(i);

              if (curButton.callback == null) {
                if (animation.status == AnimationStatus.completed) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
                triggerMask();
              } else {
                curButton.callback();
              }

              triggerIcon(widget.buttons[i]);
            },
          ),
        );
      }),
    );
  }

  //筛选弹出的下拉列表
  Widget _viewList(FilterModel lists) {
    if (lists.contents != null && lists.contents.length > 0) {
      return Positioned(
          width: MediaQuery.of(context).size.width,
          top: 50,
          left: 0,
          child: Column(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  height: animation.value,
                  child: _innerConList(lists)),
              _mask()
            ],
          ));
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _innerConList(FilterModel lists) {
    if (lists.type == 'RowLayout') {
      setState(() {
        innerHeight = 50.0 * lists.contents.length;
      });

      return Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 15),
          child: Wrap(
            alignment: WrapAlignment.start,
            verticalDirection: VerticalDirection.down,
            runSpacing: 15,
            children: List.generate(lists.contents.length, (i) {
              return GestureDetector(
                  onTap: () {
                    controller.reverse();
                    triggerIcon(widget.buttons[curFilterIndex]);
                    triggerMask();
                    widget.buttons[curFilterIndex]
                        .onChangedVideo(lists.contents[i]);
                  },
                  child: Container(
                      width:
                          (MediaQuery.of(context).size.width - 20) / 3, //每行显示3个
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(216, 216, 216, 0.3),
                        ),
                        child: Text(lists.contents[i]),
                      )));
            }),
          ));
    } else {
      setState(() {
        innerHeight = 50.0 * lists.contents.length;
      });
      return ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: List.generate(lists.contents.length, (i) {
              return GestureDetector(
                  onTap: () {
                    controller.reverse();
                    triggerIcon(widget.buttons[curFilterIndex]);
                    triggerMask();
                    widget.buttons[curFilterIndex]
                        .onChangedVideo(lists.contents[i]);
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(top: 15, left: 15, bottom: 15),
                    child: Text(
                      lists.contents[i],
                      style: TextStyle(),
                    ),
                  ));
            }),
          ));
    }
  }

  //筛选的黑色蒙层
  Widget _mask() {
    if (isMask) {
      return GestureDetector(
        onTap: () {
          controller.reverse();
          triggerMask();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  //右侧旋转箭头组建
  Widget _rotateIcon(direction) {
    if (direction == 'up') {
      return Icon(Icons.keyboard_arrow_up,
          color: Color.fromRGBO(10, 10, 10, 1));
    } else {
      return Icon(Icons.keyboard_arrow_down,
          color: Color.fromRGBO(10, 10, 10, 1));
    }
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
