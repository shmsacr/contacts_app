import '../../model/user.dart';

abstract class DatabaseRepository {
  Future<int> insert(User customUser);
  Future<List<User>> getAllUsers();
  Future<User?> getUserById(int id);
  Future<bool> deleteUser(int id);
  Future<int> updateUser(int id, User customUser);
}
