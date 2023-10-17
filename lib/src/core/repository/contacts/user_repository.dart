import 'package:contacts_app/src/core/model/customUser.dart';
import 'package:dio/dio.dart';

import '../../model/contacts.dart';

class UserRepository {
  String endpoint = "http://www.motosikletci.com/api/kisiler";

  Future<List<Contacts>> getUsers(CustomUser user) async {
    Dio dio = Dio();
    Response response = await dio.post(
      endpoint,
      data: {
        'email': user.email,
        'sifre': user.sifre,
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

  Future<void> addUser(CustomUser user, Contacts contacts) async {
    Dio dio = Dio();

    try {
      Response response = await dio.post(
        "http://www.motosikletci.com/api/kisi-kaydet",
        data: {
          'email': user.email,
          'sifre': user.sifre,
          'kisi_ad': contacts.kisi_ad,
          'kisi_id': contacts.kisi_id,
          'city_id': contacts.city_id,
          'town_id': contacts.town_id,
          'kisi_tel': contacts.kisi_tel,
          'resim': contacts.resim,
        },
      );
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData['basari'] == 1 && responseData['durum'] == 1) {
          print('API Response: ${responseData['mesaj']}');
        } else {
          throw Exception('API Error: ${responseData['mesaj']}');
        }
        print('Contact added successfully: ${response.data}');
      } else {
        throw Exception('API Error: ${response.statusMessage}');
      }
    } catch (error) {
      // Handle other errors, for example, network errors
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }
}
