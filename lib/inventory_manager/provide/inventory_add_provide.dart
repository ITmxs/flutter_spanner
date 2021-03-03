
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:spanners/base/base_provide.dart';
import 'package:spanners/inventory_manager/model/inventory_add_model.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

class InventoryAddProvide extends BaseProvide {

  Map submitMap = {
    "applyto": '',///适用车型
    "barcode": '',///条形码
    "bonus": '',///商品分红
    "brand": '',///商品品牌
    "categoryId": '',///分类ID
    "goodsName": '',///商品名
    "goodsPrice": '',///零售价格
    "locationId": '',///库位ID
    "model": '',///商品型号
    "partsCost": '',///商品成本
    "picUrl": '',///照片
    "specName": '',///商品规格
    "stock": '',///商品库存
    "unitName": '',///商品单位
    "warningValue": '',///最低库存
    'borrowType':'',///借出方式
    'listPics':[],///详情图片
    'remarks':'',///商品描述
    'sharePrice':'',///共享价格
    'shareStock':'',///上架数量
    'shareSwitch':'',///共享上架开关
    'startingPrise':'',///入手价格
    ///更改二手详情时需要
    'shopGoodsId':'',
    'secondHand':'',
  };

  Map submitEquipmentMap = {
    "name": '',///工具名称
    "brand": '',///工具品牌
    "model": '',///工具型号
    "specName": '',///工具规格
    "organization": '',///工具单位
    "barcode": '',///工具条码
    "stock": '',///库存数量
    "cost": '',///设备成本
    "picUrl": '',///照片
    "share":'',///共享开关
    "remarks":'',///备注
    "shareDescription": '',///商品描述
    "sharePics":'',///共享商品图片
    'sharePrice':'',///共享价格
    ///更改设备详情时需要
    'id':''
  };

  ///第一块分类
  List _titleList = [];
  List get titleList => _titleList;
  set titleList(List value) {
    _titleList = value;
    _titleList.forEach((element) {
      this.textControllerList.add(TextEditingController());
    });
  }

  List _textControllerList = [];
  List get textControllerList => _textControllerList;
  set textControllerList(List value) {
    _textControllerList = value;
    print(value.length);
  }

  ///适用车型
  TextEditingController applyToTextController = TextEditingController();
  ///库存数量
  TextEditingController inventoryQuantityTextController = TextEditingController(text: '0');
  ///最低库存
  TextEditingController inventoryQuantityLowTextController = TextEditingController();
  ///库位
  TextEditingController inventoryLocationTextController = TextEditingController();
  ///设备成本
  TextEditingController inventoryEquipmentCostTextController = TextEditingController();
  ///设备备注
  TextEditingController equipmentNoteTextController = TextEditingController();
  ///共享商品描述
  TextEditingController shareDescribeTextController = TextEditingController();
  ///上架数量
  TextEditingController shareNumberTextController = TextEditingController();
  ///入手价格
  TextEditingController shareOriginalPriceTextController = TextEditingController();
  ///共享价格
  TextEditingController sharePriceTextController = TextEditingController();

  ///第二块
  List _titleSubList = [];
  List get titleSubList => _titleSubList;
  set titleSubList(List value) {
    _titleSubList = value;
    _titleList.forEach((element) {
      this.textSubControllerList.add(TextEditingController());
    });
  }

  List _textSubControllerList = [];
  List get textSubControllerList => _textSubControllerList;
  set textSubControllerList(List value) {
    _textSubControllerList = value;
    print(value.length);
  }

  bool _showShare = false;
  bool get showShare => _showShare;
  set showShare(bool value) {
    _showShare = value;
    notifyListeners();
  }

  InventoryManageGoodsModel _detailsModel = InventoryManageGoodsModel();
  InventoryManageGoodsModel get detailsModel => _detailsModel;
  set detailsModel(InventoryManageGoodsModel value) {
    _detailsModel = value;
    _setContent();
  }

  InventoryManageEquipmentModel _equipmentDetailsModel = InventoryManageEquipmentModel();
  InventoryManageEquipmentModel get equipmentDetailsModel => _equipmentDetailsModel;
  set equipmentDetailsModel(InventoryManageEquipmentModel value) {
    _equipmentDetailsModel = value;
    _setEquipmentContent();
  }

  String _picUrl = '';
  String get picUrl => _picUrl;
  set picUrl(String value) {
    _picUrl = value;
    print(value);
    notifyListeners();
  }

  List _shareImagesList = [];
  List get shareImagesList => _shareImagesList;
  set shareImagesList(List value) {
    _shareImagesList = value;
    notifyListeners();
  }

  _setContent(){

    TextEditingController goodsTypeNameController = this.textControllerList[0];
    goodsTypeNameController.text = this.detailsModel.categoryName;

    TextEditingController goodsNameController = this.textControllerList[1];
    goodsNameController.text = this.detailsModel.goodsName;

    TextEditingController brandController = this.textControllerList[2];
    brandController.text = this.detailsModel.brand;

    TextEditingController modelController = this.textControllerList[3];
    modelController.text = this.detailsModel.model;

    TextEditingController specNameController = this.textControllerList[4];
    specNameController.text = this.detailsModel.specName;

    TextEditingController unitNameController = this.textControllerList[5];
    unitNameController.text = this.detailsModel.unitName;

    TextEditingController barCodeController = this.textControllerList[6];
    barCodeController.text = this.detailsModel.barcode;


    ///适用车型
    this.applyToTextController.text = this.detailsModel.applyto;

    ///库存数量
    this.inventoryQuantityTextController.text = this.detailsModel.stock;

    ///最低库存
    this.inventoryQuantityLowTextController.text = this.detailsModel.warningValue;
    ///共享图片
    this.shareImagesList = this.detailsModel.infoPics;
    ///共享上架
    this.showShare = this.detailsModel.shareSwitch == '1';
    ///商品描述
    this.shareDescribeTextController.text = this.detailsModel.remarks;
    ///上架数量
    this.shareNumberTextController.text = this.detailsModel.shareStock;
    ///入手价格
    this.shareOriginalPriceTextController.text = this.detailsModel.startingPrise;
    ///共享价格
    this.sharePriceTextController.text = this.detailsModel.sharePrice;

    TextEditingController partsCostController = this.textSubControllerList[0];
    partsCostController.text = this.detailsModel.partsCost;
    TextEditingController goodsPriceController = this.textSubControllerList[1];
    goodsPriceController.text = this.detailsModel.goodsPrice;
    TextEditingController bonusController = this.textSubControllerList[2];
    bonusController.text = this.detailsModel.bonus;

    TextEditingController locationController = this.inventoryLocationTextController;
    locationController.text = this.detailsModel.locationName;

    this.picUrl = this.detailsModel.picUrl;

    notifyListeners();
  }

  _setEquipmentContent(){
    TextEditingController nameController = this.textControllerList[0];
    nameController.text = this.equipmentDetailsModel.name;

    TextEditingController brandController = this.textControllerList[1];
    brandController.text = this.equipmentDetailsModel.brand;

    TextEditingController modelController = this.textControllerList[2];
    modelController.text = this.equipmentDetailsModel.model;

    TextEditingController specNameController = this.textControllerList[3];
    specNameController.text = this.equipmentDetailsModel.specName;

    TextEditingController organizationController = this.textControllerList[4];
    organizationController.text = this.equipmentDetailsModel.organization;

    TextEditingController barCodeController = this.textControllerList[5];
    barCodeController.text = this.equipmentDetailsModel.barcode;

    ///库存数量
    this.inventoryQuantityTextController.text = this.equipmentDetailsModel.stock;
    ///设备成本
    this.inventoryEquipmentCostTextController.text = this.equipmentDetailsModel.cost;
    ///图片
    this.picUrl = this.equipmentDetailsModel.picUrl;
    ///备注
    this.equipmentNoteTextController.text = this.equipmentDetailsModel.remarks;
    ///共享上架
    this.showShare = this.equipmentDetailsModel.share == '1';
    ///商品描述
    this.shareDescribeTextController.text = this.equipmentDetailsModel.shareDescription;
    ///共享图片
    this.shareImagesList = this.equipmentDetailsModel.sharePics;
    ///共享价格
    this.sharePriceTextController.text = this.equipmentDetailsModel.sharePrice;

    notifyListeners();
  }

  final InventoryManageRepo _repo = InventoryManageRepo();

  Stream postAddGoods(){

    return _repo.postAddGoods(this.submitMap)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      var data = res['data'];
      if(data){
        BotToast.showText(text: '创建成功');
      }else {
        BotToast.showText(text: data);
      }
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream postAddSecondHand(){

    return _repo.postAddSecondHand(this.submitMap)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      var data = res['msg'];
      BotToast.showText(text: data);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream postAddEquipment(){

    return _repo.postAddEquipment(this.submitEquipmentMap)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      var data = res['msg'];
      BotToast.showText(text: data);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }


  Stream getInventoryDetails(String shopGoodsId){
    var query = {
      'shopGoodsId': shopGoodsId,
    };
    return _repo.getInventoryDetails(query: query).doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      InventoryManageGoodsModel model = InventoryManageGoodsModel.fromJson(res['data']);
      this.detailsModel = model;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream getInventoryEquipmentDetails(String equipmentId){
    var query = {
      'equipmentId': equipmentId,
    };
    return _repo.getInventoryEquipmentDetails(query: query).doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      InventoryManageEquipmentModel model = InventoryManageEquipmentModel.fromJson(res['data']);
      this.equipmentDetailsModel = model;
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream postModifyGoods(Map modifyGoodsMap){

    return _repo.postModifyGoods(modifyGoodsMap)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      var data = res['msg'];
      BotToast.showText(text: data);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream postModifyEquipment(Map modifyGoodsMap){

    return _repo.postModifyEquipment(modifyGoodsMap)
        .doOnData((result) {
      Map res = convert.jsonDecode(result.toString());
      var data = res['msg'];
      BotToast.showText(text: data);
    })
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }




}