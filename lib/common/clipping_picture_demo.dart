import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spanners/common/routerUtil.dart';

// ignore: must_be_immutable
class ClippingPictureDemo extends StatefulWidget {
  Function push;
  ClippingPictureDemo({this.push});

  @override
  _ClippingPictureDemoState createState() => _ClippingPictureDemoState();
}

class _ClippingPictureDemoState extends State<ClippingPictureDemo> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      RouterUtil.pushReplacementNamed(context,
          routerName: "clippingDemo2",
          data: {"path": pickedFile.path}, pushThen: (value) {
        widget.push(value);
      });
    } else {
      print('No image selected.');
    }
  }

  Future getImageFor() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      RouterUtil.pushReplacementNamed(context,
          routerName: "clippingDemo2",
          data: {"path": pickedFile.path}, pushThen: (value) {
        widget.push(value);
      } );
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              getImage();
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Center(
                child: Text(
                  '拍照',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        children: [
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              getImageFor();
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Center(
                child: Text(
                  '图片选择',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        children: [
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Center(
                child: Text(
                  '取消',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      SizedBox(
        height: 20,
      ),
    ]);
  }
}
