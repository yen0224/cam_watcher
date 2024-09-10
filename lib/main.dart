import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/intro_screen.dart';
import 'screens/dashboard.dart';
import 'services/background_service.dart';

void main() {
  runApp(MyApp());
  BackgroundService.initialize(); // 初始化背景服務
}

class MyApp extends StatelessWidget {
  Future<bool> checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstLaunch') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Dashboard App',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: FutureBuilder<bool>(
        future: checkFirstLaunch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CupertinoActivityIndicator(); // 顯示加載中
          } else if (snapshot.data == true) {
            return IntroScreen(); // 初次啟動顯示引導畫面
          } else {
            return DashboardScreen(); // 已經設定過顯示主畫面
          }
        },
      ),
    );
  }
}
