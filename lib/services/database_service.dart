import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';
import '../models/pet_service_model.dart';

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
    String path = join(await getDatabasesPath(), 'pet_app_v2.db');
    return await openDatabase(

      path,
      version: 2,
      onCreate: (db, version) async {
        // Products Favorites Table
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

        // Services Favorites Table
        await _createServicesTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createServicesTable(db);
        }
      },
    );
  }

  Future<void> _createServicesTable(Database db) async {
    await db.execute('''
      CREATE TABLE favorite_services(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        price REAL,
        image TEXT,
        category TEXT,
        temperament TEXT,
        origin TEXT,
        lifeSpan TEXT,
        adaptability INTEGER,
        affectionLevel INTEGER,
        childFriendly INTEGER,
        dogFriendly INTEGER,
        energyLevel INTEGER,
        groomingLevel INTEGER,
        healthIssues INTEGER,
        intelligence INTEGER,
        sheddingLevel INTEGER,
        socialNeeds INTEGER,
        strangerFriendly INTEGER,
        vocalisation INTEGER
      )
    ''');
  }

  // --- PRODUCT FAVORITES ---
  Future<void> insertFavorite(Product product) async {
    final db = await database;
    final productMap = product.toJson();
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

  // --- SERVICE FAVORITES ---
  Future<void> insertServiceFavorite(PetServiceModel service) async {
    final db = await database;
    await db.insert(
      'favorite_services',
      service.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeServiceFavorite(String serviceId) async {
    final db = await database;
    await db.delete(
      'favorite_services',
      where: 'id = ?',
      whereArgs: [serviceId],
    );
  }

  Future<List<PetServiceModel>> getServiceFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorite_services');
    return List.generate(maps.length, (i) {
      return PetServiceModel.fromJson(maps[i]);
    });
  }

  Future<bool> isServiceFavorite(String serviceId) async {
    final db = await database;
    final maps = await db.query(
      'favorite_services',
      where: 'id = ?',
      whereArgs: [serviceId],
    );
    return maps.isNotEmpty;
  }

  Future<void> clearAllFavorites() async {
    final db = await database;
    await db.delete('favorites');
    await db.delete('favorite_services');
  }
}

