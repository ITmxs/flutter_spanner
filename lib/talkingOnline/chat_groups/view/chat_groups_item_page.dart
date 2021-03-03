import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:spanners/base/common.dart';

// ignore: must_be_immutable
class ChatGroupsItemPage extends StatefulWidget {

  final EMGroup emGroup;
  final ChatGroupListItemDelegate delegate;

  ChatGroupsItemPage(this.emGroup, this.delegate);

  @override
  _ChatGroupsItemPageState createState() => _ChatGroupsItemPageState();
}

class _ChatGroupsItemPageState extends State<ChatGroupsItemPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){
      _onTaped();
    },
    child: Container(
      height: 58,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPortrait(),
          _buildContent(),
        ],
      ),
    ),);
  }

  _buildPortrait(){
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 8,
            ),
            ClipOval(
              child: Container(child: Icon(Icons.group, color: Colors.white,),color: AppColors.primaryColor, width: 38, height: 38,),
            ),
          ],
        ),
      ],
    );
  }

  _buildContent(){
    return Expanded(
      child: Container(
          height: 58,
          margin: EdgeInsets.only(left:15, right: 0),
          decoration:  BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Color(0xffe5e5e5))
              )
          ),
          child: Row(
            children: <Widget>[
              Text(widget.emGroup.getGroupName(), style: TextStyle(fontSize: 15),),
            ],
          )
      ),
    );
  }

  void _onTaped() {
    if(widget.delegate != null) {
      widget.delegate.onTapChatGroup(widget.emGroup);
    }else {
      print("没有实现 EMChatGroupListItemDelegate");
    }
  }

}

abstract class ChatGroupListItemDelegate {
  void onTapChatGroup(EMGroup group);
}