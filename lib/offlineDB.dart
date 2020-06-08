import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class OfflineDB {
  static final _databaseName = "OfflineDB.db";
  static final _databaseVersion = 1;
  static final table = 'offline';
  static final id = 'id';
  static final dataid = 'dataid';
  static final firstname = 'firstname';
  static final lastname = 'lastname';
  static final email = 'email';
  static final gender = 'gender';
  static final dob = 'dob';
  static final phone = 'phone';
  static final favorite = 'favorite';

  OfflineDB._privateConstructor();
  static final OfflineDB instance = OfflineDB._privateConstructor();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $id INTEGER PRIMARY KEY,
            $dataid TEXT,
            $firstname TEXT,
            $lastname TEXT,
            $email TEXT,
            $gender TEXT,
            $dob TEXT,
            $phone TEXT,
            $favorite TEXT
          )
          ''');
  }
}
