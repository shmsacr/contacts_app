import '../../model/city.dart';

abstract class CityService {
  Future<List<City>> getCities();
}
