import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class CityEvent extends Equatable {}

class LoadCityEvent extends CityEvent {
  @override
  List<Object?> get props => [];
}
