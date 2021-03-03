import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:spanners/cTools/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:spanners/cTools/showLoadingView.dart';
import 'package:spanners/cTools/Router.dart';
import 'package:spanners/dLoginOrOther/login.dart';
import 'package:path_provider/path_provider.dart';
/*
 * 封装 restful 请求
 *
 * GET、POST、DELETE、PATCH
 * 主要作用为统一处理相关事务：
 *  - 统一处理请求前缀；
 *  - 统一打印请求信息；
 *  - 统一打印响应信息；
 *  - 统一打印报错信息；
 */

class DioUtils {
/*
 Api  接口  归纳
*/
  //static String baseURL = 'https://bs-brother.com:8443/'; //--> 生产环境
  static String baseURL = 'http://39.100.255.159:8080/'; //---> 开发环境
  //static String baseURL = 'http://192.168.31.171:8080/';//--> 测试 //肖哥
  //static String baseURL = 'http://192.168.31.61:8080/'; //---> 测试环境//由金
  //static String baseURL = 'http://192.168.31.16:8080/'; //---> 测试环境//寒冰
  //static String baseURL = 'http://192.168.1.5:8080/'; //---> 测试环境//吴超

  //公共viewApi
  static String costList = 'api/settlement/query/costList'; //--->成本清单
  static String permissions = '/api/auth/permissions'; //权限
  /*退出接口*/
  static String logout = 'api/auth/logout'; //--->退出接口
  /* Home */
  static String homeURL = 'api/workorder/collect'; //---> 首页 信息获取 URL
  static String deleteWarning = 'api/workorder/deleteWarning'; //---> 首页 删除智能提醒
  static String shopList = 'api/myShop/usershopid'; //---> 首页 获取门店列表
  /* 预约*/
  static String getAppointmentListURL = 'api/appointment/list'; //---> 预约看板 URL
  static String appointmentDetail = 'api/appointment/detail'; //---> 预约看板 详情
  static String appointment = 'api/appointment'; //---> 预约看板 新建预约
  static String serviceDictList =
      'api/serviceDict/receiveCarDict'; // 新建预约 一二级分类
  // static String newserviceDictList = 'api/appointment/services'; // 新建预约 一二级分类
  static String getVehicle = 'api/appointment/getVehicle'; // 根据车牌号获取信息
  static String getAllCarURL = 'api/workorder/getAllCar'; //---> 预约看板 接车 URL
  static String workorderURL = 'api/workorder'; //---> 预约看板 删除 URL
  /* 接车*/
  static String receiveCarPage = 'api/receiveCar/page'; //---> 接车看板
  static String receiveCarDetail = 'api/receiveCar/detail'; //---> 工单信息查询
  static String receiveCarGetMaterial =
      'api/receiveCar/searchMaterial'; //'receiveCar/getMaterial'; //---> 接车配件联想
  static String secondaryList = 'api/serviceDict/secondaryList'; //---> 接车二级分类联想
  static String receiveCar = 'api/receiveCar'; //---> 接车新建工单
  static String saveService = 'api/receiveCar/saveService'; //---> 接车新建工单
  static String getMember = 'api/receiveCar/getMember'; //---> 获取车辆登记信息与会员信息

  /* 派工*/
  static String getWorkLookListPG =
      'api/workOrderDev/getWorkLookListPG'; //---> 派工看板
  static String getUserList = 'api/workorder/getUserList'; //---> 派工 人员列表
  static String updateWorkAll = 'api/workorder/updateWorkAll'; //---> 派工
  static String delWorkAll = 'api/workOrderDev/delWorkAll'; //---> 派工 删除
  /* 施工*/
  static String getWorkLookList = 'api/workorder/getWorkLookList'; //施工看板一览
  static String modifyWorkLookInfo =
      'api/workorder/modifyWorkLookInfo'; //施工看板修改
  static String modifyWorkLookStatus =
      'api/workorder/modifyWorkLookStatus'; //施工看板开始完成
  /*  About  */
  static String carfriendlistURL = 'api/friend/carfriendlist'; //--->技术圈 列表 URL
  static String carFriendByIdURL =
      'api/friend/carFriendById'; //--->技术圈 评论 列表 URL
  static String addArticle = 'api/friend/addArticle'; //--->技术圈 发布
  static String comment = 'api/friend/comment'; //--->技术圈 评论
  static String articleLike = 'api/friend/articleLike'; //--->技术圈 点赞
  static String followURL = 'api/friend/follow'; //--->技术圈 guanzhu
  static String imAddFriend = '/api/im/addFriend'; //--->技术圈 加好友
  static String myArticleList = '/api/friend/myArticleList'; //--->技术圈 加好友
  /* 保养手册 */
  static String maintenanceList = 'api/maintenance/list'; //--->保养手册 列表 URL
  static String maintenanceSave = 'api/maintenance/save'; //--->创建保养手册
  static String maintenanceServiceList =
      'api/maintenance/initList'; //--->保养手册筛选
  /* 全车检查 */
  static String getVehicleInspectionDic =
      'apiv2/vehicleCheck/getVehicleInspectionDic'; //--->全车检查 项 apiV +
  static String vehicleChecksave = 'apiv2/vehicleCheck/save'; //--->创建检查单
  static String vehicleCheckhistoryList =
      'apiv2/vehicleCheck/historyList'; //--->历史检查单
  static String vehicleCheckinfo = 'apiv2/vehicleCheck/info'; //--->历史检查单
  static String generateRecivceCar =
      'apiv2/vehicleCheck/generateRecivceCar'; //--->生成 接车单
  //收支统计
  static String accounttantDetail = 'apiv2/accounttant/detail'; //--->根据月份获取收支统计
  static String accounttantSave = 'apiv2/accounttant/save'; //--->添加统计
  static String accounttantExplicit =
      'apiv2/accounttant/explicit'; //--->获取收支统计详情
  //运营统计
  static String operationstatisDetail =
      'apiv2/operationstatis/init_detail'; //-->运营统计初期表示
  static String operationstatisAccount =
      'apiv2/operationstatis/on_account'; //-->挂账情况
  static String operationstatisStatistics =
      'apiv2/operationstatis/profit_statistics'; //-->利润统计
  static String operationstatisValue =
      '/apiv2/operationstatis/store_value'; //-->会员储值
  static String operationstatisOut =
      '/apiv2/operationstatis/store_value_out'; //-->月消费走势
  static String workOrderList =
      'apiv2/operationstatis/work_order_list'; //-->关于工单
  //绩效统计
  static String performanceList = 'apiv2/percentage/list'; //绩效列表
  static String dayPerformanceList = 'apiv2/percentage/detail'; //当月绩效列表
  static String toBonusList = 'apiv2/percentage/waitPercentageList'; //分红列表
  static String individualPerformance =
      'apiv2/percentageperson/initlist'; //个人绩效
  static String individualDayPerformance =
      'apiv2/percentageperson/nowdaylist'; //个人当天绩效
  //客户管理
  static String memberList = 'api/member/memberManagement'; //客户列表
  static String addMember = 'api/receiveCar/becomeMember'; //成为会员
  static String memberDetail = 'api/member/detail'; //客户详情
  static String member = 'api/member'; //修改
  static String vehicle = 'api/vehicle'; //删除车辆
  static String vehicleDetail = 'api/vehicle/detail'; //车辆详情
  static String rechargeList = 'api/member/rechargeList'; //优惠卡
  static String rechargeBalance = 'api/member/rechargeBalance'; //充值优惠卡
  static String cardRechargeList = 'api/member/cardRechargeList'; //次数  卡
  static String cardRecharge = 'api/member/cardRecharge'; //充值次数  卡
  //车辆管理
  static String vehicleManagementList =
      'api/vehicle/vehicleManagementList'; //车辆列表
  static String vehicleListDetail = 'api/vehicle/vehicleDetail'; //车辆列表详情
  //服务管理
  static String serviceDictLists = 'api/serviceDict/querySecondary'; //搜索服务列表
  static String postServiceDict = 'api/serviceDict'; // 添加服务
  static String serviceDictShopDetail = 'api/serviceDict/shopDetail'; // 获取 门店信息
  static String dictDetail = 'api/serviceDict/dictDetail'; // 获取 服务信息
  static String updateStatus = 'api/serviceDict/updateStatus'; // 开启关闭

  //员工管理
  static String employeeList = 'apiv2/employees/getEmployeesList'; //员工列表
  static String groupList = 'apiv2/employees/getGroupList'; //分组列表
  static String deleteGroup = 'apiv2/employees/deleteGroup'; //删除分组
  static String addGroup = 'apiv2/employees/addGroup'; //新增分组
  static String employeeDetail = 'apiv2/employees/getEmployeeDetail'; //员工详情
  static String updateEmployee = 'apiv2/employees/updateEmployee'; //更新员工
  static String deleteEmployee = 'apiv2/employees/deleteEmployee'; //删除员工
  static String addEmployee = 'apiv2/employees/addEmployee'; //新增员工
  static String addEmployeeInit = 'apiv2/employees/addEmployeeInit'; //新增员工初始化
  //考勤分析
  static String initDetail = 'apiv2/attendance/init_detail'; //--> 考勤分析初期表示-日
  static String attendancePersonMonth =
      'apiv2/attendance/attendance_person_month'; //--> 考勤分析初期表示-月
  static String saveLeave = 'apiv2/attendance/save_leave'; //--> 添加休假记录
  static String attendanceRuleList =
      'apiv2/attendance/attendance_rule_list'; //--> 考勤规则
  static String getWorkgroupAttList =
      'apiv2/attendance/get_workgroup_att_list'; //--> 添加规则-----考勤人员一览接口
  static String deleteRule = 'apiv2/attendance/delete_rule'; //-->  删除规则
  static String attendanceDetail =
      'apiv2/attendance/attendance_detail'; //-->  考勤分析详情
  static String addAttRule = 'apiv2/attendance/add_att_rule'; //-->  新增考勤规则

  static String updAttRule =
      'apiv2/attendance/update_attendance_rule'; //-->  更新规则
  static String getAttRule =
      'apiv2/attendance/get_rule_by_userid'; //-->  获取考勤规则
  static String attendanceDayDetail =
      'apiv2/attendance/attendance_detail_day'; //-->  当天打卡时间
  //考勤打卡
  static String attendanceClockInit =
      'apiv2/attendance_clock_in/init'; //-->  考勤打卡初始化
  static String attendanceClockIn =
      '/apiv2/attendance_clock_in/save'; //-->  考勤打卡

  //物品存储
  static String storageList = 'apiv2/storage/getStorageList'; //获取列表
  static String addStorage = '/apiv2/storage/addStorage'; //添加物品存储
  static String deleteStorage = '/apiv2/storage/deleteStorage'; //删除物品存储
  static String findStorage =
      '/apiv2/storage/findStorageByVehicle'; //根据车牌号查找物品存储记录
  static String storageDetail = '/apiv2/storage/getStorageDetail'; //获取物品存储详情
  static String takeOutItem = '/apiv2/storage/takeOutItem'; //取出物品
  static String findUser = '/api/vehicle/findUserBylicence'; //根据车牌号查找用户
  static String updateComment = '/apiv2/storage/updateStorageComment'; //更新备注

  //销售任务
  static String salesTask = '/apiv2/salesTask/index'; //-->  销售任务首页
  static String saveRecord = '/apiv2/salesTask/saveRecord'; //-->  销售任务记录
  static String recordList = '/apiv2/salesTask/recordList'; //-->  员工销售记录分页
  static String review = '/apiv2/salesTask/review'; //-->  任务审核
  static String deleteRecord = '/apiv2/salesTask/deleteRecord'; //-->  删除
  static String getTaskList = '/apiv2/salesTask/getTaskList'; //-->  任务list
  static String taskDetail = '/apiv2/salesTask/taskDetail'; //-->  店内任务list
  static String salesTaskSave =
      '/apiv2/salesTask/save'; //-->  保存店内销售任务 /apiv2/salesTask/taskInfo
  static String taskInfo = '/apiv2/salesTask/taskInfo'; //-->  任务详情+员工任务详情
  static String salesTaskDelete = '/apiv2/salesTask/delete'; //-->  任务详情删除

  //门店活动
  static String campaignList = '/api/campaign/list'; //-->  门店活动列表
  static String campaignSave = '/api/campaign'; //-->  保存
  static String deleteCampaign = '/api/campaign/deleteCampaign'; //-->  活动卡券删除
  static String deleteCampaignGoods =
      '/api/campaign/deleteCampaignGoods'; //-->  活动商品删除
  static String campaignDetail = '/api/campaign/detail'; //卡劵 详情
  //救援
  static String rescueList = '/apiv2/rescue/list'; //救援列表
  static String rescueUpdate = '/apiv2/rescue/update'; //救援 状态更新
  //保险
  static String newInsureList = '/api/newInsure/list'; //保险询价列表
  static String newInsureInfo = '/api/newInsure/info'; //保险详情
  static String newInsureSave = '​/api​/newInsure​/save'; //保险 保存 修改

  //领料管理
  static String pickingList = '/api/picking/list'; //领料管理列表
  static String pickingListNei = '/api/picking/pickingList'; //内部领料管理列表
  static String pickingSave = '/api/picking'; //领料单保存
  static String pickingGoodsList = '/api/picking/goodsList'; //领料单库存商品

  //我的接口
  static String myInfo = '/api/storeshop/queryShopInfoById'; //-->  我的详情
  static String addFeedback = '/apiv2/my/insertFeedback'; //-->  意见反馈
  static String shareSetting = '/apiv2/my/shareBonusSetting'; //--> 分红设置
  static String hasPayPassword = '/apiv2/my/hasPayPassword'; //--> 支付密码check
  static String updatePassword = '/apiv2/my/updatePassword'; //--> 更新密码

  //采购管理
  static String addPurchase = '/apiv2/purchase/addPurchaseRecord'; //插入采购记录
  static String deleteItem = '/apiv2/purchase/deleteItem'; //删除商品
  static String getMaterialList = '/apiv2/purchase/getMaterialList'; //获取配件列表
  static String getPurchaseDetail =
      '/apiv2/purchase/getPurchaseDetail'; //获取采购详情
  static String getPurchaseList = '/apiv2/purchase/getPurchaseList'; //获取采购列表
  static String getServiceMaterialDetail =
      '/apiv2/purchase/getServiceMaterialDetail'; //获取配件详情
  static String getStockShopList =
      '/apiv2/purchase/getStockShopList'; //获取库存商品列表
  static String itemInStore = '/apiv2/purchase/itemInStore'; //商品入库
  static String updateMaterial = '/apiv2/purchase/updateMaterial'; //更新配件信息
  static String updatePurchase = '/apiv2/purchase/updatePurchase'; //更新采购
  /*       自定义 限制参数       */
  static bool putBool = false; //是否上传
  static bool ocrBool = false; //ocr
  static bool vinBool = false; //vins
  static bool loginBool = false; //登录
  static bool homeBool = false; //首页

  /// global dio object
  static Dio dio;

  /// default options
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;

  /// http request methods
  static const String GET = 'get';
  static const String NEWGET = 'newGet';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';
  static String token;
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

  /*  加载数据的  loading 动画  */
  static Future _showHomeDialog() async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container();
      },
    );
  }

  /*  加载数据的  请求成功  */
  static Future _showSuccessDialog(String message) async {
    await showDialog(
      barrierColor: Color(0x00000001),
      context: Routers.navigatorState.currentState.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowSuccess(
          title: message,
        );
      },
    );
  }

  /*  加载数据的  请求失败 超时  */
  static Future _showErrorDialog(String message) async {
    // await showDialog(
    //   barrierColor: Color(0x00000001),
    //   context: Router.navigatorState.currentState.context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return ShowError(
    //       title: message,
    //     );
    //   },
    // );
  }

  /*  加载数据的  请求失败 超时  */
  static Future _showErrorDialogs(String message) async {
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

  /// 创建 dio 实例对象
  static Future<Dio> createInstance() async {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      var options = BaseOptions(
          connectTimeout: 30000,
          receiveTimeout: 30000,
          sendTimeout: 200000,
          responseType: ResponseType.json,
          validateStatus: (status) {
            // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
            return true;
          },
          baseUrl: baseURL,
          headers: {
            'Accept': 'application/json,*/*',
            'Content-Type': 'application/json',
            //  'shopId': shopId,
            // 'token':
            // 'bfc513dc3c564b8db23b3d31a9e3b282'
          });

      dio = new Dio(options);
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) {
          print('上传接口：${options.uri}');
          //通过接口字段 判断要展示的文言提示
          if (options.uri.toString().contains('uploadFile')) {
            putBool = true;

            _showAlertDialog('上传中...');
          } else if (options.uri.toString().contains('uploadVideoFile')) {
            putBool = true;
          } else if (options.uri.toString().contains('scanLicenseVin')) {
            vinBool = true;
            ocrBool = false;

            print('指向这里');
            _showAlertDialog('识别中...');
          } else if (options.uri.toString().contains('scanLicense')) {
            ocrBool = true;
            vinBool = false;

            _showAlertDialog('识别中...');
          } else if (options.uri.toString().contains('auth/login')) {
            loginBool = true;

            _showAlertDialog('加载中...');
          } else if (options.uri.toString().contains('workorder/collect')) {
            _showHomeDialog();
          } else if (options.uri.toString().contains('articleLike')) {
            _showHomeDialog();
          } else if (options.uri.toString().contains('friend/follow')) {
            _showHomeDialog();
          } else if (options.uri.toString().contains('im/addFriend')) {
            _showHomeDialog();
          } else if (options.uri.toString().contains('receiveCarDict')) {
            _showHomeDialog();
          } else {
            _showAlertDialog('加载中...');
          }
        },
        onResponse: (e) {
          Navigator.pop(Routers.navigatorState.currentState.context);

          print('拦截器获取的数据:${e.data}');
          if (loginBool) {
            /*登录页面顶部错误提示错误*/
          } else if (putBool) {
            /* 因为是单次循环上传 所以去 对应页面文言提示*/
          } else {
            if (e.data['code'] == 200) {
              //有 点 问题待 解开时  调整
              _showSuccessDialog(e.data['msg']);
            } else if (e.data['code'] == 401) {
              Navigator.push(Routers.navigatorState.currentState.context,
                  MaterialPageRoute(builder: (context) => LoginView()));
            } else {
              /*  等 后期code 统一后 在进行 变动*/
              if (ocrBool) {
                if (e.data['data'] == '请上传正确的图片') {
                  _showErrorDialog(e.data['data']);
                } else {
                  _showErrorDialog(e.data['msg']);
                }
              } else if (vinBool) {
                if (e.data['data'] == '请上传正确图片') {
                  _showErrorDialogs(e.data['data']);
                } else {
                  _showErrorDialog(e.data['msg']);
                }
              } else if (e.data['msg'].toString() == '未认证') {
                Navigator.push(Routers.navigatorState.currentState.context,
                    MaterialPageRoute(builder: (context) => LoginView()));
              } else {
                _showErrorDialog(e.data['msg']);
              }
            }
          }
        },
        onError: (e) {
          print('网络pop2');
          Navigator.pop(Routers.navigatorState.currentState.context);
          _showErrorDialog('网络连接错误，请重试！');
          print('拦截器错误信息-->：$e');
        },
      ));
    }

    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }

  ///Get请求
  // ignore: missing_return
  static Future<Response> getHttp<T>(
    String url, {
    parameters,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    try {
      Dio dios = await createInstance();
      var shopId = SynchronizePreferences.Get('shopId');
      parameters['shopId'] = shopId;
      print('请求参数-->$parameters');
      //var cookieJar = CookieJar();
      //获取cookies
      List<Cookie> cookiess = (await Cook.cookieJar)
          .loadForRequest(Uri.parse(baseURL + 'auth/login'));
      //Save cookies
      (await Cook.cookieJar)
          .saveFromResponse(Uri.parse(baseURL + 'auth/login'), cookiess);

      print('首页获取的登录cookie====>,$cookiess');

      dios.interceptors.add(CookieManager((await Cook.cookieJar)));

      Response response;
      response = await dios.get(
        url,
        queryParameters: Map<String, dynamic>.from(parameters),
      ); //cancelToken: token
      var responseData = response.data;
      var i = responseData['msg'];
      if (responseData['code'] == 0) {
        if (responseData['data'] == null) {
          print('没有data');
          onSuccess(responseData['code']);
        } else {
          onSuccess(responseData['data']);
        }
      } else {
        onError(responseData['msg']);
      }

      print('get返回结果-->$responseData');
      print('get返回结果$i');
      return response;
    } catch (e) {
      print('请求出错：' + e.toString());
      onError(e.toString());
    }
  }

  ///NEWGet请求
  // ignore: missing_return
  static Future<Response> newGetHttp<T>(
    String url, {
    parameters,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    try {
      Dio dios = await createInstance();
      var shopId = SynchronizePreferences.Get('shopId');
      var cookieJar = CookieJar();
      dios.interceptors.add(CookieManager(cookieJar));
      Response response;
      print('请求url：${url + '/' + shopId.toString()}');
      response = await dios.get(
        url + '/' + shopId.toString(),
      );
      var responseData = response.data;
      var i = responseData['msg'];
      if (responseData['code'] == 0) {
        onSuccess(responseData['data']);
      } else {
        onError(responseData['msg']);
      }
      print('newget返回结果-->$responseData');
      print('newget返回结果$i');
      return response;
    } catch (e) {
      print('请求出错：' + e.toString());
      onError(e.toString());
    }
  }

  ///Post请求
  // ignore: missing_return
  static Future<Response> postHttp<T>(
    String url, {
    parameters,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    try {
      Dio dios = await createInstance();
      if (parameters.toString().contains('Instance')) {
        print('formdata 类型');
      } else if (parameters is List) {
        print('List 类型');
        print(parameters);
      } else {
        parameters = Map<String, dynamic>.from(parameters);
        var shopId = SynchronizePreferences.Get('shopId');
        parameters['shopId'] = shopId;
        print('非  formdata 类型');
      }
      print('请求参数-->$parameters');
      //var cookieJar = CookieJar();
      dios.interceptors.add(CookieManager((await Cook.cookieJar)));
      Response response = await dios.post(
        url,
        data: parameters,
      ); //cancelToken: token
      //获取cookies
      List<Cookie> cookiess = (await Cook.cookieJar)
          .loadForRequest(Uri.parse(baseURL + 'auth/login'));
      //Save cookies
      (await Cook.cookieJar)
          .saveFromResponse(Uri.parse(baseURL + 'auth/login'), cookiess);

      print('登录cookie====>,$cookiess');
      var responseData = response.data;
      var i = responseData['msg'];
      if (responseData['code'] == 0) {
        onSuccess(responseData['data']);
      } else if (responseData['code'] == 200) {
        print('返回结果-->${responseData['code']}');
        onSuccess(responseData['data']);
      } else {
        print('指向这里');
        onError(responseData['msg']);
      }

      print('post返回结果$i');

      return response;
    } catch (e) {
      print('post返回结果x $e');
    }
  }

  ///delete 请求
  static void deleteHttp<T>(
    String url, {
    parameters,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    try {
      Dio dios = await createInstance();
      var shopId = SynchronizePreferences.Get('shopId');
      if (url != DioUtils.deleteRule) {
        parameters['shopId'] = shopId;
      }

      print('请求参数-->$parameters');
      var cookieJar = CookieJar();
      dios.interceptors.add(CookieManager(cookieJar));
      Response response = await dios.delete(
        url,
        data: parameters,
      ); //cancelToken: token
      var responseData = response.data;
      var i = responseData['msg'];
      if (responseData['code'] == 0) {
        onSuccess(responseData['data']);
      } else {
        onError(responseData['msg']);
      }
      print('delete返回结果-->$responseData');
      print('delete返回结果$i');
    } catch (e) {
      print(e);
    }
  }

  ///put 请求
  static void putHttp<T>(
    String url, {
    parameters,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      //var token = prefs.get("bd6e07cff85c46a8a9184cf76bc52d04");
      Dio dios = await createInstance();
      var shopId = SynchronizePreferences.Get('shopId');
      parameters['shopId'] = shopId;
      print('put请求参数-->$parameters');
      var cookieJar = CookieJar();
      dios.interceptors.add(CookieManager(cookieJar));
      Response response = await dios.put(
        url,
        data: parameters,
      ); //cancelToken: token
      var responseData = response.data;
      var i = responseData['msg'];
      if (responseData['code'] == 0) {
        onSuccess(responseData['data']);
      } else {
        onError(responseData['msg']);
      }
      print('put返回结果-->$responseData');
      print('put返回结果$i');
    } catch (e) {
      print(e);
    }
  }

  /// request Get、Post 请求
  //url 请求链接
  //parameters 请求参数
  //method 请求方式
  //onSuccess 成功回调
  //onError 失败回调
  static Future<Response> requestHttp<T>(String url,
      {parameters,
      method,
      Function(T t) onSuccess,
      Function(String error) onError}) async {
    parameters = parameters ?? {};
    method = method ?? 'GET';

    if (method == DioUtils.GET) {
      return getHttp(
        url,
        parameters: parameters,
        onSuccess: (data) {
          onSuccess(data);
        },
        onError: (error) {
          onError(error);
        },
      );
    } else if (method == DioUtils.NEWGET) {
      return newGetHttp(
        url,
        parameters: parameters,
        onSuccess: (data) {
          onSuccess(data);
        },
        onError: (error) {
          onError(error);
        },
      );
    } else if (method == DioUtils.POST) {
      return postHttp(
        url,
        parameters: parameters,
        onSuccess: (data) {
          onSuccess(data);
        },
        onError: (error) {
          onError(error);
        },
      );
    } else if (method == DioUtils.PUT) {
      putHttp(
        url,
        parameters: parameters,
        onSuccess: (data) {
          onSuccess(data);
        },
        onError: (error) {
          onError(error);
        },
      );
      return Response();
    } else if (method == DioUtils.DELETE) {
      deleteHttp(
        url,
        parameters: parameters,
        onSuccess: (data) {
          onSuccess(data);
        },
        onError: (error) {
          onError(error);
        },
      );
      return Response();
    } else {
      return Response();
    }
  }
}

class Cook {
  //改为使用 PersistCookieJar，在文档中有介绍，PersistCookieJar将cookie保留在文件中，因此，如果应用程序退出，则cookie始终存在，除非显式调用delete
  static PersistCookieJar _cookieJar;

  static Future<PersistCookieJar> get cookieJar async {
    print('==================');
    print(_cookieJar);
    if (_cookieJar == null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      print('获取的文件系统目录 appDocPath： ' + appDocPath);
      _cookieJar = new PersistCookieJar(dir: appDocPath);
    }
    return _cookieJar;
  }
}
