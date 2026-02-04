import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pet_app_favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            price REAL,
            image TEXT,
            rating REAL,
            category TEXT,
            subcategory TEXT,
            ingredients TEXT,
            healthBenefits TEXT,
            targetAudience TEXT,
            specialFeatures TEXT,
            usageInstructions TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertFavorite(Product product) async {
    final db = await database;
    final productMap = product.toJson();
    // Remove the reviews list as SQLite doesn't support it in this table
    productMap.remove('reviews');
    
    await db.insert(
      'favorites',
      productMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String productId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<List<Product>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

  Future<bool> isFavorite(String productId) async {
    final db = await database;
    final maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [productId],
    );
    return maps.isNotEmpty;
  }

  Future<void> clearAllFavorites() async {
    final db = await database;
    await db.delete('favorites');
  }
}
