import 'package:elderlycompanion/widgets/app_default.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: ElderlyAppBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[Text('Hello')],
        ),
      ),
    );
  }
}
