import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:ourcohol/provider_ourcohol.dart';
import 'package:ourcohol/style.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PartyInformation extends StatelessWidget {
  const PartyInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
              '당신은 ' +
                  (context.read<PartyProvider>().participants[context
                              .read<PartyProvider>()
                              .myPaticipantIndex] ==
                          true
                      ? '호스트'
                      : '참가자'),
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "GowunBatang",
                  color: Color(0xff131313),
                  fontWeight: FontWeight.w700,
                  height: 1.3)),
          centerTitle: true,
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
          ],
        ),
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Container(
                width: 100.w - 40,
                height: (100.w - 40) * 1.2,
                margin: const EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    color: const Color(0xffE0E0E0),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('출입증',
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "GowunBatang",
                            color: Color(0xff131313),
                            fontWeight: FontWeight.w700,
                            height: 1.3)),
                    Container(
                      width: (100.w - 50) / 7,
                      height: (100.w - 50) / 7,

                      decoration: BoxDecoration(
                        color: Color(colorList[
                            context.read<PartyProvider>().participants[context
                                    .read<PartyProvider>()
                                    .myPaticipantIndex]['id'] %
                                7]),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(FlutterRemix.user_2_fill,
                          color: Colors.white, size: 40), // 교체 해야함
                    ),
                  ],
                ),
              )
            ])));
  }
}
