import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/prediction_record.dart';

class DatabaseHelper {
  static const _databaseName = "DiabeticPrediction.db";
  static const _databaseVersion = 1;
  static const table = 'predictions';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagePath TEXT NOT NULL,
            resultLabel TEXT NOT NULL,
            confidence REAL NOT NULL,
            timestamp TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(PredictionRecord record) async {
    Database db = await instance.database;
    return await db.insert(table, record.toMap());
  }

  Future<List<PredictionRecord>> getAllRecords() async {
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "id DESC");
    List<PredictionRecord> list =
        res.isNotEmpty ? res.map((c) => PredictionRecord.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
