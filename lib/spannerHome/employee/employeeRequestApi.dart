import 'package:spanners/AfNetworking/requestDio.dart';

class EmployeeRequestApi{
  static void getEmployeeListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.employeeList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
          onSuccess(data);
        }, onError: (error) {
          print('${error}');
          //onError(error);
        });
  }
  static void getGroupListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    print("1111");
    DioUtils.requestHttp(DioUtils.groupList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
          onSuccess(data);
        }, onError: (error) {
          print('${error}');
          //onError(error);
        });
  }
  static void deleteGroupListRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    print("1111");
    DioUtils.requestHttp(DioUtils.deleteGroup,
        parameters: param, method: DioUtils.POST ,onSuccess: (data) {
          onSuccess(data);
        }, onError: (error) {
          print('${error}');
          //onError(error);
        });
  }
  static void addGroupRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.addGroup,
        parameters: param, method: DioUtils.GET ,onSuccess: (data) {
          onSuccess(data);
        }, onError: (error) {
          print('${error}');
          //onError(error);
        });
  }
  static void getEmployeeDetailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.employeeDetail,
        parameters: param, method: DioUtils.GET ,onSuccess: (data) {
          onSuccess(data);
        }, onError: (error) {
          print('${error}');
        });
  }
  static void updateEmployeeDetailRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.updateEmployee,
        parameters: param, method: DioUtils.POST ,onSuccess: (data) {
          onSuccess(data);
        }, onError: (error) {
          print('${error}');
        });
  }
  static void addEmployeeRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.addEmployee,
        parameters: param, method: DioUtils.POST ,onSuccess: (data) {
          onSuccess(data);
        }, onError: (error) {
          onError(error);
          print('${error}');
        });
  }
  static void addEmployeeInitRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.addEmployeeInit,
        parameters: param, method: DioUtils.GET ,onSuccess: (data) {
          onSuccess(data);
        }, onError: (error) {
          print('${error}');
        });
  }
  static void deleteEmployeeRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.deleteEmployee,
        parameters: param, method: DioUtils.GET ,onSuccess: (data) {
          onSuccess(data);
        }, onError: (error) {
          print('${error}');
        });
  }
}