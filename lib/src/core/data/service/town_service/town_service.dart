import 'package:contacts_app/src/core/data/model/town.dart';

abstract class TownService {
  Future<List<Town>> getTowns(int? city_id);
}
