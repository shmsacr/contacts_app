import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contacts_app/src/core/model/user.dart';
import 'package:contacts_app/src/core/repository/user/user_repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authenctication_event.dart';
part 'authenctication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc(this.userRepository) : super(AuthenticationInitial()) {
    on<AppLoaded>(_mapAppLoadedToState);
    on<LoggedInEvent>(_mapUserLoggedInToState);
    on<LoggedOutEvent>(_mapUserLoggedOutToState);
  }

  FutureOr<void> _mapAppLoadedToState(
      AppLoaded event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
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
      LoggedOutEvent event, Emitter<AuthenticationState> emit) {}
// @override
// Stream<AuthenticationState> mapEventToState(
//     AuthenticationEvent event) async* {
//   if (event is AppLoaded) {
//     yield* _mapAppLoadedToState(event);
//   }
//
//   if (event is LoggedInEvent) {
//     yield* _mapUserLoggedInToState(event);
//   }
//
//   if (event is LoggedOutEvent) {
//     yield* _mapUserLoggedOutToState(event);
//   }
// }

// @override
// Stream<AuthenticationState> mapEventToState(
//     AuthenticationEvent event) async* {
//   yield AuthenticationLoading();
//
//   if (event is LoggedInEvent) {
//     try {
//       final user = await userRepository.getUser(event.data);
//       if (user != null) yield AuthenticationSuccess(data: user);
//     } catch (e) {
//       yield AuthenticationFailure(error: e.toString());
//     }
//   }
//   if (event is LoggedOutEvent) {
//     try {
//       await userRepository.singOut();
//       yield AuthenticationFailure(error: "Kullanıcı silindi");
//     } catch (e) {
//       yield AuthenticationFailure(error: e.toString());
//     }
//   }
// }

// Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
//   yield AuthenticationLoading();
//   try {
//     await Future.delayed(Duration(milliseconds: 500));
//     final currentUser = await userRepository.getCurrentUser();
//     if (currentUser != null) {
//       yield AuthenticationSuccess(data: currentUser);
//     } else {
//       yield AuthenticationNotAuthenticated();
//     }
//   } catch (e) {
//     yield AuthenticationFailure(error: e.toString());
//   }
// }
//
// Stream<AuthenticationState> _mapUserLoggedInToState(event) async* {
//   yield AuthenticationSuccess(data: event.data);
// }
//
// _mapUserLoggedOutToState(event) {}
}
