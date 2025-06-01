import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../entity/urun_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY,
        ad TEXT,
        resim TEXT,
        kategori TEXT,
        fiyat INTEGER,
        marka TEXT
      )
    ''');
  }

  Future<void> insertFavorite(Urun urun) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'id': urun.id,
        'ad': urun.ad,
        'resim': urun.resim,
        'kategori': urun.kategori,
        'fiyat': urun.fiyat,
        'marka': urun.marka,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavorite(int id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Urun>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return Urun(
        id: maps[i]['id'],
        ad: maps[i]['ad'],
        resim: maps[i]['resim'],
        kategori: maps[i]['kategori'],
        fiyat: maps[i]['fiyat'],
        marka: maps[i]['marka'],
      );
    });
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}
