import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/user.dart';
import '../../repository/user/user_repository/user_repository.dart';
import '../../widget/authentication_exception.dart';
import '../authentication/authenctication_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc? authenticationBloc;
  LoginBloc(this.userRepository, this.authenticationBloc)
      : super(LoginInitial()) {
    on<LoginButtonPressedEvent>(_mapLoginButtonPressedEvent);
  }

  FutureOr<void> _mapLoginButtonPressedEvent(
      LoginButtonPressedEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await userRepository.getUser(event.data);
      if (user != null) {
        authenticationBloc?.add(LoggedInEvent(data: event.data));
        emit(LoginSuccess());
      }
    } on AuthenticationException catch (e) {
      emit(LoginFailure(error: e.toString()));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}

//
// @override
// Stream<LoginState> mapEventToState(LoginEvent event) async* {
//   if (event is LoginButtonPressedEvent) {
//     yield LoginLoading();
//     try {
//       final authUser = await userRepository.getUser(event.data);
//       if (authUser != null) {
//         authenticationBloc?.add(LoggedInEvent(data: event.data));
//         yield LoginSuccess();
//         yield LoginInitial();
//       } else {
//         yield LoginFailure(error: "Kullanıcı adı veya şifre hatalı");
//       }
//       await Future.delayed(Duration(seconds: 3));
//       yield LoginSuccess();
//     } on AuthenticationException catch (e) {
//       yield LoginFailure(error: e.message);
//     } catch (e) {
//       yield LoginFailure(error: e.toString());
//     }
//   }

// {
//   on<LoginButtonPressedEvent>(_loginButtonPressedEvent);
// }
//
// FutureOr<void> _loginButtonPressedEvent(
//     LoginButtonPressedEvent event, Emitter<LoginState> emit) async {
//   emit(LoginLoading());
//   try {
//     final authUser = await userRepository.getUser(event.data);
//     if (authUser != null) {
//       authenticationBloc?.add(LoggedInEvent(data: event.data));
//       emit(LoginSuccess());
//       emit(LoginInitial());
//     } else {
//       emit(LoginFailure(error: "Kullanıcı adı veya şifre hatalı"));
//     }
//     await Future.delayed(Duration(seconds: 3));
//     emit(LoginSuccess());
//   } on AuthenticationException catch (e) {
//     emit(LoginFailure(error: e.message));
//   } catch (e) {
//     emit(LoginFailure(error: e.toString()));
//   }
// }

// @override
// Stream<LoginState> mapEventToState(LoginEvent event) async* {
//   if (event is LoginButtonPressedEvent) {
//     yield LoginLoading();
//     try {
//       final authUser = await userRepository.getUser(event.data);
//       if (authUser != null) {
//         authenticationBloc?.add(LoggedInEvent(data: event.data));
//         yield LoginSuccess();
//         yield LoginInitial();
//       } else {
//         yield LoginFailure(error: "Kullanıcı adı veya şifre hatalı");
//       }
//       await Future.delayed(Duration(seconds: 3));
//       yield LoginSuccess();
//     } on AuthenticationException catch (e) {
//       yield LoginFailure(error: e.message);
//     } catch (e) {
//       yield LoginFailure(error: e.toString());
//     }
//   }
// }
