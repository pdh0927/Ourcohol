import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class PartyDetail extends StatefulWidget {
  PartyDetail({super.key, this.partyMemory});

  var partyMemory;

  @override
  State<PartyDetail> createState() => _PartyDetailState();
}

class _PartyDetailState extends State<PartyDetail> {
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
                  },
                  child: const Icon(FlutterRemix.close_circle_fill,
                      color: Colors.grey))
            ]),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
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
                  margin: const EdgeInsets.only(top: 5),
                  alignment: Alignment.centerLeft,
                  child: Text('${widget.partyMemory['party']['place']}',
                      style: const TextStyle(
                          fontFamily: "GowunBatang",
                          fontSize: 15,
                          color: Color(0xff484848),
                          fontWeight: FontWeight.w700,
                          height: 1.3)))
            ],
          ),
        ))));
  }
}
