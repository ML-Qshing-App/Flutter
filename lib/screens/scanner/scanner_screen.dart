import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrgard/utilities/color/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isDialogOpen = false;
  bool _canScan = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: FIRST_COLOR,
                borderLength: 30,
                borderWidth: 10,
                borderRadius: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          const Expanded(
            flex: 4,
            child: Center(
              child: Text(
                'QR코드를 화면에 중앙에 맞춰주세요.',
                style: TextStyle(
                  color: FIRST_COLOR,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
      _controller.scannedDataStream.listen((scanData) {
        if (!_isDialogOpen && _canScan) {
          fetchDataFromServer(scanData.code!);
        }
      });
    });
  }

  void fetchDataFromServer(String qrData) async {
    _canScan = false;
    var url = Uri.parse('http://kairoshk.ddns.net:8080/url_ai/?data=$qrData');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print(response.body);
      if (responseData['result'] == 1) {
        _showDialog(qrData);
      } else if (responseData['result'] == 0) {
        _QshingDialog(qrData);
      }
    } else {
      _errorDialog();
    }
  }

  // error 팝업창
  void _errorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '오류',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 큐싱 팝업창
  void _QshingDialog(String data) {
    _isDialogOpen = true;
    bool isValidUrl = RegExp(
      r'^(https?:\/\/)?'
      r'([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}'
      r'(:\d+)?(\/[^\s]*)?$',
    ).hasMatch(data);

    String dialogContent = isValidUrl ? '$data' : '올바른 주소가 아닙니다';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '스캔 결과',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '악성 QR코드 주의!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(dialogContent),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _isDialogOpen = false;
                        _canScan = true;
                      },
                      child: const Text(
                        '닫기',
                        style: TextStyle(
                          color: FIRST_COLOR,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _isDialogOpen = false;
                      _canScan = true;
                      _launchURL(data);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                    ),
                    child: const Text(
                      '무시하고 열기',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // 일반 팝업창
  void _showDialog(String data) {
    _isDialogOpen = true;
    bool isValidUrl = RegExp(
      // 정규식
      r'^(https?:\/\/)?'
      r'([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}'
      r'(:\d+)?(\/[^\s]*)?$',
    ).hasMatch(data);

    String dialogContent = isValidUrl ? '$data' : '올바른 주소가 아닙니다';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '스캔 결과',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '안전한 QR코드입니다!',
                  style: TextStyle(
                    color: FIRST_COLOR,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(dialogContent),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _isDialogOpen = false;
                      _canScan = true;
                      _launchURL(data);
                    },
                    child: const Text(
                      '열기',
                      style: TextStyle(
                        color: FIRST_COLOR,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _isDialogOpen = false;
                    _canScan = true;
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                  ),
                  child: const Text(
                    '닫기',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
