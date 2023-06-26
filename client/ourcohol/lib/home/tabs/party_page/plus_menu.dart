import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:ourcohol/provider_ourcohol.dart';
import 'package:ourcohol/style.dart';
import 'package:provider/provider.dart';

class PlusMenu extends StatefulWidget {
  PlusMenu({super.key, this.modifyAlcohol});
  var modifyAlcohol;

  @override
  State<PlusMenu> createState() => _PlusMenuState();
}

class _PlusMenuState extends State<PlusMenu> {
  var flag = false;
  var totalAlcohol;

  @override
  void initState() {
    totalAlcohol = (context.read<UserProvider>().type_alcohol == 'soju'
            ? 0.169 * 360
            : 0.045 * 500) *
        context.read<UserProvider>().amount_alcohol;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon:
          flag == false ? AnimatedIcons.add_event : AnimatedIcons.menu_close,
      backgroundColor: const Color(0xff131313),
      overlayColor: Color(0xff131313),
      activeForegroundColor: Colors.grey,
      child: const Icon(FlutterRemix.close_fill),
      childMargin: const EdgeInsets.only(left: 10),
      overlayOpacity: 0.6,
      spacing: 0,
      spaceBetweenChildren: 15,
      closeManually: false,
      onOpen: () {
        setState(() {
          flag = true;
        });
      },
      onClose: (() {
        setState(() {
          flag = false;
        });
      }),
      children: [
        SpeedDialChild(
            child: Image.asset('assets/images/beer.png', fit: BoxFit.fill),
            labelBackgroundColor: Colors.transparent,
            labelShadow: [],
            onTap: () {
              widget.modifyAlcohol('add', 'beer');
              if ((context.read<PartyProvider>().participants[context
                              .read<PartyProvider>()
                              .myPaticipantIndex]['drank_soju'] *
                          0.169 *
                          360 /
                          8 +
                      context.read<PartyProvider>().participants[context
                              .read<PartyProvider>()
                              .myPaticipantIndex]['drank_beer'] *
                          0.045 *
                          500 /
                          3) >
                  totalAlcohol) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('주량 초과 알림'),
                      content: const Text('좀 더 조절해서 마시기 바랍니다.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('승인'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }),
        SpeedDialChild(
            child: Image.asset('assets/images/soju.png', fit: BoxFit.fill),
            labelBackgroundColor: Colors.transparent,
            labelShadow: [],
            onTap: () async {
              widget.modifyAlcohol('add', 'soju');
              if ((context.read<PartyProvider>().participants[context
                              .read<PartyProvider>()
                              .myPaticipantIndex]['drank_soju'] *
                          0.169 *
                          360 /
                          8 +
                      context.read<PartyProvider>().participants[context
                              .read<PartyProvider>()
                              .myPaticipantIndex]['drank_beer'] *
                          0.045 *
                          500 /
                          3) >
                  totalAlcohol) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('주량 초과 알림'),
                      content: const Text('좀 더 조절해서 마시기 바랍니다.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('승인'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }),
      ],
    );
  }
}
