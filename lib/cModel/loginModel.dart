/*
   登录 model 定义
*/
class LoginMessage {
  final String shopId; //---> 店铺id
  final String userid; //---> 用户id
  final String token; //---> 用户id
  final Map mapInfo; //---> 用户id

  LoginMessage(this.shopId, this.userid, this.token, this.mapInfo);
  LoginMessage.fromJson(Map<String, dynamic> json)
      : shopId = json['userInfo']['shopId'],
        userid = json['userid'],
        token = json['token'],
        mapInfo = json['userInfo'];
  Map<String, dynamic> toJson() =>
      {'shopId': shopId, 'userid': userid, 'token': token};
}
