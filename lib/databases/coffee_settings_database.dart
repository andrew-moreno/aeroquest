import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aeroquest/models/coffee_settings.dart';

class CoffeeSettingsDatabase {
  static final CoffeeSettingsDatabase instance = CoffeeSettingsDatabase._init();
  static Database? _database;

  CoffeeSettingsDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB("coffeeSettings.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const integerType = "INTEGER NOT NULL";
    const realType = "REAL NOT NULL";

    await db.execute('''
      CREATE TABLE $tableCoffeeSettings (
        ${CoffeeSettingsFields.id} $idType,
        ${CoffeeSettingsFields.recipeEntryId} $integerType,
        ${CoffeeSettingsFields.beanId} $integerType,
        ${CoffeeSettingsFields.grindSetting} $realType,
        ${CoffeeSettingsFields.coffeeAmount} $realType,
        ${CoffeeSettingsFields.waterAmount} $integerType,
        ${CoffeeSettingsFields.waterTemp} $integerType,
        ${CoffeeSettingsFields.brewTime} $integerType,
        ${CoffeeSettingsFields.visibility} $textType
      ) 
    ''');
  }

  Future<CoffeeSettings> create(CoffeeSettings coffeeSetting) async {
    final db = await instance.database;

    final id = await db.insert(tableCoffeeSettings, coffeeSetting.toJson());
    return coffeeSetting.copy(id: id);
  }

  Future<CoffeeSettings> readCoffeeSetting(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCoffeeSettings,
      columns: CoffeeSettingsFields.values,
      where:
          "${CoffeeSettingsFields.id} = ?", // ? prevents sql injection attacks
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CoffeeSettings.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  Future<List<CoffeeSettings>> readAllCoffeeSettingsForRecipe(
      int recipeEntryId) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT * FROM $tableCoffeeSettings 
      WHERE $tableCoffeeSettings.${CoffeeSettingsFields.recipeEntryId} = $recipeEntryId''');

    return result.map((json) => CoffeeSettings.fromJson(json)).toList();
  }

  Future<int> update(CoffeeSettings coffeeSetting) async {
    final db = await instance.database;

    return db.update(
      tableCoffeeSettings,
      coffeeSetting.toJson(),
      where: "${CoffeeSettingsFields.id} = ?",
      whereArgs: [coffeeSetting.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCoffeeSettings,
      where: "${CoffeeSettingsFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteAllSettingsForRecipe(int recipeEntryId) async {
    final db = await instance.database;

    return await db.delete(tableCoffeeSettings,
        where: "${CoffeeSettingsFields.recipeEntryId} = ?",
        whereArgs: [recipeEntryId]);
  }

  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "coffeeSettings.db");

    deleteDatabase(path);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
