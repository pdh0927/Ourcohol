import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ourcohol/home/tabs/party_page/active_party.dart';
import 'package:ourcohol/home/tabs/party_page/unactive_party.dart';
import 'package:ourcohol/provider_ourcohol.dart';
import 'package:provider/provider.dart';

import 'no_party.dart';

class Party extends StatefulWidget {
  const Party({super.key});

  @override
  State<Party> createState() => _PartyState();
}

class _PartyState extends State<Party> {
  var party = [];
  Future getRecentParty() async {
    http.Response response;
    if (Platform.isIOS) {
      response = await http.get(
          Uri.parse(
              'http://127.0.0.1:8000/api/party/active/${context.read<UserProvider>().activeParty}/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });
      if (json.decode(utf8.decode(response.bodyBytes)) != null) {
        setState(() {
          party = json.decode(utf8.decode(response.bodyBytes)).toList();
        });
      }
      return party;
    } else {
      response = await http.get(
          Uri.parse(
              'http://10.0.2.2:8000/api/party/active/${context.read<UserProvider>().activeParty}/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });
      if (json.decode(utf8.decode(response.bodyBytes)) != null) {
        setState(() {
          party = json.decode(utf8.decode(response.bodyBytes)).toList();
        });
      }
      return party;
    }
  }

  var _future;
  @override
  void initState() {
    _future = getRecentParty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return const CupertinoActivityIndicator();
          } else {
            if (party.isEmpty) {
              return NoParty();
            } else if (party[0]['is_active'] == false &&
                party[0]['ended_at'] == null) {
              return UnactiveParty();
            } else if (party[0]['is_active'] == false &&
                party[0]['ended_at'] != null) {
              return NoParty();
            } else {
              return ActiveParty(party: party);
            }
          }
        });
  }
}
