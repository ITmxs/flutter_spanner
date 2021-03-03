import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_crop/image_crop.dart';
import 'package:spanners/cTools/scanPut.dart';

// ignore: must_be_immutable
class ClippingDemo2 extends StatefulWidget {
  String data;

  setData(data) {
    this.data = data["path"];
  }

  @override
  _ClippingDemo2State createState() => new _ClippingDemo2State();
}

class _ClippingDemo2State extends State<ClippingDemo2> {
  final cropKey = GlobalKey<CropState>();
  File _file;
  File _sample;
  File _lastCropped;

  @override
  // ignore: must_call_super
  void initState() {
    _file = File(widget.data);
    _sample = _file;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: _buildCroppingImage(),
        ),
      ),
    );
  }

  Widget _buildCroppingImage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(_sample, key: cropKey),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: Text(
                  '确认',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white),
                ),
                onPressed: () => _cropImage(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      return;
    }

    final sample = await ImageCrop.sampleImage(
      file: _file,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample?.delete();

    _lastCropped?.delete();
    _lastCropped = file;

    debugPrint(file.path);
    _saveImage(file).then((value) => {
          _postImagePath(value),
        });
  }

  Future<FormData> _saveImage(File file) async {
    File imageFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      Directory.systemTemp.path +
          '/userava' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.jpg',
      quality: 50,
    );
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path,
          filename: imageFile.path.substring(
              imageFile.path.lastIndexOf("/") + 1, imageFile.path.length))
    });

    return formData;
  }

  _postImagePath(imagePath) async {
    ScanDio.imageRequest(
      param: imagePath,
      onSuccess: (data) {
        Navigator.pop(context, data);
      },
      onError: (error) {},
    );
  }
}
