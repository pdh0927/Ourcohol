// User 관련 Provider
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int userId = -1;
  String email = '';
  int activeParty = -1;
  String tokenAccess = '';
  String tokenRefresh = '';
  String nickname = '';

  setUserInformation(
      userId, email, nickname, activeParty, tokenAccess, tokenRefresh) {
    this.userId = userId;
    this.email = email;
    this.nickname = nickname;
    this.activeParty = activeParty;
    this.tokenAccess = tokenAccess;
    this.tokenRefresh = tokenRefresh;

    notifyListeners();
  }
}
