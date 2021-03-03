import 'package:flutter/material.dart';
import 'package:spanners/cModel/recCarModel.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import '../../publicView/pub_VipView.dart';

class VipTopView extends StatefulWidget {
  final int type;
  final Map vipMap;
  const VipTopView({Key key, this.type, this.vipMap}) : super(key: key);
  @override
  _VipTopViewState createState() => _VipTopViewState();
}

class _VipTopViewState extends State<VipTopView> {
  bool indexBool = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VipView(
          type: widget.type,
          vipMap: widget.vipMap,
        ),
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
                constraints: BoxConstraints(maxHeight: 160),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                // child: Expanded(
                //     child: Container(
                //   width: 200,
                //   height: 100,
                //   color: Colors.red,
                // )

                child: ScrollConfiguration(
                  behavior: NeverScrollBehavior(),
                  child: ListView(
                    shrinkWrap: true,
                    children: List.generate(
                        widget.vipMap['historyList'].length,
                        (index) => Column(
                              children: [
                                SizedBox(
                                  height: 14,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Container(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          RecCarHistoryModel.fromJson(widget
                                                  .vipMap['historyList'][index])
                                              .createDate,
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(66, 66, 66, 1),
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Center(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          RecCarHistoryModel.fromJson(widget
                                                  .vipMap['historyList'][index])
                                              .secondaryService,
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(66, 66, 66, 1),
                                              fontSize: 15),
                                        ),
                                      ),
                                    )),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '¥${RecCarHistoryModel.fromJson(widget.vipMap['historyList'][index]).price}',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(66, 66, 66, 1),
                                            fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                index == widget.vipMap['historyList'].length - 1
                                    ? SizedBox(
                                        height: 14,
                                      )
                                    : SizedBox(
                                        height: 0,
                                      ),
                              ],
                            )),
                  ),
                )),
            //),
            SizedBox(
              width: 15,
            ),
          ],
        )
      ],
    );
  }
}
