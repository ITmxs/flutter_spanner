import 'package:spanners/AfNetworking/requestDio.dart';

class AboutDio {
//--> 技术圈 列表
  static void aboutHomeRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.carfriendlistURL,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('成功--->$param}');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error}');
      onError(error);
    });
  }

  //--> 个人动态
  static void aboutPersonRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.myArticleList,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('成功--->$param}');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error}');
      onError(error);
    });
  }

  //点赞
  static void articleLike<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.articleLike,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('成功--->$param}');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error}');
      onError(error);
    });
  }

  //关注
  static void followUserId<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.followURL,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('成功--->$param}');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error}');
      onError(error);
    });
  }

  //--> 获取 评论数据
  static void aboutRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.carFriendByIdURL,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('成功--->$param}');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error}');
      onError(error);
    });
  }

  //--> 加好友 请求
  static void addFriendRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.imAddFriend,
        parameters: param, method: DioUtils.GET, onSuccess: (data) {
      print('成功--->$param}');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error}');
      onError(error);
    });
  }

  //--> 发布 技术圈
  static void aboutPostCommentRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.addArticle,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('成功--->$param}');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error}');
      onError(error);
    });
  }

  //--> 评论
  static void aboutCommentRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.comment,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('成功--->$data}');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error}');
      onError(error);
    });
  }

  //--> 点赞
  /*
  type  0 点赞 1 取消点赞     articleLikeNum  原有点赞数量
  */
  static void aboutarticleLikeRequest<T>({
    param,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    DioUtils.requestHttp(DioUtils.articleLike,
        parameters: param, method: DioUtils.POST, onSuccess: (data) {
      print('成功--->$data}');
      onSuccess(data);
    }, onError: (error) {
      print('失败--->$error}');
      onError(error);
    });
  }
}
