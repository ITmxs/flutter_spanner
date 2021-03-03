import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CarAddImageView extends StatefulWidget {
  final List _imagesList = List();
  @override
  _CarAddImageViewState createState() => _CarAddImageViewState();
}

class _CarAddImageViewState extends State<CarAddImageView> {
  var _imagePath;
  int _imageValue;

  @override
  void initState() {
    _imageValue =
        widget._imagesList.length == 0 ? 1 : widget._imagesList.length + 1;
    print('--->${widget._imagesList.length}');
    super.initState();
  }

  @override
  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _imagePath = image;
      widget._imagesList.add(_imagePath);
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = image;
      _imagePath == null ? _imageValue = _imageValue : _imageValue++;
      widget._imagesList.add(_imagePath);
      print('图片$_imagePath');
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            SizedBox(
              width: 24,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '添加照片',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ],
        ),

        SizedBox(
          height: 10,
        ),
        //iamge add part
        Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: new NeverScrollableScrollPhysics(), //禁止滑动
                  itemCount: _imageValue > 6 ? 6 : _imageValue, //做多6个
                  //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 3,
                      //纵轴间距
                      mainAxisSpacing: 10.0,
                      //横轴间距
                      crossAxisSpacing: 15.0,
                      //子组件宽高长度比例
                      childAspectRatio: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    //Widget Function(BuildContext context, int index)
                    return InkWell(
                      onTap: () {
                        //_takePhoto();
                        setState(() {
                          _openGallery();
                        });

                        // Navigator.of(context).push(new FadeRoute(
                        //     page: PhotoViewSimpleScreen(
                        //   imageProvider: NetworkImage(
                        //     "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1554110093883&di=9db9b92f1e6ee0396b574a093cc987d6&imgtype=0&src=http://n.sinaimg.cn/sinacn20/151/w2048h1303/20180429/37c0-fzvpatr1915813.jpg",
                        //   ),
                        //   heroTag: 'simple',
                        // )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3 - 50 / 3,
                        height: MediaQuery.of(context).size.width / 3 - 50 / 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: index + 1 == _imageValue
                              ? Image.asset(
                                  'Assets/Home/image_add.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  widget._imagesList[index],
                                  fit: BoxFit.fill,
                                ),
                          // child: index == _imagesList.length
                          //     ? Image.asset(
                          //         'Assets/Home/image_add.png',
                          //         fit: BoxFit.cover,
                          //       )
                          //     : Image.file(_imagesList[index]),
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
    );
  }
}
