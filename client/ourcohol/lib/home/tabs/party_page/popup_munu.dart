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

import 'party_information.dart';

class PopupMenu extends StatefulWidget {
  PopupMenu({super.key, this.rebuild1, this.rebuild2, this.updateParty});
  var rebuild1;
  var rebuild2;
  var updateParty;

  @override
  State<PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  var inputId;
  finishParty() async {
    await widget.updateParty(
        'ended_at', context.read<PartyProvider>().ended_at);
  }

  deleteParticipant(participantId) async {
    Response response;

    response = await delete(
        Uri.parse(
            "http://ourcohol-server-dev.ap-northeast-2.elasticbeanstalk.com/api/participant/${participantId}/"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${context.read<UserProvider>().tokenAccess}',
        });

    if (response.statusCode == 204) {
      print('삭제 성공');
    } else {
      print('삭제 실패');
    }
  }

  addParticipant(userId) async {
    Response response;
    try {
      response = await post(
          Uri.parse(
              "http://ourcohol-server-dev.ap-northeast-2.elasticbeanstalk.com/api/participant/"),
          body: {
            'user': userId.toString(),
            'party': context.read<PartyProvider>().partyId.toString(),
          },
          headers: {
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });

      if (response.statusCode == 406) {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('이미 초대된 사용자',
                  style: TextStyle(fontSize: 20, color: Color(0xff131313))),
              content: const Text('다른 사용자를 초대해주세요.',
                  style: TextStyle(fontSize: 17, color: Color(0xff131313))),
              contentPadding:
                  EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 5),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 20, color: Color(0xff131313)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

        return null;
      } else if (response.statusCode == 409) {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('초대할 수 없는 사용자',
                  style: TextStyle(fontSize: 20, color: Color(0xff131313))),
              content: const Text('사용자가 이미 다른 파티에 등록되어 있습니다.',
                  style: TextStyle(fontSize: 17, color: Color(0xff131313))),
              contentPadding:
                  EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 5),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 20, color: Color(0xff131313)),
                  ),
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

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        padding: const EdgeInsets.only(bottom: 0, top: 15, right: 10, left: 10),
        icon: const Icon(
          FlutterRemix.menu_line,
          color: Color(0xff131313),
        ),
        itemBuilder: (context) => [
              PopupMenuItem(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xff131313)))),
                    child: MaterialButton(
                        minWidth: 80,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          showDialog(
                              useSafeArea: false,
                              context: context,
                              barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                              builder: (BuildContext ctx) {
                                return Dialog(
                                    insetPadding: EdgeInsets.zero,
                                    child: Container(
                                      height: (100.w - 32) / 2,
                                      width: 100.w - 32,
                                      padding: const EdgeInsets.only(
                                          bottom: 10, left: 20, right: 20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: (100.w - 32) / 8,
                                              alignment: Alignment.center,
                                              child: const Text('인원 추가',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: "GowunBatang",
                                                      color: Color(0xff454545),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 1.3))),
                                          const Divider(
                                            thickness: 2,
                                            height: 0,
                                            color: Color(0xff131313),
                                          ),
                                          Container(
                                            width: 100.w - 32 - 40,
                                            height: (100.w - 32) / 8,
                                            margin:
                                                const EdgeInsets.only(top: 17),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: TextField(
                                              textAlign: TextAlign.start,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9]'))
                                              ],
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                style:
                                                                    BorderStyle
                                                                        .none),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        gapPadding: 0),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                style:
                                                                    BorderStyle
                                                                        .none),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        gapPadding: 0),
                                                hintText: '초대코드를 입력해주세요',
                                                hintStyle: const TextStyle(
                                                    color: Color(0xff686868)),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15, top: 30),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xffE0E0E0),
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
                                            height: 44 / 852 * 100.h,
                                            margin:
                                                const EdgeInsets.only(top: 16),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey),
                                            child: inputId != ''
                                                ? MaterialButton(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    color:
                                                        const Color(0xff131313),
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: const Text('초대하기',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white)),
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      await addParticipant(
                                                          int.parse(inputId));

                                                      Navigator.pop(context);

                                                      widget.rebuild1();
                                                    })
                                                : Container(
                                                    width: 100.w - 32 - 40,
                                                    height: 44 / 852 * 100.h,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffADADAD),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10)),
                                                    child: Text("초대하기", style: textStyle10)),
                                          ),
                                        ],
                                      ),
                                    ));
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(FlutterRemix.user_add_line),
                            Text('인원 추가', style: textStyle25)
                          ],
                        )),
                  )),
              PopupMenuItem(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xff131313)))),
                    child: MaterialButton(
                        minWidth: 80,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(FlutterRemix.share_box_line),
                            Text('공유 하기', style: textStyle25)
                          ],
                        )),
                  )),
              PopupMenuItem(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xff131313)))),
                    child: MaterialButton(
                        minWidth: 80,
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          Navigator.pop(context);
                          await Navigator.of(context, rootNavigator: false)
                              .push(MaterialPageRoute(
                                  builder: (c) => PartyInformation(
                                        rebuild1: widget.rebuild1,
                                        rebuild2: widget.rebuild2,
                                        updateParty: widget.updateParty,
                                      )));
                          widget.rebuild1();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(FlutterRemix.settings_line),
                            Text('술자리 정보 변경', style: textStyle25)
                          ],
                        )),
                  )),
              PopupMenuItem(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: MaterialButton(
                      minWidth: 80,
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        if (context.read<PartyProvider>().participants[context
                                .read<PartyProvider>()
                                .myPaticipantIndex]['is_host'] ==
                            false) {
                          Navigator.pop(context);
                          await deleteParticipant(
                              context.read<PartyProvider>().participants[context
                                  .read<PartyProvider>()
                                  .myPaticipantIndex]['id']);

                          context.read<PartyProvider>().initPartyInformation();
                          widget.rebuild1();
                        } else {
                          // 술자리 끝내기
                          Navigator.pop(context);
                          context.read<PartyProvider>().ended_at =
                              DateTime.now().toString();
                          await finishParty();

                          context.read<PartyProvider>().initPartyInformation();
                          widget.rebuild1();
                        }
                      },
                      child: Container(
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xff131313),
                          ),
                          child: context.read<PartyProvider>().participants[
                                      context
                                          .read<PartyProvider>()
                                          .myPaticipantIndex]['is_host'] ==
                                  true
                              ? Text("술자리 끝내기", style: textStyle26)
                              : Text("술자리 나가기", style: textStyle26)))),
            ]);
  }
}
