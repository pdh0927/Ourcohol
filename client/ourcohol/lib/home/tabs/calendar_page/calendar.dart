import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import 'package:ourcohol/style.dart';
import 'package:ourcohol/home/tabs/calendar_page/calendar_data.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  int year = -1;
  int month = -1;

  int startDayOfWeek = -1;
  int selectedYear = -1;
  int selectedMonth = -1;
  int selectedDay = -1;

  setDate() {
    DateTime? date = DateTime.now();
    setState(() {
      year = date.year;
      month = date.month;
      selectedYear = date.year;
      selectedMonth = date.month;

      startDayOfWeek = (date.weekday - (date.day % 7 - 1)) >= 0
          ? date.weekday - (date.day % 7 - 1)
          : date.weekday - (date.day % 7 - 1) + 7;
    });
  }

  setWeekDay(newYear, newMonth) {
    DateTime newDate = DateTime(newYear, newMonth, 1);
    DateTime oldDate = DateTime(year, month, 1);
    Duration duration = oldDate.difference(newDate);

    setState(() {
      if (duration.inDays > 0) {
        startDayOfWeek = (startDayOfWeek - (duration.inDays % 7)) % 7;
      } else {
        startDayOfWeek = (startDayOfWeek + (-duration.inDays % 7)) % 7;
      }
    });
  }

  List<Widget> getDayOfWeekList() {
    List<Widget> childs = [];

    for (int i = 0; i < 7; i++) {
      childs.add(Container(
        width: (100.w - 32) / 7,
        height: 2.7.h,
        alignment: Alignment.center,
        child: Text(dayOfWeekStr[i],
            style: i != 0
                ? textStyle1
                : const TextStyle(
                    fontSize: 16,
                    fontFamily: "GowunBatang",
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                    height: 1.3)),
      ));
    }

    return childs;
  }

  int countParty = 0;
  int countThisMonth = 0;
  bool finishFlag = false;
  List<Widget> getDateList(week) {
    int lastWeekDay = 0;
    List<Widget> childs = [];

    for (int i = week * 7; i < week * 7 + 7; i++) {
      if (i - startDayOfWeek + 1 > 0 &&
          i - startDayOfWeek + 1 <=
              int.parse(calendarData[year.toString()]![month.toString()]!)) {
        // 이번 달
        if (myPartyList.isNotEmpty && countParty < myPartyList.length) {
          for (int j = 0; j < myPartyList.length; j++) {
            var parsedDate =
                DateTime.parse(myPartyList[j]['party']['created_at']);
            if (parsedDate.year == year &&
                parsedDate.month == month &&
                parsedDate.day == i - startDayOfWeek + 1) {
              childs.add(Container(
                  width: (100.w - 32) / 7,
                  // height: 9.h,
                  height: 0.59.h * 2 +
                      12 * 1.3 +
                      1 +
                      0.59.h +
                      (100.w - 32) / 7 -
                      0.59.h * 2,
                  alignment: Alignment.center,
                  decoration: selectedDay == (i - startDayOfWeek + 1)
                      ? const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                              Colors.grey,
                              Colors.white,
                            ]))
                      : null,
                  child: MaterialButton(
                      padding:
                          EdgeInsets.fromLTRB(0.59.h, 0.59.h, 0.59.h, 0.3.h),
                      child: SizedBox(
                        width: (100.w - 32) / 7,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text((i - startDayOfWeek + 1).toString(),
                                  style: i % 7 != 0
                                      ? textStyle2
                                      : const TextStyle(
                                          fontSize: 12,
                                          fontFamily: "GowunBatang",
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                          height: 1.3)),
                              Container(
                                margin: EdgeInsets.only(bottom: 0.59.h),
                                width: (100.w - 32) / 7 - 0.59.h * 2,
                                height: (100.w - 32) / 7 - 0.59.h * 2,
                                child: Image.memory(
                                  base64Decode(
                                      myPartyList[j]['party']['image_memory']),
                                  fit: BoxFit.fill,
                                  width: (100.w - 32) / 7 - 0.59.h * 2,
                                  height: (100.w - 32) / 7 - 0.59.h * 2,
                                ),
                              )
                            ]),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedYear = year;
                          selectedMonth = month;
                          selectedDay = i - startDayOfWeek + 1;
                          partyMemory = myPartyList[j];
                        });
                      })));
              countParty++;
              break;
            } else if (j == myPartyList.length - 1) {
              childs.add(Container(
                  width: (100.w - 32) / 7,
                  // height: 9.h,
                  height: 0.59.h * 2 +
                      12 * 1.3 +
                      1 +
                      0.59.h +
                      (100.w - 32) / 7 -
                      0.59.h * 2,
                  padding: EdgeInsets.fromLTRB(0.59.h, 0.59.h, 0.59.h, 0.3.h),
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text((i - startDayOfWeek + 1).toString(),
                            style: i % 7 != 0
                                ? textStyle2
                                : const TextStyle(
                                    fontSize: 12,
                                    fontFamily: "GowunBatang",
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3)),
                        Container(
                          margin: EdgeInsets.only(bottom: 0.59.h),
                          width: (100.w - 32) / 7 - 0.59.h * 2,
                          height: (100.w - 32) / 7 - 0.59.h * 2,
                        )
                      ])));
            }
          }
        } else {
          childs.add(Container(
              width: (100.w - 32) / 7,
              height: 9.h,
              padding: EdgeInsets.fromLTRB(0.59.h, 0.59.h, 0.59.h, 0.3.h),
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((i - startDayOfWeek + 1).toString(),
                        style: i % 7 != 0
                            ? textStyle2
                            : const TextStyle(
                                fontSize: 12,
                                fontFamily: "GowunBatang",
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                height: 1.3)),
                    Container(
                      margin: EdgeInsets.only(bottom: 0.59.h),
                      width: (100.w - 32) / 7 - 0.59.h * 2,
                      height: (100.w - 32) / 7 - 0.59.h * 2,
                    )
                  ])));
        }
        lastWeekDay++;
        countThisMonth++;
        if (int.parse(calendarData[year.toString()]![month.toString()]!) ==
            countThisMonth) {
          finishFlag = true;
        }
      } else if (i - startDayOfWeek + 1 <= 0) {
        // 이전달
        if (myPartyList.isNotEmpty && countParty < myPartyList.length) {
          for (int j = 0; j < myPartyList.length; j++) {
            var parsedDate =
                DateTime.parse(myPartyList[j]['party']['created_at']);
            if (parsedDate.year == ((month - 1) == 0 ? year - 1 : year) &&
                parsedDate.month == ((month - 1) == 0 ? 12 : (month - 1)) &&
                parsedDate.day ==
                    ((int.parse(calendarData[
                                ((month - 1) == 0 ? year - 1 : year)
                                    .toString()]![
                            ((month - 1) == 0 ? 12 : (month - 1))
                                .toString()]!) +
                        (i - startDayOfWeek + 1)))) {
              childs.add(Container(
                  width: (100.w - 32) / 7,
                  // height: 9.h,
                  height: 0.59.h * 2 +
                      12 * 1.3 +
                      1 +
                      0.59.h +
                      (100.w - 32) / 7 -
                      0.59.h * 2,
                  alignment: Alignment.center,
                  decoration: selectedDay ==
                          (int.parse(calendarData[
                                      ((month - 1) == 0 ? year - 1 : year)
                                          .toString()]![
                                  ((month - 1) == 0 ? 12 : (month - 1))
                                      .toString()]!) +
                              (i - startDayOfWeek + 1))
                      ? const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                              Colors.grey,
                              Colors.white,
                            ]))
                      : null,
                  child: MaterialButton(
                      padding:
                          EdgeInsets.fromLTRB(0.59.h, 0.59.h, 0.59.h, 0.3.h),
                      child: SizedBox(
                        width: (100.w - 32) / 7,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  (int.parse(calendarData[((month - 1) == 0
                                                  ? year - 1
                                                  : year)
                                              .toString()]![((month - 1) == 0
                                                  ? 12
                                                  : (month - 1))
                                              .toString()]!) +
                                          (i - startDayOfWeek + 1))
                                      .toString(),
                                  style: textStyle5),
                              Container(
                                margin: EdgeInsets.only(bottom: 0.59.h),
                                width: (100.w - 32) / 7 - 0.59.h * 2,
                                height: (100.w - 32) / 7 - 0.59.h * 2,
                                child: Image.memory(
                                  base64Decode(
                                      myPartyList[j]['party']['image_memory']),
                                  fit: BoxFit.fill,
                                  width: (100.w - 32) / 7 - 0.59.h * 2,
                                  height: (100.w - 32) / 7 - 0.59.h * 2,
                                ),
                              )
                            ]),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedYear = (month - 1) == 0 ? year - 1 : year;
                          selectedMonth = (month - 1) == 0 ? 12 : (month - 1);
                          selectedDay = int.parse(calendarData[
                                      ((month - 1) == 0 ? year - 1 : year)
                                          .toString()]![
                                  ((month - 1) == 0 ? 12 : (month - 1))
                                      .toString()]!) +
                              (i - startDayOfWeek + 1);
                          partyMemory = myPartyList[j];
                        });
                      })));
              countParty++;
              break;
            } else if (j == myPartyList.length - 1) {
              childs.add(Container(
                  width: (100.w - 32) / 7,
                  // height: 9.h,
                  height: 0.59.h * 2 +
                      12 * 1.3 +
                      1 +
                      0.59.h +
                      (100.w - 32) / 7 -
                      0.59.h * 2,
                  padding: EdgeInsets.fromLTRB(0.59.h, 0.59.h, 0.59.h, 0.3.h),
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            (int.parse(calendarData[
                                            ((month - 1) == 0 ? year - 1 : year)
                                                .toString()]![
                                        ((month - 1) == 0 ? 12 : (month - 1))
                                            .toString()]!) +
                                    (i - startDayOfWeek + 1))
                                .toString(),
                            style: textStyle5),
                        Container(
                          margin: EdgeInsets.only(bottom: 0.59.h),
                          width: (100.w - 32) / 7 - 0.59.h * 2,
                          height: (100.w - 32) / 7 - 0.59.h * 2,
                        )
                      ])));
            }
          }
        } else {
          childs.add(Container(
              width: (100.w - 32) / 7,
              // height: 9.h,
              height: 0.59.h * 2 +
                  12 * 1.3 +
                  1 +
                  0.59.h +
                  (100.w - 32) / 7 -
                  0.59.h * 2,
              padding: EdgeInsets.fromLTRB(0.59.h, 0.59.h, 0.59.h, 0.3.h),
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        (int.parse(calendarData[
                                        ((month - 1) == 0 ? year - 1 : year)
                                            .toString()]![
                                    ((month - 1) == 0 ? 12 : (month - 1))
                                        .toString()]!) +
                                (i - startDayOfWeek + 1))
                            .toString(),
                        style: textStyle5),
                    Container(
                      margin: EdgeInsets.only(bottom: 0.59.h),
                      width: (100.w - 32) / 7 - 0.59.h * 2,
                      height: (100.w - 32) / 7 - 0.59.h * 2,
                    )
                  ])));
        }
      } else {
        // 다음 달
        if (myPartyList.isNotEmpty && countParty < myPartyList.length) {
          for (int j = 0; j < myPartyList.length; j++) {
            var parsedDate =
                DateTime.parse(myPartyList[j]['party']['created_at']);
            if (parsedDate.year == ((month + 1) == 13 ? year + 1 : year) &&
                parsedDate.month == ((month + 1) == 13 ? 1 : (month + 1)) &&
                parsedDate.day == (i - 7 * week - lastWeekDay + 1)) {
              childs.add(Container(
                  width: (100.w - 32) / 7,
                  // height: 9.h,
                  height: 0.59.h * 2 +
                      12 * 1.3 +
                      1 +
                      0.59.h +
                      (100.w - 32) / 7 -
                      0.59.h * 2,
                  alignment: Alignment.center,
                  decoration: selectedDay == (i - 7 * week - lastWeekDay + 1)
                      ? const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                              Colors.grey,
                              Colors.white,
                            ]))
                      : null,
                  child: MaterialButton(
                      padding:
                          EdgeInsets.fromLTRB(0.59.h, 0.59.h, 0.59.h, 0.3.h),
                      child: SizedBox(
                        width: (100.w - 32) / 7,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text((i - 7 * week - lastWeekDay + 1).toString(),
                                  style: textStyle5),
                              Container(
                                margin: EdgeInsets.only(bottom: 0.59.h),
                                width: (100.w - 32) / 7 - 0.59.h * 2,
                                height: (100.w - 32) / 7 - 0.59.h * 2,
                                child: Image.memory(
                                  base64Decode(
                                      myPartyList[j]['party']['image_memory']),
                                  fit: BoxFit.fill,
                                  width: (100.w - 32) / 7 - 0.59.h * 2,
                                  height: (100.w - 32) / 7 - 0.59.h * 2,
                                ),
                              )
                            ]),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedYear = (month + 1) == 13 ? year + 1 : year;
                          selectedMonth = (month + 1) == 13 ? 1 : (month + 1);
                          selectedDay = (i - 7 * week - lastWeekDay + 1) as int;
                          partyMemory = myPartyList[j];
                        });
                      })));
              countParty++;
              break;
            } else if (j == myPartyList.length - 1) {
              childs.add(Container(
                  width: (100.w - 32) / 7,
                  // height: 9.h,
                  height: 0.59.h * 2 +
                      12 * 1.3 +
                      1 +
                      0.59.h +
                      (100.w - 32) / 7 -
                      0.59.h * 2,
                  padding: EdgeInsets.fromLTRB(0.59.h, 0.59.h, 0.59.h, 0.3.h),
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text((i - 7 * week - lastWeekDay + 1).toString(),
                            style: textStyle5),
                        Container(
                          margin: EdgeInsets.only(bottom: 0.59.h),
                          width: (100.w - 32) / 7 - 0.59.h * 2,
                          height: (100.w - 32) / 7 - 0.59.h * 2,
                        )
                      ])));
            }
          }
        } else {
          childs.add(Container(
              width: (100.w - 32) / 7,
              // height: 9.h,
              height: 0.59.h * 2 +
                  12 * 1.3 +
                  1 +
                  0.59.h +
                  (100.w - 32) / 7 -
                  0.59.h * 2,
              padding: EdgeInsets.fromLTRB(0.59.h, 0.59.h, 0.59.h, 0.3.h),
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((i - 7 * week - lastWeekDay + 1).toString(),
                        style: textStyle5),
                    Container(
                      margin: EdgeInsets.only(bottom: 0.59.h),
                      width: (100.w - 32) / 7 - 0.59.h * 2,
                      height: (100.w - 32) / 7 - 0.59.h * 2,
                    )
                  ])));
        }
      }
    }

    return childs;
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system
              // navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  List<Widget> getCommentList() {
    List<Widget> childs = [];

    for (int i = 0; i < partyMemory['party']['comments'].length; i++) {
      childs.add(Container(
        margin: EdgeInsets.only(
            bottom: i != partyMemory['party']['comments'].length - 1 ? 2.w : 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 6.w,
                height: 6.w,
                margin: const EdgeInsets.only(right: 7),
                decoration: partyMemory['party']['comments'][i]['user']
                            ['image_memory'] !=
                        null
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: MemoryImage(base64Decode(partyMemory['party']
                                ['comments'][i]['user']['image_memory']))))
                    : const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                child: partyMemory['party']['comments'][i]['user']
                            ['image_memory'] ==
                        null
                    ? const Icon(
                        FlutterRemix.user_2_fill,
                        color: Colors.white,
                      )
                    : null),
            Text(partyMemory['party']['comments'][i]['content'],
                style: textStyle8),
          ],
        ),
      ));
    }
    return childs;
  }

  var partyMemory;
  var myPartyList = [];
  Future getMyPartyList() async {
    http.Response response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/api/party/participant/list/2/${selectedYear}/${selectedMonth}/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjg0MTE2NTk5LCJpYXQiOjE2NzgxMTY1OTksImp0aSI6IjlhZDFkOWJiOGExYjRhNGY5M2Y5NDY5Yjc0ODJhZmY2IiwidXNlcl9pZCI6Mn0.UoQFcrWwWbm6_KrGGNn6mmJzH27ZPQUMqqbLJpB0IWw',
        });
    setState(() {
      myPartyList = json.decode(utf8.decode(response.bodyBytes)).toList();
    });

    return myPartyList;
  }

  var _future;
  @override
  void initState() {
    setDate();
    partyMemory = null;
    _future = getMyPartyList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      countParty = 0;
      countThisMonth = 0;
      finishFlag = false;
    });

    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              width: 100.w - 32,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                    child: MaterialButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        _showDialog(
                          CupertinoDatePicker(
                            initialDateTime: DateTime(
                              year,
                              month,
                            ),
                            minimumYear: 2023, maximumYear: 2029,
                            mode: CupertinoDatePickerMode.date,
                            use24hFormat: true,
                            // This is called when the user changes the date.
                            onDateTimeChanged: (DateTime newDate) {
                              setState(() {
                                setWeekDay(newDate.year, newDate.month);
                                year = newDate.year;
                                month = newDate.month;
                                countThisMonth = 0;
                                finishFlag = false;
                                selectedYear = newDate.year;
                                selectedMonth = newDate.month;
                                selectedDay = newDate.day;
                              });
                              setState(() {
                                _future = getMyPartyList();
                              });
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$year Year', style: textStyle3),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 0.3.h, bottom: 0.5.h),
                              child: Text(monthStr[month], style: textStyle4))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 1.17.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: getDayOfWeekList(),
                    ),
                  ),
                  const Divider(
                    thickness: 1.5,
                    height: 0,
                    color: Color(0xffCACACA),
                  ),
                  FutureBuilder(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.hasData == false) {
                          return const CupertinoActivityIndicator();
                        } else {
                          return Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: getDateList(0),
                            ),
                            const Divider(
                              thickness: 1.5,
                              height: 0,
                              color: Color(0xffCACACA),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: getDateList(1),
                            ),
                            const Divider(
                              thickness: 1.5,
                              height: 0,
                              color: Color(0xffCACACA),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: getDateList(2),
                            ),
                            const Divider(
                              thickness: 1.5,
                              height: 0,
                              color: Color(0xffCACACA),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: getDateList(3),
                            ),
                            const Divider(
                              thickness: 1.5,
                              height: 0,
                              color: Color(0xffCACACA),
                            ),
                            finishFlag == false
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: getDateList(4),
                                      ),
                                      const Divider(
                                        thickness: 1.5,
                                        height: 0,
                                        color: Color(0xffCACACA),
                                      )
                                    ],
                                  )
                                : const SizedBox(height: 0),
                            finishFlag == false
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: getDateList(5),
                                      ),
                                      const Divider(
                                        thickness: 1.5,
                                        height: 0,
                                        color: Color(0xffCACACA),
                                      )
                                    ],
                                  )
                                : const SizedBox(height: 0),
                          ]);
                        }
                      }),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 1.5.h, 16, 1.h),
              decoration: partyMemory != null
                  ? const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                          Colors.grey,
                          Colors.white,
                        ]))
                  : null,
              child: partyMemory != null
                  ? Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${partyMemory['party']['name']}',
                                style: textStyle6,
                              ),
                              Text(
                                '더 보기',
                                style: textStyle7,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 42.w,
                                height: 30.w,
                                child: Image.memory(
                                  base64Decode(
                                      partyMemory['party']['image_memory']),
                                  fit: BoxFit.fill,
                                  width: 42.w,
                                  height: 30.w,
                                ),
                              ),
                              partyMemory['party']['comments'].length == 0
                                  ? Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '우리들의 이야기를 남겨주세요 :)',
                                          style: textStyle5,
                                        ),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: getCommentList(),
                                    )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                              '$selectedYear.$selectedMonth.$selectedDay',
                              style: textStyle8),
                        )
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 6.h),
                      child: Text('내 기억을 떠올려 보세요 :)', style: textStyle9)),
            )
          ])),
    );
  }
}
