import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int userId = -1;
  String image_memory = '';
  String email = '';
  String tokenAccess = '';
  String tokenRefresh = '';
  String nickname = '';

  setUserInformation(
      userId, email, nickname, image_memory, tokenAccess, tokenRefresh) {
    this.userId = userId;
    this.email = email;
    this.nickname = nickname;
    this.image_memory = image_memory;
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
  String started_at = '';
  String ended_at = '';
  int drank_beer = 0;
  int drank_soju = 0;

  var myPaticipantIndex = -1;

  setPartyInformation(
      partyId,
      image_memory,
      participants,
      comments,
      name,
      place,
      image,
      created_at,
      started_at,
      ended_at,
      drank_beer,
      drank_soju,
      userId) {
    this.partyId = partyId;
    this.image_memory = image_memory;
    this.participants = participants;
    this.comments = comments;
    this.place = place;
    this.name = name;
    this.image = image;
    this.created_at = created_at;
    this.started_at = started_at;
    this.ended_at = ended_at;
    this.drank_beer = drank_beer;
    this.drank_soju = drank_soju;

    if (partyId != -1) {
      for (int i = 0; i < participants.length; i++) {
        if (participants[i]['user']['id'] == userId) {
          myPaticipantIndex = i;
          notifyListeners();
        }
      }
    }

    notifyListeners();
  }

  initPartyInformation() {
    partyId = -1;
    image_memory = '';
    participants = [];
    comments = [];
    name = '';
    place = '';
    image = '';
    created_at = '';
    started_at = '';
    ended_at = '';
    drank_beer = 0;
    drank_soju = 0;

    notifyListeners();
  }
}
