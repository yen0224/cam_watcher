import 'package:flutter/cupertino.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('通知中心'),
      ),
      child: Center(
        child: Text('這是通知中心頁面'),
      ),
    );
  }
}
