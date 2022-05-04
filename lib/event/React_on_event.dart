import 'package:now_apps/model/product_to_dart_model.dart';
import 'package:now_apps/services/get_product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<bool> veryfyEvent() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("login", true);
    ProductToDartModel productToDartModel = await getProDuct();
    print("product value : ${productToDartModel.data!.products![0].prodImage}");

    // Get a location using getDatabasesPath
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'product.db');
    Database database = await openDatabase(path, version: 1);
   /* Database? database = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, Product_Name TEXT, Price TEXT, Unit TEXT, Product_Image TEXT)');
    });*/
    productToDartModel.data!.products!.forEach((element) async {
      // Insert some records in a transaction
      await database.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO Test(Product_Name, Price, Unit,Product_Image) VALUES("${element.prodName}", "${element.prodPrice}", "${element.unitId}", "${element.prodImage}")');
        print('inserted1: $id1');
      });
    });
  //  await database.close();
  } catch (e) {
    print("Exception");
    return false;
  }
  return true;
}

Future<bool> insertCheckInStatus(int index) async {
  try {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'checkin.db');
    Database database = await openDatabase(path, version: 1);
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Check_In(IndexValue, Status) VALUES("$index", "true")');
      print('inserted Check_In: $id1');
    });
  //  await database.close();
  }catch(e){
    return false;
  }
  return true;
}

Future<bool> insertCartStatus(productname,quantity,totalprice,identification) async {
  try {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cart.db');
    Database database = await openDatabase(path, version: 1);
      await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Cart(Product_Name, Quantity,Total_Price,Identification) VALUES("$productname", "$quantity","$totalprice","$identification")');
      print('inserted Check_In: $id1');
    });
    //  await database.close();
  }catch(e){
    return false;
  }
  return true;
}

Future<bool> deleteCartStatus(id) async {
  try {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cart.db');
    Database database = await openDatabase(path, version: 1);
    await database
        .rawDelete('DELETE FROM Cart WHERE id = $id');
    //  await database.close();
  }catch(e){
    return false;
  }
  return true;
}

Future<bool> createTableCart() async {
  try {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cart.db');

    Database? database=   await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE IF NOT EXISTS Cart (id INTEGER PRIMARY KEY,Product_Name TEXT, Quantity TEXT, Total_Price TEXT, Identification TEXT)');
        });

  /*  await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Cart(Product_Name, Quantity,Total_Price,Identification) VALUES("$index", "true")');
      print('inserted Check_In: $id1');
    });*/
    //  await database.close();
  }catch(e){
    return false;
  }
  return true;
}


Future<bool> CreateTableTest() async {
  try {
    // Get a location using getDatabasesPath
    final databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'product.db');
    Database? database= await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY, Product_Name TEXT, Price TEXT, Unit TEXT, Product_Image TEXT)');
        });


  } catch (e) {
    print("Exception");
    return false;
  }
  return true;
}
Future<bool> CreateTableCheckIn() async {
  try {
    // Get a location using getDatabasesPath
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'checkin.db');
    Database? database=  await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE IF NOT EXISTS Check_In (id INTEGER PRIMARY KEY, IndexValue TEXT, Status TEXT)');
        });


  } catch (e) {
    print("Exception");
    return false;
  }
  return true;
}
