import 'package:flutter/material.dart';

class UnactiveParty extends StatefulWidget {
  const UnactiveParty({super.key});

  @override
  State<UnactiveParty> createState() => _UnactivePartyState();
}

class _UnactivePartyState extends State<UnactiveParty> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('unactive party'));
  }
}
