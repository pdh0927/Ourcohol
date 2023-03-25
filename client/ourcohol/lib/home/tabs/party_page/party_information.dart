import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:http/http.dart';
import 'package:ourcohol/provider_ourcohol.dart';
import 'package:ourcohol/style.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PartyInformation extends StatefulWidget {
  const PartyInformation({super.key});

  @override
  State<PartyInformation> createState() => _PartyInformationState();
}

class _PartyInformationState extends State<PartyInformation> {
  TextEditingController _nameComtroller = TextEditingController();
  update(String key, String value) async {
    Response response;
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
                "http://127.0.0.1:8000/api/party/${context.read<PartyProvider>().partyId}/"),
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

  @override
  void initState() {
    _nameComtroller =
        TextEditingController(text: context.read<PartyProvider>().name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
              '당신은 ' +
                  (context.read<PartyProvider>().participants[context
                              .read<PartyProvider>()
                              .myPaticipantIndex] ==
                          true
                      ? '호스트'
                      : '참가자'),
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "GowunBatang",
                  color: Color(0xff131313),
                  fontWeight: FontWeight.w700,
                  height: 1.3)),
          centerTitle: true,
          actions: [
            MaterialButton(
                height: 25,
                minWidth: 25,
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(FlutterRemix.close_circle_fill,
                    color: Colors.grey))
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 100.w - 40,
                  height: (100.w - 40) * 1.2,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: const Color(0xffE0E0E0),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('출입증',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "GowunBatang",
                              color: Color(0xff131313),
                              fontWeight: FontWeight.w700,
                              height: 1.3)),
                      (context.read<PartyProvider>().participants[context
                                  .read<PartyProvider>()
                                  .myPaticipantIndex]['user']['image_memory'] !=
                              null
                          ? Container(
                              width: 150 / 852 * 100.h,
                              height: 150 / 852 * 100.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: MemoryImage(base64Decode(context
                                              .read<PartyProvider>()
                                              .participants[context.read<PartyProvider>().myPaticipantIndex]
                                          ['user']['image_memory'])),
                                      fit: BoxFit.fill)))
                          : Container(
                              width: (100.w - 50) / 7,
                              height: (100.w - 50) / 7,
                              decoration: BoxDecoration(
                                color: Color(colorList[
                                    context.read<PartyProvider>().participants[
                                            context
                                                .read<PartyProvider>()
                                                .myPaticipantIndex]['id'] %
                                        7]),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(FlutterRemix.user_2_fill,
                                  color: Colors.white, size: 40))),
                      Text(context.read<UserProvider>().nickname,
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "GowunBatang",
                              color: Color(0xff131313),
                              fontWeight: FontWeight.w700,
                              height: 1.3)),
                      Container(
                        width: 100.w - 40 - 66 / 303 * 100.w,
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: const Text('모임명',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "GowunBatang",
                                        color: Color(0xff131313),
                                        fontWeight: FontWeight.w700,
                                        height: 1.3))),
                            Expanded(
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: _nameComtroller,
                                  textAlign: TextAlign.end,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(style: BorderStyle.none),
                                        gapPadding: 0),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(style: BorderStyle.none),
                                        gapPadding: 0),
                                    hintText:
                                        context.read<PartyProvider>().name,
                                    hintStyle: const TextStyle(
                                        color: Color(0xff131313)),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                  ),
                                  onSubmitted: (text) async {
                                    setState(() {
                                      context.read<PartyProvider>().name = text;
                                    });
                                    await update('name', text);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100.w - 40 - 66 / 303 * 100.w,
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: const Text('장소',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "GowunBatang",
                                        color: Color(0xff131313),
                                        fontWeight: FontWeight.w700,
                                        height: 1.3))),
                            Expanded(
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: TextField(
                                  textAlign: TextAlign.end,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(style: BorderStyle.none),
                                        gapPadding: 0),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(style: BorderStyle.none),
                                        gapPadding: 0),
                                    hintText:
                                        context.read<PartyProvider>().place,
                                    hintStyle: const TextStyle(
                                        color: Color(0xff131313)),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                  ),
                                  onSubmitted: (text) async {
                                    setState(() {
                                      context.read<PartyProvider>().place =
                                          text;
                                    });
                                    await update('place', text);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ]),
        )));
  }
}
