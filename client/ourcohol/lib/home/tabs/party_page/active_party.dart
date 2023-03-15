import 'package:flutter/material.dart';

class ActiveParty extends StatefulWidget {
  const ActiveParty({super.key});

  @override
  State<ActiveParty> createState() => _ActivePartyState();
}

class _ActivePartyState extends State<ActiveParty> {
  var party;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('activeparty'));
  }
}
