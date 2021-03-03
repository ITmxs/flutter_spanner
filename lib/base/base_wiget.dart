import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'common.dart';

// ignore: non_constant_identifier_names
Widget BaseAppBar(BuildContext context, {String title = ''}) => AppBar(
      title: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
      ),
      backgroundColor: AppColors.AppBarColor,
      elevation: 0,
      leading: FlatButton(
        child: Image(
          image: AssetImage('Assets/appbar/back.png'),
        ),
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
    );

// ignore: non_constant_identifier_names
Widget CustomTextFieldItem(double width, String itemName, TextEditingController textController, {String hintText = '请输入', bool redStar = false, bool camera = false}) {
  return Container(
    width: width,
    height: 50,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 39,
          child: Row(
            children: [
              Container(
                width: width / 2,
                child: Row(
                  children: [
                    redStar?Image.asset('Assets/redStart.png', width: 10,):Container(),
                    SizedBox(width: 5,),
                    Text(
                      itemName,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                width: width / 2,
                child: Row(
                  children: [
                    Container(
                      width: width / 2 - 18 - 5 - 5,
                      child: TextField(
                        controller: textController,
                        style: TextStyle(fontSize: 13),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText:hintText,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    camera?Icon(
                      Icons.camera_alt,
                      size: 18,
                    ):Container(),
                    SizedBox(width: 5,),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          color: AppColors.ViewBackgroundColor,
          height: 1,
        ),
      ],
    ),
  );
}

// ignore: non_constant_identifier_names
Widget SliverFixedExtentListItem(String itemName, String content) {
  return Container(
    height: 50,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  itemName,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Expanded(child: Container(
                child: Text(content, textAlign: TextAlign.right, style: TextStyle(fontSize: 14),maxLines: 1,
                  overflow: TextOverflow.ellipsis,),
              ),),
            ],
          ),
        ),
      ],
    ),
  );
}

///网络图片
Widget networkImage(BuildContext context, String imgUrl, {double imgWidth, double imgHeight, BoxFit fit = BoxFit.contain}) {
  return CachedNetworkImage(
    imageUrl: imgUrl,
    width: imgWidth,
    height: imgHeight,
    fit: BoxFit.fill,
    placeholder: (context, url) => Container(color: Colors.grey,),
    errorWidget: (context, url, error) =>
        Image.asset("images/loadImgError.png", width: imgWidth, height: imgHeight,),
  );
}


///网络图片
Widget imageNetwork(BuildContext context, String imgUrl, {double imgWidth, double imgHeight, bool crop = false}) {
  return CachedNetworkImage(
    imageUrl: imgUrl+'?x-oss-process=image/resize,m_fill,h_'+imgHeight.toString()+',w_'+imgWidth.toString(),
    placeholder: (context, url) => CircularProgressIndicator(),
    errorWidget: (context, url, error) =>
        Image.asset("Assets/loadImgError.png", width: imgWidth, height: imgHeight,),
  );
}




String judgeStringValue(String string) {
  if(string == null) {
    return ' ';
  }else {
    return string;
  }
}


