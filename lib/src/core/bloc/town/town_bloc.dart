import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/town.dart';
import '../../data/service/town_service/town_service.dart';
import '../../data/service/town_service/town_service_impl.dart';

part 'town_event.dart';
part 'town_state.dart';

class TownBloc extends Bloc<TownEvent, TownState> {
  TownBloc() : super(TownInitial()) {
    on<LoadTownEvent>(_mapLoadTownEvent);
    on<ClearTownEvent>(_mapClearTownEvent);
  }

  FutureOr<void> _mapLoadTownEvent(
      LoadTownEvent event, Emitter<TownState> emit) async {
    emit(TownLoadingState());
    try {
      final TownService _townService = TownServiceImpl();
      final towns = await _townService.getTowns(event.city_id);
      emit(TownLoadedState(towns));
    } catch (e) {
      emit(TownErrorState(e.toString()));
    }
  }

  FutureOr<void> _mapClearTownEvent(
      ClearTownEvent event, Emitter<TownState> emit) {
    emit(TownInitial());
  }
}
