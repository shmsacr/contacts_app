import 'package:dio/dio.dart';

import '../../../model/user.dart';
import '../../database/database_repository_impl.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User?> getUser(User loginData) async {
    Dio dio = Dio();
    String enpoint = "http://www.motosikletci.com/api/oturum-test";
    try {
      Response response = await dio.post(enpoint, data: {
        "email": loginData.email,
        "sifre": loginData.sifre,
      });
      var responseData = response.data;
      if (responseData["basari"] == 1 && responseData["durum"] == 1) {
        User user = User(email: loginData.email, sifre: loginData.sifre, id: 1);
        DatabaseRepositoryImpl databaseProvider = DatabaseRepositoryImpl();
        await databaseProvider.open();
        await databaseProvider.insert(user);
        await databaseProvider.close();
        return user;
      } else {
        throw Exception('API Error: ${responseData['mesaj']}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> singOut() {
    DatabaseRepositoryImpl databaseProvider = DatabaseRepositoryImpl();
    return databaseProvider.deleteUser(1);
    // TODO: implement singOut
    throw UnimplementedError();
  }

  @override
  Future<User?> getCurrentUser() async {
    DatabaseRepositoryImpl databaseProvider = DatabaseRepositoryImpl();
    await databaseProvider.open();
    User? currentUser = await databaseProvider.getUserById(1);
    return currentUser;
  }
}
