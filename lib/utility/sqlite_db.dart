import 'package:nutrome_user/utility/data_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDB {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final doubleType = "REAL NOT NULL";

    await db.execute('''
CREATE TABLE CART ( 
  mealId $textType,
        mealName $textType,
        mealType $textType,
        imgUrl $textType,
        quantity $integerType,
        price $doubleType,
        deliveryCharges $doubleType,
        taxes $doubleType
  )
''');
  }

  Future<CartModel> addToCart(CartModel cartModel) async {
    final db = await database;
    var id = await db.insert("CART", cartModel.toJson());
    print(id);
    return cartModel;
  }

  Future<List<CartModel>> getCartItems() async {
    final db = await database;
    final orderBy = 'mealName ASC';
    final result = await db.query("CART", orderBy: orderBy);
    return result.map((json) => CartModel.fromJson(json)).toList();
  }

  Future<void> update(CartModel cartModel, int count, bool inc) async {
    final db = await database;
    try {
      int res = await db.update(
        "CART",
        {'quantity': inc ? ++count : --count},
        where: 'mealId = ?',
        whereArgs: [cartModel.mealId],
      );
      if (res == 0) {
        addToCart(cartModel);
      }
    } on Exception catch (ex) {
      print(ex.runtimeType);
    } catch (error) {
      print(error.runtimeType);
    }
  }

  Future<int> delete(String mealId) async {
    final db = await database;
    return await db.delete(
      "CART",
      where: "mealId = ?",
      whereArgs: [mealId],
    );
  }

  Future<void> clearCart() async {
    final db = await database;
    db.execute("DELETE FROM CART");
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
