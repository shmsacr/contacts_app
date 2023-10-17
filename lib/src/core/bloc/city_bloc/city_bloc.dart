import 'package:bloc/bloc.dart';
import 'package:contacts_app/src/core/bloc/city_bloc/city_event.dart';
import 'package:contacts_app/src/core/bloc/city_bloc/city_state.dart';

import '../../repository/city/city_repository.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  CityBloc() : super(CityLoadingState()) {
    on<CityEvent>((event, emit) async {
      emit(CityLoadingState());
      // TODO: implement event handler
      try {
        final CityRepository _cityRepository = CityRepository();

        final city = await _cityRepository.getCities();
        emit(CityLoadedState(city));
      } catch (e) {
        emit(CityErrorState(e.toString()));
      }
    });
  }
}
