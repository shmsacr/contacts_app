import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/model/user.dart';
import '../../data/repository/user/user_repository/user_repository.dart';
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
