import 'package:dio/dio.dart';

import '../../model/city.dart';

class CityRepository {
  String endpoint = "http://www.motosikletci.com/api/iller";

  Future<List<City>> getCities() async {
    Dio dio = Dio();
    final response = await dio.get(
      endpoint,
    );
    if (response.statusCode == 200) {
      print(response.data["iller"]);
      final List<Map<String, dynamic>> responseData =
          List<Map<String, dynamic>>.from(response.data["iller"]);
      final List<City> cities =
          responseData.map((map) => City.fromJson(map)).toList();
      return cities;
    } else {
      throw Exception("Error");
    }
  }
}
