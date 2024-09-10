import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const _apiUrlKey = 'api_url';

  static Future<void> setApiUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiUrlKey, url);
  }

  static Future<String?> getApiUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiUrlKey);
  }
}
