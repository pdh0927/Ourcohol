import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ourcohol/style.dart';
import 'package:ourcohol/tabs/calendar_page/calendar_data.dart';
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

  List<Widget> getDateList(week) {
    int nextDay = 1;
    List<Widget> childs = [];

    for (int i = week * 7; i < week * 7 + 7; i++) {
      if (i - startDayOfWeek + 1 > 0 &&
          i - startDayOfWeek + 1 <=
              int.parse(calendarData[year.toString()]![month.toString()]!)) {
        for (int j = 0; j < myPartyList.length; j++) {
          var parsedDate =
              DateTime.parse(myPartyList[j]['party']['created_at']);
          if (parsedDate.year == year &&
              parsedDate.month == month &&
              parsedDate.day == i) {
            childs.add(Container(
                width: (100.w - 32) / 7,
                height: 9.h,
                alignment: Alignment.center,
                child: MaterialButton(
                    padding: EdgeInsets.all(0.59.h),
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
                      });
                    })));
            break;
          } else if (j == myPartyList.length - 1) {
            childs.add(Container(
                width: (100.w - 32) / 7,
                height: 9.h,
                alignment: Alignment.center,
                child: MaterialButton(
                    padding: EdgeInsets.all(0.59.h),
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
                            )
                          ]),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedYear = year;
                        selectedMonth = month;
                        selectedDay = i - startDayOfWeek + 1;
                      });
                    })));
          }
        }
      } else if (i - startDayOfWeek + 1 <= 0) {
        childs.add(Container(
            width: (100.w - 32) / 7,
            height: 9.h,
            alignment: Alignment.center,
            child: MaterialButton(
                padding: EdgeInsets.all(0.59.h),
                child: SizedBox(
                  width: (100.w - 32) / 7,
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
                          child: Image.asset(
                              'assets/images/example${(i + 3) % 9}.png',
                              fit: BoxFit.fitHeight),
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
                  });
                })));
      } else {
        childs.add(Container(
            width: (100.w - 32) / 7,
            height: 9.h,
            alignment: Alignment.center,
            child: MaterialButton(
                padding: EdgeInsets.all(0.59.h),
                child: SizedBox(
                  width: (100.w - 32) / 7,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(nextDay.toString(), style: textStyle5),
                        Container(
                          margin: EdgeInsets.only(bottom: 0.59.h),
                          width: (100.w - 32) / 7 - 0.59.h * 2,
                          height: (100.w - 32) / 7 - 0.59.h * 2,
                          child: Image.asset(
                              'assets/images/example${(i + 3) % 9}.png',
                              fit: BoxFit.fitHeight),
                        )
                      ]),
                ),
                onPressed: () {
                  setState(() {
                    selectedYear = (month + 1) == 13 ? year + 1 : year;
                    selectedMonth = (month + 1) == 13 ? 1 : (month + 1);
                    selectedDay = nextDay;
                  });
                })));
        nextDay++;
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

  var myPartyList = [];
  Future getMyPartyList() async {
    http.Response response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/party/participant/list/2/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjg0MTE2NTk5LCJpYXQiOjE2NzgxMTY1OTksImp0aSI6IjlhZDFkOWJiOGExYjRhNGY5M2Y5NDY5Yjc0ODJhZmY2IiwidXNlcl9pZCI6Mn0.UoQFcrWwWbm6_KrGGNn6mmJzH27ZPQUMqqbLJpB0IWw',
        });
    myPartyList = jsonDecode(response.body);

    return jsonDecode(response.body);
  }

  var _future;
  @override
  void initState() {
    _future = getMyPartyList();
    setDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
        child: MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            _showDialog(
              CupertinoDatePicker(
                initialDateTime: DateTime(
                  year,
                  month,
                ),
                minimumYear: 2023, maximumYear: 2025,
                mode: CupertinoDatePickerMode.date,
                use24hFormat: true,
                // This is called when the user changes the date.
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    setWeekDay(newDate.year, newDate.month);
                    year = newDate.year;
                    month = newDate.month;
                    selectedYear = newDate.year;
                    selectedMonth = newDate.month;
                    selectedDay = newDate.day;
                  });
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 4.1.h,
                  child: Text('${year} Year', style: textStyle3)),
              SizedBox(
                  height: 3.05.h,
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
      Divider(
        thickness: 1.5,
        height: 0,
        color: Color(0xffCACACA),
      ),
      FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return CupertinoActivityIndicator();
            } else {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: getDateList(0),
                  ),
                  Divider(
                    thickness: 1.5,
                    height: 0,
                    color: Color(0xffCACACA),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: getDateList(1),
                  ),
                  Divider(
                    thickness: 1.5,
                    height: 0,
                    color: Color(0xffCACACA),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: getDateList(2),
                  ),
                  Divider(
                    thickness: 1.5,
                    height: 0,
                    color: Color(0xffCACACA),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: getDateList(3),
                  ),
                  Divider(
                    thickness: 1.5,
                    height: 0,
                    color: Color(0xffCACACA),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: getDateList(4),
                  ),
                  Divider(
                    thickness: 1.5,
                    height: 0,
                    color: Color(0xffCACACA),
                  )
                ],
              );
            }
          }),
    ]);
  }
}


// serializer 수정해서 party만 나오게
// 인수로 년,월 받아서 filte해서(안되면 for문 조건)써서 해당 전, 후 달꺼만 오게