import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

//单 图 展示
class PhotoViewSimpleScreen extends StatelessWidget {
  const PhotoViewSimpleScreen({
    this.imageProvider, //图片
    this.loadingChild, //加载时的widget
    this.backgroundDecoration, //背景修饰
    this.minScale, //最大缩放倍数
    this.maxScale, //最小缩放倍数
    this.heroTag, //hero动画tagid
    this.photoList,
    this.initialIndex, //展示选中 图片
    this.currentIndex, //底部展示第几个图片
  });
  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String heroTag;
  final String photoList;
  final int initialIndex;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '图片展示',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          backgroundColor: Colors.black,
        ),
        body: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: PhotoView(
                    imageProvider: imageProvider,
                    loadingChild: loadingChild,
                    backgroundDecoration: backgroundDecoration,
                    minScale: minScale,
                    maxScale: maxScale,
                    heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
                    enableRotation: false,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

////多 图 展示
class ShowPhotp extends StatefulWidget {
  final List photoList;
  final int index;

  const ShowPhotp({Key key, this.photoList, this.index}) : super(key: key);

  @override
  _ShowPhotpState createState() => _ShowPhotpState();
}

class _ShowPhotpState extends State<ShowPhotp> {
  @override
  int initialIndex; //初始index
  int length;
  int title;
  Widget loadingChild;
  @override
  void initState() {
    initialIndex = widget.index;
    length = widget.photoList.length;
    title = initialIndex + 1;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      title = index + 1;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('$title / $length'),
        centerTitle: true,
      ),
      body: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              PhotoViewGallery.builder(
                scrollDirection: Axis.horizontal,
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.photoList[index]),
                    initialScale: PhotoViewComputedScale.contained * 1,
                    heroAttributes: PhotoViewHeroAttributes(tag: 'heroTag'),
                  );
                },
                itemCount: widget.photoList.length,
                // ignore: deprecated_member_use
                loadingChild: loadingChild,
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
                pageController:
                    PageController(initialPage: initialIndex), //点进去哪页默认就显示哪一页
                onPageChanged: onPageChanged,
              ),
            ],
          )),
    );
  }
}
