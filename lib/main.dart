import 'package:flutter/material.dart';
import 'package:qrgard/screens/splash_screen.dart';
import 'package:qrgard/utilities/color/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
        scaffoldBackgroundColor: BACKGROUND_COLOR,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
