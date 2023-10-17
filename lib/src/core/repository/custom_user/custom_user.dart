import 'package:dio/dio.dart';
import 'package:flutter_login/flutter_login.dart';

import '../../model/customUser.dart';
import '../../model/user_database_provider.dart';

class CustomUserRepository {
  String endpoint = 'http://www.motosikletci.com/api/oturum-test';
  Dio dio = Dio();
  Future<LoginData> addUser(LoginData user) async {
    try {
      Dio dio = Dio();
      Response response = await dio.post(
        endpoint,
        data: {'email': user.name, 'sifre': user.password},
      );

      if (response.statusCode == 200) {
        // API'den başarılı yanıt alındı
        var responseData = response.data;
        print(responseData);
        if (responseData['basari'] == 1 && responseData['durum'] == 1) {
          print('API Response: ${responseData['mesaj']}');
          CustomUser myUser =
              CustomUser(email: user.name, sifre: user.password);
          UserDatabaseProvider databaseProvider = UserDatabaseProvider();
          await databaseProvider.open();
          await databaseProvider.insert(myUser);
          await databaseProvider.close();
          return user;
        } else {
          // Handle incorrect API response here, for example:
          throw Exception('API Error: ${responseData['mesaj']}');
        }
      } else {
        // Handle non-200 status code
        throw Exception('API Error: ${response.statusMessage}');
      }
    } catch (error) {
      // Handle other errors, for example, network errors
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }
}
