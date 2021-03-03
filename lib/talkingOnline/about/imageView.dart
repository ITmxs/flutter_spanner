import 'package:flutter/material.dart';
import 'package:spanners/cTools/imageChange.dart';
import 'package:spanners/cModel/aboutModel.dart';
import 'package:spanners/cTools/foldText.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:spanners/talkingOnline/about/aaboutRequestApi.dart';

class ImageView extends StatefulWidget {
  final dataLists;
  final ValueChanged<String> onChanged; //
  const ImageView({Key key, this.dataLists, this.onChanged}) : super(key: key);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var dataModel;
  List<String> imageList;
  //关注
  _followUserId(String articleId, String type) {
    AboutDio.followUserId(
        param: {'followUserId': articleId, 'type': type},
        onSuccess: (data) {
          print(data);
          setState(() {
            widget.onChanged('');
          });
        },
        onError: (error) {
          setState(() {});
        });
  }

  //加好友
  _addFriend(
    String friendname,
  ) async {
    AboutDio.addFriendRequest(
        param: {
          'friendname': friendname,
          'ownername': await SharedManager.getString('mobile')
        },
        onSuccess: (data) {
          print(data);
          setState(() {
            widget.onChanged('');
          });
        },
        onError: (error) {
          setState(() {});
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      dataModel = AboutModel.fromJson(widget.dataLists);
      if (dataModel.imagesStr.toString().length > 0) {
        imageList = dataModel.imagesStr.toString().split(',');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dataModel = AboutModel.fromJson(widget.dataLists);
    return Container(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 11,
          ),
//--> 头像
          Row(children: <Widget>[
            SizedBox(
              width: 5,
            ),
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(25.0),
                  image: DecorationImage(
                    image: dataModel.headurl == null
                        ? AssetImage('Assets/Technology/headimage.png')
                        : NetworkImage(dataModel.headurl.toString()),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white),
            ),
            SizedBox(
              width: 7,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Container(
                  // width: 160,
                  height: 20,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(dataModel.realName.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Medium')),
                  ),
                ),
                Container(
                  //  width: 160,
                  height: 20,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(dataModel.date.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontFamily: 'Medium')),
                  ),
                ),
              ],
            ),
            Expanded(child: SizedBox()),
            //加好友
            dataModel.auth == SynchronizePreferences.Get('userid')
                ? Container()
                : dataModel.isFriend
                    ? Container()
                    : InkWell(
                        onTap: () {
                          _addFriend(dataModel.mobile);
                        },
                        child: Image.asset(
                          'Assets/Technology/addfiend.png',
                          width: 22,
                          height: 22,
                          fit: BoxFit.fill,
                        ),
                      ),
            SizedBox(
              width: 20,
            ),

            // 关注
            dataModel.auth == SynchronizePreferences.Get('userid')
                ? Container()
                : InkWell(
                    onTap: () {
                      dataModel.isWatching
                          ? _followUserId(dataModel.auth, '1')
                          : _followUserId(dataModel.auth, '0');
                    },
                    child: Container(
                        width: 50,
                        height: 25,
                        child: dataModel.isWatching
                            ? Image.asset("Assets/Home/focused.png")
                            : Image.asset("Assets/Home/focus.png")),
                  ),
            SizedBox(
              width: 20,
            ),
          ]),
          SizedBox(
            height: 22,
          ),
//--> 内容
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Expanded(
                  child: FoldText(
                text: dataModel.text.toString(),
                width: MediaQuery.of(context).size.width - 30,
              )),
              SizedBox(
                width: 15,
              ),
            ],
          ),

//--> image 区域
          SizedBox(
            height: 19,
          ),

          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), //禁止滑动
                    itemCount: imageList.length,
                    //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //横轴元素个数
                        crossAxisCount: 3,
                        //纵轴间距
                        mainAxisSpacing: 10.0,
                        //横轴间距
                        crossAxisSpacing: 11.0,
                        //子组件宽高长度比例
                        childAspectRatio: 1.0),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(new FadeRoute(
                              page: ShowPhotp(
                            photoList: imageList,
                            index: index,
                          )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3 - 50 / 3,
                          height:
                              MediaQuery.of(context).size.width / 3 - 50 / 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              imageList[index].toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
