import 'dart:async';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:flutter/services.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/homeTabbottom/homeTabbottom.dart';
import 'package:spanners/spannerHome/atwork/atWorkView.dart';
import 'package:spanners/spannerHome/receiveCar/receiveCar.dart';
import 'package:spanners/spannerHome/working/workingView.dart';
import 'package:spanners/dLoginOrOther/login.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:amap_base/amap_base.dart';
import 'package:spanners/weCenter/weCenterRequestApi.dart';
import 'base/common.dart';
import 'cTools/sharedPreferences.dart';
import 'common/routerUtil.dart';
import 'package:spanners/publicView/pud_permission.dart';
// import 'package:getuiflut/getuiflut.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'em_manager/em_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  realRunApp();
  //catchMake();
}

/*
  异常 捕捉 ⬇️
*/

catchMake() {
  FlutterError.onError = (FlutterErrorDetails details) {
    reportErrorAndLog(details);
  };

  ///* runZoned 解开后 部分print打印不输出  有待解决*/
  // runZoned(
  //   () => runApp(MyApp()),
  //   zoneSpecification: ZoneSpecification(
  //     print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
  //       collectLog(line); // 收集日志
  //     },
  //   ),
  //   onError: (Object obj, StackTrace stack) {
  //     var details = makeDetails(obj, stack);
  //     reportErrorAndLog(details);
  //   },
  // );
  //构建异常提示界面
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    return CatchPage();
  };
}

void collectLog(String line) {
  //收集日志
}
void reportErrorAndLog(FlutterErrorDetails details) {
  //上报错误和日志逻辑
  print('错误和日志逻辑' + '$details');
}

// ignore: missing_return
FlutterErrorDetails makeDetails(Object obj, StackTrace stack) {
  // 构建错误信息
}
//⬆️

void realRunApp() async {
  print('初始化');
  bool success = await SynchronizePreferences.getInstance();
  await AMap.init('f1a72858d51ce608a92a29f0f001f7d1');

  await registerWxApi(
      appId: AppConst.wxAppId,
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: "https://bs-brother.com/");
  var result = await isWeChatInstalled;
  print("is installed $result");

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements EMConnectionListener {
  int auto = 1;
  _getAutoLogin() async {
    var str = await SharedManager.getShopIdString();
    print('==================>$str');
    setState(() {
      if (str.length == 0) {
        print('指向这里->登录');
        auto = 1;
      } else {
        //移除验证
        SharedManager.removeString('autoLogin');
        print('指向这里自动登录');
        auto = 2;
        //自动登录获取权限
        PermissionApi.getPermissionList();
      }
    });
  }

  void initState() {
    //TODO: init sdk;
    print('sdk 初始化');

    /* 判断自动登录*/
    _getAutoLogin();
    // // EMOptions options = EMOptions(appKey: "1158210126030466#spanner"); //正式
    // EMOptions options = EMOptions(appKey: "1106200331065633#chatpage"); //测试
    // options.setAcceptInvitationAlways(false);
    // options.setAutoLogin(true);
    // EMPushConfig config = EMPushConfig();
    // config.enableHWPush();
    // config.enableAPNS('iOSPush');
    // options.setPushConfig(config);
    // EMClient.getInstance().init(options);
    // EMClient.getInstance().setDebugMode(true);
    // EMClient.getInstance().addConnectionListener(this);
    super.initState();

    ///极光推送
    this.initJpush();
    //app 启动清除接车工单缓存
    SharedManager.removeString('receiveCarServiceList');
    SharedManager.removeString('upCarMap');
    SharedManager.removeString('CommentUpmap');
    SharedManager.removeString('upVipCarMap');
  }

  //监听极光推送 (自定义的方法)
  //https://github.com/jpush/jpush-flutter-plugin/blob/master/documents/APIs.md
  initJpush() async {
    JPush jpush = new JPush();
    //获取注册的id
    jpush.getRegistrationID().then((rid) {
      print("获取注册的id:$rid");
    });
    //初始化
    jpush.setup(
      appKey: "51c5db59e04cd072089a9aab",
      channel: "theChannel",
      production: false,
      debug: true, // 设置是否打印 debug 日志
    );

    //设置别名  实现指定用户推送
    jpush.setAlias("jg123").then((map) {
      print("设置别名成功");
    });

    try {
      //监听消息通知
      jpush.addEventHandler(
        // 接收通知回调方法。
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
        },
        // 点击通知回调方法。
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
        },
        // 接收自定义消息回调方法。
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
        },
      );
    } catch (e) {
      print('极光sdk配置异常');
    }
  }

//极光⬆️

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit(); //bot_toast 初始化
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => HomeView(),
        "/rec": (BuildContext context) => ReceiveCar(),
        "/atwork": (BuildContext context) => AtWorkView(),
        "/working": (BuildContext context) => WorkingView(),
      },

      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      builder: (context, child) {
        child = Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }
            },
            child: child,
          ),
        ); //键盘隐藏
        child = botToastBuilder(context, child); //bot_toast 初始化
        return child;
      },
      navigatorKey: Routers.navigatorState,
      navigatorObservers: [
        BotToastNavigatorObserver()
      ], //2. registered route observer
      onGenerateRoute: RouterUtil.jumpTo,
      title: 'flutter APP name ',
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        primarySwatch: Colors.blue,
        highlightColor: Color.fromRGBO(1, 0, 0, 0.0),
        splashColor: Color.fromRGBO(1, 0, 0, 0.0),
        cardColor: Color.fromRGBO(1, 1, 1, 0.6),
      ),
      home: auto == 1 ? LoginView() : HomeView(),
    );
  }

  void onConnected() {
    // TODO: implement onConnected

    // initPlatformState();
    // Getuiflut().turnOnPush();
    EMClient.getInstance().callManager().registerCallReceiver();
  }

  void onDisconnected(int errorCode) {
    // TODO: implement onDisconnected

    // initPlatformState();
    // Getuiflut().turnOnPush();
  }
}
