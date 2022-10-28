import 'dart:collection';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aeroquest/models/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB("notes.db");
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
      CREATE TABLE $tableNotes (
        ${NoteFields.id} $idType,
        ${NoteFields.recipeEntryId} $integerType,
        ${NoteFields.time} $integerType,
        ${NoteFields.text} $textType
      ) 
    ''');
  }

  Future<int> create(Note note) async {
    final db = await instance.database;

    final id = await db.insert(tableNotes, note.toJson());
    return id;
  }

  // { recipeEntryId : { noteId : note } }
  Future<SplayTreeMap<int, SplayTreeMap<int, Note>>> readAllNotes() async {
    final db = await instance.database;

    final result = await db.query(tableNotes);

    final notesList = result.map((json) => Note.fromJson(json)).toList();
    final notesMap = SplayTreeMap<int, SplayTreeMap<int, Note>>();
    for (var note in notesList) {
      if (notesMap.containsKey(note.recipeEntryId)) {
        notesMap[note.recipeEntryId]!.addAll({note.id!: note});
      } else {
        notesMap.addAll({note.recipeEntryId: SplayTreeMap<int, Note>()});
        notesMap[note.recipeEntryId]!.addAll({note.id!: note});
      }
    }

    return notesMap;
  }

  Future<List<Note>> readAllNotesFromRecipe(int recipeEntryId) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT * FROM $tableNotes 
      WHERE $tableNotes.${NoteFields.recipeEntryId} = $recipeEntryId''');

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: "${NoteFields.id} = ?",
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: "${NoteFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteAllNotesForRecipe(int recipeEntryId) async {
    final db = await instance.database;

    return await db.delete(tableNotes,
        where: "${NoteFields.recipeEntryId} = ?", whereArgs: [recipeEntryId]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
