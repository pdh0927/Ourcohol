import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:ourcohol/home/tabs/calendar_page/calendar.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Tips'),
    Calendar(),
    Text('Index 2: Party'),
    Text('Index 3: My'),
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
        height: 9.7.h,
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
