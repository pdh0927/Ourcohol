import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:http/http.dart';
import 'package:ourcohol/home/tabs/calendar_page/calendar.dart';
import 'package:ourcohol/provider_ourcohol.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../style.dart';

class PartyDetail extends StatefulWidget {
  PartyDetail({super.key, this.partyMemory, this.rebuild});

  var partyMemory;
  var rebuild;
  @override
  State<PartyDetail> createState() => _PartyDetailState();
}

class _PartyDetailState extends State<PartyDetail> {
  int sojuStandard = 8;
  int beerStandard = 3;
  var commentsList;
  var content;

  getConvertDate() {
    var date = DateTime.parse(widget.partyMemory['party']['started_at']);
    var month;
    var day;

    if (date.month == 1) {
      month = 'January';
    } else if (date.month == 2) {
      month = 'February';
    } else if (date.month == 3) {
      month = 'March';
    } else if (date.month == 4) {
      month = 'April';
    } else if (date.month == 5) {
      month = 'May';
    } else if (date.month == 6) {
      month = 'June';
    } else if (date.month == 7) {
      month = 'July';
    } else if (date.month == 8) {
      month = 'August';
    } else if (date.month == 9) {
      month = 'September';
    } else if (date.month == 10) {
      month = 'October';
    } else if (date.month == 11) {
      month = 'November';
    } else if (date.month == 12) {
      month = 'December';
    }

    if (date.day == 1) {
      day = date.day.toString() + 'st';
    } else if (date.day == 2) {
      day = date.day.toString() + 'nd';
    } else if (date.day == 3) {
      day = date.day.toString() + 'rd';
    } else {
      day = date.day.toString() + 'th';
    }

    return month + ' ' + day;
  }

  getPartyAlcohol(source, size) {
    return [
      (source['drank_soju'] / sojuStandard).toInt() > 0
          ? Container(
              margin: EdgeInsets.only(right: 20 / 393 * 100.w),
              child: Column(children: [
                Container(
                    width: size,
                    height: size,
                    margin: const EdgeInsets.only(bottom: 3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      'assets/images/soju_bottle.png',
                      fit: BoxFit.fill,
                    )),
                Text('X${(source['drank_soju'] / sojuStandard).toInt()}',
                    style: textStyle23)
              ]),
            )
          : const SizedBox(height: 0, width: 0),
      source['drank_soju'] % sojuStandard > 0
          ? Container(
              margin: EdgeInsets.only(right: 20 / 393 * 100.w),
              child: Column(children: [
                Container(
                    width: size,
                    height: size,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      'assets/images/soju.png',
                      fit: BoxFit.fill,
                    )),
                Text('X${source['drank_soju'] % sojuStandard}',
                    style: textStyle23)
              ]),
            )
          : const SizedBox(height: 0, width: 0),
      (source['drank_beer'] / beerStandard).toInt() > 0
          ? Container(
              margin: EdgeInsets.only(right: 20 / 393 * 100.w),
              child: Column(children: [
                Container(
                    width: size,
                    height: size,
                    margin: const EdgeInsets.only(bottom: 3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      'assets/images/beer_bottle.png',
                      fit: BoxFit.fill,
                    )),
                Text('X${(source['drank_beer'] / beerStandard).toInt()}',
                    style: textStyle23)
              ]),
            )
          : const SizedBox(height: 0, width: 0),
      (source['drank_beer'] % beerStandard) > 0
          ? Container(
              child: Column(children: [
                Container(
                    width: size,
                    height: size,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      'assets/images/beer.png',
                      fit: BoxFit.fill,
                    )),
                Text('X${source['drank_beer'] % beerStandard}',
                    style: textStyle23)
              ]),
            )
          : const SizedBox(height: 0, width: 0)
    ];
  }

  void sortParticipants() {
    for (int i = 0;
        i < widget.partyMemory['party']['participants'].length - 1;
        i++) {
      int maxIndex = i;

      for (int j = i + 1;
          j < widget.partyMemory['party']['participants'].length;
          j++) {
        if (widget.partyMemory['party']['participants'][j]['drank_soju'] +
                widget.partyMemory['party']['participants'][j]['drank_beer'] >
            widget.partyMemory['party']['participants'][j]['drank_soju'] +
                widget.partyMemory['party']['participants'][maxIndex]
                    ['drank_beer']) {
          maxIndex = j;
        }
      }

      if (maxIndex != i) {
        var temp = widget.partyMemory['party']['participants'][i];
        widget.partyMemory['party']['participants'][i] =
            widget.partyMemory['party']['participants'][maxIndex];
        widget.partyMemory['party']['participants'][maxIndex] = temp;
      }
    }
  }

  addComment(content, party, user) async {
    Response response;

    response = await post(Uri.parse(
        // "http://OURcohol-env.eba-fh7m884a.ap-northeast-2.elasticbeanstalk.com/api/comment/"),
        "http://127.0.0.1:8000/api/comment/"), body: {
      'content': content,
      'user': user.toString(),
      'party': party.toString()
    }, headers: {
      'Authorization': 'Bearer ${context.read<UserProvider>().tokenAccess}',
    });

    if (response.statusCode == 201) {
      print('댓글 생성 완료');
    } else {
      print('댓글 생성 실패');
      print(response.body);
    }
  }

  commentDialog(userId) async {
    await showDialog(
        useSafeArea: false,
        context: context,
        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
        builder: (BuildContext ctx) {
          String inputContent = '';
          return StatefulBuilder(// dialog를 동적으로 만들기 위해
              builder: (BuildContext context, StateSetter setDialogState) {
            return Dialog(
                insetPadding: EdgeInsets.zero,
                child: Container(
                  height: (100.w - 32) / 2 * 1.1,
                  width: 100.w - 32,
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Container(
                          height: (100.w - 32) / 8,
                          alignment: Alignment.center,
                          child: const Text('댓글 작성',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "GowunBatang",
                                  color: Color(0xff454545),
                                  fontWeight: FontWeight.w700,
                                  height: 1.3))),
                      const Divider(
                        thickness: 2,
                        height: 0,
                        color: Color(0xff131313),
                      ),
                      Container(
                        width: 100.w - 32 - 40,
                        height: (100.w - 32) / 6,
                        margin: const EdgeInsets.only(top: 17),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        child: TextField(
                          maxLength: 13,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(style: BorderStyle.none),
                                borderRadius: BorderRadius.circular(10),
                                gapPadding: 0),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(style: BorderStyle.none),
                                borderRadius: BorderRadius.circular(5),
                                gapPadding: 0),
                            hintText: '추억에 한마디 남겨주세요 :)',
                            hintStyle:
                                const TextStyle(color: Color(0xff686868)),
                            contentPadding:
                                const EdgeInsets.only(left: 15, top: 30),
                            filled: true,
                            fillColor: const Color(0xffE0E0E0),
                          ),
                          autofocus: true,
                          onChanged: (text) {
                            setDialogState(() {
                              inputContent = text;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 100.w - 32 - 40,
                        height: 44 / 852 * 100.h,
                        margin: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey),
                        child: inputContent != ''
                            ? MaterialButton(
                                padding: const EdgeInsets.all(0),
                                color: const Color(0xff131313),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: const Text('작성하기',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                                onPressed: () async {
                                  content = inputContent;
                                  Navigator.pop(context);
                                  await addComment(
                                      inputContent,
                                      widget.partyMemory['party']['id'],
                                      userId);
                                })
                            : Container(
                                width: 100.w - 32 - 40,
                                height: 44 / 852 * 100.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: const Color(0xffADADAD),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text("작성하기", style: textStyle10)),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  getParticipantsList() {
    List<Widget> childs = [];
    int score = 1;

    for (int i = 0;
        i < widget.partyMemory['party']['participants'].length;
        i++) {
      var comment;
      for (int j = 0; j < commentsList.length; j++) {
        if (commentsList[j]['user']['nickname'] ==
            widget.partyMemory['party']['participants'][i]['user']
                ['nickname']) {
          comment = commentsList[j];
        }
      }

      childs.add(Container(
          width: 100.w - 52,
          margin: EdgeInsets.only(
              bottom:
                  i == widget.partyMemory['party']['participants'].length - 1
                      ? 0
                      : 20),
          child: Row(
            children: [
              Container(
                width: 45,
                alignment: Alignment.center,
                child: Text(
                    '${(i == widget.partyMemory['party']['participants'].length - 1 && score != 1) ? '꼴' : score}등',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff131313),
                        fontWeight: FontWeight.w400,
                        height: 1.3)),
              ),
              Column(children: [
                (widget.partyMemory['party']['participants'][i]['user']
                            ['image_memory'] !=
                        null
                    ? Container(
                        width: 60 / 393 * 100.w,
                        height: 60 / 393 * 100.w,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: MemoryImage(base64Decode(
                                    widget.partyMemory['party']['participants']
                                        [i]['user']['image_memory'])),
                                fit: BoxFit.fill)))
                    : Container(
                        width: 60 / 393 * 100.w,
                        height: 60 / 393 * 100.w,
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Color(colorList[widget.partyMemory['party']
                                  ['participants'][i]['id'] %
                              7]),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(FlutterRemix.user_2_fill,
                            color: Colors.white, size: 40))),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      widget.partyMemory['party']['participants'][i]['user']
                          ['nickname'],
                      style: textStyle14),
                )
              ]),
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: Column(
                  children: [
                    Container(
                      width: 200 / 393 * 100.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: getPartyAlcohol(
                            widget.partyMemory['party']['participants'][i],
                            (100.w - 50) / 10),
                      ),
                    ),
                    Container(
                        width: 200 / 393 * 100.w,
                        height: 25,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: comment == null
                            ? (context.read<UserProvider>().userId ==
                                    widget.partyMemory['party']['participants']
                                        [i]['user']['id']
                                ? MaterialButton(
                                    minWidth: 200 / 393 * 100.w,
                                    onPressed: () async {
                                      await commentDialog(widget
                                              .partyMemory['party']
                                          ['participants'][i]['user']['id']);

                                      widget.rebuild();
                                      if (content != null) {
                                        setState(() {
                                          commentsList.add({
                                            'content': content,
                                            'user': widget.partyMemory['party']
                                                ['participants'][i]['user'],
                                            'party': widget.partyMemory['party']
                                                ['id']
                                          });
                                        });
                                      }
                                    },
                                    child: const Text('한마디 남기기'))
                                : const Text('\u2764',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff131313),
                                        fontWeight: FontWeight.w400,
                                        height: 1.3)))
                            : Text('${comment['content']}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff131313),
                                    fontWeight: FontWeight.w400,
                                    height: 1.3)))
                  ],
                ),
              )
            ],
          )));

      // 등수 정하기 위해서 같은 등수 check
      if (i != widget.partyMemory['party']['participants'].length - 1 &&
          widget.partyMemory['party']['participants'][i]['drank_soju'] +
                  widget.partyMemory['party']['participants'][i]['drank_beer'] >
              widget.partyMemory['party']['participants'][i + 1]['drank_soju'] +
                  widget.partyMemory['party']['participants'][i + 1]
                      ['drank_beer']) {
        score++;
      }
    }

    return childs;
  }

  @override
  void initState() {
    sortParticipants();
    commentsList = widget.partyMemory['party']['comments'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            actions: [
              MaterialButton(
                  height: 25,
                  minWidth: 25,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
                    widget.rebuild();
                  },
                  child: const Icon(FlutterRemix.close_circle_fill,
                      color: Colors.grey))
            ]),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 20,
                    ),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${widget.partyMemory['party']['name']}',
                              style: const TextStyle(
                                  fontFamily: "GowunBatang",
                                  fontSize: 24,
                                  color: Color(0xff131313),
                                  fontWeight: FontWeight.w700,
                                  height: 1.3)),
                          Text('${getConvertDate()}',
                              style: const TextStyle(
                                  fontFamily: "GowunBatang",
                                  fontSize: 18,
                                  color: Color(0xff131313),
                                  fontWeight: FontWeight.w700,
                                  height: 1.3)),
                        ],
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          alignment: Alignment.centerLeft,
                          child: Text('${widget.partyMemory['party']['place']}',
                              style: const TextStyle(
                                  fontFamily: "GowunBatang",
                                  fontSize: 15,
                                  color: Color(0xff484848),
                                  fontWeight: FontWeight.w700,
                                  height: 1.3))),
                      widget.partyMemory['party']['image_memory'] != null
                          ? Container(
                              height: (100.w - 32) / 7 * 4,
                              width: 100.w - 32,
                              child: Image.memory(
                                base64Decode(widget.partyMemory['party']
                                    ['image_memory']),
                                fit: BoxFit.fill,
                                height: (100.w - 32) / 7 * 4,
                                width: 100.w - 32,
                              ),
                            )
                          : TmpPicture(
                              participants: widget.partyMemory['party']
                                  ['participants'],
                              height: (100.w - 32) / 7 * 4,
                              width: 100.w - 32),
                      Container(
                        width: 100.w - 32,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 10, right: 10),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                            color: const Color(0xffE0E0E0),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('술자리 총 음주량',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff131313),
                                      fontWeight: FontWeight.w700,
                                      height: 1.3)),
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: getPartyAlcohol(
                                        widget.partyMemory['party'],
                                        (100.w - 50) / 9),
                                  )),
                              const Text('개인별 주량 정보',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff131313),
                                      fontWeight: FontWeight.w700,
                                      height: 1.3)),
                              Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: getParticipantsList(),
                                  )),
                            ]),
                      ),
                    ])))));
  }
}
