import 'dart:collection';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aeroquest/models/recipe_settings.dart';

class RecipeSettingsDatabase {
  static final RecipeSettingsDatabase instance = RecipeSettingsDatabase._init();
  static Database? _database;
  static const recipeSettingsDatabaseFileName = "recipeSettings.db";

  RecipeSettingsDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB(recipeSettingsDatabaseFileName);
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
      CREATE TABLE $tableRecipeSettings (
        ${RecipeSettingsFields.id} $idType,
        ${RecipeSettingsFields.recipeEntryId} $integerType,
        ${RecipeSettingsFields.beanId} $integerType,
        ${RecipeSettingsFields.grindSetting} $realType,
        ${RecipeSettingsFields.coffeeAmount} $realType,
        ${RecipeSettingsFields.waterAmount} $integerType,
        ${RecipeSettingsFields.waterTemp} $realType,
        ${RecipeSettingsFields.brewTime} $integerType,
        ${RecipeSettingsFields.visibility} $textType
      ) 
    ''');
  }

  /// Creates a new recipe settings entry in the database and returns its id
  Future<int> create(RecipeSettings recipeSetting) async {
    final db = await instance.database;

    final id = await db.insert(tableRecipeSettings, recipeSetting.toJson());
    return id;
  }

  /// Returns the recipe associated with [id]
  ///
  /// Throws an exception if [id] does not exist in the database
  Future<RecipeSettings> readRecipeSetting(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableRecipeSettings,
      columns: RecipeSettingsFields.values,
      where:
          "${RecipeSettingsFields.id} = ?", // ? prevents sql injection attacks
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return RecipeSettings.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  /// Returns a list of all recipe settings associated with a single recipe id
  Future<List<RecipeSettings>> readAllRecipeSettingsForRecipe(
      int recipeEntryId) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT * FROM $tableRecipeSettings 
      WHERE $tableRecipeSettings.${RecipeSettingsFields.recipeEntryId} = $recipeEntryId''');

    return result.map((json) => RecipeSettings.fromJson(json)).toList();
  }

  /// Returns all recipe settings in the database
  ///
  /// Recipe settings are mapped by their associated recipe id first,
  /// then their recipe setting id
  Future<Map<int, SplayTreeMap<int, RecipeSettings>>>
      readAllRecipeSettings() async {
    final db = await instance.database;

    final result = await db.query(tableRecipeSettings);

    final recipeSettingsList =
        result.map((json) => RecipeSettings.fromJson(json)).toList();

    final settingsMap = <int, SplayTreeMap<int, RecipeSettings>>{};
    for (var recipeSetting in recipeSettingsList) {
      if (settingsMap.containsKey(recipeSetting.recipeEntryId)) {
        settingsMap[recipeSetting.recipeEntryId]!
            .addAll({recipeSetting.id!: recipeSetting});
      } else {
        settingsMap.addAll(
            {recipeSetting.recipeEntryId: SplayTreeMap<int, RecipeSettings>()});
        settingsMap[recipeSetting.recipeEntryId]!
            .addAll({recipeSetting.id!: recipeSetting});
      }
    }

    return settingsMap;
  }

  /// Updates the recipe setting in the database that matches
  /// the [recipeSetting] id
  Future<int> update(RecipeSettings recipeSetting) async {
    final db = await instance.database;

    return db.update(
      tableRecipeSettings,
      recipeSetting.toJson(),
      where: "${RecipeSettingsFields.id} = ?",
      whereArgs: [recipeSetting.id],
    );
  }

  /// Deletes the recipe setting in the database associated with [id]
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableRecipeSettings,
      where: "${RecipeSettingsFields.id} = ?",
      whereArgs: [id],
    );
  }

  /// Deletes all recipe settings that use a bean with id [beanId]
  Future<int> deleteSettingsOfBeanId(int beanId) async {
    final db = await instance.database;

    return await db.delete(
      tableRecipeSettings,
      where: "${RecipeSettingsFields.beanId} = ?",
      whereArgs: [beanId],
    );
  }

  /// Deletes all recipe settings for a particular recipe
  Future<int> deleteAllSettingsForRecipe(int recipeEntryId) async {
    final db = await instance.database;

    return await db.delete(tableRecipeSettings,
        where: "${RecipeSettingsFields.recipeEntryId} = ?",
        whereArgs: [recipeEntryId]);
  }

  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, recipeSettingsDatabaseFileName);

    deleteDatabase(path);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
