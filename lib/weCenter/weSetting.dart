import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/common/commonTools.dart';
import 'package:spanners/dLoginOrOther/login.dart';
import 'package:spanners/em_manager/em_manager.dart';
import 'package:spanners/weCenter/weCenterRequestApi.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String fileSize = "";
  bool flag = true;
  @override
  void initState() {
    loadCache();
    initData();
  }
  //初始化数据
  initData()  {
     WeCenterDio.hasPayPasswordRequest(
        param: {"": ""},
        onSuccess: (data) {
          flag = data;
          print(flag);
          setState(() {});
        });
  }
  ///加载缓存
  Future<Null> loadCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
      print('临时目录大小: ' + value.toString());

      fileSize = "${ value~/1024 } MB";
      setState(() {
        // _cacheSizeStr = _renderSize(value);
      });
    } catch (err) {
      print(err);
    }
  }

  /// 递归方式 计算文件的大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  void _clearCache() async {
    //此处展示加载loading
    try {
      Directory tempDir = await getTemporaryDirectory();
      //删除缓存目录
      await delDir(tempDir);
      await loadCache();
      CommonWidget.showAlertDialog("清除缓存成功");
      print('清除缓存成功');
      print('清除缓存成功');
    } catch (e) {
      print(e);
      print('清除缓存失败');
    } finally {
      //此处隐藏加载loading
    }
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }

  //退出登录
  _logOut() {
    WeCenterDio.logOutRequest(
      onSuccess: (data) {
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.simpleAppBar(context, title: "设置"),
      body: ScrollConfiguration(
        behavior: NeverScrollBehavior(),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 5.s,
                ),
                Container(
                  width: 375.s,
                  height: 46.s,
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(25.s, 0, 25.s, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidget.font(text: "账户"),
                      CommonWidget.font(
                          text:
                              "${json.decode(SynchronizePreferences.Get("userInfo"))["mobile"]}"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.s,
                ),

                GestureDetector(
                  onTap: (){
                    RouterUtil.push(context,routerName: "forgetView");

                  },
                  child: Container(
                    width: 375.s,
                    height: 46.s,
                    padding: EdgeInsets.fromLTRB(25.s, 0, 25.s, 0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border(
                        //     bottom: BorderSide(
                        //         color: Color.fromRGBO(169, 169, 172, 1),
                        //         width: 0.5.s))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidget.font(text: "重置密码"),
                        Row(
                          children: [
                            CommonWidget.font(text: "修改"),
                            Icon(
                              Icons.chevron_right,
                              color: Color.fromRGBO(169, 169, 172, 1),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: (){
                //     RouterUtil.push(context,routerName: "updatePayPassword",data: flag);
                //   },
                //   child: Container(
                //     width: 375.s,
                //     height: 46.s,
                //     color: Colors.white,
                //     padding: EdgeInsets.fromLTRB(25.s, 0, 25.s, 0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         CommonWidget.font(text: "支付设置"),
                //         Row(
                //           children: [
                //             CommonWidget.font(text: flag?"修改":"设置"),
                //             Icon(
                //               Icons.chevron_right,
                //               color: Color.fromRGBO(169, 169, 172, 1),
                //             )
                //           ],
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 5.s,
                ),
                GestureDetector(
                  onTap: (){
                    _clearCache();
                  },
                  child: Container(
                    width: 375.s,
                    height: 46.s,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(25.s, 0, 25.s, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidget.font(text: "清除缓存"),
                        Row(
                          children: [
                            CommonWidget.font(text: fileSize),
                            Icon(
                              Icons.chevron_right,
                              color: Color.fromRGBO(169, 169, 172, 1),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.s,
                ),
                GestureDetector(
                  onTap: (){
                    em_logout((){
                      _logOut();
                    },(){
                      _logOut();
                    });
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => LoginView()));
                  },
                  child: Container(
                    width: 375.s,
                    height: 46.s,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(25.s, 0, 25.s, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonWidget.font(text: "退出登录",color: Color.fromRGBO(39, 153, 93, 1)),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


}
