import 'package:dio/dio.dart';

import '../../model/contacts.dart';

class UserRepository {
  String endpoint = "http://www.motosikletci.com/api/kisiler";

  Future<List<Contacts>> getUsers(String email, String sifre) async {
    Dio dio = Dio();
    Response response = await dio.post(
      endpoint,
      data: {
        'email': email,
        'sifre': sifre,
      },
    );
    if (response.statusCode == 200) {
      print("${response.data["kisiler"]["data"]}");
      final List<Map<String, dynamic>> responseData =
          List<Map<String, dynamic>>.from(response.data["kisiler"]["data"]);
      final List<Contacts> users =
          responseData.map((map) => Contacts.fromJson(map)).toList();
      return users;
    } else {
      throw Exception("Error");
    }
  }

  Future<void> addUser(String email, String sifre, Contacts contacts) async{
    Dio dio = Dio();
    Response response = await dio.post(
      endpoint,
      data: {
        'email': email,
        'sifre': sifre,
        'kisi_ad': contacts.kisi_ad,
        'kisi_id': contacts.kisi_id,
        'city_id': contacts.city_id,
        'town_id': contacts.town_id,
        'kisi_tel': contacts.kisi_tel,
      },

    );
  }
}
