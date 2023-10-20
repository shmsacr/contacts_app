import 'package:sqflite/sqflite.dart';

import '../../model/user.dart';
import 'database_repository.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
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

  @override
  Future<int> insert(User customUser) async {
    if (_database == null) await open();

    final userMaps = await _database!.insert(
      _userTableName,
      {
        _columnUserEmail: customUser.email,
        _columnUserPassword: customUser.sifre,
      },
    );
    await close();
    return userMaps;
  }

  @override
  Future<List<User>> getAllUsers() async {
    if (_database == null) await open();
    List<Map<String, dynamic>> users = await _database!.query(_userTableName);
    await close();
    return users.map((e) => User.fromJson(e)).toList();
  }

  @override
  Future<User?> getUserById(int id) async {
    if (_database == null) await open();

    final userMaps = await _database!
        .query(_userTableName, where: "$_columnUserId = ?", whereArgs: [id]);
    if (userMaps.isNotEmpty) {
      await close();
      return userMaps.map((e) => User.fromJson(e)).first;
    } else {
      await close();
      return null;
    }
  }

  @override
  Future<bool> deleteUser(int id) async {
    if (_database == null) await open();
    final userMaps = await _database!
        .delete(_userTableName, where: "$_columnUserId = ?", whereArgs: [id]);
    await close();
    return true;
  }

  @override
  Future<int> updateUser(int id, User customUser) async {
    if (_database == null) await open();

    final userMaps = await _database!.update(
        _userTableName, customUser.toJson(),
        where: "$_columnUserId = ?", whereArgs: [id]);
    await close();
    return userMaps;
  }

  Future<void> close() async {
    await _database!.close();
  }
}
