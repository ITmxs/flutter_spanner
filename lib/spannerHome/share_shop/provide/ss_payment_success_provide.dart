import 'package:spanners/base/base_provide.dart';
import 'package:spanners/ob_networking/network_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;

import 'package:spanners/spannerHome/share_shop/model/ss_other_details_model.dart';

class SSPaymentSuccessProvide extends BaseProvide {

  bool _showCode = false;
  bool get showCode => _showCode;
  set showCode(bool value) {
    _showCode = value;
    notifyListeners();
  }

}