import 'package:elderlycompanion/widgets/app_default.dart';
import 'package:flutter/material.dart';

class LinkElder extends StatefulWidget {
  @override
  _LinkElderState createState() => _LinkElderState();
}

class _LinkElderState extends State<LinkElder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElderlyAppBar(),
      drawer: AppDrawer(),
      body: Container(),
    );
  }
}
