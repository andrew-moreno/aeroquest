import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aeroquest/models/recipe.dart';

class RecipesDatabase {
  static final RecipesDatabase instance = RecipesDatabase._init();
  static Database? _database;

  RecipesDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB("recipes.db");
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
    const nullableTextType = "TEXT";

    await db.execute('''
      CREATE TABLE $tableRecipes (
        ${RecipeFields.id} $idType,
        ${RecipeFields.title} $textType,
        ${RecipeFields.description} $nullableTextType,
        ${RecipeFields.pushPressure} $textType,
        ${RecipeFields.brewMethod} $textType
      )
    ''');
  }

  /// Finds the next highest unused id in the database and returns it
  ///
  /// Does not return unused ids that are in between used ids
  /// eg. if database has 1, 3, 4, will return 5 not 2
  Future<int> getUnusedId() async {
    final db = await instance.database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT MAX($tableRecipes.${RecipeFields.id}) FROM $tableRecipes''');

    return ((result[0]["MAX($tableRecipes.${RecipeFields.id})"] ?? 0) as int) +
        1;
  }

  /// Creates a new recipe entry in the database and returns it
  Future<Recipe> create(Recipe recipe) async {
    final db = await instance.database;

    final id = await db.insert(tableRecipes, recipe.toJson());
    return recipe.copy(id: id);
  }

  /// Returns the recipe associated with [id]
  ///
  /// Throws an exception if [id] does not exist in the database
  Future<Recipe> readRecipe(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableRecipes,
      columns: RecipeFields.values,
      where: "${RecipeFields.id} = ?", // ? prevents sql injection attacks
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Recipe.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  /// Returns all recipes in the database
  Future<List<Recipe>> readAllRecipes() async {
    final db = await instance.database;

    final result = await db.query(tableRecipes);

    return result.map((json) => Recipe.fromJson(json)).toList();
  }

  /// Updates the recipe in the database that matches the [recipe] id
  Future<int> update(Recipe recipe) async {
    final db = await instance.database;

    return db.update(
      tableRecipes,
      recipe.toJson(),
      where: "${RecipeFields.id} = ?",
      whereArgs: [recipe.id],
    );
  }

  /// Deletes the recipe in the database associated with [id]
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableRecipes,
      where: "${RecipeFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "recipes.db");

    deleteDatabase(path);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
