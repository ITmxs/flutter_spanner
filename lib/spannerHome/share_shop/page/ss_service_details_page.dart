import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spanners/base/base_wiget.dart';
import 'package:spanners/base/common.dart';
import 'package:spanners/spannerHome/share_shop/model/ss_service_details_model.dart';
import 'package:spanners/spannerHome/share_shop/provide/ss_service_details_provide.dart';


class SSServiceDetailsPage extends StatefulWidget {

  final String id;

  const SSServiceDetailsPage({Key key, this.id}) : super(key: key);

  @override
  _SSServiceDetailsPageState createState() => _SSServiceDetailsPageState();
}

class _SSServiceDetailsPageState extends State<SSServiceDetailsPage> {

  SSServiceDetailsProvide _provide;
  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _provide = SSServiceDetailsProvide();
    _loadData();
  }

  _loadData(){
    var s = _provide
        .getShareShopServiceDetails(widget.id)
        .doOnData((event) {})
        .doOnListen(() {})
        .doOnCancel(() {})
        .listen((data) {}, onError: (e) {});
    _subscriptions.add(s);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provide,
      child: Scaffold(
        appBar: BaseAppBar(context, title: '扳手共享'),
        body: _initViews(),
      ),
    );
  }

  _initViews() => Selector<SSServiceDetailsProvide, ShareShopServiceModel>(builder: (_,model,child){return Container(
    padding: EdgeInsets.only(
      top: 16,
      left: 15,
      right: 15,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          color: Colors.white,
          padding: EdgeInsets.only(left: 15, right: 25, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('所属项目'),
              Text(_provide.serviceModel.belongName),
            ],
          ),
        ),
        Container(
          height: 1,
          color: AppColors.ViewBackgroundColor,
        ),
        Container(
          height: 50,
          color: Colors.white,
          padding: EdgeInsets.only(left: 15, right: 25, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('项目名称'),
              Text(_provide.serviceModel.projectName),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          height: 50,
          color: Colors.white,
          padding: EdgeInsets.only(left: 15, right: 25, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('项目单价'),
              Text('¥'+_provide.serviceModel.price),
            ],
          ),
        ),
        SizedBox(height: 19,),
        Container(
          padding: EdgeInsets.only(left: 12),
          child: Text('项目描述'),
        ),
        SizedBox(height: 11,),
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width-30,
          padding: EdgeInsets.only(left: 13, top: 11, right: 14, bottom: 7),
          child: Text(_provide.serviceModel.remark
            ,  maxLines: 30,
          ),
        ),
        SizedBox(height: 11,),
        Column(
          children: [
            Container(
              color: AppColors.backgroundColor,
              width: MediaQuery.of(context).size.width-30,
              padding: EdgeInsets.only(left: 13, top: 11, right: 14),
              child: Text('门店 / '+_provide.serviceModel.shopName
                ,  maxLines: 30,
              ),
            ),
            Container(
              color: AppColors.backgroundColor,
              width: MediaQuery.of(context).size.width-30,
              padding: EdgeInsets.only(left: 13, top: 11, right: 14),
              child: Text('地址 / '+_provide.serviceModel.shopAddress
                ,  maxLines: 30,
              ),
            ),
            Container(
              color: AppColors.backgroundColor,
              width: MediaQuery.of(context).size.width-30,
              padding: EdgeInsets.only(left: 13, top: 11, right: 14, bottom: 7),
              child: Text('电话 / '+_provide.serviceModel.tel
                ,  maxLines: 30,
              ),
            ),
          ],
        ),
      ],
    ),
  );}, selector: (_,provide)=>_provide.serviceModel);


}
