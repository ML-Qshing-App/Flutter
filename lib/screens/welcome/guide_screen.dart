import 'package:flutter/material.dart';
import 'package:qrgard/screens/welcome/welcome_screen.dart';
import 'package:qrgard/utilities/color/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  bool _showGuideScreen = true;

  @override
  void initState() {
    super.initState();
    _checkGuideStatus();
  }

  Future<void> _checkGuideStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showGuideScreen = prefs.getBool('showGuideScreen') ?? true;
    setState(() {
      _showGuideScreen = showGuideScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: BACKGROUND_COLOR,
      ),
      debugShowCheckedModeBanner: false,
      home: _showGuideScreen ? const FirstGuide() : const WelcomeScreen(),
    );
  }
}

class FirstGuide extends StatelessWidget {
  const FirstGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('가이드1'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('showGuideScreen', false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SecondGuide()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SecondGuide extends StatelessWidget {
  const SecondGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('가이드2'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
