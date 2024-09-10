import 'package:flutter/cupertino.dart';
import 'notification.dart';
import 'home.dart';
import 'details.dart';
import 'settings.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    DetailsPage(),
    SettingsPage(),
  ];

  final List<String> _titles = [
    '主畫面',
    '詳細資訊',
    '設定頁面',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToNotificationCenter() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => NotificationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_titles[_selectedIndex]),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.bell),
          onPressed: _goToNotificationCenter,
        ),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: '主畫面',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.info),
              label: '詳細資訊',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: '設定',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        tabBuilder: (context, index) {
          return _pages[index];
        },
      ),
    );
  }
}
