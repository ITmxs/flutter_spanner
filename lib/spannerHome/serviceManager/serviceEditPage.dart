import 'dart:math';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/Alart.dart';
import 'package:spanners/cTools/keyboardLimit.dart';
import 'package:spanners/cTools/showBottomSheet.dart';
import 'package:spanners/spannerHome/appointment/appointmentRequestApi.dart';
import 'package:spanners/spannerHome/serviceManager/serviceApiRequst.dart';

class ServiceEditePage extends StatefulWidget {
  final title;
  final dictId;
  const ServiceEditePage({
    Key key,
    this.title,
    this.dictId,
  }) : super(key: key);
  @override
  _ServiceEditePageState createState() => _ServiceEditePageState();
}

class _ServiceEditePageState extends State<ServiceEditePage> {
  /* */
  var projectController = TextEditingController();
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var shareMoneyController = TextEditingController();
  var sharePriceController = TextEditingController();
  var shareMoblieController = TextEditingController();
  var remarkController = TextEditingController();

  //用于 按钮换行
  FocusNode projectNode = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode priceNode = FocusNode();
  FocusNode shareMoneyNode = FocusNode();
  FocusNode sharePriceNode = FocusNode();
  FocusNode shareMoblieNode = FocusNode();

  List item = ['所属项目', '项目名称', '项目单价', '项目分红'];
  List shareItem = [
    '共享单价',
  ];
  bool selectBool = true; //  默认 启用服务
  bool shareBool = false; //  默认 不填共享服务
  bool deleBool = false; //  默认 不显示删除

  String projectType = ''; //选中的 一级服务名称
  String id = ''; //服务id
  List titleList = List();
  List projectList = List();

  //上传 map
  Map upMap = Map();
  //shop Message
  Map shopMap = Map();
  //service Message
  Map serviceMap = Map();

  /*  获取一二级分类 */
  _getTypeList() {
    ApiDio.getserviceDictList(
        pragm: '',
        onSuccess: (data) {
          projectList = data;
          var count = projectList.length;
          // print('projectList--->$projectList');
          for (var i = 0; i < count; i++) {
            if (projectList[i]['dictName'] == '其他配件项目') {
              projectList.removeAt(i);
            } else {
              titleList.add(projectList[i]['dictName']);
            }
          }
          print('projectList--->$titleList');
        },
        onError: (value) {
          _showAlartDialogs('');
        });
  }

  Future _showAlartDialogs(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ServiceLoad(
          onChanged: (value) {
            _getTypeList();
          },
        );
      },
    );
  }

//添加 服务
  _addService() {
    ServiceApi.addServiceRequest(
      param: upMap,
      onSuccess: (data) {
        if (data) {
          Navigator.pop(context);
        }
      },
    );
  }

  //获取 门店 手机号 地址
  _getShopMessage() {
    ServiceApi.getShopMessageRequest(
      param: {'': ''},
      onSuccess: (data) {
        shopMap = data;
      },
    );
  }

  //获取 服务详情
  _getServiceMessage() {
    ServiceApi.getServiceMessageRequest(
      param: {'dictId': widget.dictId},
      onSuccess: (data) {
        print(data);
        setState(() {
          id = data['id'].toString();
          projectType = data['serviceName'].toString();
          nameController.text = data['dictName'].toString();
          priceController.text =
              data['cost'] == null ? '0.0' : data['cost'].toString();
          shareMoneyController.text =
              data['bonus'] == null ? '0.0' : data['bonus'].toString();
          sharePriceController.text =
              data['shareCost'] == null ? '0.0' : data['shareCost'].toString();
          remarkController.text =
              data['remark'] == null ? '' : data['remark'].toString();
          data['delFlag'] == 0 ? selectBool = true : selectBool = false;
          data['isDelete'] == 1 ? deleBool = true : deleBool = false;
          data['isShare'] == 1 ? shareBool = true : shareBool = false;
        });
      },
    );
  }

//删除
  _delete() {
    ServiceApi.deletRequest(
      param: {'id': id},
      onSuccess: (data) {
        Navigator.pop(context);
      },
    );
  }

//修改
  _put() {
    if (upMap.length == 0) {
      Alart.showAlartDialog('当前无任何修改', 1);
    } else {
      upMap['id'] = id;
      ServiceApi.putRequest(
        param: upMap,
        onSuccess: (data) {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTypeList();
    _getShopMessage();
    if (widget.dictId == null) {
      upMap['isShare'] = 0;
      upMap['delFlag'] = 0;
      upMap['cost'] = 0.00;
      upMap['bonus'] = 0.00;
      upMap['shareCost'] = 0.00;
    } else {
      _getServiceMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title,
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
        body: ScrollConfiguration(
          behavior: NeverScrollBehavior(),
          child: ListView(
            children: [
              SizedBox(
                height: 25,
              ),
              //开启 关闭
              Row(
                children: [
                  SizedBox(
                    width: 28,
                  ),
                  Text(
                    '是否启用',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectBool = true;
                        upMap['delFlag'] = 0;
                      });
                    },
                    child: Icon(
                      selectBool ? Icons.check_circle : Icons.panorama_fish_eye,
                      color: selectBool
                          ? Color.fromRGBO(39, 153, 93, 1)
                          : Color.fromRGBO(112, 112, 112, 1),
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    '是',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectBool = false;
                        upMap['delFlag'] = 1;
                      });
                    },
                    child: Icon(
                      selectBool ? Icons.panorama_fish_eye : Icons.check_circle,
                      color: selectBool
                          ? Color.fromRGBO(112, 112, 112, 1)
                          : Color.fromRGBO(39, 153, 93, 1),
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    '否',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                height: 26,
              ),
              //项目 填写
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: item.length,
                        itemBuilder: (context, int index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              item[index].toString() == '所属项目'
                                  // 选择区域
                                  ? Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (widget.dictId == null) {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              showModalBottomSheet(
                                                isDismissible: true,
                                                enableDrag: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    height: 300.0,
                                                    child: ShowBottomSheet(
                                                      type: 1,
                                                      dataList: titleList,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          print('项目种类$value');
                                                          if (value == null) {
                                                          } else {
                                                            for (var i = 0;
                                                                i <
                                                                    projectList
                                                                        .length;
                                                                i++) {
                                                              if (projectList[i]
                                                                      [
                                                                      'dictName'] ==
                                                                  value) {
                                                                print(
                                                                    '指向这里${projectList[i]['dictName']}');
                                                                upMap['pid'] =
                                                                    projectList[
                                                                            i][
                                                                        'id']; //一级分类 id

                                                              }
                                                            }

                                                            projectType = value;
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '项目种类',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            42, 42, 42, 1),
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    projectType == ''
                                                        ? '请选择 '
                                                        : '$projectType ',
                                                    style: TextStyle(
                                                        color: projectType == ''
                                                            ? Color.fromRGBO(
                                                                164,
                                                                164,
                                                                164,
                                                                1)
                                                            : Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.chevron_right,
                                                  color: Color.fromRGBO(
                                                      164, 164, 164, 1),
                                                ),
                                                // SizedBox(
                                                //   width: 15,
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  // 输入 文本  区域
                                  : Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          item[index],
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(30, 30, 30, 1),
                                              fontSize: 15),
                                        ),
                                        // 输入 文本  区域
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.centerRight,
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxHeight: 20, maxWidth: 200),
                                            child: TextFormField(
                                              keyboardType: item[index]
                                                              .toString() ==
                                                          '项目单价' ||
                                                      item[index].toString() ==
                                                          '项目分红'
                                                  ? TextInputType
                                                      .numberWithOptions(
                                                          decimal: true)
                                                  : null,
                                              inputFormatters: item[index]
                                                              .toString() ==
                                                          '项目单价' ||
                                                      item[index].toString() ==
                                                          '项目分红'
                                                  ? [KeyboardLimit(1)]
                                                  : null,
                                              controller: item[index]
                                                          .toString() ==
                                                      '所属项目'
                                                  ? priceController
                                                  : item[index].toString() ==
                                                          '项目名称'
                                                      ? nameController
                                                      : item[index]
                                                                  .toString() ==
                                                              '项目单价'
                                                          ? priceController
                                                          : item[index]
                                                                      .toString() ==
                                                                  '项目分红'
                                                              ? shareMoneyController
                                                              : null,

                                              focusNode: item[index]
                                                          .toString() ==
                                                      '所属项目'
                                                  ? projectNode
                                                  : item[index].toString() ==
                                                          '项目名称'
                                                      ? nameNode
                                                      : item[index]
                                                                  .toString() ==
                                                              '项目单价'
                                                          ? priceNode
                                                          : item[index]
                                                                      .toString() ==
                                                                  '项目分红'
                                                              ? shareMoneyNode
                                                              : null,
                                              enabled: item[index].toString() ==
                                                      '项目名称'
                                                  ? widget.dictId != null
                                                      ? false
                                                      : true
                                                  : true,

                                              // enabled:

                                              onEditingComplete: () {
                                                switch (
                                                    item[index].toString()) {
                                                  case '所属项目':
                                                    FocusScope.of(context)
                                                        .requestFocus(nameNode);
                                                    break;
                                                  case '项目名称':
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            priceNode);
                                                    break;
                                                  case '项目单价':
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            shareMoneyNode);
                                                    break;
                                                  case '项目分红':
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    break;

                                                  default:
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                }
                                              },
                                              onChanged: (value) {
                                                /*  参数封装  */
                                                switch (
                                                    item[index].toString()) {
                                                  case '所属项目':
                                                    // dataMap['carBrand'] =
                                                    //     value.toString();
                                                    break;
                                                  case '项目名称':
                                                    upMap['dictName'] =
                                                        value.toString();
                                                    break;
                                                  case '项目单价':
                                                    upMap['cost'] =
                                                        value.toString();
                                                    break;
                                                  case '项目分红':
                                                    upMap['bonus'] =
                                                        value.toString();
                                                    break;

                                                  default:
                                                }
                                              },
                                              //controller: nameControll,
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
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                            ),
                                          ),
                                        )),
                                        SizedBox(
                                          width: 25,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              item.length - 1 == index
                                  ? Container()
                                  : Container(
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      height: 1,
                                      color: Color.fromRGBO(238, 238, 238, 1),
                                    )
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 27,
              ),
              //共享 服务  按钮
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  Text(
                    '共享服务',
                    style: TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 1), fontSize: 15),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        shareBool ? shareBool = false : shareBool = true;
                        upMap['isShare'] = shareBool ? 1 : 0;
                      });
                    },
                    child: Icon(
                      shareBool ? Icons.check_circle : Icons.panorama_fish_eye,
                      color: shareBool
                          ? Color.fromRGBO(39, 153, 93, 1)
                          : Color.fromRGBO(112, 112, 112, 1),
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              //共享 服务填写
              shareBool
                  ? Container(
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
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: shareItem.length,
                                    itemBuilder: (context, int index) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                shareItem[index],
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        30, 30, 30, 1),
                                                    fontSize: 15),
                                              ),
                                              // 输入 文本  区域
                                              Expanded(
                                                  child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxHeight: 20,
                                                      maxWidth: 200),
                                                  child: TextFormField(
                                                    inputFormatters: item[index]
                                                                .toString() ==
                                                            '共享单价'
                                                        ? [KeyboardLimit(1)]
                                                        : null,
                                                    keyboardType: item[index]
                                                                .toString() ==
                                                            '共享单价'
                                                        ? TextInputType
                                                            .numberWithOptions(
                                                                decimal: true)
                                                        : null,
                                                    controller:
                                                        sharePriceController,

                                                    focusNode: item[index]
                                                                .toString() ==
                                                            '共享单价'
                                                        ? sharePriceNode
                                                        : item[index]
                                                                    .toString() ==
                                                                '联系电话'
                                                            ? shareMoblieNode
                                                            : null,

                                                    // enabled:

                                                    onEditingComplete: () {
                                                      switch (shareItem[index]
                                                          .toString()) {
                                                        case '共享单价':
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  nameNode);
                                                          break;

                                                        default:
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  FocusNode());
                                                      }
                                                    },
                                                    onChanged: (value) {
                                                      /*  参数封装  */
                                                      switch (shareItem[index]
                                                          .toString()) {
                                                        case '共享单价':
                                                          upMap['shareCost'] =
                                                              value.toString();
                                                          break;
                                                        case '联系电话':
                                                          // dataMap['model'] = value.toString();
                                                          break;

                                                        default:
                                                      }
                                                    },
                                                    //controller: nameControll,
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 0,
                                                              horizontal: 0),
                                                      hintText: '请输入',
                                                      hintStyle: TextStyle(
                                                          color: Color.fromRGBO(
                                                              164, 164, 164, 1),
                                                          fontSize: 14),
                                                      border:
                                                          new OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                              SizedBox(
                                                width: 25,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          item.length - 1 == index
                                              ? Container()
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      30,
                                                  height: 1,
                                                  color: Color.fromRGBO(
                                                      238, 238, 238, 1),
                                                )
                                        ],
                                      );
                                    }),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //活动详情 编辑
                          Row(
                            children: [
                              SizedBox(
                                width: 26,
                              ),
                              Text(
                                '活动详情',
                                style: TextStyle(
                                    color: Color.fromRGBO(30, 30, 30, 1),
                                    fontSize: 15),
                              ),
                            ],
                          ),
                          //活动详情 编辑
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 30,
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight: 200, maxWidth: 300),
                                  child: TextFormField(
                                    controller: remarkController,
                                    maxLines: 6,
                                    onChanged: (value) {
                                      setState(() {
                                        //flowtext = value;
                                        /*  发布 文字 数量 限制  */
                                        if (value.length > 500) {
                                          Alart.showAlartDialog('超出字数限制', 1);
                                        } else {
                                          upMap['remark'] = value;
                                          //flowtext = value;
                                        }
                                      });
                                    },
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                      hintText: '请输入活动优惠详情......',
                                      hintStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(136, 133, 133, 1),
                                          fontSize: 15),
                                      enabledBorder: OutlineInputBorder(
                                        //未选中时候的颜色
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(238, 238, 238, 1),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        //选中时外边框颜色
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(238, 238, 238, 1),
                                        ),
                                      ),
                                    ),
                                  ),
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
                          //门店 地址
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 30,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(233, 245, 238, 1)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '电话/' + shopMap['mobile'].toString(),
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(30, 30, 30, 1),
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '门店/${shopMap['shopname']}',
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(30, 30, 30, 1),
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '地址/${shopMap['address']}',
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(30, 30, 30, 1),
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),

              SizedBox(
                height: 70,
              ),
              /*  新增   与  修改  展示按钮不同  */
              widget.dictId == null
                  ?
                  //确认新增
                  Center(
                      child: GestureDetector(
                        onTap: () {
                          if (upMap.length == 0) {
                            Alart.showAlartDialog('清添加服务', 1);
                            return;
                          }
                          if (!upMap.containsKey('pid') ||
                              !upMap.containsKey('dictName')) {
                            Alart.showAlartDialog('清添加服务', 1);
                            return;
                          }
                          if (upMap['isShare'] == 1 &&
                              !upMap.containsKey('shareCost')) {
                            Alart.showAlartDialog('清添加共享服务价格', 1);
                            return;
                          }
                          _addService();
                        },
                        child: Container(
                          width: 107,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(39, 153, 93, 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '确认新增',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    )
                  :
                  // 删除  修改
                  Row(
                      children: [
                        Expanded(
                            child:
                                /* 门店展示删除按钮   默认不展示删除按钮  */
                                deleBool
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _delete();
                                            },
                                            child: Container(
                                              width: 80,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color.fromRGBO(
                                                      255, 77, 76, 1)),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '删除',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 1),
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container()),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                //权限处理 详细参考 后台Excel
                                PermissionApi.whetherContain(
                                        'service_management_opt')
                                    ? print('')
                                    : _put();
                              },
                              child: Container(
                                width: 80,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(39, 153, 93, 1)),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '修改',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ))
                      ],
                    ),

              SizedBox(
                height: 80,
              ),
            ],
          ),
        ));
  }
}
