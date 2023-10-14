import 'package:contacts_app/src/core/model/customUser.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabaseProvider {
  final String _userDatabaseName = "userDatabase";
  final String _userTableName = "user";
  final String _columnUserEmail = "email";
  final String _columnUserPassword = "sifre";
  final String _columnUserId = "id";

  Database? _database;

  Future<void> open() async {
    _database = await openDatabase(_userDatabaseName, version: 1,
        onCreate: (db, version) async {
      createDatabase(db);
    });
  }

  void createDatabase(Database db) async {
    await db.execute('''CREATE TABLE $_userTableName ( 
        $_columnUserId INTEGER PRIMARY KEY,
         $_columnUserEmail TEXT,
         $_columnUserPassword TEXT)''');
  }

  Future<bool> insert(CustomUser customUser) async {
    if (_database == null) await open();

    final userMaps = await _database!.insert(
      _userTableName,
      {
        _columnUserEmail: customUser.email,
        _columnUserPassword: customUser.sifre,
      },
    );
    return userMaps != null;
  }

  Future<List<CustomUser>> getAllUsers() async {
    if (_database == null) await open();
    List<Map<String, dynamic>> users = await _database!.query(_userTableName);
    await close();
    return users.map((e) => CustomUser.fromJson(e)).toList();
  }

  Future<CustomUser> getUserById(int id) async {
    if (_database == null) await open();

    final userMaps = await _database!
        .query(_userTableName, where: "$_columnUserId = ?", whereArgs: [id]);
    if (userMaps.isNotEmpty) {
      await close();
      return userMaps.map((e) => CustomUser.fromJson(e)).first;
    } else {
      await close();
      throw Exception("User not found");
    }
  }

  Future<bool> deleteUser(int id) async {
    if (_database == null) await open();
    final userMaps = await _database!
        .delete(_userTableName, where: "$_columnUserId = ?", whereArgs: [id]);
    await close();
    return userMaps != null;
  }

  Future<bool> updateUser(int id, CustomUser customUser) async {
    if (_database == null) await open();

    final userMaps = await _database!.update(
        _userTableName, customUser.toJson(),
        where: "$_columnUserId = ?", whereArgs: [id]);
    await close();
    return userMaps != null;
  }

  Future<void> close() async {
    await _database!.close();
  }
}
