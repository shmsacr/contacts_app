import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/model/user.dart';
import '../../data/repository/user/user_repository/user_repository.dart';

part 'authenctication_event.dart';
part 'authenctication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc(this.userRepository) : super(AuthenticationLoading()) {
    on<AppLoaded>(_mapAppLoadedToState);
    on<LoggedInEvent>(_mapUserLoggedInToState);
    on<LoggedOutEvent>(_mapUserLoggedOutToState);
  }

  FutureOr<void> _mapAppLoadedToState(
      AppLoaded event, Emitter<AuthenticationState> emit) async {
    try {
      final currentUser = await userRepository.getCurrentUser();
      if (currentUser != null) {
        emit(AuthenticationSuccess(data: currentUser));
      } else {
        emit(AuthenticationNotAuthenticated());
      }
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }

  FutureOr<void> _mapUserLoggedInToState(
      LoggedInEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationSuccess(data: event.data));
  }

  FutureOr<void> _mapUserLoggedOutToState(
      LoggedOutEvent event, Emitter<AuthenticationState> emit) {
    try {
      final signOut = userRepository.singOut();
      if (signOut == true) {
        emit(AuthenticationNotAuthenticated());
      }
    } catch (e) {
      throw Exception("Kullanıcı silinemedi");
    }
  }
}
