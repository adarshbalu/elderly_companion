import 'package:elderlycompanion/screens/home/home_screen.dart';
import 'package:elderlycompanion/screens/loading/loading_screen.dart';
import 'package:elderlycompanion/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elderly Companion',
      theme: ThemeData(
          fontFamily: GoogleFonts.lato().fontFamily,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme:
              TextTheme().apply(fontFamily: GoogleFonts.lato().fontFamily)),
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(
        auth: Auth(),
      ),
    );
  }
}
