import 'dart:io';

import 'package:contacts_app/src/core/model/user.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../model/contacts.dart';

class ContactRepository {
  String endpoint = "http://www.motosikletci.com/api/kisiler";
  Dio dio = Dio();

  Future<List<Contacts>> getUsers(User user) async {
    Response response = await dio.post(endpoint, queryParameters: {
      'email': user.email,
      'sifre': user.sifre,
    });
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

  Future<void> addUserWithImage(
    User user,
    Contacts contacts,
    File imageFile,
  ) async {
    String fileName = imageFile.path.split('/').last;
    try {
      // Create a FormData object for the image upload
      FormData formData = FormData.fromMap({
        'resim': await MultipartFile.fromFile(imageFile.path,
            filename: fileName, contentType: MediaType('image', 'jpg')),
      });

      // Upload the image fir
      Response response = await dio.post(
        'http://www.motosikletci.com/api/kisi-kaydet',
        queryParameters: {
          'email': user.email,
          'sifre': user.sifre,
          'kisi_ad': contacts.kisi_ad,
          'kisi_id': contacts.kisi_id,
          'city_id': contacts.city_id,
          'town_id': contacts.town_id,
          'kisi_tel': contacts.kisi_tel,
          // Use the uploaded image URL here
        },
        data: formData,
      );

      if (response.statusCode == 200) {
        print('User data and image uploaded successfully: ${response.data}');
      } else {
        print('Error uploading user data: ${response.statusMessage}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
