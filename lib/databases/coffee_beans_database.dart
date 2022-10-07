import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aeroquest/models/coffee_bean.dart';

class CoffeeBeansDatabase {
  static final CoffeeBeansDatabase instance = CoffeeBeansDatabase._init();
  static Database? _database;

  CoffeeBeansDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB("coffeeBeans.db");
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
      CREATE TABLE $tableCoffeeBeans (
        ${CoffeeBeanFields.id} $idType,
        ${CoffeeBeanFields.beanName} $textType,
        ${CoffeeBeanFields.description} $nullableTextType
      ) 
    ''');
  }

  Future<CoffeeBean> create(CoffeeBean coffeeBean) async {
    final db = await instance.database;

    final id = await db.insert(tableCoffeeBeans, coffeeBean.toJson());
    return coffeeBean.copy(id: id);
  }

  Future<CoffeeBean> readCoffeeBean(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCoffeeBeans,
      columns: CoffeeBeanFields.values,
      where: "${CoffeeBeanFields.id} = ?", // ? prevents sql injection attacks
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CoffeeBean.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  Future<List<CoffeeBean>> readAllCoffeeBeans() async {
    final db = await instance.database;

    final result = await db.query(tableCoffeeBeans);

    return result.map((json) => CoffeeBean.fromJson(json)).toList();
  }

  Future<int> update(CoffeeBean coffeeBean) async {
    final db = await instance.database;

    return db.update(
      tableCoffeeBeans,
      coffeeBean.toJson(),
      where: "${CoffeeBeanFields.id} = ?",
      whereArgs: [coffeeBean.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableCoffeeBeans,
      where: "${CoffeeBeanFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "coffeeBeans.db");

    deleteDatabase(path);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
