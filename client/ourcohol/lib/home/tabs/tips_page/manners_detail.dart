import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final List<String> contents;
  final String image;

  DetailPage(
      {required this.title, required this.image, required this.contents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "술자리 예절",
            style: TextStyle(
                fontSize: 23,
                color: Color(0xff131313),
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Color(0xff131313))),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Title 부분
          Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // 이미지 공간
          Container(
            height: (100.w - 32) / 7 * 4,
            width: 100.w - 32,
            margin: const EdgeInsets.only(top: 10, bottom: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  image: AssetImage(image), // 로컬 이미지를 사용하는 경우
                  fit: BoxFit.fill),
            ),
          ),
          // Contents 부분
          ...contents.map((content) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 아이콘 추가
                  const Icon(
                    Icons.check, // 아이콘 선택, 예시로 check_circle 아이콘 사용
                    color: Colors.green, // 아이콘 색상
                    size: 20, // 아이콘 크기
                  ),
                  const SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격을 추가
                  Expanded(
                    child: Text(
                      content,
                      style: const TextStyle(
                        fontSize: 19,
                        color: Color(0xff131313),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
