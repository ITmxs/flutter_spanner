class AddFriendModel {
  final String username;
  final String headUrl;
  final String nickName;
  final String status;
  final String applyDate;
  AddFriendModel(this.username, this.headUrl, this.nickName, this.status, this.applyDate);
  AddFriendModel.fromJson(Map<String, dynamic> json)
      : username = json['username'] == null ? '' : json['username'].toString(),
        headUrl = json['headUrl'] == null ? 'Assets/temp_icon.png' : json['headUrl'].toString(),
        nickName = json['nickName'] == null ? '' : json['nickName'].toString(),
        status = json['status'] == null ? '' : json['status'].toString(),
        applyDate = json['applyDate'] == null ? '' : json['applyDate'].toString();
}
