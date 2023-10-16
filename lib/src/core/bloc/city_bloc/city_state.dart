import 'package:contacts_app/src/core/model/city.dart';
import 'package:equatable/equatable.dart';

abstract class CityState extends Equatable {}

class CityLoadedState extends CityState {
  CityLoadedState(this.cities);
  final List<City> cities;
  @override
  List<Object> get props => [cities];
}

class CityLoadingState extends CityState {
  @override
  List<Object?> get props => [];
}

class CityErrorState extends CityState {
  CityErrorState(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
