import 'package:flutter/material.dart';
import 'package:ourcohol/home/tabs/tips_page/manners_detail.dart';
import 'package:sizer/sizer.dart';

class Manners extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('OURcohol Tips',
              style: TextStyle(
                  fontSize: 23,
                  color: Color(0xff131313),
                  fontWeight: FontWeight.w700,
                  height: 1.3)),
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Color(0xff131313))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              '술자리 예절',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            height: (100.w - 32) / 7 * 4,
            width: 100.w - 32,
            margin: const EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/manner_third.png'), // 로컬 이미지를 사용하는 경우
                  fit: BoxFit.fill),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 1,
              side: const BorderSide(color: Colors.black, width: 1),
              padding: const EdgeInsets.all(16),
            ),
            child: const Text(
              '술을 따를 때',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          title: '술을 따를 때',
                          image: 'assets/images/manner_first.png',
                          contents: const [
                            '병뚜껑을 딸때는 살짝 흔들고 과하게 흔들지 않는다.',
                            '라벨을 손으로 가린다.',
                            '테이프가 없는 병 부분을 상대가 보이게 끔 한다.',
                            '오른손으로 술병을 잡고 왼손으로 자연스럽게 오른손목을 받쳐준다.',
                            '멀리있는 사람에게 따를 때는 팔꿈치를 받친다.',
                            '팔꿈치로 받쳐도 멀리있다면 일어나서 따른다',
                            '따르는 순서는 직급(나이)가 높은 순으로 따른다',
                          ],
                        )),
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 1,
              side: const BorderSide(color: Colors.black, width: 1),
              padding: const EdgeInsets.all(16),
            ),
            child: const Text(
              '술을 받을 때',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          title: '술을 받을 때',
                          image: 'assets/images/manner_third.png',
                          contents: const [
                            '오른손으로 술잔을 잡고 왼손으로 잔 아래를 받친다.',
                            '술을 받을 때 멀다면 왼손으로 오른손 팔꿈치를 받쳐준다',
                            '그 보다 멀다면 살짝 일어나서 받는다.',
                          ],
                        )),
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 1,
              side: const BorderSide(color: Colors.black, width: 1),
              padding: const EdgeInsets.all(16),
            ),
            child: const Text(
              '술잔을 칠 때',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          title: '술잔을 칠 때',
                          image: 'assets/images/manner_second.png',
                          contents: const [
                            '잔을 칠 때 내 잔이 상급자(연장자)의 잔 보다 아래에 맞춘다.',
                            '고개를 돌려서 마실 때 방향은 연장자를 기준으로 한다',
                            '연장자가 오른쪽에 있다면 왼쪽으로 돌려 마신다',
                            '오른쪽과 왼쪽에 모두 연장자가 있다면 더 연장자 반대방향으로 빠르게 마시고 잔을 내려놓는다.',
                            '술을 마시지 않더라도 짠을 했다면 입술에 술잔을 맞추는 정도만 한다.',
                          ],
                        )),
              );
            },
          ),
        ]),
      ),
    );
  }
}
