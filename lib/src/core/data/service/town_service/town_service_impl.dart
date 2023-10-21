import 'package:contacts_app/src/core/data/model/town.dart';
import 'package:dio/dio.dart';

import 'town_service.dart';

class TownServiceImpl implements TownService {
  String endpoint = "http://www.motosikletci.com/api/ilceler";
  Dio dio = Dio();
  @override
  Future<List<Town>> getTowns(int? city_id) async {
    Response response = await dio.post(endpoint, queryParameters: {
      'city_id': city_id,
    });
    if (response.statusCode == 200) {
      var responseData = response.data;
      print("${response.data["ilceler"]}");
      if (responseData["basari"] == 1 && responseData["durum"] == 1) {
        final List<Map<String, dynamic>> responseData =
            List<Map<String, dynamic>>.from(response.data["ilceler"]);
        final List<Town> towns =
            responseData.map((map) => Town.fromJson(map)).toList();
        return towns;
      } else {
        throw ('Error uploading user data: ${response.data}');
      }
    } else {
      throw Exception("Error");
    }
  }
}
