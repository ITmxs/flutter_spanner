import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:spanners/spannerHome/spannerHome.dart';
import 'package:spanners/talkingOnline/about/about.dart';
import 'package:spanners/talkingOnline/conversation/view/conversation_list_page.dart';
import 'package:spanners/talkingOnline/friend/view/friend.dart';
import 'package:spanners/weCenter/weCenter.dart';

/*
 * 有状态StatefulWidget
 *  继承于 StatefulWidget，通过 State 的 build 方法去构建控件
 */
// ignore: camel_case_types
class HomeView extends StatefulWidget {
  //主要是负责创建state
  @override
  HomeViewState createState() => HomeViewState();
}

/*
 * 在 State 中,可以动态改变数据
 * 在 setState 之后，改变的数据会触发 Widget 重新构建刷新
 */
// ignore: camel_case_types
class HomeViewState extends State<HomeView> implements EMMessageListener, EMConnectionListener {
  HomeViewState();

  @override
  void initState() {
    ///初始化，这个函数在生命周期中只调用一次
    super.initState();
    EMClient.getInstance().chatManager().addMessageListener(this);
    EMClient.getInstance().addConnectionListener(this);
  }

  //当前显示页面的
  int currentIndex = 0;
  int messageCount = 0;

  @override
  Widget build(BuildContext context) {
    //点击导航项是要显示的页面
    final pages = [
      SpannerHome(),
      About(), //技术圈
//      Talking(),
      ConversationListPage(),
      Friend(),
      WeCenter(),
    ];
    //构建页面
    //   return buildBottomTabScaffold();
    // }

    // Widget buildBottomTabScaffold() {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 11,
        unselectedFontSize: 11,
        iconSize: 20,
        items: [
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? Image.asset(
                    "Assets/index_home.png",
                    width: 23,
                    height: 23,
                  )
                : Image.asset(
                    'Assets/unhome.png',
                    width: 23,
                    height: 23,
                  ),
            title: Text("首页",
                style: currentIndex == 0
                    ? TextStyle(
                        color: Color.fromRGBO(39, 153, 93, 1), fontSize: 10)
                    : TextStyle(
                        color: Color.fromRGBO(37, 35, 35, 1), fontSize: 10)),
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? Image.asset(
                    "Assets/indextwo.png",
                    width: 23,
                    height: 23,
                  )
                : Image.asset(
                    'Assets/untwo.png',
                    width: 23,
                    height: 23,
                  ),
            title: Text("技术圈",
                style: currentIndex == 1
                    ? TextStyle(
                        color: Color.fromRGBO(39, 153, 93, 1), fontSize: 10)
                    : TextStyle(
                        color: Color.fromRGBO(37, 35, 35, 1), fontSize: 10)),
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                currentIndex == 2
                    ? Image.asset(
                  "Assets/indexmessage.png",
                  width: 23,
                  height: 23,
                )
                    : Image.asset(
                  'Assets/unmessage.png',
                  width: 23,
                  height: 23,
                ),
                messageCount > 0?Positioned(
                  top: -0,
                  right: -0,
                  child: Container(
                  alignment: Alignment.center,
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(messageCount.toString(), style: TextStyle(color: Colors.white, fontSize: 11),),
                ),):Container(),
              ],
            ),
            title: Text("消息",
                style: currentIndex == 2
                    ? TextStyle(
                        color: Color.fromRGBO(39, 153, 93, 1), fontSize: 10)
                    : TextStyle(
                        color: Color.fromRGBO(37, 35, 35, 1), fontSize: 10)),
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 3
                ? Image.asset(
                    "Assets/indexpeople.png",
                    width: 23,
                    height: 23,
                  )
                : Image.asset(
                    'Assets/unpeople.png',
                    width: 23,
                    height: 23,
                  ),
            title: Text("联系人",
                style: currentIndex == 3
                    ? TextStyle(
                        color: Color.fromRGBO(39, 153, 93, 1), fontSize: 10)
                    : TextStyle(
                        color: Color.fromRGBO(37, 35, 35, 1), fontSize: 10)),
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 4
                ? Image.asset(
                    "Assets/indexuser.png",
                    width: 23,
                    height: 23,
                  )
                : Image.asset(
                    'Assets/unsuer.png',
                    width: 23,
                    height: 23,
                  ),
            title: Text("我的",
                style: currentIndex == 4
                    ? TextStyle(
                        color: Color.fromRGBO(39, 153, 93, 1), fontSize: 10)
                    : TextStyle(
                        color: Color.fromRGBO(37, 35, 35, 1), fontSize: 10)),
          ),
        ],
        currentIndex: currentIndex,
        //所以一般都是使用fixed模式，此时，导航栏的图标和标题颜色会使用fixedColor指定的颜色，
        // 如果没有指定fixedColor，则使用默认的主题色primaryColor
        type: BottomNavigationBarType.fixed,
        //底部菜单点击回调
        onTap: (index) {
          _changePage(index);
        },
      ),

      //对应的页面
      body: IndexedStack(
        children: pages,
        index: currentIndex,
      ),
    );
  }

  /*切换页面*/
  void _changePage(int index) {
    /*如果点击的导航项不是当前项  切换 */
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
        if(index == 2) {
          messageCount = 0;
        }
      });
    }
  }

  @override
  void onCmdMessageReceived(List<EMMessage> messages) {
    // TODO: implement onCmdMessageReceived
  }

  @override
  void onMessageChanged(EMMessage message) {
    // TODO: implement onMessageChanged
  }

  @override
  void onMessageDelivered(List<EMMessage> messages) {
    // TODO: implement onMessageDelivered
  }

  @override
  void onMessageRead(List<EMMessage> messages) {
    // TODO: implement onMessageRead
  }

  @override
  void onMessageRecalled(List<EMMessage> messages) {
    // TODO: implement onMessageRecalled
  }

  @override
  void onMessageReceived(List<EMMessage> messages) {
    // TODO: implement onMessageReceived
    print('-----------------');
    print('onMessageReceived');
    setState(() {
      messageCount += 1;
    });
    print(messages);
  }

  @override
  void onConnected() {
    // TODO: implement onConnected
  }

  @override
  void onDisconnected(int errorCode) {
    // TODO: implement onDisconnected
  }
}

//子页面
class ChildItemView extends StatefulWidget {
  String _title;

  ChildItemView(this._title);

  @override
  _ChildItemViewState createState() => _ChildItemViewState();
}

class _ChildItemViewState extends State<ChildItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(child: Text(widget._title)),
    );
  }
}
