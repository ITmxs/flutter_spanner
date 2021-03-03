import 'package:flutter/material.dart';
import 'package:spanners/cModel/pubModel.dart';

class VipView extends StatefulWidget {
  //公司type = 2  个人 type = 1
  final int type;
  final Map vipMap;
  const VipView({Key key, this.type, this.vipMap}) : super(key: key);
  @override
  _VipViewState createState() => _VipViewState();
}

class _VipViewState extends State<VipView> {
  //展示收回
  bool showBool = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: widget.type == 1
                          ? AssetImage('Assets/vipImage/vipBottom.png')
                          : AssetImage('Assets/vipImage/comVipBottom.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: //收回 按钮
                            showBool ? 150 : 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: widget.type == 1
                                  ? AssetImage('Assets/vipImage/vipImage.png')
                                  : AssetImage(
                                      'Assets/vipImage/comVipImage.png'),
                              fit: BoxFit.fill,
                            ),
                            color: Colors.transparent),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Image.asset('Assets/vipImage/warning.png'),
                                SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    PublicModel.fromJson(
                                            widget.vipMap['member'])
                                        .vehicleLicence,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    PublicModel.fromJson(
                                            widget.vipMap['member'])
                                        .realName,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${PublicModel.fromJson(widget.vipMap['member']).brand}（ ${PublicModel.fromJson(widget.vipMap['member']).model}）',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '余额/ ¥${PublicModel.fromJson(widget.vipMap['member']).accountBalances}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 3,
                            ),
                            //收回 按钮
                            showBool
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        showBool = true;
                                      });
                                    },
                                    child: Image.asset(
                                      'Assets/vipImage/vipDown.png',
                                      width: 29,
                                      height: 18,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: widget.type == 1
                                    ? AssetImage(
                                        'Assets/vipImage/vipBottom.png',
                                      )
                                    : AssetImage(
                                        'Assets/vipImage/comVipBottom.png'),
                                fit: BoxFit.fill,
                              ),
                              color: Colors.transparent),
                          child: Column(
                            children: [
                              //弹出  区域
                              showBool
                                  ? SizedBox(
                                      height: 0,
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                              showBool
                                  ? Container(
                                      // height: 70,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: widget.type == 1
                                                ? AssetImage(
                                                    'Assets/vipImage/vipsimage.png',
                                                  )
                                                : AssetImage(
                                                    'Assets/vipImage/comvipsimage.png'),
                                            fit: BoxFit.fill,
                                          ),
                                          color: Colors.transparent),
                                      child: ListView(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: List.generate(
                                              widget.vipMap['ownList'].length >
                                                      2
                                                  ? 2
                                                  : widget
                                                      .vipMap['ownList'].length,
                                              (index) => Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 22,
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          PublicOwnListModel.fromJson(
                                                                  widget.vipMap[
                                                                          'ownList']
                                                                      [index])
                                                              .realName,
                                                          style: TextStyle(
                                                              color: widget
                                                                          .type ==
                                                                      1
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          39,
                                                                          153,
                                                                          93,
                                                                          1)
                                                                  : Color
                                                                      .fromRGBO(
                                                                          91,
                                                                          121,
                                                                          255,
                                                                          1),
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          '剩余${PublicOwnListModel.fromJson(widget.vipMap['ownList'][index]).quantity}次',
                                                          style: TextStyle(
                                                              color: widget
                                                                          .type ==
                                                                      1
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          39,
                                                                          153,
                                                                          93,
                                                                          1)
                                                                  : Color
                                                                      .fromRGBO(
                                                                          91,
                                                                          121,
                                                                          255,
                                                                          1),
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 22,
                                                      ),
                                                    ],
                                                  ))),
                                    )
                                  : Container(),
                              showBool
                                  ? ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: List.generate(
                                          widget.vipMap['ownList'].length > 2
                                              ? widget.vipMap['ownList']
                                                      .length -
                                                  2
                                              : 0,
                                          (index) => Row(
                                                children: [
                                                  SizedBox(
                                                    width: 22,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      PublicOwnListModel.fromJson(
                                                              widget.vipMap[
                                                                      'ownList']
                                                                  [index + 2])
                                                          .realName,
                                                      style: TextStyle(
                                                          color: widget.type ==
                                                                  1
                                                              ? Color.fromRGBO(
                                                                  39,
                                                                  153,
                                                                  93,
                                                                  1)
                                                              : Color.fromRGBO(
                                                                  91,
                                                                  121,
                                                                  255,
                                                                  1),
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '剩余${PublicOwnListModel.fromJson(widget.vipMap['ownList'][index + 2]).quantity}次',
                                                      style: TextStyle(
                                                          color: widget.type ==
                                                                  1
                                                              ? Color.fromRGBO(
                                                                  39,
                                                                  153,
                                                                  93,
                                                                  1)
                                                              : Color.fromRGBO(
                                                                  91,
                                                                  121,
                                                                  255,
                                                                  1),
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 22,
                                                  ),
                                                ],
                                              )))
                                  : Container(),

                              showBool
                                  ? SizedBox(
                                      height: 3,
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                              //收回 按钮
                              showBool
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          showBool = false;
                                        });
                                      },
                                      child: Container(
                                        child: Image.asset(
                                          widget.type == 1
                                              ? 'Assets/vipImage/3.0x/vipUp.png'
                                              : 'Assets/vipImage/comVipUp.png',
                                          width: 29,
                                          height: 18,
                                        ),
                                      ))
                                  : Container(),
                              showBool
                                  ? SizedBox(
                                      height: 3,
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                            ],
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
