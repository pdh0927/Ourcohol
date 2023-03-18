import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:ourcohol/style.dart';

class PopupMenu extends StatefulWidget {
  const PopupMenu({super.key});

  @override
  State<PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        padding: EdgeInsets.only(bottom: 0, top: 15, right: 10, left: 10),
        icon: const Icon(
          FlutterRemix.menu_line,
          color: Color(0xff131313),
        ),
        itemBuilder: (context) => [
              PopupMenuItem(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xff131313)))),
                    child: MaterialButton(
                        minWidth: 80,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Icon(FlutterRemix.user_add_line),
                                Text('인원 추가')
                              ],
                            ),
                          ],
                        )),
                  )),
              PopupMenuItem(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xff131313)))),
                    child: MaterialButton(
                        minWidth: 80,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(FlutterRemix.share_box_line),
                            Text('공유 하기', style: textStyle25)
                          ],
                        )),
                  )),
              PopupMenuItem(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xff131313)))),
                    child: MaterialButton(
                        minWidth: 80,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(FlutterRemix.settings_line),
                            Text('술자리 정보 변경', style: textStyle25)
                          ],
                        )),
                  )),
              PopupMenuItem(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: MaterialButton(
                      minWidth: 80,
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff131313),
                        ),
                        child: Text('술자리 끝내기', style: textStyle26),
                      ))),
            ]);
  }
}
