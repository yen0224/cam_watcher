import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final TextEditingController _apiUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('初次設定'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTextField(
              controller: _apiUrlController,
              placeholder: '請輸入 API URL',
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              child: const Text('完成'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                // 保存設定值
                await prefs.setString('apiUrl', _apiUrlController.text);
                await prefs.setBool('isFirstLaunch', false); // 標記為已啟動過
                // 導向主畫面
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (context) => DashboardScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
