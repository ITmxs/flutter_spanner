import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/yin_noneScrollBehavior/noneSCrollBehavior.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/publicView/pud_permission.dart';
import 'package:spanners/spannerHome/members/view/memberDetail.dart';

import '../membersRequestApi.dart';
import 'addMember.dart';

class MemberManagement extends StatefulWidget {
  @override
  _MemberManagementState createState() => _MemberManagementState();
}

class _MemberManagementState extends State<MemberManagement> {
  //下拉列表框显示隐藏标志
  bool selectShowFlag = false;
  //会员数据List
  List memberList = [];
  //下拉列表框显示内容
  String selectContent = "全部";
  //搜索条件集合
  Map searchList = {"memberType": ""};
  //文本框Controller
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    initData();
  }

  initData() {
    MembersDio.memberListRequest(
        param: {"": ""},
        onSuccess: (data) {
          print(data);
          memberList = data;
          setState(() {});
        });
  }

  tapSelect(String selectId, String selectValue) {
    searchList["memberType"] = selectId;
    selectShowFlag = false;
    selectContent = selectValue;
    setState(() {});
  }

  search() async {
    searchList["key"] = (textEditingController.text) ?? "";
    print(searchList);
    await MembersDio.memberListRequest(
        param: searchList,
        onSuccess: (data) {
          print(data);
          memberList = data;
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.iconAppBar(context, "客户管理",
          rIcon: GestureDetector(
            onTap: () {
              //权限处理 详细参考 后台Excel
              PermissionApi.whetherContain('member_opt_add')
                  ? print('')
                  : CommonRouter.push(context, widget: AddMember());
            },
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 31.s, 0),
                child: Image.asset(
                  "Assets/members/add.png",
                  width: 25.s,
                  height: 25.s,
                )),
          )),
      body: Stack(
        children: [
          Column(
            children: [
              head(),
              content(),
            ],
          ),
          CommonWidget.dropDownChoice(
              showFlag: selectShowFlag,
              top: 50.s,
              left: 22.s,
              itemList: [
                {"": '全部'},
                {"0": "储值"},
                {"1": "非储值"}
              ],
              width: 90.s,
              height: 120.s,
              tapSelect: tapSelect)
        ],
      ),
    );
  }

  head() {
    return Column(
      children: [
        SizedBox(
          height: 1.s,
        ),
        Container(
          width: 375.s,
          height: 56.s,
          color: Colors.white,
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.s),
              color: Color.fromRGBO(238, 238, 238, 1),
            ),
            width: 330.s,
            height: 30.s,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    selectShowFlag = !selectShowFlag;
                    setState(() {});
                  },
                  child: Container(
                      width: 90.s,
                      padding: EdgeInsets.fromLTRB(25.s, 0, 0, 0),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          CommonWidget.font(text: selectContent, size: 14),
                          SizedBox(
                            width: 7.s,
                          ),
                          Image.asset(
                            "Assets/members/down.png",
                            width: 10.s,
                            height: 18.s,
                          )
                        ],
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 1.s,
                          height: 20.s,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10.s,
                        ),
                        Container(
                            width: 180.s,
                            margin: EdgeInsets.fromLTRB(0, 0, 20.s, 0),
                            child: TextField(
                              controller: textEditingController,
                              onEditingComplete: () {
                                search();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  hintText: '快速搜索',
                                  hintStyle: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(129, 129, 129, 1))),
                            )

                            //  CommonWidget.textField(
                            //     hintText: "快速搜索",

                            //     textController: textEditingController,
                            //     onEditingCompletes: () {
                            //       search();
                            //     }),
                            ),
                        GestureDetector(
                          onTap: () {
                            search();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Image.asset(
                            "Assets/members/search.png",
                            width: 17.s,
                            height: 17.s,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  content() {
    print(memberList.length);
    return Expanded(
        child: ScrollConfiguration(
      behavior: NeverScrollBehavior(),
      child: ListView(
        children: [
          for (int i = 0; i < memberList.length; i++)
            Container(
              // height: 124.s,
              width: 345.s,
              margin: EdgeInsets.fromLTRB(15.s, 10.s, 15.s, 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3.s)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.s, 15.s, 0, 11.s),
                    child: CommonWidget.font(
                        text:
                            "${memberList[i]["memberName"]}(${memberList[i]["mobile"]})",
                        size: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.s, 0, 15.s, 10.s),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Visibility(
                              child: Image.asset(
                                "Assets/members/vip.png",
                                width: 24.s,
                                height: 19.s,
                              ),
                              visible:
                                  ((memberList[i]["accountBalances"] ?? 0) >
                                          0) ||
                                      memberList[i]["trhId"] != null,
                            ),
                            SizedBox(
                              width: 5.s,
                            ),
                            Visibility(
                              visible: memberList[i]["type"] == 1,
                              child: Image.asset(
                                "Assets/members/group.png",
                                width: 40.s,
                                height: 20.s,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          child: CommonWidget.font(
                              text: "详情",
                              color: Color.fromRGBO(39, 153, 93, 1)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MemberDetail(
                                          isVips: ((memberList[i]
                                                          ["accountBalances"] ??
                                                      0) >
                                                  0) ||
                                              memberList[i]["trhId"] != null,
                                          userId: memberList[i]["userId"]
                                              .toString(),
                                        ))).then((value) => initData());
                            // RouterUtil.push(context,
                            //     routerName: "memberDetail", data: '123');
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Color.fromRGBO(238, 238, 238, 1),
                    height: 1.s,
                    width: 345.s,
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20.s, 5.s, 0, 0),
                      child: Container(
                        width: 290.s,
                        child: CommonWidget.font(
                            fontWeight: FontWeight.w400,
                            text: (memberList[i]["licences"]) ?? ""),
                      ))
                ],
              ),
            ),
          SizedBox(
            height: 40.s,
          )
        ],
      ),
    ));
  }
}
