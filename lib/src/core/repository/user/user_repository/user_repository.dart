import '../../../model/user.dart';

abstract class UserRepository {
  Future<User?> getUser(User data);
  Future<void> singOut();
  Future<User?> getCurrentUser();
}
