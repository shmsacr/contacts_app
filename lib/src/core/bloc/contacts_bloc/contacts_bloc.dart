import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_event.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_state.dart';
import 'package:contacts_app/src/core/data/service/contact_service/contact_service_impl.dart';

import '../../data/repository/database/database_repository.dart';
import '../../data/repository/database/database_repository_impl.dart';
import '../../data/service/contact_service/contact_service.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(ContactsLoadingState()) {
    on<LoadUserEvent>(_loadUserEvent);
    on<PostUserEvent>(_postUserEvent);
    on<ResetUserEvent>(_resetUserEvent);
    on<DeleteUserEvent>(_deleteUserEvent);
  }

  FutureOr<void> _loadUserEvent(
      LoadUserEvent event, Emitter<ContactsState> emit) async {
    try {
      emit(ContactsLoadingState());
      final ContactService _contactService = ContactServiceImpl();
      final DatabaseRepository _userDatabaseProvider = DatabaseRepositoryImpl();
      final user = await _userDatabaseProvider.getUserById(1);
      final users = await _contactService.getUsers(user!);
      emit(ContactsLoadedState(users));
    } catch (e) {
      emit(ContactsErrorState(e.toString()));
    }
  }

  Future<FutureOr<void>> _postUserEvent(
      PostUserEvent event, Emitter<ContactsState> emit) async {
    try {
      final ContactService _contactService = ContactServiceImpl();
      final DatabaseRepository _userDatabaseProvider = DatabaseRepositoryImpl();
      final user = await _userDatabaseProvider.getUserById(1);
      final postUser =
          await _contactService.addUserWithImage(user!, event.data, event.file);
      if (postUser) {
        emit(ContactsSuccessState());
        await _loadUserEvent(LoadUserEvent(), emit);
      } else {
        emit(ContactsErrorState("Kullanıcı eklenemedi"));
      }
    } catch (e) {
      emit(ContactsErrorState(e.toString()));
    }
  }

  void _resetUserEvent(ResetUserEvent event, Emitter<ContactsState> emit) {
    emit(ContactsLoadingState());
  }

  FutureOr<void> _deleteUserEvent(
      DeleteUserEvent event, Emitter<ContactsState> emit) async {
    try {
      final ContactService _contactService = ContactServiceImpl();
      final DatabaseRepository _userDatabaseProvider = DatabaseRepositoryImpl();
      final user = await _userDatabaseProvider.getUserById(1);
      final deleteUser = await _contactService.deleteContact(user!, event.data);
      if (deleteUser) {
        emit(ContactsLoadingState());
        await _loadUserEvent(LoadUserEvent(), emit);
      } else {
        emit(ContactsErrorState("Kullanıcı silinemedi"));
      }
    } catch (e) {
      emit(ContactsErrorState(e.toString()));
    }
  }
}
