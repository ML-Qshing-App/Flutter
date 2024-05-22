import 'package:flutter/material.dart';
import 'package:qrgard/screens/tapcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showWelcomeScreen = true;

  @override
  void initState() {
    super.initState();
    _checkWelcomeStatus();
  }

  Future<void> _checkWelcomeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showWelcomeScreen = prefs.getBool('showWelcomeScreen') ?? true;
    setState(() {
      _showWelcomeScreen = showWelcomeScreen;
    });
  }

  Future<void> _closeWelcomeScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showWelcomeScreen', false);
    setState(() {
      _showWelcomeScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showWelcomeScreen
          ? SafeArea(
              child: Scaffold(
                body: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 60, 10, 10),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          '사용가이드',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _closeWelcomeScreen();
                  },
                  child: const Icon(Icons.arrow_forward_outlined),
                ),
              ),
            )
          : const TapController(),
    );
  }
}
