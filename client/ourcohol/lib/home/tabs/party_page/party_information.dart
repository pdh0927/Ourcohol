import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:http/http.dart';
import 'package:ourcohol/provider_ourcohol.dart';
import 'package:ourcohol/style.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class PartyInformation extends StatefulWidget {
  PartyInformation({super.key, this.updateParty, this.rebuild1, this.rebuild2});
  var updateParty;
  var rebuild1;
  var rebuild2;
  @override
  State<PartyInformation> createState() => _PartyInformationState();
}

class _PartyInformationState extends State<PartyInformation> {
  TextEditingController _nameComtroller = TextEditingController();
  var inputId;
  var sojuStandard = 8;
  var beerStandard = 3;

  finishParty() async {
    await widget.updateParty(
        'ended_at', context.read<PartyProvider>().ended_at);
  }

  deleteParticipant(participantId) async {
    Response response;
    if (Platform.isIOS) {
      response = await delete(
          Uri.parse("http://127.0.0.1:8000/api/participant/${participantId}/"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });
    } else {
      response = await delete(
          Uri.parse("http://10.0.2.2:8000/api/participant/${participantId}/"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });
    }

    if (response.statusCode == 204) {
      print('삭제 성공');
    } else {
      print('삭제 실패');
    }
  }

  addParticipant(userId) async {
    Response response;
    try {
      if (Platform.isIOS) {
        response = await post(
            Uri.parse("http://127.0.0.1:8000/api/participant/"),
            body: {
              'user': userId.toString(),
              'party': context.read<PartyProvider>().partyId.toString(),
            },
            headers: {
              'Authorization':
                  'Bearer ${context.read<UserProvider>().tokenAccess}',
            });
      } else {
        response = await post(
            Uri.parse("http://10.0.2.2:8000/api/participant/"),
            body: {
              'user': userId.toString(),
              'party': context.read<PartyProvider>().partyId.toString(),
            },
            headers: {
              'Authorization':
                  'Bearer ${context.read<UserProvider>().tokenAccess}',
            });
      }
      print(response.statusCode);
      if (response.statusCode == 208) {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('이미 초대된 사용자 '),
              content: const Text('다른 사용자를 초대해주세요'),
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
        return null;
      } else {
        context
            .read<PartyProvider>()
            .participants
            .add(json.decode(utf8.decode(response.bodyBytes))[0]);
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  deleteParty() async {
    Response response;
    if (Platform.isIOS) {
      response = await delete(
          Uri.parse(
              "http://127.0.0.1:8000/api/participant/${context.read<PartyProvider>().partyId}/"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });
    } else {
      response = await delete(
          Uri.parse(
              "http://10.0.2.2:8000/api/participant/${context.read<PartyProvider>().partyId}/"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });
    }

    if (response.statusCode == 204) {
      print('삭제 성공');
    } else {
      print('삭제 실패');
    }
  }

  getParticipants() {
    List<Widget> childs = [];

    for (int i = 0;
        i < context.read<PartyProvider>().participants.length;
        i++) {
      childs.add(Container(
        margin: EdgeInsets.only(
            left: i == 0 ? 16 : 0,
            right: i != context.read<PartyProvider>().participants.length - 1
                ? 40
                : 16,
            top: 5,
            bottom: 5),
        child: Stack(children: [
          Column(children: [
            (context.read<PartyProvider>().participants[i]['user']
                        ['image_memory'] !=
                    null
                ? Container(
                    width: 80 / 393 * 100.w,
                    height: 80 / 393 * 100.w,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: MemoryImage(base64Decode(context
                                .read<PartyProvider>()
                                .participants[i]['user']['image_memory'])),
                            fit: BoxFit.fill)))
                : Container(
                    width: 80 / 393 * 100.w,
                    height: 80 / 393 * 100.w,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: Color(colorList[
                          context.read<PartyProvider>().participants[i]['id'] %
                              7]),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(FlutterRemix.user_2_fill,
                        color: Colors.white, size: 40))),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                  context.read<PartyProvider>().participants[i]['user']
                      ['nickname'],
                  style: textStyle14),
            )
          ]),
          (context.read<PartyProvider>().participants[context
                          .read<PartyProvider>()
                          .myPaticipantIndex]['is_host'] ==
                      true &&
                  i != context.read<PartyProvider>().myPaticipantIndex)
              ? MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await deleteParticipant(
                        context.read<PartyProvider>().participants[i]['id']);
                    setState(() {
                      context.read<PartyProvider>().participants.removeAt(i);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 60 / 393 * 100.w, bottom: 40 / 852 * 100.h),
                    child: const Icon(FlutterRemix.close_circle_fill,
                        color: Color(0xffEC5959), size: 20),
                  ))
              : const SizedBox(height: 0, width: 0)
        ]),
      ));
    }
    return childs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: context.read<PartyProvider>().participants[context
                      .read<PartyProvider>()
                      .myPaticipantIndex]['is_host'] ==
                  true
              ? const Text('당신은 호스트',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff131313),
                      fontWeight: FontWeight.w700,
                      height: 1.3))
              : const Text('당신은 참가자',
                  style: TextStyle(
                      fontSize: 20,
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
                  width: 100.w - 50,
                  height: (100.w - 40) * 1.2,
                  margin:
                      const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                  padding: const EdgeInsets.only(top: 15, bottom: 25),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: const Color(0xffE0E0E0),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100.w - 40 - 66 / 303 * 100.w,
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 20),
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
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.none),
                                                  gapPadding: 0),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.none),
                                                  gapPadding: 0),
                                          hintText: context
                                              .read<PartyProvider>()
                                              .name,
                                          hintStyle: const TextStyle(
                                              color: Color(0xff131313)),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                        ),
                                        onSubmitted: (text) async {
                                          setState(() {
                                            context.read<PartyProvider>().name =
                                                text;
                                          });
                                          await widget.updateParty(
                                              'name', text);
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
                                              color: Color(0xff131313),
                                              fontWeight: FontWeight.w700,
                                              height: 1.3))),
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: TextField(
                                        textAlign: TextAlign.end,
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.none),
                                                  gapPadding: 0),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.none),
                                                  gapPadding: 0),
                                          hintText: context
                                              .read<PartyProvider>()
                                              .place,
                                          hintStyle: const TextStyle(
                                              color: Color(0xff131313)),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                        ),
                                        onSubmitted: (text) async {
                                          setState(() {
                                            context
                                                .read<PartyProvider>()
                                                .place = text;
                                          });
                                          await widget.updateParty(
                                              'place', text);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 100.w - 40 - 66 / 303 * 100.w,
                        margin: EdgeInsets.only(bottom: 20 / 852 * 100.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 12),
                                child: Text('현재까지 누적 테이블 주량정보',
                                    style: textStyle14)),
                            Row(
                              children: [
                                (context.read<PartyProvider>().drank_soju /
                                                sojuStandard)
                                            .toInt() >
                                        0
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            right: 20 / 393 * 100.w),
                                        child: Column(children: [
                                          Container(
                                            width: (100.w - 50) / 9,
                                            height: (100.w - 50) / 9,
                                            margin: const EdgeInsets.only(
                                                bottom: 3),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child:
                                                Text('소주병', style: textStyle24),
                                          ),
                                          Text(
                                              'X${(context.read<PartyProvider>().drank_soju / sojuStandard).toInt()}',
                                              style: textStyle23)
                                        ]),
                                      )
                                    : const SizedBox(height: 0, width: 0),
                                context.read<PartyProvider>().drank_soju %
                                            sojuStandard >
                                        0
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            right: 20 / 393 * 100.w),
                                        child: Column(children: [
                                          Container(
                                            width: (100.w - 50) / 9,
                                            height: (100.w - 50) / 9,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                bottom: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child:
                                                Text('소주잔', style: textStyle24),
                                          ),
                                          Text(
                                              'X${context.read<PartyProvider>().drank_soju % sojuStandard}',
                                              style: textStyle23)
                                        ]),
                                      )
                                    : const SizedBox(height: 0, width: 0),
                                (context.read<PartyProvider>().drank_beer /
                                                beerStandard)
                                            .toInt() >
                                        0
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            right: 20 / 393 * 100.w),
                                        child: Column(children: [
                                          Container(
                                            width: (100.w - 50) / 9,
                                            height: (100.w - 50) / 9,
                                            margin: const EdgeInsets.only(
                                                bottom: 3),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child:
                                                Text('맥주병', style: textStyle24),
                                          ),
                                          Text(
                                              'X${(context.read<PartyProvider>().drank_beer / beerStandard).toInt()}',
                                              style: textStyle23)
                                        ]),
                                      )
                                    : const SizedBox(height: 0, width: 0),
                                context.read<PartyProvider>().drank_beer %
                                            sojuStandard >
                                        0
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            right: 20 / 393 * 100.w),
                                        child: Column(children: [
                                          Container(
                                            width: (100.w - 50) / 9,
                                            height: (100.w - 50) / 9,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child:
                                                Text('맥주잔', style: textStyle24),
                                          ),
                                          Text(
                                              'X${context.read<PartyProvider>().drank_beer % sojuStandard}',
                                              style: textStyle23)
                                        ]),
                                      )
                                    : const SizedBox(height: 0, width: 0),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 100.w - 40 - 66 / 303 * 100.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 12),
                                child:
                                    Text('현재까지 누적 내 주량정보', style: textStyle14)),
                            Row(
                              children: [
                                (context.read<PartyProvider>().drank_soju /
                                                sojuStandard)
                                            .toInt() >
                                        0
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            right: 20 / 393 * 100.w),
                                        child: Column(children: [
                                          Container(
                                            width: (100.w - 50) / 9,
                                            height: (100.w - 50) / 9,
                                            margin: const EdgeInsets.only(
                                                bottom: 3),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child:
                                                Text('소주병', style: textStyle24),
                                          ),
                                          Text(
                                              'X${(context.read<PartyProvider>().drank_soju / sojuStandard).toInt()}',
                                              style: textStyle23)
                                        ]),
                                      )
                                    : const SizedBox(height: 0, width: 0),
                                context.read<PartyProvider>().drank_soju %
                                            sojuStandard >
                                        0
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            right: 20 / 393 * 100.w),
                                        child: Column(children: [
                                          Container(
                                            width: (100.w - 50) / 9,
                                            height: (100.w - 50) / 9,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                bottom: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child:
                                                Text('소주잔', style: textStyle24),
                                          ),
                                          Text(
                                              'X${context.read<PartyProvider>().drank_soju % sojuStandard}',
                                              style: textStyle23)
                                        ]),
                                      )
                                    : const SizedBox(height: 0, width: 0),
                                (context.read<PartyProvider>().drank_beer /
                                                beerStandard)
                                            .toInt() >
                                        0
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            right: 20 / 393 * 100.w),
                                        child: Column(children: [
                                          Container(
                                            width: (100.w - 50) / 9,
                                            height: (100.w - 50) / 9,
                                            margin: const EdgeInsets.only(
                                                bottom: 3),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child:
                                                Text('맥주병', style: textStyle24),
                                          ),
                                          Text(
                                              'X${(context.read<PartyProvider>().drank_beer / beerStandard).toInt()}',
                                              style: textStyle23)
                                        ]),
                                      )
                                    : const SizedBox(height: 0, width: 0),
                                context.read<PartyProvider>().drank_beer %
                                            sojuStandard >
                                        0
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            right: 20 / 393 * 100.w),
                                        child: Column(children: [
                                          Container(
                                            width: (100.w - 50) / 9,
                                            height: (100.w - 50) / 9,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child:
                                                Text('맥주잔', style: textStyle24),
                                          ),
                                          Text(
                                              'X${context.read<PartyProvider>().drank_beer % sojuStandard}',
                                              style: textStyle23)
                                        ]),
                                      )
                                    : const SizedBox(height: 0, width: 0),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    width: 100.w,
                    child: Column(
                      children: [
                        Container(
                          width: 100.w - 32,
                          margin: const EdgeInsets.only(right: 16, left: 16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '참가자 ${context.read<PartyProvider>().participants.length}명',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff131313),
                                        fontWeight: FontWeight.w700,
                                        height: 1.3)),
                                MaterialButton(
                                    minWidth: 80,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      showDialog(
                                          useSafeArea: false,
                                          context: context,
                                          barrierDismissible:
                                              true, // 바깥 영역 터치시 닫을지 여부
                                          builder: (BuildContext ctx) {
                                            return Dialog(
                                                insetPadding: EdgeInsets.zero,
                                                child: Container(
                                                  height: (100.w - 32) / 2,
                                                  width: 100.w - 32,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10,
                                                          left: 20,
                                                          right: 20),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          height:
                                                              (100.w - 32) / 8,
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                              '인원 추가',
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      "GowunBatang",
                                                                  color: Color(
                                                                      0xff454545),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  height:
                                                                      1.3))),
                                                      const Divider(
                                                        thickness: 2,
                                                        height: 0,
                                                        color:
                                                            Color(0xff131313),
                                                      ),
                                                      Container(
                                                        width: 100.w - 32 - 40,
                                                        height:
                                                            (100.w - 32) / 8,
                                                        margin: const EdgeInsets
                                                            .only(top: 17),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: TextField(
                                                          textAlign:
                                                              TextAlign.start,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    '[0-9]'))
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        style: BorderStyle
                                                                            .none),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                gapPadding: 0),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        style: BorderStyle
                                                                            .none),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                gapPadding: 0),
                                                            hintText:
                                                                '초대코드를 입력해주세요',
                                                            hintStyle:
                                                                const TextStyle(
                                                                    color: Color(
                                                                        0xff686868)),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 15,
                                                                    top: 30),
                                                            filled: true,
                                                            fillColor:
                                                                const Color(
                                                                    0xffE0E0E0),
                                                          ),
                                                          autofocus: true,
                                                          onChanged: (text) {
                                                            setState(() {
                                                              inputId = text;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 100.w - 32 - 40,
                                                        height:
                                                            44 / 852 * 100.h,
                                                        margin: const EdgeInsets
                                                            .only(top: 16),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.grey),
                                                        child: inputId != ''
                                                            ? MaterialButton(
                                                                padding: const EdgeInsets.all(
                                                                    0),
                                                                color: const Color(
                                                                    0xff131313),
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.all(Radius.circular(
                                                                        10))),
                                                                child: const Text('초대하기',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .white)),
                                                                onPressed:
                                                                    () async {
                                                                  await addParticipant(
                                                                      int.parse(
                                                                          inputId));
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(
                                                                      () {});
                                                                  widget
                                                                      .rebuild1;
                                                                })
                                                            : Container(
                                                                width: 100.w -
                                                                    32 -
                                                                    40,
                                                                height: 44 /
                                                                    852 *
                                                                    100.h,
                                                                alignment: Alignment
                                                                    .center,
                                                                decoration: BoxDecoration(
                                                                    color: const Color(0xffADADAD),
                                                                    borderRadius: BorderRadius.circular(10)),
                                                                child: Text("초대하기", style: textStyle10)),
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                          });
                                    },
                                    child: const Text('인원 추가하기',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff131313),
                                            fontWeight: FontWeight.w700,
                                            height: 1.3)))
                              ]),
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                                width: 100.w - 32,
                                height: 120 / 852 * 100.h,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: getParticipants()))),
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                      height: (100.w - 32) / 7 + 10,
                      padding: const EdgeInsets.all(5),
                      onPressed: () async {
                        if (context.read<PartyProvider>().participants[context
                                .read<PartyProvider>()
                                .myPaticipantIndex]['is_host'] ==
                            false) {
                          // 술자리 나가기
                          deleteParticipant(
                              context.read<PartyProvider>().participants[context
                                  .read<PartyProvider>()
                                  .myPaticipantIndex]['id']);
                          Navigator.pop(context);
                        } else {
                          await deleteParty();
                          widget.rebuild2();
                          // 술자리 끝내기
                          context.read<PartyProvider>().ended_at =
                              DateTime.now().toString();
                          finishParty();
                          Navigator.pop(context);
                          widget.rebuild2();
                        }
                      },
                      child: Container(
                          width: 100.w - 32,
                          height: (100.w - 32) / 7,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color(0xff131313),
                              borderRadius: BorderRadius.circular(10)),
                          child: context.read<PartyProvider>().participants[
                                      context
                                          .read<PartyProvider>()
                                          .myPaticipantIndex]['is_host'] ==
                                  true
                              ? Text("술자리 끝내기", style: textStyle10)
                              : Text("술자리 나가기", style: textStyle10))),
                )
              ]),
        )));
  }
}
