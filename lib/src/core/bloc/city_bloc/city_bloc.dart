import 'package:bloc/bloc.dart';
import 'package:contacts_app/src/core/bloc/city_bloc/city_event.dart';
import 'package:contacts_app/src/core/bloc/city_bloc/city_state.dart';
import 'package:contacts_app/src/core/data/service/city_service/city_service.dart';
import 'package:contacts_app/src/core/data/service/city_service/city_service_impl.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  CityBloc() : super(CityLoadingState()) {
    on<CityEvent>((event, emit) async {
      emit(CityLoadingState());
      // TODO: implement event handler
      try {
        final CityService _cityService = CityServiceImpl();

        final city = await _cityService.getCities();
        emit(CityLoadedState(city));
      } catch (e) {
        emit(CityErrorState(e.toString()));
      }
    });
  }
}
