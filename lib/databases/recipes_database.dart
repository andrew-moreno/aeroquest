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

  Future<Recipe> create(Recipe recipe) async {
    final db = await instance.database;

    final id = await db.insert(tableRecipes, recipe.toJson());
    return recipe.copy(id: id);
  }

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

  Future<List<Recipe>> readAllRecipes() async {
    final db = await instance.database;

    final result = await db.query(tableRecipes);

    return result.map((json) => Recipe.fromJson(json)).toList();
  }

  Future<int> update(Recipe recipe) async {
    final db = await instance.database;

    return db.update(
      tableRecipes,
      recipe.toJson(),
      where: "${RecipeFields.id} = ?",
      whereArgs: [recipe.id],
    );
  }

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
