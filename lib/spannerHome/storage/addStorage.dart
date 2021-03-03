import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/photoSelect.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/cTools/yPickerTime.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/spannerHome/storage/storageRequestApi.dart';

class AddStorage extends StatefulWidget {
  @override
  _AddStorageState createState() => _AddStorageState();
}

class _AddStorageState extends State<AddStorage> {
  //图片集合
  List picList = [];

  //物品存储条目集合
  List textControllerList = [TextEditingController()];

  //物品存储信息
  Map storageInfo = {};

  //限时寄存标志
  bool limitTimeFlag = false;

  //车牌号组件用集合
  List vecList = [];

  //文本框控制器
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    initData();
  }

  //初始化数据
  initData() {
    storageInfo["startDate"] =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    storageInfo["endDate"] =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  }

  //根据车牌号查找用户
  findUser(String vehicle) async {
    await StorageRequestApi.findUser(
        param: {"vehicleLicence": vehicle},
        onSuccess: (data) {
          if (data != null) {
            nameController.text = data["realName"] ?? "";
            mobileController.text = data["mobile"] ?? "";
            setState(() {});
          }
        });
  }

  //新增存储
  addStorage() async {
    if (storageInfo["vehicleLicence"] == null) {
      CommonWidget.showAlertDialog("车牌号不能为空");
      return;
    }
    if (nameController.text == "") {
      CommonWidget.showAlertDialog("联系人姓名不能为空");
      return;
    }
    if (mobileController.text == "") {
      CommonWidget.showAlertDialog("手机号不能为空");
      return;
    }
    if (textControllerList.length == 0) {
      CommonWidget.showAlertDialog("至少输入一个物品");
      return;
    }
    if (costController.text == "") {
      CommonWidget.showAlertDialog("寄存费用不能为空");
      return;
    }
    for (int i = 0; i < textControllerList.length; i++) {
      if (textControllerList[i].text == "") {
        CommonWidget.showAlertDialog("物品名称不能为空");
        return;
      }
    }
    Map storageEntity = {};
    storageEntity["comment"] = commentController.text;
    storageEntity["ownerName"] = nameController.text;
    storageEntity["mobile"] = mobileController.text;
    storageEntity["vehicleLicence"] = storageInfo["vehicleLicence"];
    storageEntity["cost"] = int.parse(costController.text);
    if (limitTimeFlag) {
      storageEntity["startDate"] = storageInfo["startDate"];
      storageEntity["endDate"] = storageInfo["endDate"];
      storageEntity["timeLimit"] = 0;
    } else {
      storageEntity["timeLimit"] = 1;
    }
    List itemList = [];
    for (int i = 0; i < textControllerList.length; i++) {
      itemList.add({"itemName": textControllerList[i].text});
    }
    List picListForFunc = [];
    for (int i = 0; i < picList.length; i++) {
      picListForFunc.add({"picUrl": picList[i]});
    }
    await StorageRequestApi.addStorageRequest(
        param: {
          "storageEntity": storageEntity,
          "storagePicEntityList": picListForFunc,
          "storageItemEntityList": itemList
        },
        onSuccess: (data) {
          Navigator.pop(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonWidget.simpleAppBar(context, title: "新增存储"),
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: [
              Column(
                children: [
                  userInfo(),
                  SizedBox(height: 10.s),
                  itemListWidget(),
                  chooseTime(),
                  choosePic(),
                  tail()
                ],
              )
            ],
          ),
        ));
  }

  //用户信息
  userInfo() {
    return Column(
      children: [
        SizedBox(
          height: 25.s,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.s, 0.s, 0, 10.s),
              child: CommonWidget.greenFont(text: "用户信息"),
            ),
          ],
        ),
        Container(
          width: 345.s,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(3.s)),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 20.s, 0, 10.s),
                decoration: true ? CommonWidget.grayBottomBorder() : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 70.s,
                      child: Row(
                        children: [
                          Visibility(
                            visible: true,
                            child: CommonWidget.mustInput(),
                            replacement: SizedBox(
                              width: 5.s,
                            ),
                          ),
                          CommonWidget.font(text: "车牌号")
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 200.s,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                barrierColor: Color.fromRGBO(255, 255, 255, 0),
                                isScrollControlled: true,
                                isDismissible: true,
                                enableDrag: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return CarKeyboard(
                                    type: vecList.length == 0 ? 0 : 1,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == 'del') {
                                          //删除操作
                                          if (vecList.length > 0) {
                                            vecList.removeLast();
                                          }
                                          if (vecList.length == 0) {
                                            //if (ocrBool) {
                                            //发送通知
                                            //}
                                          }
                                        } else {
                                          //车牌号展示 逻辑
                                          if (vecList.length < 8) {
                                            vecList.add(value);
                                          }
                                        }
                                        //数组list转 string
                                        String result;
                                        vecList.forEach((string) => {
                                              if (result == null)
                                                result = string
                                              else
                                                result = '$result$string'
                                            });
                                        if (vecList.length >= 7) {
                                          findUser(result);
                                          storageInfo["vehicleLicence"] =
                                              result;
                                        }
                                      });
                                    },
                                  );
                                },
                              );
                            },
                            child: GridView.builder(
                                shrinkWrap: true,
                                physics: new NeverScrollableScrollPhysics(),
                                //禁止滑动
                                itemCount: 8,
                                //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        //横轴元素个数
                                        crossAxisCount: 8,
                                        //纵轴间距
                                        mainAxisSpacing: 0.0,
                                        //横轴间距
                                        crossAxisSpacing: 5.0,
                                        //子组件宽高长度比例
                                        childAspectRatio: 15 / 20),
                                itemBuilder: (BuildContext context, int item) {
                                  return Container(
                                    width: 15,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: item == vecList.length - 1
                                                ? Color.fromRGBO(39, 153, 93, 1)
                                                : Color.fromRGBO(
                                                    220, 220, 220, 1),
                                            width: 1),
                                        color: item == 7
                                            ? Color.fromRGBO(233, 245, 238, 1)
                                            : Colors.white),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        //用于解决 车牌号未输入完其余空展示
                                        vecList.length == 8
                                            ? vecList[item]
                                            : item < vecList.length
                                                ? vecList[item]
                                                : '',
                                        style: TextStyle(
                                            color: Color.fromRGBO(8, 8, 8, 1),
                                            fontSize: 14),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          width: 10.s,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              CommonWidget.inputRow(
                  rowName: "联系人姓名",
                  mustFlag: true,
                  textController: nameController),
              CommonWidget.inputRow(
                  rowName: "手机号",
                  mustFlag: true,
                  lineFlag: false,
                  textController: mobileController),
            ],
          ),
        )
      ],
    );
  }

  //物品寄存清单
  itemListWidget() {
    return Column(
      children: [
        Container(
          width: 345.s,
          padding: EdgeInsets.fromLTRB(5.s, 15.s, 2.s, 25.s),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3.s),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidget.greenFont(text: "物品寄存清单"),
              SizedBox(
                height: 20.s,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.s, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidget.font(
                        text: "物品名称", fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 10.s,
                    ),
                    for (int i = 0; i < textControllerList.length; i++)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 293.s,
                            height: 28.s,
                            padding: EdgeInsets.fromLTRB(5.s, 0, 3.s, 0),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10.s),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(39, 153, 93, 1),
                                    width: 1.s),
                                borderRadius: BorderRadius.circular(5.s)),
                            child: CommonWidget.textField(
                                hintText: "请输入",
                                maxLines: 1,
                                textController: textControllerList[i]),
                          ),
                          GestureDetector(
                            onTap: () {
                              textControllerList.removeAt(i);
                              setState(() {});
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 3.s, 0, 0),
                              child: Image.asset(
                                "Assets/storage/delete.png",
                                width: 20.s,
                                height: 20.s,
                              ),
                            ),
                          ),
                        ],
                      ),
                    GestureDetector(
                      onTap: () {
                        textControllerList.add(TextEditingController());
                        setState(() {});
                      },
                      child: CommonWidget.font(
                          text: "添加+",
                          size: 13,
                          color: Color.fromRGBO(39, 153, 93, 1)),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  //限时寄存
  chooseTime() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(45.s, 30.s, 45.s, 20.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CommonWidget.circleCheckBox(
                      checkFlag: limitTimeFlag,
                      onTap: () {
                        limitTimeFlag = !limitTimeFlag;
                        setState(() {});
                      }),
                  SizedBox(
                    width: 10.s,
                  ),
                  CommonWidget.font(
                    text: "限时寄存",
                  )
                ],
              ),
              Row(
                children: [
                  CommonWidget.circleCheckBox(
                      checkFlag: !limitTimeFlag,
                      onTap: () {
                        limitTimeFlag = !limitTimeFlag;
                        setState(() {});
                      }),
                  SizedBox(
                    width: 10.s,
                  ),
                  CommonWidget.font(text: "不限时寄存")
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: limitTimeFlag,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    YinPicker.showDatePicker(context,
                        nowTimes: DateTime.now(),
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
                        value: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                        ), clickCallback: (var str, var time) {
                      setState(() {
                        var month = time.month < 10
                            ? '0${time.month}'
                            : time.month.toString();
                        storageInfo["startDate"] =
                            "${time.year}-$month-${time.day}";
                      });
                    });
                  },
                  child: Container(
                    width: 160.s,
                    height: 28.s,
                    padding: EdgeInsets.fromLTRB(10.s, 0, 10.s, 0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 245, 238, 1),
                        borderRadius: BorderRadius.circular(5.s)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidget.font(text: storageInfo["startDate"]),
                        Image.asset("Assets/storage/calendar.png"),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    YinPicker.showDatePicker(context,
                        nowTimes: DateTime.now(),
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
                        value: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                        ), clickCallback: (var str, var time) {
                      setState(() {
                        var month = time.month < 10
                            ? '0${time.month}'
                            : time.month.toString();
                        storageInfo["endDate"] =
                            "${time.year}-$month-${time.day}";
                      });
                    });
                  },
                  child: Container(
                    width: 160.s,
                    height: 28.s,
                    padding: EdgeInsets.fromLTRB(10.s, 0, 10.s, 0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 245, 238, 1),
                        borderRadius: BorderRadius.circular(5.s)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidget.font(text: storageInfo["endDate"]),
                        Image.asset("Assets/storage/calendar.png"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  //物品图片
  choosePic() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.s, 30.s, 0, 15.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.greenFont(text: "物品图片"),
          SizedBox(
            height: 10.s,
          ),
          picList.length == 0
              ? GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isDismissible: true,
                      enableDrag: false,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return new Container(
                          height: 160.0,
                          child: PhotoSelect(
                            isScan: false,
                            isVin: false,
                            imageNumber: 1,
                            type: 1,
                            onChanged: (value) {
                              setState(
                                () {
                                  for (var pic in value) {
                                    if (picList.contains(pic))
                                      value.remove(pic);
                                  }
                                  picList.addAll(value);
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Image.asset("Assets/storage/group.png"))
              : Container(
                  width: 345.s,
                  height: 220.s,
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 10.s,
                    children: <Widget>[
                      for (var imgUrl in picList)
                        GestureDetector(
                          onTap: () {
                            picList.remove(imgUrl);
                            setState(() {});
                          },
                          child: Stack(
                            children: [
                              Image.network(
                                imgUrl,
                                width: 150.s,
                                height: 150.s,
                              ),
                              Positioned(
                                top: 0.s,
                                right: 0.s,
                                child: Icon(Icons.delete),
                              )
                            ],
                          ),
                        ),
                      GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isDismissible: true,
                              enableDrag: false,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return new Container(
                                  height: 160.0,
                                  child: PhotoSelect(
                                    isScan: false,
                                    isVin: false,
                                    imageNumber: 9,
                                    type: 1,
                                    imageList: null,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          picList.addAll(value);
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.asset("Assets/storage/group.png"))
                    ],
                  ),
                )
        ],
      ),
    );
  }

//尾部
  tail() {
    return Column(
      children: [
        Container(
          width: 345.s,
          height: 47.s,
          padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(3.s)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonWidget.font(text: "寄存费用"),
              Container(
                  width: 200.s,
                  child: CommonWidget.textField(
                      hintText: "请输入",
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      textController: costController))
            ],
          ),
        ),
        SizedBox(
          height: 20.s,
        ),
        Row(
          children: [
            SizedBox(
              width: 20.s,
            ),
            CommonWidget.font(text: "备注"),
          ],
        ),
        SizedBox(
          height: 15.s,
        ),
        Container(
          width: 345.s,
          height: 80.s,
          padding: EdgeInsets.fromLTRB(20.s, 10.s, 20.s, 0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(3.s)),
          child: CommonWidget.textField(
              hintText: "请填写您需要备注的信息......", textController: commentController),
        ),
        SizedBox(
          height: 40.s,
        ),
        GestureDetector(
          onTap: () {
            addStorage();
          },
          child: Padding(
            child: CommonWidget.button(text: "确定", width: 105.s, height: 30.s),
            padding: EdgeInsets.fromLTRB(20.s, 0, 0, 0),
          ),
        ),
        SizedBox(
          height: 40.s,
        )
      ],
    );
  }
}
