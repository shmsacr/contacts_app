import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_event.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_state.dart';
import 'package:contacts_app/src/core/model/user_database_provider.dart';

import '../../repository/contacts/contacts_repository.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(UserLoadingState()) {
    on<LoadUserEvent>(_loadUserEvent);
    on<PostUserEvent>(_postUserEvent);
  }

  FutureOr<void> _loadUserEvent(
      LoadUserEvent event, Emitter<ContactsState> emit) async {
    try {
      emit(UserLoadingState());
      final ContactRepository _contactRepository = ContactRepository();
      final UserDatabaseProvider _userDatabaseProvider = UserDatabaseProvider();
      final user = await _userDatabaseProvider.getUserById(1);
      final users = await _contactRepository.getUsers(user!);
      emit(UserLoadedState(users));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<FutureOr<void>> _postUserEvent(
      PostUserEvent event, Emitter<ContactsState> emit) async {
    try {
      emit(UserLoadingState());
      final ContactRepository _userRepository = ContactRepository();
      final UserDatabaseProvider _userDatabaseProvider = UserDatabaseProvider();
      final user = await _userDatabaseProvider.getUserById(1);
      _userRepository.addUserWithImage(user!, event.data!, event.file!);
      final updatedUsers = await _userRepository.getUsers(user);
      emit(UserLoadedState(updatedUsers));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}
