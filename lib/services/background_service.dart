import 'package:workmanager/workmanager.dart';
import 'database_service.dart';

class BackgroundService {
  static const fetchTask = "fetchDataTask";

  static void initialize() {
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      fetchTask,
      fetchTask,
      frequency: const Duration(minutes: 5),
    );
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      // 執行資料抓取邏輯
      try {
        final newData = await fetchDataFromApi(); // 向 API 請求資料
        await DatabaseService.instance.insertData(newData); // 插入資料至 SQLite
        return Future.value(true);
      } catch (e) {
        // 記錄錯誤
        return Future.value(false);
      }
    });
  }

  static Future<List<Map<String, dynamic>>> fetchDataFromApi() async {
    // 模擬 API 請求
    return []; // 返回資料列表
  }
}
