import 'dart:collection';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aeroquest/models/recipe_variables.dart';

class RecipeVariablesDatabase {
  static final RecipeVariablesDatabase instance =
      RecipeVariablesDatabase._init();
  static Database? _database;
  static const recipeVariablesDatabaseFileName = "recipeVariables.db";

  RecipeVariablesDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB(recipeVariablesDatabaseFileName);
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
      CREATE TABLE $tableRecipeVariables (
        ${RecipeVariablesFields.id} $idType,
        ${RecipeVariablesFields.recipeEntryId} $integerType,
        ${RecipeVariablesFields.beanId} $integerType,
        ${RecipeVariablesFields.grindSetting} $realType,
        ${RecipeVariablesFields.coffeeAmount} $realType,
        ${RecipeVariablesFields.waterAmount} $realType,
        ${RecipeVariablesFields.waterTemp} $realType,
        ${RecipeVariablesFields.brewTime} $integerType,
        ${RecipeVariablesFields.visibility} $textType
      ) 
    ''');
  }

  /// Creates a new recipe variables entry in the database and returns its id
  Future<int> create(RecipeVariables recipeVariable) async {
    final db = await instance.database;

    final id = await db.insert(tableRecipeVariables, recipeVariable.toJson());
    return id;
  }

  /// Returns the recipe variables associated with [id]
  ///
  /// Throws an exception if [id] does not exist in the database
  Future<RecipeVariables> readRecipeVariables(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableRecipeVariables,
      columns: RecipeVariablesFields.values,
      where:
          "${RecipeVariablesFields.id} = ?", // ? prevents sql injection attacks
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return RecipeVariables.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  /// Returns a list of all recipe variables associated with a single recipe id
  Future<List<RecipeVariables>> readAllRecipeVariablesForRecipe(
      int recipeEntryId) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT * FROM $tableRecipeVariables 
      WHERE $tableRecipeVariables.${RecipeVariablesFields.recipeEntryId} = $recipeEntryId''');

    return result.map((json) => RecipeVariables.fromJson(json)).toList();
  }

  /// Returns all recipe variables in the database
  ///
  /// Recipe variables are mapped by their associated recipe id first,
  /// then their recipe variable id
  Future<Map<int, SplayTreeMap<int, RecipeVariables>>>
      readAllRecipeVariables() async {
    final db = await instance.database;

    final result = await db.query(tableRecipeVariables);

    final recipeVariablesList =
        result.map((json) => RecipeVariables.fromJson(json)).toList();

    final variablesMap = <int, SplayTreeMap<int, RecipeVariables>>{};
    for (var recipeVariables in recipeVariablesList) {
      if (variablesMap.containsKey(recipeVariables.recipeEntryId)) {
        variablesMap[recipeVariables.recipeEntryId]!
            .addAll({recipeVariables.id!: recipeVariables});
      } else {
        variablesMap.addAll({
          recipeVariables.recipeEntryId: SplayTreeMap<int, RecipeVariables>()
        });
        variablesMap[recipeVariables.recipeEntryId]!
            .addAll({recipeVariables.id!: recipeVariables});
      }
    }

    return variablesMap;
  }

  /// Updates the recipe variable in the database that matches
  /// the [recipeVariable] id
  Future<int> update(RecipeVariables recipeVariables) async {
    final db = await instance.database;

    return db.update(
      tableRecipeVariables,
      recipeVariables.toJson(),
      where: "${RecipeVariablesFields.id} = ?",
      whereArgs: [recipeVariables.id],
    );
  }

  /// Deletes the recipe variable in the database associated with [id]
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableRecipeVariables,
      where: "${RecipeVariablesFields.id} = ?",
      whereArgs: [id],
    );
  }

  /// Deletes all recipe variables that use a bean with id [beanId]
  Future<int> deleteVariablesOfBeanId(int beanId) async {
    final db = await instance.database;

    return await db.delete(
      tableRecipeVariables,
      where: "${RecipeVariablesFields.beanId} = ?",
      whereArgs: [beanId],
    );
  }

  /// Deletes all recipe variables for a particular recipe
  Future<int> deleteAllVariablesForRecipe(int recipeEntryId) async {
    final db = await instance.database;

    return await db.delete(tableRecipeVariables,
        where: "${RecipeVariablesFields.recipeEntryId} = ?",
        whereArgs: [recipeEntryId]);
  }

  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, recipeVariablesDatabaseFileName);

    deleteDatabase(path);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
