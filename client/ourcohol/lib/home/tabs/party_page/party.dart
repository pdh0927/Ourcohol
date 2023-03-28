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
  rebuild1() async {
    setState(() {});
  }

  rebuild2() async {
    setState(() {
      context.read<PartyProvider>().initPartyInformation();
      _future = getRecentParty();
      party = {};
    });
  }

  var party = {};
  Future getRecentParty() async {
    http.Response response;
    if (Platform.isIOS) {
      response = await http.get(
          Uri.parse(
              'http://127.0.0.1:8000/api/participant/recent/${context.read<UserProvider>().userId}/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });

      if (json.decode(utf8.decode(response.bodyBytes)).length > 0) {
        party =
            json.decode(utf8.decode(response.bodyBytes)).toList()[0]['party'];

        context.read<PartyProvider>().setPartyInformation(
            party['id'],
            party['image_memory'],
            party['participants'],
            party['comments'],
            party['name'],
            party['place'],
            party['image'],
            party['created_at'],
            party['started_at'],
            party['ended_at'],
            party['drank_beer'],
            party['drank_soju'],
            context.read<UserProvider>().userId);
      } else {
        context.read<PartyProvider>().initPartyInformation();
      }

      return party;
    } else {
      response = await http.get(
          Uri.parse(
              'http://10.0.2.2:8000/api/participant/recent/${context.read<UserProvider>().userId}/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });
      if (json.decode(utf8.decode(response.bodyBytes)) != null) {
        party =
            json.decode(utf8.decode(response.bodyBytes)).toList()[0]['party'];

        context.read<PartyProvider>().setPartyInformation(
            party['id'],
            party['image_memory'],
            party['participants'],
            party['comments'],
            party['name'],
            party['place'],
            party['image'],
            party['created_at'],
            party['started_at'],
            party['ended_at'],
            party['drank_beer'],
            party['drank_soju'],
            context.read<UserProvider>().userId);
      } else {
        context.read<PartyProvider>().initPartyInformation();
      }

      return party;
    }
  }

  var _future;
  @override
  void initState() {
    party = {};

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
            if (context.read<PartyProvider>().partyId == -1) {
              return NoParty();
            } else if (context.read<PartyProvider>().started_at == '') {
              return UnactiveParty();
            } else if (DateTime.parse(context.read<PartyProvider>().ended_at)
                .isBefore(DateTime.now())) {
              return NoParty();
            } else {
              return ActiveParty(rebuild1: rebuild1, rebuild2: rebuild2);
            }
          }
        });
  }
}
