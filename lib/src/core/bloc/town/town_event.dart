part of 'town_bloc.dart';

abstract class TownEvent extends Equatable {}

class LoadTownEvent extends TownEvent {
  final int? city_id;
  LoadTownEvent({this.city_id});
  @override
  List<Object?> get props => [city_id];
}

class ClearTownEvent extends TownEvent {
  @override
  List<Object?> get props => [];
}
