import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/movie_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDB();
    return _database;
  }

  final String _tableMovie = 'movie';

  Future<Database> _initializeDB() async {
    var db = openDatabase(
      join(
        await getDatabasesPath(),
        'di_tonton.db',
      ),
      onCreate: _onCreate,
      version: 1,
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tableMovie (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertWatchlist(MovieTable movie) async {
    final db = await database;

    print("sukses insert ${db.database}");
    print(movie.toMap());
    return await db.insert(_tableMovie, movie.toMap());
  }

  Future<int> removeWatchlist(MovieTable movie) async {
    final db = await database;
    return await db.delete(
      _tableMovie,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<MovieTable> getMovieById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      _tableMovie,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.map((e) => MovieTable.fromMap(e)).first;
  }

  Future<List<MovieTable>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(_tableMovie);

    return results.map((e) => MovieTable.fromMap(e)).toList();
  }
}
