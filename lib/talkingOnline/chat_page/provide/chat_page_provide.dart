import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';

class ChatPageProvide extends BaseProvide {

  final ApplyFriendRepo _repo = ApplyFriendRepo();

  Stream getApplyMessage(String userId, String toUserId) {
    var body = {
      'ownerId':userId,
      'friendId':toUserId,
    };
    return _repo.postDeleteFriend(body).doOnData((event) {
    }).
    doOnError((e, stacktrace) {
    }).doOnListen(() {
    }).doOnDone(() {
    });
  }

}