// lib/core/utils/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../core/constants/app_constant.dart';
import '../models/scan_result_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);
    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.tableScans} (
        id                  TEXT PRIMARY KEY,
        foodLabel           TEXT NOT NULL,
        imagePath           TEXT,
        scannedAt           TEXT NOT NULL,
        freshnessLabel      TEXT DEFAULT 'Fresh',
        freshnessConfidence REAL DEFAULT 1.0,
        isFresh             INTEGER DEFAULT 1,
        foodConfidence      REAL DEFAULT 1.0,
        isFavourite         INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE ${AppConstants.tableScans} ADD COLUMN freshnessLabel TEXT DEFAULT 'Fresh'");
      await db.execute("ALTER TABLE ${AppConstants.tableScans} ADD COLUMN freshnessConfidence REAL DEFAULT 1.0");
      await db.execute("ALTER TABLE ${AppConstants.tableScans} ADD COLUMN isFresh INTEGER DEFAULT 1");
      await db.execute("ALTER TABLE ${AppConstants.tableScans} ADD COLUMN foodConfidence REAL DEFAULT 1.0");
    }
    if (oldVersion < 3) {
      await db.execute("ALTER TABLE ${AppConstants.tableScans} ADD COLUMN isFavourite INTEGER DEFAULT 0");
    }
  }

  Future<void> insertScan(ScanResultModel scan) async {
    final db = await database;
    await db.insert(
      AppConstants.tableScans,
      scan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ScanResultModel>> getAllScans() async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableScans,
      orderBy: 'scannedAt DESC',
    );
    return maps.map((m) => ScanResultModel.fromMap(m)).toList();
  }

  /// Toggle favourite in DB
  Future<void> updateFavourite(String id, bool isFavourite) async {
    final db = await database;
    await db.update(
      AppConstants.tableScans,
      {'isFavourite': isFavourite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get only favourited scans
  Future<List<ScanResultModel>> getFavourites() async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableScans,
      where: 'isFavourite = ?',
      whereArgs: [1],
      orderBy: 'scannedAt DESC',
    );
    return maps.map((m) => ScanResultModel.fromMap(m)).toList();
  }

  Future<void> deleteScan(String id) async {
    final db = await database;
    await db.delete(AppConstants.tableScans,
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllScans() async {
    final db = await database;
    await db.delete(AppConstants.tableScans);
  }
}