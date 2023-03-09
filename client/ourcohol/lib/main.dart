import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:ourcohol/tabs/calendar_page/calendar.dart';
import 'package:ourcohol/tabs/calendar_page/calendar_main.dart';
import 'package:ourcohol/user/login.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(Sizer(builder: (context, orientation, deviceType) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyApp(),
    );
  }));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Login(),
    Calendar(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: _widgetOptions[_selectedIndex])),
      bottomNavigationBar: SizedBox(
        height: 90,
        width: 100.w,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                FlutterRemix.lightbulb_line,
              ),
              label: '팁',
            ),
            BottomNavigationBarItem(
              icon: Icon(FlutterRemix.calendar_check_fill),
              label: '캘린더',
            ),
            BottomNavigationBarItem(
              icon: Icon(FlutterRemix.team_line),
              label: '술자리',
            ),
            BottomNavigationBarItem(
              icon: Icon(FlutterRemix.account_circle_line),
              label: '내정보',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xff131313),
          unselectedItemColor: Color(0xffCACACA),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
