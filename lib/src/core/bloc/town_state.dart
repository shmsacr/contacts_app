part of 'town_bloc.dart';

abstract class TownState extends Equatable {
  const TownState();
}

class TownInitial extends TownState {
  @override
  List<Object> get props => [];
}

class TownLoadingState extends TownState {
  @override
  List<Object?> get props => [];
}

class TownLoadedState extends TownState {
  TownLoadedState(this.towns);
  final List<Town> towns;
  @override
  List<Object> get props => [towns];
}

class TownErrorState extends TownState {
  TownErrorState(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
