import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/user_event.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/user_state.dart';
import 'package:contacts_app/src/core/model/user_database_provider.dart';

import '../../repository/contacts/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserLoadingState()) {
    on<LoadUserEvent>(_loadUserEvent);
    on<PostUserEvent>(_postUserEvent);
  }

  FutureOr<void> _loadUserEvent(
      LoadUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      final UserRepository _userRepository = UserRepository();
      final UserDatabaseProvider _userDatabaseProvider = UserDatabaseProvider();
      final user = await _userDatabaseProvider.getUserById(1);
      final users = await _userRepository.getUsers(user);
      emit(UserLoadedState(users));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<FutureOr<void>> _postUserEvent(
      PostUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      final UserRepository _userRepository = UserRepository();
      final UserDatabaseProvider _userDatabaseProvider = UserDatabaseProvider();
      final user = await _userDatabaseProvider.getUserById(1);
      _userRepository.addUser(user, event.data!);
      emit(UserLoadedState([]));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}
