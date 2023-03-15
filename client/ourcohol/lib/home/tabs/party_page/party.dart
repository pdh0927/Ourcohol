import 'dart:convert';

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
  var party = null;
  Future getMyPartyList() async {
    http.Response response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/api/party/participant/recent/${context.read<UserProvider>().userId}/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${context.read<UserProvider>().tokenAccess}',
        });
    if (json.decode(utf8.decode(response.bodyBytes)) != null) {
      setState(() {
        party = json.decode(utf8.decode(response.bodyBytes));
      });
    }

    return party;
  }

  var _future;
  @override
  void initState() {
    _future = getMyPartyList();
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
            if (party.length == 0) {
              return NoParty();
            } else if (party[0]['party']['is_active'] == false &&
                party[0]['party']['ended_at'] == null) {
              return UnactiveParty();
            } else if (party[0]['party']['is_active'] == false &&
                party[0]['party']['ended_at'] != null) {
              return NoParty();
            } else {
              return ActiveParty();
            }
          }
        });
  }
}