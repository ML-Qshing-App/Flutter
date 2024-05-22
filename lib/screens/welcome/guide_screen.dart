import 'package:flutter/material.dart';
import 'package:qrgard/screens/welcome/welcome_screen.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstGuide(),
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
        onPressed: () {
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
