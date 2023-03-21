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
            child: Text('맥주'),
            label: '맥주 한잔',
            labelStyle: textStyle14,
            labelBackgroundColor: Colors.transparent,
            labelShadow: [],
            onTap: () {
              widget.modifyAlcohol('add', 'beer');
            }),
        SpeedDialChild(
            child: Text('소주'),
            label: '소주 한잔',
            labelStyle: textStyle14,
            labelBackgroundColor: Colors.transparent,
            labelShadow: [],
            onTap: () async {
              widget.modifyAlcohol('add', 'soju');
            }),
      ],
    );
  }
}