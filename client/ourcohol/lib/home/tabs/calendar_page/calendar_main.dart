import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'calendar.dart';

class CalendarMain extends StatelessWidget {
  const CalendarMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w - 32,
      child: Container(
        child: Column(children: [
          Calendar(),
        ]),
      ),
    );
  }
}
