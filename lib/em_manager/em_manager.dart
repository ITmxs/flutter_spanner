import 'package:bot_toast/bot_toast.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

///登录
// ignore: non_constant_identifier_names
void em_login(String username, String password, Function successBack,
    Function errorBack) {

  EMClient.getInstance().login(username, password, onSuccess: (username) {
    successBack();
  }, onError: (code, desc) {
    print(' - - - - -- - - -  - -- -  - -登录失败error');
    print(code);
    switch (code) {
      case 2:
        {
          BotToast.showText(text: 'em_网络未连接!');
        }
        break;

      case 202:
        {
          BotToast.showText(text: 'em_密码错误!');
        }
        break;

      case 204:
        {
          BotToast.showText(text: 'em_用户ID不存在!');
        }
        break;

      case 300:
        {
          BotToast.showText(text: 'em_无法连接服务器!');
        }
        break;

      default:
        {
          BotToast.showText(text: 'em_$desc');
        }
        break;
    }

    print("login error:" + code.toString() + "//" + desc.toString());
    errorBack();
  });
}

///退出登录
// ignore: non_constant_identifier_names
void em_logout(Function successBack, Function errorBack) {
  EMClient.getInstance().logout(
    false,
    onSuccess: () {
      successBack();
    },
    onError: (code, desc) {
      BotToast.showText(text: 'em_$desc');
      errorBack();
    },
  );
}

//获取好友列表
// ignore: non_constant_identifier_names
em_allFriendsList(Function successBack, Function errorBack) {
  EMClient.getInstance().contactManager().getAllContactsFromServer(
      onSuccess: (contacts) {
    successBack(contacts);
  }, onError: (code, desc) {
    print(code.toString() + ':' + desc);
    errorBack();
  });
}


//添加好友
// ignore: non_constant_identifier_names
em_addContact(String userId, Function successBack, Function errorBack) {
  EMClient.getInstance().contactManager().addContact(userId, null ,
      onSuccess: () {
        print('successBack');
        successBack();
      },
      onError: (code, desc){
    print(desc);
        errorBack();
      });
}

//拒绝添加好友
// ignore: non_constant_identifier_names
em_declineContact(String userId, Function successBack, Function errorBack) {
  EMClient.getInstance().contactManager().declineInvitation(userId,
      onSuccess: () {
        print('successBack');
        successBack();
      },
      onError: (code, desc){
        print(desc);
        errorBack();
      });
}

