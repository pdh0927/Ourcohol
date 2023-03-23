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

class PartyProvider extends ChangeNotifier {
  int partyId = -1;
  String image_memory = '';
  List participants = [];
  List comments = [];
  String name = '';
  String place = '';
  String image = '';
  String created_at = '';
  String ended_at = '';
  int drank_beer = 0;
  int drank_soju = 0;
  bool is_active = false;

  setPartyInformation(partyId, image_memory, participants, comments, name,
      place, image, created_at, ended_at, drank_beer, drank_soju, is_active) {
    this.partyId = partyId;
    this.image_memory = image_memory;
    this.participants = participants;
    this.comments = comments;
    this.place = place;
    this.name = name;
    this.image = image;
    this.created_at = created_at;
    this.ended_at = ended_at;
    this.drank_beer = drank_beer;
    this.drank_soju = drank_soju;
    this.is_active = is_active;

    notifyListeners();
  }
}
