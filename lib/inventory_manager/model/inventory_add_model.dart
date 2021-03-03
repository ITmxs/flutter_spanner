
class InventoryManageGoodsModel {
  ///商品唯一id
  final String shopGoodsId;
  ///分类标签ID
  final String categoryId;
  ///分类标签名称
  final String categoryName;
  ///商品名称
  final String goodsName;
  ///品牌
  final String brand;
  ///型号
  final String model;
  ///规格
  final String specName;
  ///单位
  final String unitName;
  ///条码
  final String barcode;
  ///适用车型
  final String applyto;
  ///库存数量
  final String stock;
  ///最低库存
  final String warningValue;
  ///商品成本
  final String partsCost;
  ///零售价
  final String goodsPrice;
  ///分红
  final String bonus;
  ///库位ID
  final String locationId;
  ///库位
  final String locationName;
  ///图片
  final String picUrl;
  ///共享开关
  final String shareSwitch;
  ///列表图片数组
  final List listPics;
  ///商品描述
  final String remarks;
  ///判断二手
  final String secondHand;
  ///共享价格
  final String sharePrice;
  ///上架数量
  final String shareStock;
  ///入手价格///市场价格
  final String startingPrise;
  ///详情图片数组
  final List infoPics;


  InventoryManageGoodsModel({this.shopGoodsId, this.categoryId, this.categoryName, this.goodsName, this.brand, this.model, this.specName, this.unitName, this.barcode, this.applyto, this.stock, this.warningValue, this.partsCost, this.goodsPrice, this.bonus, this.locationId, this.locationName, this.picUrl = '', this.shareSwitch, this.listPics, this.remarks, this.secondHand, this.sharePrice = '0', this.shareStock, this.startingPrise = '0', this.infoPics});

  InventoryManageGoodsModel.fromJson(Map<String, dynamic> json):
        shopGoodsId = json['shopGoodsId'].toString() != null ? json['shopGoodsId'].toString():'',
        categoryId = json['categoryId'].toString() != null ? json['categoryId'].toString():'',
        categoryName = json['categoryName'].toString() != null ? json['categoryName'].toString():'',
        goodsName = json['goodsName'].toString() != null ? json['goodsName'].toString():'',
        brand = json['brand'].toString() != null ? json['brand'].toString():'',
        model = json['model'].toString() != null ? json['model'].toString():'',
        specName = json['specName'].toString() != null ? json['specName'].toString():'',
        unitName = json['unitName'].toString() != null ? json['unitName'].toString():'',
        barcode = json['barcode'].toString() != null ? json['barcode'].toString():'',
        applyto = json['applyto'].toString() != null ? json['applyto'].toString():'',
        stock = json['stock'].toString() != null ? json['stock'].toString():'',
        warningValue = json['warningValue'].toString() != null ? json['warningValue'].toString():'',
        partsCost = json['partsCost'].toString() != null ? json['partsCost'].toString():'',
        goodsPrice = json['goodsPrice'].toString() != null ? json['goodsPrice'].toString():'',
        bonus = json['bonus'].toString() != null ? json['bonus'].toString():'',
        locationId = json['locationId'].toString() != null ? json['locationId'].toString():'',
        locationName = json['locationName'].toString() != null ? json['locationName'].toString():'',
        picUrl = json['picUrl'].toString() != null ? json['picUrl'].toString():'',
        shareSwitch = json['shareSwitch'].toString() != null ? json['shareSwitch'].toString():'',
        listPics = json['listPics'] != null ? json['listPics']:[],
        remarks = json['remarks'].toString() != null ? json['remarks'].toString():'',
        secondHand = json['secondHand'].toString() != null ? json['secondHand'].toString():'',
        sharePrice = json['sharePrice'].toString() != null ? json['sharePrice'].toString():'',
        shareStock = json['shareStock'].toString() != null ? json['shareStock'].toString():'',
        startingPrise = json['startingPrise'].toString() != null ? json['startingPrise'].toString():'',
        infoPics = json['infoPics'] != null ? json['infoPics']:[];

  Map<String, Object> toJson() {
    return {
      'shopGoodsId': shopGoodsId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'goodsName': goodsName,
      'brand': brand,
      'model': model,
      'specName': specName,
      'unitName': unitName,
      'barcode': barcode,
      'applyto': applyto,
      'stock': stock,
      'warningValue': warningValue,
      'partsCost': partsCost,
      'goodsPrice': goodsPrice,
      'bonus': bonus,
      'locationId': locationId,
      'locationName': locationName,
      'picUrl': picUrl,
      'shareSwitch': shareSwitch,
      'listPics': listPics,
      'remarks': remarks,
      'secondHand': secondHand,
      'sharePrice': sharePrice,
      'shareStock': shareStock,
      'startingPrise': startingPrise,
      'infoPics':infoPics
    };
  }

}

class InventoryManageEquipmentModel {
  ///id
  final String id;
  ///工具名称
  final String name;
  ///品牌
  final String brand;
  ///型号
  final String model;
  ///规格
  final String specName;
  ///单位
  final String organization;
  ///条码
  final String barcode;
  ///库存数量
  final String stock;
  ///商品描述
  final String remarks;
  ///设备成本
  final String cost;
  ///图片
  final String picUrl;
  ///商品描述
  final String shareDescription;
  ///共享价格
  final String sharePrice;
  ///商品图片
  final List sharePics;
  ///共享开关
  final String share;


  InventoryManageEquipmentModel({this.id, this.name, this.brand, this.model, this.specName, this.organization, this.barcode, this.stock, this.remarks, this.cost, this.picUrl, this.shareDescription, this.sharePrice, this.sharePics, this.share,});

  InventoryManageEquipmentModel.fromJson(Map<String, dynamic> json):
        id = json['id'].toString() != null ? json['id'].toString():'',
        name = json['name'].toString() != null ? json['name'].toString():'',
        brand = json['brand'].toString() != null ? json['brand'].toString():'',
        model = json['model'].toString() != null ? json['model'].toString():'',
        specName = json['specName'].toString() != null ? json['specName'].toString():'',
        organization = json['organization'].toString() != null ? json['organization'].toString():'',
        barcode = json['barcode'].toString() != null ? json['barcode'].toString():'',
        stock = json['stock'].toString() != null ? json['stock'].toString():'',
        remarks = json['remarks'].toString() != null ? json['remarks'].toString():'',
        cost = json['cost'].toString() != null ? json['cost'].toString():'',
        picUrl = json['picUrl'].toString() != null ? json['picUrl'].toString():'',
        shareDescription = json['shareDescription'].toString() != null ? json['shareDescription'].toString():'',
        sharePrice = json['sharePrice'].toString() != null ? json['sharePrice'].toString():'',
        sharePics = json['sharePics']!= null ? json['sharePics']:[],
        share = json['share'].toString() != null ? json['share'].toString():'';

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'specName': specName,
      'organization': organization,
      'barcode': barcode,
      'stock': stock,
      'remarks': remarks,
      'cost':cost,
      'picUrl': picUrl,
      'shareDescription': shareDescription,
      'sharePrice': sharePrice,
      'sharePics': sharePics,
      'share': share
    };
  }

}