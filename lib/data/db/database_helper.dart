import 'package:dicoding_restaurant_app/data/model/restaurant_result_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database _database;

  static const String _databaseName = 'restaurant_db';
  static const String _tableName = 'restaurant_favorites';

  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(join(path, '$_databaseName.db'), onCreate: (db, version) async {
      await db.execute('''CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY,
            name TEXT, 
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL,
          ) ''');
    }, version: 1);
    return db;
  }

  Future<void> insertRestaurant(Restaurant restaurant) async {
    final Database db = await database;
    await db.insert(_tableName, restaurant.toJson());
  }

  Future<List<Restaurant>> getRestaurants() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);
    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<void> deleteRestaurant(int id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
