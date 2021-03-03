/*
技术圈 列表 model
*/
class AboutModel {
  final String id; //--->用于查看详情 参数
  final String headurl; //--->用户头像
  final String logo; //--->车友头像
  final String realName; //--->车友名
  final String text; //--->所发技术圈文字
  final String imagesStr; //--->图片，视频url
  final String date; //--->发表日期
  final String commentNum; //--->评论数
  final String mobile; //--->评论数
  final int like; //--->点赞个数
  final isLike;
  final isFriend;
  final isWatching; //--->是否关注
  final String auth;
  AboutModel(
      this.headurl,
      this.logo,
      this.realName,
      this.text,
      this.imagesStr,
      this.date,
      this.commentNum,
      this.id,
      this.like,
      this.isWatching,
      this.isLike,
      this.auth,
      this.mobile,
      this.isFriend);
  AboutModel.fromJson(Map<String, dynamic> json)
      : headurl = json['headurl'],
        logo = json['logo'],
        id = json['id'],
        realName = json['realName'],
        text = json['text'],
        imagesStr = json['imagesStr'],
        date = json['date'],
        like = json['like'],
        mobile = json['mobile'],
        isLike = json['isLike'] ?? false,
        isFriend = json['isFriend'] ?? false,
        auth = json['auth'],
        commentNum = json['commentNum'],
        isWatching = json['isWatching'] ?? false;
  Map<String, dynamic> toJso(n) => {
        'id': id,
        'headurl': headurl,
        'logo': logo,
        'realName': realName,
        'text': text,
        'imagesStr': imagesStr,
        'date': date,
        'like': like,
        'mobile': mobile,
        'auth': auth,
        'isLike': isLike,
        'isFriend': isFriend,
        'commentNum': commentNum,
        'isWatching': isWatching
      };
}

/*
 技术圈 评论区 model
*/
class AboutTalkModel {
  final String comment; //--->评论 内容
  final String sendId; //---> 发送人 id
  final String sendUser; //---> 发送人
  final String repeatId; //---> 回复 id
  final String sendTime; //---> 日期
  final String repeatUser; //--->回复给谁
  final String comid; // 评论 id
  final String parentId;

  AboutTalkModel(this.comment, this.sendId, this.sendUser, this.repeatId,
      this.sendTime, this.repeatUser, this.comid, this.parentId);
  AboutTalkModel.fromJson(Map<String, dynamic> json)
      : comment = json['comment'].toString(),
        sendId = json['sendId'].toString(),
        repeatId = json['repeatId'].toString(),
        sendUser = json['sendUser'].toString(),
        sendTime = json['sendTime'].toString(),
        comid = json['comid'].toString(),
        parentId = json['parentId'].toString(),
        repeatUser = json['repeatUser'].toString();
  Map<String, dynamic> toJso(n) => {
        'comment': comment,
        'sendId': sendId,
        'repeatId': repeatId,
        'sendUser': sendUser,
        'sendTime': sendTime,
        'comid': comid,
        'parentId': parentId,
        'repeatUser': repeatUser,
      };
}
