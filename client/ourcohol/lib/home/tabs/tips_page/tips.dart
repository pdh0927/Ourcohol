import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:ourcohol/home/tabs/tips_page/talk_topics.dart';

import 'hangover.dart';
import 'manners.dart';

class Tips extends StatelessWidget {
  const Tips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> tips = [
      {
        'title': '술자리 예절',
        'description': '술자리에서 지켜야 할 기본적인 예절에 대해 알아봅니다.',
        'icon': Icons.group,
        'color': Colors.blue,
        'page': Manners(),
      },
      {
        'title': '숙취해소 방법',
        'description': '효과적인 숙취해소 방법들을 알아봅니다.',
        'icon': Icons.healing,
        'color': Colors.green,
        'page': Hangover(),
      },
      {
        'title': '술자리 토크 주제',
        'description': '술자리에서 대화가 더욱 흥미롭게 이어지도록 도와줄 토크 주제들을 소개합니다.',
        'icon': Icons.chat,
        'color': Colors.orange,
        'page': TalkTopics(),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text('OURcohol TIPS',
              style: TextStyle(
                  fontSize: 23,
                  color: Color(0xff131313),
                  fontWeight: FontWeight.w700,
                  height: 1.3))),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin:
                const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 8),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              leading: Icon(
                tips[index]['icon'],
                size: 40,
                color: tips[index]['color'],
              ),
              title: Text(tips[index]['title'],
                  style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xff131313),
                      fontWeight: FontWeight.w700,
                      height: 1.3)),
              subtitle: Text(tips[index]['description'],
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff131313),
                      fontWeight: FontWeight.w400,
                      height: 1.3)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => tips[index]['page']),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
