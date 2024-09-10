import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_screen.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SettingsPageContent(),
    );
  }
}

class SettingsPageContent extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPageContent> {
  String _api = "";
  int _notificationLevel = 0;
  bool _systemNotification = false;
  String _syncMode = '手動同步';
  String _syncFrequency = '每天一次';
  bool _isSyncFrequencyEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _api = prefs.getString('apiUrl') ?? '';
      _notificationLevel = prefs.getInt('notificationLevel') ?? 0;
      _systemNotification = prefs.getBool('systemNotification') ?? false;
      _syncMode = prefs.getString('syncMode') ?? '手動同步';
      _syncFrequency = prefs.getString('syncFrequency') ?? '每天一次';
      _isSyncFrequencyEnabled = _syncMode == '自動同步(建議選項)';
    });
  }

  void _saveSettings(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  Future<void> _resetSettings(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 刪除所有儲存的設定資料
    // 導向至初次設定頁面
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => IntroScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: Column(
          children: [
            CupertinoListSection.insetGrouped(
              header: const Text('通知設定'),
              children: [
                // 通知權限
                CupertinoListTile(
                  title: const Text('系統通知'),
                  trailing: CupertinoSwitch(
                    value: _systemNotification, // 是否已經開啟通知權限
                    onChanged: (bool value) {
                      setState(() {
                        _systemNotification = value;
                        _saveSettings('systemNotification', value);
                      });
                    },
                  ),
                ),
                // 通知等級 multiple choice
                CupertinoListTile(
                  title: const Text('通知等級'),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    // 顯示當前通知等級
                    child: Text(
                      _notificationLevel == 0
                          ? '嚴重事件'
                          : _notificationLevel == 1
                              ? '警告事件'
                              : '全部事件',
                    ),
                    onPressed: () {
                      // 彈出對話框選擇通知等級
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoActionSheet(
                            title: const Text('請選擇通知推播'),
                            message: const Text('此處將設定推播的最低等級'),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                child: const Text('嚴重事件'),
                                onPressed: () {
                                  setState(() {
                                    _notificationLevel = 0;
                                    _saveSettings('notificationLevel', 0);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text('警告事件'),
                                onPressed: () {
                                  setState(() {
                                    _notificationLevel = 1;
                                    _saveSettings('notificationLevel', 1);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text('全部事件'),
                                onPressed: () {
                                  setState(() {
                                    _notificationLevel = 2;
                                    _saveSettings('notificationLevel', 2);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text('取消'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text("同步設定"),
              children: [
                // 同步機制選擇
                CupertinoListTile(
                  title: const Text('同步機制'),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(_syncMode),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoActionSheet(
                            title: const Text('設定同步機制'),
                            message: const Text('建議設為自動同步, 以確保資料為最新'),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                child: const Text('手動同步'),
                                onPressed: () {
                                  setState(() {
                                    _syncMode = '手動同步';
                                    _isSyncFrequencyEnabled = false;
                                    _saveSettings('syncMode', _syncMode);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text('自動同步(建議選項)'),
                                onPressed: () {
                                  setState(() {
                                    _syncMode = '自動同步(建議選項)';
                                    _isSyncFrequencyEnabled = true;
                                    _saveSettings('syncMode', _syncMode);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text('取消'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                // 同步頻率選擇
                CupertinoListTile(
                  title: const Text('同步頻率'),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(_syncFrequency),
                    onPressed: _isSyncFrequencyEnabled
                        ? () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoActionSheet(
                                  title: const Text('設定同步頻率'),
                                  message: const Text('選擇自動同步的頻率'),
                                  actions: <Widget>[
                                    CupertinoActionSheetAction(
                                      child: const Text('每天一次'),
                                      onPressed: () {
                                        setState(() {
                                          _syncFrequency = '每天一次';
                                          _saveSettings(
                                              'syncFrequency', _syncFrequency);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: const Text('每小時一次'),
                                      onPressed: () {
                                        setState(() {
                                          _syncFrequency = '每小時一次';
                                          _saveSettings(
                                              'syncFrequency', _syncFrequency);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: const Text('每15分鐘一次'),
                                      onPressed: () {
                                        setState(() {
                                          _syncFrequency = '每15分鐘一次';
                                          _saveSettings(
                                              'syncFrequency', _syncFrequency);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: const Text('取消'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        : null, // 禁用按鈕
                  ),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('危險區'),
              children: [
                CupertinoListTile(
                  title: const Text('API URL'),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('編輯'),
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController apiController =
                              TextEditingController();
                          return CupertinoAlertDialog(
                            title: const Text('編輯 API URL'),
                            content: CupertinoTextField(
                              controller: apiController,
                              placeholder: _api,
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: const Text('取消'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoDialogAction(
                                child: const Text('確定'),
                                onPressed: () async {
                                  setState(() {
                                    _api = apiController.text;
                                    _saveSettings('apiUrl', _api);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                CupertinoListTile(
                  title: const Text('還原預設值',
                      style: TextStyle(color: CupertinoColors.destructiveRed)),
                  onTap: () => _resetSettings(context),
                ),
                CupertinoListTile(
                  title: const Text('重設資料庫',
                      style: TextStyle(color: CupertinoColors.destructiveRed)),
                  onTap: () => _resetSettings(context),
                ),
                CupertinoListTile(
                  title: const Text('重置設定',
                      style: TextStyle(color: CupertinoColors.destructiveRed)),
                  onTap: () => _resetSettings(context),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
