import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:ourcohol/home/tabs/calendar_page/calendar.dart';
import 'package:ourcohol/home/tabs/my_information_page/my_information.dart';
import 'package:ourcohol/home/tabs/party_page/party.dart';
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
    Party(),
    MyInformation(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future(() => false); //뒤로가기 막음
        },
        child: Scaffold(
          body: SafeArea(
              left: false,
              right: false,
              child: Center(child: _widgetOptions[_selectedIndex])),
          bottomNavigationBar: SizedBox(
            height: 11.h,
            width: 100.w,
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(FlutterRemix.lightbulb_line, size: 20),
                  label: '팁',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FlutterRemix.calendar_check_fill, size: 20),
                  label: '캘린더',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FlutterRemix.team_line, size: 20),
                  label: '술자리',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FlutterRemix.account_circle_line, size: 20),
                  label: '내정보',
                )
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xff131313),
              unselectedItemColor: const Color(0xffCACACA),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              onTap: _onItemTapped,
            ),
          ),
        ));
  }
}
