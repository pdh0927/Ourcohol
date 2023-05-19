import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ourcohol/provider_ourcohol.dart';
import 'package:ourcohol/style.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class NoParty extends StatefulWidget {
  NoParty({super.key, this.rebuild1});
  var rebuild1;
  @override
  State<NoParty> createState() => _NoPartyState();
}

class _NoPartyState extends State<NoParty> {
  createParty() async {
    Response response;

    response = await post(Uri.parse(
        // "http://OURcohol-env.eba-fh7m884a.ap-northeast-2.elasticbeanstalk.com/api/party/"),
        "http://127.0.0.1:8000/api/party/"), body: {
      'name': '대환장파티',
      'place': '우리집 자취방',
    }, headers: {
      'Authorization': 'Bearer ${context.read<UserProvider>().tokenAccess}',
    });

    if (response.statusCode == 201) {
      print('파티 생성 완료');

      context.read<PartyProvider>().setPartyInformation(
          json.decode(utf8.decode(response.bodyBytes))['id'],
          json.decode(utf8.decode(response.bodyBytes))['image_memory'] ?? '',
          [],
          json.decode(utf8.decode(response.bodyBytes))['comments'] ?? [],
          json.decode(utf8.decode(response.bodyBytes))['name'],
          json.decode(utf8.decode(response.bodyBytes))['place'],
          json.decode(utf8.decode(response.bodyBytes))['image'] ?? '',
          json.decode(utf8.decode(response.bodyBytes))['created_at'] ?? '',
          json.decode(utf8.decode(response.bodyBytes))['started_at'] ?? '',
          json.decode(utf8.decode(response.bodyBytes))['ended_at'] ?? '',
          json.decode(utf8.decode(response.bodyBytes))['drank_beer'],
          json.decode(utf8.decode(response.bodyBytes))['drank_soju'],
          context.read<UserProvider>().userId);

      await addParticipant(context.read<UserProvider>().userId);
      context
          .read<PartyProvider>()
          .setMyParticipantIndex(context.read<UserProvider>().userId);
    } else {
      print('파티 생성 실패');
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('파티 중복 생성'),
            content: const Text('하루에 2개의 파티를 생성할 수 없습니다'),
            actions: <Widget>[
              TextButton(
                child: const Text('Approve'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  addParticipant(userId) async {
    Response response;
    try {
      response = await post(Uri.parse(
          // "http://OURcohol-env.eba-fh7m884a.ap-northeast-2.elasticbeanstalk.com/api/participant/"),
          "http://127.0.0.1:8000/api/participant/"), body: {
        'user': userId.toString(),
        'party': context.read<PartyProvider>().partyId.toString(),
        'is_host': 'true'
      }, headers: {
        'Authorization': 'Bearer ${context.read<UserProvider>().tokenAccess}',
      });

      if (response.statusCode == 406) {
        return null;
      } else {
        print('참가자 추가 완료');
        context
            .read<PartyProvider>()
            .participants
            .add(json.decode(utf8.decode(response.bodyBytes))[0]);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        minWidth: 100.w - 32,
        padding: EdgeInsets.zero,
        onPressed: () async {
          await createParty();
          widget.rebuild1();
        },
        child: Container(
          height: 50,
          width: 100.w - 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff131313),
          ),
          child: const Text('술자리 생성하기',
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xffFFFFFF),
                  fontWeight: FontWeight.w700,
                  height: 1.3)),
        ));
  }
}
