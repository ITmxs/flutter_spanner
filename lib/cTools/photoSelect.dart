import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spanners/cTools/Router.dart';

//视频压缩
import 'package:video_compress/video_compress.dart';

//ocr
import './scanPut.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

//
import 'package:spanners/cTools/showLoadingView.dart';

// ignore: slash_for_doc_comments
/**
 ****
    PhotoVideo --> 图片视频 获取 压缩 formdata 上传 服务器 ，实用类
 ****
 **/
class PhotoVideo {
/*拍照*/
  // ignore: unused_element
  static void _takePhoto<T>({
    Function(FormData) onValue,
  }) async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    Navigator.pop(Routers.navigatorState.currentState.context);
    _saveImage(image).then((value) => {
          /*
           post 上传 block 传值一系列操作
          */
          onValue(value)
        });
  }

/*相册 单图选择*/
  // ignore: unused_element
  static void _openGallerySingle<T>({
    Function(FormData) onValue,
  }) async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    print('相册图片-->$image');
    _saveImage(image).then((value) => {
          /*
           post 上传 block 传值一系列操作
          */
          onValue(value)
        });
    Navigator.pop(Routers.navigatorState.currentState.context);
  }

  /*相册 多图选择*/
  // ignore: unused_element
  static void _openGallery<T>({
    Function(List) onValue,
  }) async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        // 是否支持拍照
        enableCamera: true,
        materialOptions: MaterialOptions(
            // 显示所有照片， false时显示相册
            startInAllView: true,
            allViewTitle: '所有照片',
            actionBarColor: '#1ba593',
            textOnNothingSelected: '没有选择照片',
            selectionLimitReachedText: '图片选择超出限制，最多选择9张'),
      );
    } catch (e) {
      print(e);
    }

    if (resultList.length > 0) {
      _saveImages(resultList).then((value) => {
            /*
            post 上传 block 传值一系列操作
            */
            onValue(value)
          });
    }

    Navigator.pop(Routers.navigatorState.currentState.context);
  }

  /* 单图片压缩 与 flie存图*/
  static Future<FormData> _saveImage(File file) async {
    File imageFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      Directory.systemTemp.path +
          '/userava' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.jpg',
      quality: 50,
    );
    print('压缩后图片文件大小:' + imageFile.lengthSync().toString());

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path,
          filename: imageFile.path.substring(
              imageFile.path.lastIndexOf("/") + 1, imageFile.path.length))
    });

    return formData;
  }

  /*  多图片压缩 与 flie存图*/
  static Future<List> _saveImages(List<Asset> images) async {
    List fileList = List();
    for (int i = 0; i < images.length; i++) {
      ByteData byteData = await images[i].getByteData(quality: 60);
      String name = DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = MultipartFile.fromBytes(
        imageData,
        // 文件名
        filename: name,
        // // 文件类型
        // contentType: MediaType("image", "jpg"),
      );
      FormData formData = FormData.fromMap({'file': multipartFile});
      if (multipartFile != null) {
        fileList.add(formData);
      }
    }

    return fileList;
  }

  //视频压缩 初始化
  //static final _flutterVideoCompress = FlutterVideoCompress();
  /*拍摄视频*/
  // ignore: unused_element
  static _getVideo() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickVideo(
        maxDuration: Duration(seconds: 10), source: ImageSource.camera);
    print('视频文件大小:' + image.lengthSync().toString());
    Navigator.pop(Routers.navigatorState.currentState.context);
    /* 视频的压缩上传 */
    _upLoadVideo(image);
  }

  /* 视频的压缩上传 */
  static _upLoadVideo(image) async {
    // await _flutterVideoCompress
    //     .compressVideo(
    //       image.path,
    //       quality: VideoQuality.LowQuality, //  默认VideoQuality.DefaultQuality
    //       deleteOrigin: false, // 默认(false)
    //     )
    //     .then((value) async => {
    //           print('压缩后视频文件大小:' + value.toJson().toString()),
    //           /*
    //           post 上传 block 传值一系列操作
    //           */
    //         });
  }

  /*选取视频*/
  // ignore: unused_element
  static _takeVideo() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickVideo(
        source: ImageSource.gallery, preferredCameraDevice: CameraDevice.front);

    print('相册选取的视频文件:$image');
    /*
      暂时没有更好的办法，先原文件上传
    */
    Navigator.pop(Routers.navigatorState.currentState.context);
  }
}

// ignore: slash_for_doc_comments
/**
 ****
    带有 bottomsheet  拍照 相册 拍摄 取消 选择的 封装好的 页面 实用类
 ****
 **/
class PhotoSelect extends StatefulWidget {
  final bool isScan; // 是否ocr
  final bool isVin; // 是否vin
  final int type; //1, 拍照-相册   2，拍照-相册 摄像-相册
  final int imageNumber; // 相册多图选择时 的 设置
  final List imageList;
  final List _imagesList = List();
  final ValueChanged<List> onChanged; // 图片上传成功返回值集合
  final ValueChanged<String> onChangedVideo; // 视频上传成功返回值url
  final ValueChanged onPutString; // 成功后返回值
  PhotoSelect({
    Key key,
    this.onChanged,
    this.type,
    this.imageList,
    this.onChangedVideo,
    this.isScan,
    this.isVin,
    this.onPutString,
    this.imageNumber,
  }) : super(key: key);

  @override
  _PhotoSelectState createState() => _PhotoSelectState();
}

class _PhotoSelectState extends State<PhotoSelect> {
  var _imagePath;

  //视频压缩 初始化
  //final _flutterVideoCompress = FlutterVideoCompress();

/*  加载数据的  loading 动画  */
  static Future _showAlertDialog(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowLoading(
          title: message,
        );
      },
    );
  }

/*  加载数据的  请求失败 超时  */
  // ignore: unused_element
  static Future _showErrorDialog(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowError(
          title: message,
        );
      },
    );
  }

  @override
  /* 图片上传 -- > 实现功能：ocr识别*/
  // ignore: override_on_non_overriding_member
  _postOCRImagePath(imagePath) async {
    ScanDio.ocrRequest(
      param: imagePath,
      onSuccess: (data) {
        print('====>$data');
        if (data.toString() == '请上传正确的图片') {
          _showErrorDialog('请上传正确的图片');
        } else {
          widget.onPutString(data.toString());
        }
      },
      onError: (error) {},
    );
  }

  /* 图片上传 -- > 实现功能：vin识别*/
  _postVinImagePath(imagePath) async {
    ScanDio.vinRequest(
      param: imagePath,
      onSuccess: (data) {
        print('========>' + data);
        if (data.toString() == '请上传正确图片') {
          _showErrorDialog('请上传正确图片');
        } else {
          /*  传输 字典格式*/
          //var value = data[0]['results'][0]['vehicleVinInfo']['vin'].toString();

          print('vin回调传值$data');
          widget.onPutString(data);
        }
      },
      onError: (error) {},
    );
  }

  /* 图片上传 -- > 实现功能：图片上传....*/
  // ignore: override_on_non_overriding_member
  _postImagePath(int number, imagePath) async {
    ScanDio.imageRequest(
      param: imagePath,
      onSuccess: (data) {
        widget._imagesList.clear();

        widget._imagesList.add(data);
        widget.onChanged(widget._imagesList);
        print('图片上传成功-->${widget._imagesList}');

        // if (widget._imagesList.length == number) {
        //   widget.onChanged(widget._imagesList);
        // }
      },
      onError: (error) {},
    );
  }

  /* 视频上传 -- > 实现功能：视频上传....*/

  // ignore: unused_element
  _postVideoPath(imagePath) async {
    ScanDio.videoRequest(
      param: imagePath,
      onSuccess: (data) {
        print('视频上传成功-->$data');
        widget.onChangedVideo(data);
      },
      onError: (error) {},
    );
  }

  /*拍照*/
  // ignore: override_on_non_overriding_member
  _takePhoto() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      print('拍照图片-->$image');
      _saveImage(image).then((value) => {
            if (widget.isScan)
              {_postOCRImagePath(value), print('--->OCR')}
            else if (widget.isVin)
              {_postVinImagePath(value), print('--->vin')}
            else
              {_postImagePath(1, value), print('--->image')}
          });

      Navigator.pop(context);
      //  widget._imagesList.add(_imagePath);
    });
  }

  /*相册 单图选择*/
  // ignore: unused_element
  _openGallerySingle() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      print('相册图片-->$image');
      _saveImage(image).then((value) => {
            if (widget.isScan)
              {_postOCRImagePath(value), print('--->OCR')}
            else if (widget.isVin)
              {_postVinImagePath(value), print('--->vin')}
            else
              {_postImagePath(1, value), print('--->image')}
          });
      Navigator.pop(context);
    });
  }

  /*相册 多图选择*/
  _openGallery() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: widget.imageNumber - widget._imagesList.length,
        // 是否支持拍照
        enableCamera: true,
        materialOptions: MaterialOptions(
            // 显示所有照片， false时显示相册
            startInAllView: true,
            allViewTitle: '所有照片',
            actionBarColor: '#1ba593',
            textOnNothingSelected: '没有选择照片',
            selectionLimitReachedText: '图片选择超出限制，最多选择${widget.imageNumber}张'),
      );
    } catch (e) {
      print(e);
    }
    if (!mounted) return;

    if (resultList.length > 0) {
      setState(() {
        _saveImages(resultList).then((value) => {
              print('图片地址File集合：${widget._imagesList}'),
              for (var i = 0; i < value.length; i++)
                {_postImagePath(resultList.length, value[i])}
            });
      });
    }
    Navigator.pop(context);
  }

/*拍摄视频*/
  _getVideo() async {
    // ignore: deprecated_member_use
    var video = await ImagePicker.pickVideo(
        maxDuration: Duration(seconds: 10), source: ImageSource.camera);
    print('视频文件大小:' + video.lengthSync().toString());
    Navigator.pop(context);
    /* 视频的压缩上传 */
    _upLoadVideo(video);
  }

  /* 视频的压缩上传 */
  _upLoadVideo(video) async {
    _showAlertDialog('处理中...');

    await VideoCompress.setLogLevel(0);
    final info = await VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    if (info != null) {
      print(
          'video 本地压缩路径========================================== ${info.path}');
      _postVideoPath(FormData.fromMap({
        'file': await MultipartFile.fromFile(info.path,
            filename: info.path
                .substring(info.path.lastIndexOf("/") + 1, info.path.length))
      }));
      VideoCompress.cancelCompression();
    }
  }

  /*选取视频*/
  _takeVideo() async {
    // ignore: deprecated_member_use
    var video = await ImagePicker.pickVideo(
        source: ImageSource.gallery, preferredCameraDevice: CameraDevice.front);

    print('相册选取的视频文件:$video');
    Navigator.pop(context);
    _upLoadVideo(video);
    await VideoCompress.setLogLevel(0);
    final info = await VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    if (info != null) {
      print(
          'video 本地压缩路径========================================== ${info.path}');
      _postVideoPath(FormData.fromMap({
        'file': await MultipartFile.fromFile(info.path,
            filename: info.path
                .substring(info.path.lastIndexOf("/") + 1, info.path.length))
      }));
      VideoCompress.cancelCompression();
    }
  }

/*  多图片压缩 与 flie存图*/
  Future<List> _saveImages(List<Asset> images) async {
    List fileList = List();
    for (int i = 0; i < images.length; i++) {
      ByteData byteData = await images[i].getByteData(quality: 60);
      String name = DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = MultipartFile.fromBytes(
        imageData,
        // 文件名
        filename: name,
        // // 文件类型
        // contentType: MediaType("image", "jpg"),
      );
      FormData formData = FormData.fromMap({'file': multipartFile});
      if (multipartFile != null) {
        fileList.add(formData);
      }
    }

    return fileList;
  }

/* 单图片压缩 与 flie存图*/
  Future<FormData> _saveImage(File file) async {
    File imageFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      Directory.systemTemp.path +
          '/userava' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.jpg',
      quality: 50,
    );
    print('压缩后图片文件大小:' + imageFile.lengthSync().toString());

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path,
          filename: imageFile.path.substring(
              imageFile.path.lastIndexOf("/") + 1, imageFile.path.length))
    });

    return formData;
  }

  @override
  void initState() {
    // TODO: implement initState
    print('传来的数组：${widget.imageList}');
    widget.imageList == null
        ? print('传来的数组为null')
        : widget._imagesList.addAll(widget.imageList);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 3) {
      return Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  _takePhoto();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
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
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      '取消',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Column(
      children: [
        widget.type == 2
            ? Container()
            : Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _takePhoto();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
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
        widget.type == 2
            ? SizedBox()
            : SizedBox(
                height: 10,
              ),
        widget.type == 2
            ? Container()
            : Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.isScan) {
                        _openGallerySingle();
                        print('--->OCR');
                      } else if (widget.isVin) {
                        _openGallerySingle();
                        print('--->vin');
                      } else {
                        _openGallery();
                        print('--->image');
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
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
        widget.type == 2
            ? SizedBox(
                height: 10,
              )
            : SizedBox(
                height: 0,
              ),
        widget.type == 2
            ? Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _getVideo();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Center(
                        child: Text(
                          '拍摄',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              )
            : Container(),
        widget.type == 2
            ? SizedBox(
                height: 10,
              )
            : SizedBox(
                height: 0,
              ),
        widget.type == 2
            ? Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _takeVideo();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Center(
                        child: Text(
                          '视频选择',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              )
            : Container(),
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
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
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
      ],
    );
  }
}
