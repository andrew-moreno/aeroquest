import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aeroquest/models/recipe_note.dart';

class RecipeNotesDatabase {
  static final RecipeNotesDatabase instance = RecipeNotesDatabase._init();
  static Database? _database;

  RecipeNotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB("recipeNotes.db");
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
      CREATE TABLE $tableRecipeNotes (
        ${RecipeNoteFields.id} $idType,
        ${RecipeNoteFields.recipeEntryId} $integerType,
        ${RecipeNoteFields.text} $textType
      ) 
    ''');
  }

  /// Creates a new recipe note entry in the database and returns its id
  Future<int> create(RecipeNote recipeNote) async {
    final db = await instance.database;

    final id = await db.insert(tableRecipeNotes, recipeNote.toJson());
    return id;
  }

  /// Returns all recipe notes in the database
  ///
  /// RecipeNotes are grouped by their associated recipe id
  Future<Map<int, List<RecipeNote>>> readAllRecipeNotes() async {
    final db = await instance.database;

    final result = await db.query(tableRecipeNotes);

    final recipeNotesList =
        result.map((json) => RecipeNote.fromJson(json)).toList();
    final recipeNotesMap = <int, List<RecipeNote>>{};
    for (var recipeNote in recipeNotesList) {
      if (recipeNotesMap.containsKey(recipeNote.recipeEntryId)) {
        recipeNotesMap[recipeNote.recipeEntryId]!.add(recipeNote);
      } else {
        recipeNotesMap.addAll({recipeNote.recipeEntryId: []});
        recipeNotesMap[recipeNote.recipeEntryId]!.add(recipeNote);
      }
    }

    return recipeNotesMap;
  }

  /// Updates the recipe note in the database that matches the [recipeNote] id
  Future<int> update(RecipeNote recipeNote) async {
    final db = await instance.database;

    return db.update(
      tableRecipeNotes,
      recipeNote.toJson(),
      where: "${RecipeNoteFields.id} = ?",
      whereArgs: [recipeNote.id],
    );
  }

  /// Deletes the recipe note in the database associated with [id]
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableRecipeNotes,
      where: "${RecipeNoteFields.id} = ?",
      whereArgs: [id],
    );
  }

  /// Deletes all recipe notes for a particular recipe
  Future<int> deleteAllRecipeNotesForRecipe(int recipeEntryId) async {
    final db = await instance.database;

    return await db.delete(tableRecipeNotes,
        where: "${RecipeNoteFields.recipeEntryId} = ?",
        whereArgs: [recipeEntryId]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
