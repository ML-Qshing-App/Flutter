import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrgard/utilities/color/colors.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _qrGenerated = false;
  bool _isValidAddress = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: _qrGenerated,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: QrImageView(
                      data: _textEditingController.text,
                      version: QrVersions.auto,
                      size: 300,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _textEditingController,
                    cursorColor: FIRST_COLOR,
                    decoration: const InputDecoration(
                      labelText: 'QR코드 주소를 입력하세요.',
                      labelStyle: TextStyle(color: FIRST_COLOR),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FIRST_COLOR), // 밑줄 색상 변경
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: FIRST_COLOR), // focus되었을 때의 밑줄 색상 변경
                      ),
                    ),
                    style: const TextStyle(color: FIRST_COLOR),
                  ),
                ),
                if (!_isValidAddress)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '주소가 유효하지 않습니다.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    // 주소가 유효한지 확인
                    if (_textEditingController.text.isNotEmpty &&
                        _isValidUrl(_textEditingController.text)) {
                      setState(() {
                        _qrGenerated = true;
                        _isValidAddress = true;
                      });
                    } else {
                      setState(() {
                        _isValidAddress = false;
                        if (_qrGenerated) {
                          _qrGenerated = false;
                        }
                      });
                    }
                    FocusScope.of(context).unfocus();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width - 40, 50),
                    backgroundColor: FIRST_COLOR,
                  ),
                  child: const Text(
                    'QR생성하기',
                    style: TextStyle(
                      color: BACKGROUND_COLOR,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidUrl(String url) {
    // 정규식
    RegExp urlRegExp = RegExp(
      r'^(https?:\/\/)?'
      r'([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}'
      r'(:\d+)?(\/[^\s]*)?$',
    );

    return urlRegExp.hasMatch(url);
  }

  @override
  void dispose() {
    // 페이지가 dispose 될 때 컨트롤러를 정리
    _textEditingController.dispose();
    super.dispose();
  }
}
