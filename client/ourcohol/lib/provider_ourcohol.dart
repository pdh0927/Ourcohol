// User 관련 Provider
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userId = '';
  String email = '';
  // String password = '';
  String tokenAccess = '';
  String tokenRefresh = '';
  String nickname = '';

  setUserInformation(userId, email, nickname, tokenAccess, tokenRefresh) {
    this.userId = userId;
    this.email = email;
    this.nickname = nickname;
    this.tokenAccess = tokenAccess;
    this.tokenRefresh = tokenRefresh;

    notifyListeners();
  }
}
