import 'package:api_practice/models/address_model.dart';
import 'package:api_practice/models/category.dart';
import 'package:api_practice/models/product.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/constants/strings.dart';

class DBServices extends GetxController {
  DBServices._constructor();

  static final instance = DBServices._constructor();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final dataBaseDirPath = await getDatabasesPath();
    final databasePath = join(dataBaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 2,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE ${Strings.dbCartTable['table']} (
          ${Strings.dbCartTable['id']} INTEGER PRIMARY KEY,
          ${Strings.dbCartTable['title']} TEXT NOT NULL,
          ${Strings.dbCartTable['description']} TEXT NOT NULL,
          ${Strings.dbCartTable['image']} TEXT NOT NULL,
          ${Strings.dbCartTable['category']} TEXT NOT NULL,
          ${Strings.dbCartTable['price']} INTEGER NOT NULL,
          ${Strings.dbCartTable['quantity']} INTEGER NOT NULL
        )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if(newVersion == 2) {
          await db.execute('''
            CREATE TABLE address (${Strings.dbAddressIdColumn} INTEGER PRIMARY KEY,
            ${Strings.dbAddressNameColumn} TEXT NOT NULL,
            ${Strings.dbAddressCountryColumn} TEXT NOT NULL,
            ${Strings.dbAddressPhoneColumn} INTEGER NOT NULL,
            ${Strings.dbAddressStreetColumn} TEXT NOT NULL,
            ${Strings.dbAddressStateColumn} TEXT NOT NULL,
            ${Strings.dbAddressCityColumn} TEXT NOT NULL)
            '''
          );
        }
      },
    );
    return database;
  }

  Future<String> addToCart({required ProductModel product}) async {
    final db = await database;
    try {
      await db.insert(Strings.dbCartTable['table']!, {
        Strings.dbCartTable['id']!: product.id,
        Strings.dbCartTable['title']!: product.title,
        Strings.dbCartTable['category']!: product.category?.name,
        Strings.dbCartTable['price']!: product.price,
        Strings.dbCartTable['description']!: product.description,
        Strings.dbCartTable['image']!: product.images![0],
        Strings.dbCartTable['quantity']!: 1,
      });
    } catch (e) {
      print(e.toString());
      return 'fail';
    }
    return 'success';
  }

  Future<List<ProductModel>> getCartList() async {
    final db = await database;
    final data = await db.query(
      Strings.dbCartTable['table']!,
    );
    print(data);
    final cartList = data
        .map((e) => ProductModel(
            id: e['id'] as int,
            title: e['title'] as String,
            description: e['description'] as String,
            images: [e['image'] as String],
            category: CategoryModel(name: e['category'] as String),
            price: e['price'] as int,
            qty: e['quantity'] as int))
        .toList();
    return cartList;
  }

  Future<String> deleteRecord({required String tableName, required int id,}) async {
    final db = await database;
    try {
      await db.delete(tableName,
          where: 'id = ?',
          whereArgs: [id]
      );
    } catch (e) {
      print(e.toString());
      return 'fail';
    }
    return 'success';
  }

  Future<String> updateCart({required int id, required int qty}) async {
    final db = await database;
    try {
      await db.update(Strings.dbCartTable['table']!,
          {
            Strings.dbCartTable['quantity']!: qty
          },
          where: 'id = ?',
          whereArgs: [id]
      );
    } catch (e) {
      print(e.toString());
      return 'fail';
    }
    return 'success';
  }

  Future<bool> cartContainsProduct(int id) async {
    final db = await database;
    final result =await db.query(Strings.dbCartTable['table']!,
    where: 'id = ?',
      whereArgs: [id]
    );
    return result.isNotEmpty;
  }

  Future<String> addNewAddress(Address address) async {
    final db = await getDatabase();
    try{
      db.insert(Strings.dbAddressTableName, address.toJson() );
    } catch (e) {
      print(e.toString());
      return 'failed';
    }
    return 'success';
  }

  Future<List<Address>> getAllAddress() async {

    try{
      final db = await database;
      final addressList = await db.query(Strings.dbAddressTableName);
      print(addressList);
      final list = addressList.map((e)=> Address.fromJson(e)).toList();
      return list;
    } catch(e){
      print(e.toString());
      throw Exception(e.toString());
    }
  }


}
