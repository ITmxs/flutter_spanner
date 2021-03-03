import 'package:spanners/AfNetworking/requestDio.dart';

class RecCarDio {
//--> 接车二级联想
  static void secondaryListRequest<T>({
    String param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.secondaryList + '/' + param,
        parameters: param, method: DioUtils.NEWGET, onSuccess: (data) {
      print('二级联想--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('二级联想--->$error');
      onError(error);
    });
  }

  //--> 接车配件联想
  static void materialListRequest<T>({
    String param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    print('配件联想--->$param');
    DioUtils.requestHttp(DioUtils.receiveCarGetMaterial,
        parameters: {'search': param}, method: DioUtils.GET, onSuccess: (data) {
      print('配件联想--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('配件联想--->$error');
      onError(error);
    });
  }

  //--> 车辆登记信息
  static void getMemberRequest<T>({
    String param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getMember + '/' + param,
        parameters: '', method: DioUtils.NEWGET, onSuccess: (data) {
      print('车辆登记信息--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('车辆登记信息--->$error');
      onError(error);
    });
  }

  //--> 新建工单
  static void postNewOrderRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.receiveCar,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('新建工单--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('新建工单--->$error');
      onError(error);
    });
  }

  //--> 新建工单
  static void addNewOrderRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.saveService,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('新建工单--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('新建工单--->$error');
      onError(error);
    });
  }

  //--> 工单信息查询
  static void getDetailRequest<T>({
    String param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.receiveCarDetail + '/' + param,
        parameters: '', method: DioUtils.NEWGET, onSuccess: (data) {
      print('工单信息查询--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('工单信息查询--->$error');
      onError(error);
    });
  }

  //--> 全车检查 获取检查项
  static void getCheckItemRequest<T>({
    String param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.getVehicleInspectionDic,
        parameters: {'': ''}, method: DioUtils.GET, onSuccess: (data) {
      print('获取检查项--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('获取检查项--->$error');
      onError(error);
    });
  }

  //--> 全车检查 获取检查项
  static void upCheckItemRequest<T>({
    Map param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.vehicleChecksave,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('创建检查项--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('创建检查项--->$error');
      onError(error);
    });
  }

  //--> 全车检查 获取检查项历史
  static void getCheckHistoryRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.vehicleCheckhistoryList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('获取检查项历史--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('获取检查项历史--->$error');
      onError(error);
    });
  }

  //--> 全车检查 创建接车单页
  static void getCheckMessageRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.vehicleCheckinfo,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('创建接车单页--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('创建接车单页--->$error');
      onError(error);
    });
  }

  //--> 全车检查 创建接车
  static void postCheckMenuRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.generateRecivceCar,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('创建接车--->$data');
      onSuccess(data);
    }, onError: (error) {
      print('创建接车--->$error');
      onError(error);
    });
  }
}
