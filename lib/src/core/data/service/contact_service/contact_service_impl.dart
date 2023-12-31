import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:image/image.dart' as Img;

import '../../model/contacts.dart';
import '../../model/user.dart';
import 'contact_service.dart';

class ContactServiceImpl implements ContactService {
  String endpoint = "http://www.motosikletci.com/api/kisiler";
  Dio dio = Dio();
  @override
  Future<List<Contacts>> getUsers(User user, [int page = 1]) async {
    Response response = await dio.post(endpoint, queryParameters: {
      'email': user.email,
      'sifre': user.sifre,
      'page': page,
    });
    debugPrint("page: $page");

    if (response.statusCode == 200) {
      var responseData = response.data;
      if (responseData["basari"] == 1 && responseData["durum"] == 1) {
        final List<Map<String, dynamic>> responseData =
            List<Map<String, dynamic>>.from(response.data["kisiler"]["data"]);
        final List<Contacts> users =
            responseData.map((map) => Contacts.fromJson(map)).toList();
        return users;
      } else {
        throw ('Error uploading user data: ${response.data}');
      }
    } else {
      throw Exception("Error");
    }
  }

  @override
  Future<bool> addUserWithImage(
    User user,
    Contacts contacts,
    File? imageFile,
  ) async {
    String? fileName = imageFile?.path.split('/').last;
    FormData _formData;
    try {
      if (imageFile != null) {
        final resizedImage = Img.copyResize(
          Img.decodeImage(imageFile!.readAsBytesSync())!,
          width: 100,
          height: 100,
        );
        final resizedImageData = Img.encodeJpg(resizedImage);
        final resizedMultipartFile = MultipartFile.fromBytes(
          resizedImageData,
          filename: fileName,
          contentType: MediaType('image', 'jpg'),
        );

        _formData = FormData.fromMap({
          'resim': resizedMultipartFile,
        });
      } else {
        _formData = FormData.fromMap({
          'resim': null,
        });
      }

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
        },
        data: _formData,
      );
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData["basari"] == 1 && responseData["durum"] == 1) {
          print('User data and image uploaded successfully: ${response.data}');
          return true;
        } else {
          throw ('Error uploading user data: ${response.data}');
        }
      } else {
        throw ('Error uploading user data: ${response.statusMessage}');
      }
    } catch (error) {
      throw ('Error: $error');
    }
  }

  Future<bool> deleteContact(User user, Contacts contacts) async {
    Response response = await dio.post(
      'http://www.motosikletci.com/api/kisi-sil',
      queryParameters: {
        'email': user.email,
        'sifre': user.sifre,
        'kisi_id': contacts.kisi_id,
      },
    );
    if (response.statusCode == 200) {
      var responseData = response.data;
      if (responseData["basari"] == 1 && responseData["durum"] == 3) {
        return true;
      } else {
        throw ('Error uploading user data: ${response.data}');
      }
    } else {
      throw ('Error uploading user data: ${response.statusMessage}');
    }
  }
}
