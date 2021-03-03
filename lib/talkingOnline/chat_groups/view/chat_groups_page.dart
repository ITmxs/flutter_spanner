import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:spanners/talkingOnline/chat_groups/view/chat_groups_item_page.dart';
import 'package:spanners/talkingOnline/chat_page/view/chat_page.dart';

class ChatGroupsPage extends StatefulWidget {
  @override
  _ChatGroupsPageState createState() => _ChatGroupsPageState();
}

class _ChatGroupsPageState extends State<ChatGroupsPage> implements ChatGroupListItemDelegate {

  var groupList = List<EMGroup>();
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJoinedGroups();
  }

  void getJoinedGroups() async{
    _loading = true;
    print('加载数据');
    EMClient.getInstance().groupManager().getJoinedGroupsFromServer(
        onSuccess: (groups){
          groupList = groups;
          print('groupList');
          print(groupList);
          _refreshUI(false);
        },
        onError: (code, desc){
          print('加载失败');
          print(code.toString()+':'+desc);
          Text(code.toString()+':'+desc);
          _refreshUI(false);
        }
    );
  }

  _refreshUI(bool loading){
    setState(() {
      _loading = loading;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '群聊',
          style: TextStyle(color: Colors.black87),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context, true);
              });
        }),
      ),
      body: Stack(children: <Widget>[
        _buildChatGroupListView(),
        // ProgressDialog(loading: _loading, msg: DemoLocalizations.of(context).loading,),
      ],
      ),
    );
  }

  Widget _buildChatGroupListView(){
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: groupList.length + 2,
        itemBuilder:(BuildContext context, int index){
          if(index == 0){
            return _buildCreateGroupItem();
          }
          if(index == 1){
            return _buildPublicGroupsItem();
          }
          // return ChatGroupsItemPage(groupList[index - 2], this);
          print('groupList[index - 2]');
          print(groupList[index - 2]);
          return ChatGroupsItemPage(groupList[index - 2], this);
        });
  }

  _buildCreateGroupItem(){
    return GestureDetector(
      onTap: (){
        print('创建群聊');
        // WidgetUtil.hintBoxWithDefault('默认创建可直接加入公开群');
        _refreshUI(true);
        EMClient.getInstance().groupManager().createGroup('可直接加入的公开群' + DateTime.now().millisecondsSinceEpoch.toString(), '', [], '', EMGroupOptions(maxUsers : 2000, style: EMGroupStyle.EMGroupStylePublicOpenJoin),
            onSuccess: (group){
              // WidgetUtil.hintBoxWithDefault('创建群组成功');
              print('创建群组成功');
              getJoinedGroups();
            },
            onError: (code, desc){
              // WidgetUtil.hintBoxWithDefault(code.toString() +':'+ desc);
              print('创建群组失败'+code.toString() +':'+ desc);
              _refreshUI(false);
            });
      },
      child : Container(
        height: 67,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 8.0),
              height: 67,
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(child: Icon(Icons.group_add, color: Colors.white,),color: Colors.blue,width: 38, height: 38,),
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Text('创建群聊', style: TextStyle(fontSize: 18.0),)
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 64.0,
              height: 1.0,
              color: Color(0xffe5e5e5),
              margin: EdgeInsets.fromLTRB(64.0, 66.0, 0.0, 0.0),
            ),
          ],
        ),
      ),
    );
  }

  _buildPublicGroupsItem(){
    return GestureDetector(
      onTap: (){
        // Navigator.of(context).pushNamed(Constant.toPublicGroupListPage);
      },
      child : Container(
        height: 67,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 8.0),
              height: 67,
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(child: Icon(Icons.group_work, color: Colors.white,),color: Colors.blue,width: 38, height: 38,),
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Text('公开群聊', style: TextStyle(fontSize: 18.0),)
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 64.0,
              height: 1.0,
              color: Color(0xffe5e5e5),
              margin: EdgeInsets.fromLTRB(64.0, 66.0, 0.0, 0.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onTapChatGroup(EMGroup group) {
    print(group.getGroupId());
    print(group.getGroupName());


    // Navigator.push<bool>(context, new MaterialPageRoute(builder: (BuildContext context){
    //   return ChatPage(model, 1);
    // })).then((bool isRefresh){
    //   if(isRefresh){
    //     getJoinedGroups();
    //   }
    // });
  }

  // _contactInfo = ContactInfo();
  // _contactInfo.name = user['name'];
  // _contactInfo.id = user['id'];
  // _contactInfo.headUrl = user['headUrl'];

}
