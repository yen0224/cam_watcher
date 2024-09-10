import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const dataTable = '''
    CREATE TABLE data(
      id INTEGER PRIMARY KEY,
      content TEXT
    )
    ''';
    await db.execute(dataTable);
  }

  Future<void> insertData(List<Map<String, dynamic>> data) async {
    final db = await instance.database;
    for (var item in data) {
      await db.insert('data', item,conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // 其他的 CRUD 操作
}
