import 'dart:collection';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aeroquest/models/recipe_step.dart';

class RecipeStepsDatabase {
  static final RecipeStepsDatabase instance = RecipeStepsDatabase._init();
  static Database? _database;

  RecipeStepsDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB("recipeSteps.db");
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

    await db.execute('''
      CREATE TABLE $tableRecipeSteps (
        ${RecipeStepFields.id} $idType,
        ${RecipeStepFields.recipeEntryId} $integerType,
        ${RecipeStepFields.time} $integerType,
        ${RecipeStepFields.text} $textType
      ) 
    ''');
  }

  /// Creates a new recipe step entry in the database and returns its id
  Future<int> create(RecipeStep recipeStep) async {
    final db = await instance.database;

    final id = await db.insert(tableRecipeSteps, recipeStep.toJson());
    return id;
  }

  /// Returns all recipe steps in the database
  ///
  /// RecipeSteps are mapped by their associated recipe id first,
  /// then their recipe step id
  Future<Map<int, SplayTreeMap<int, RecipeStep>>> readAllRecipeSteps() async {
    final db = await instance.database;

    final result = await db.query(tableRecipeSteps);

    final recipeStepsList =
        result.map((json) => RecipeStep.fromJson(json)).toList();
    final recipeStepsMap = <int, SplayTreeMap<int, RecipeStep>>{};
    for (var recipeStep in recipeStepsList) {
      if (recipeStepsMap.containsKey(recipeStep.recipeEntryId)) {
        recipeStepsMap[recipeStep.recipeEntryId]!
            .addAll({recipeStep.id!: recipeStep});
      } else {
        recipeStepsMap.addAll(
            {recipeStep.recipeEntryId: SplayTreeMap<int, RecipeStep>()});
        recipeStepsMap[recipeStep.recipeEntryId]!
            .addAll({recipeStep.id!: recipeStep});
      }
    }

    return recipeStepsMap;
  }

  /// Updates the recipe step in the database that matches the [recipeStep] id
  Future<int> update(RecipeStep recipeStep) async {
    final db = await instance.database;

    return db.update(
      tableRecipeSteps,
      recipeStep.toJson(),
      where: "${RecipeStepFields.id} = ?",
      whereArgs: [recipeStep.id],
    );
  }

  /// Deletes the recipe step in the database associated with [id]
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableRecipeSteps,
      where: "${RecipeStepFields.id} = ?",
      whereArgs: [id],
    );
  }

  /// Deletes all recipe steps for a particular recipe
  Future<int> deleteAllRecipeStepsForRecipe(int recipeEntryId) async {
    final db = await instance.database;

    return await db.delete(tableRecipeSteps,
        where: "${RecipeStepFields.recipeEntryId} = ?",
        whereArgs: [recipeEntryId]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
