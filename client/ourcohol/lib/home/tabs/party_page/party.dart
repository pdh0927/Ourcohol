import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
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
  rebuild1() {
    setState(() {});
  }

  rebuild2() {
    setState(() {
      context.read<PartyProvider>().initPartyInformation();

      _future = getRecentParty();
    });
  }

  Future getRecentParty() async {
    var party = {};
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
    }
  }

  updateParty(String key, String value) async {
    http.Response response;
    try {
      if (Platform.isIOS) {
        response = await patch(
            Uri.parse(
                "http://127.0.0.1:8000/api/party/${context.read<PartyProvider>().partyId}/"),
            body: {
              key: value
            },
            headers: {
              'Authorization':
                  'Bearer ${context.read<UserProvider>().tokenAccess}',
            });
      } else {
        response = await patch(
            Uri.parse(
                "http://10.0.2.2:8000/api/party/${context.read<PartyProvider>().partyId}/"),
            body: {
              key: value
            },
            headers: {
              'Authorization':
                  'Bearer ${context.read<UserProvider>().tokenAccess}',
            });
      }

      if (response.statusCode == 200) {
        print('update success');
        return null;
      } else {
        print('update fail');
        return null;
      }
    } catch (e) {
      print(e.toString());
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
            DateTime now = DateTime.now();
            if (context.read<PartyProvider>().partyId == -1) {
              return NoParty(rebuild1: rebuild1);
            } else if (context.read<PartyProvider>().started_at == null) {
              return UnactiveParty(
                updateParty: updateParty,
                rebuild1: rebuild1,
                rebuild2: rebuild2,
              );
            } else if ((DateTime.parse(context.read<PartyProvider>().ended_at)
                    .toUtc())
                .isBefore(DateTime.utc(now.year, now.month, now.day, now.hour,
                    now.minute, now.second))) {
              return NoParty(rebuild1: rebuild1);
            } else {
              return ActiveParty(
                  updateParty: updateParty,
                  rebuild1: rebuild1,
                  rebuild2: rebuild2);
            }
          }
        });
  }
}
