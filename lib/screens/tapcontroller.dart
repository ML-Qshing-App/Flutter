import 'package:flutter/material.dart';
import 'package:qrgard/screens/generator/generator_screen.dart';
import 'package:qrgard/screens/scanner/scanner_screen.dart';
import 'package:qrgard/screens/welcome/guide_screen.dart';
import 'package:qrgard/utilities/color/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TapController extends StatefulWidget {
  const TapController({super.key});

  @override
  State<TapController> createState() => _TapControllerState();
}

class _TapControllerState extends State<TapController>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabTitles = ["QR생성", "QR스캔"];
  late String currentTabTitle;

  @override
  void initState() {
    currentTabTitle = tabTitles[0];
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_changeTabTitle);
    super.initState();
  }

  void _changeTabTitle() {
    setState(() {
      currentTabTitle = tabTitles[_tabController.index];
    });
  }

  Future<void> _showGuideScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showGuideScreen', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GuideScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: BACKGROUND_COLOR,
        title: Text(
          currentTabTitle,
          style: const TextStyle(
            color: FIRST_COLOR,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: FIRST_COLOR),
            onPressed: () {
              _showGuideScreen();
            },
          ),
        ],
        centerTitle: true,
        bottom: TabBar(
          overlayColor: const WidgetStatePropertyAll(
            Colors.transparent,
          ),
          controller: _tabController,
          indicatorColor: FIRST_COLOR,
          tabs: const <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.qr_code, color: FIRST_COLOR),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.qr_code_scanner, color: FIRST_COLOR),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          GeneratorScreen(),
          ScannerScreen(),
        ],
      ),
    );
  }
}
