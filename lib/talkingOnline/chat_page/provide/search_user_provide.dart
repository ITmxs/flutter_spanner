import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';

class SearchUserProvide extends BaseProvide {
  final SearchUserInfoRepo _repo = SearchUserInfoRepo();

  final ApplyFriendRepo _applyFriendRepo = ApplyFriendRepo();

  // ignore: missing_return
  Stream searchUserInfo(String phone) {
    print('开始请求');
    return _repo
        .getSearchUserInfo(query: {'username': phone})
        .doOnData((result) {})
        .doOnError((e, stacktrace) {})
        .doOnListen(() {})
        .doOnDone(() {});
  }

  Stream applyFriend(dynamic request) {
    return _applyFriendRepo.postApplyFriend(request).doOnData((result) {
    }).doOnError((e, stacktrace) {
    }).doOnListen(() {
    }).doOnDone(() {
    });
  }

}
