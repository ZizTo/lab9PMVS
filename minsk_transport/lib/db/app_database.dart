import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> database() async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), 'minsk_transport.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            routeId INTEGER PRIMARY KEY
          )
        ''');

        await db.execute('''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            routeId INTEGER NOT NULL,
            openedAt TEXT NOT NULL
          )
        ''');
      },
    );

    return _db!;
  }
}