import 'package:dio/dio.dart';

import '../../model/city.dart';
import 'city_service.dart';

class CityServiceImpl implements CityService {
  String endpoint = "http://www.motosikletci.com/api/iller";

  @override
  Future<List<City>> getCities() async {
    Dio dio = Dio();
    final response = await dio.get(
      endpoint,
    );
    if (response.statusCode == 200) {
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
