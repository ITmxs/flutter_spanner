import 'package:spanners/AfNetworking/requestDio.dart';

class MembersDio {
//--> 客户管理列表 信息获取
  static void memberListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.memberList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //--> 客户管理详情 信息获取
  static void memberDetailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.memberDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //创建会员
  static void addMemberRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.addMember,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //修改会员
  static void memberRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.member,
        parameters: param, method: DioUtils.PUT, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //删除车辆
  static void deleteRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.vehicle,
        parameters: param, method: DioUtils.DELETE, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //添加车辆
  static void addVipCarRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.vehicle,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //修改车辆
  static void editVipCarRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.vehicle,
        parameters: param, method: DioUtils.PUT, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //车辆详情
  static void vipCarDetailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.vehicleDetail,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //优惠卡
  static void topupRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.rechargeList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //次数卡
  static void countRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.cardRechargeList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //充值次数卡
  static void cardRechargeRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.cardRecharge,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }

  //充值优惠卡
  static void rechargeRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.rechargeBalance,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      onSuccess(data);
    }, onError: (error) {
      print('$error');
    });
  }
}
