import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_event.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_state.dart';
import 'package:contacts_app/src/core/data/service/contact_service/contact_service_impl.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../data/repository/database/database_repository.dart';
import '../../data/repository/database/database_repository_impl.dart';
import '../../data/service/contact_service/contact_service.dart';

const _contactDuration = Duration(milliseconds: 300);
EventTransformer<T> contactDroppable<T>(Duration duration) {
  return (events, mapper) {
    return droppable<T>().call(events.throttle(duration), mapper);
  };
}

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(ContactsLoadingState()) {
    on<ContactsFetch>(_contactFetch,
        transformer: contactDroppable(_contactDuration));
    on<PostContactEvent>(_postUserEvent);
    on<ResetContactEvent>(_resetUserEvent);
    on<DeleteContactEvent>(_deleteUserEvent);
  }

  Future<FutureOr<void>> _postUserEvent(
      PostContactEvent event, Emitter<ContactsState> emit) async {
    try {
      final ContactService _contactService = ContactServiceImpl();
      final DatabaseRepository _userDatabaseProvider = DatabaseRepositoryImpl();
      final user = await _userDatabaseProvider.getUserById(1);
      final postUser =
          await _contactService.addUserWithImage(user!, event.data, event.file);
      if (postUser) {
        emit(ContactsSuccessState());
        await _contactFetch(ContactsFetch(), emit);
      } else {
        emit(ContactsErrorState("Kullanıcı eklenemedi"));
      }
    } catch (e) {
      emit(ContactsErrorState(e.toString()));
    }
  }

  void _resetUserEvent(ResetContactEvent event, Emitter<ContactsState> emit) {
    emit(ContactsLoadingState());
  }

  FutureOr<void> _deleteUserEvent(
      DeleteContactEvent event, Emitter<ContactsState> emit) async {
    try {
      final ContactService _contactService = ContactServiceImpl();
      final DatabaseRepository _userDatabaseProvider = DatabaseRepositoryImpl();
      final user = await _userDatabaseProvider.getUserById(1);
      final deleteUser = await _contactService.deleteContact(user!, event.data);
      if (deleteUser) {
        final updatedContacts = state.contact
            .where((c) => c.kisi_id != event.data.kisi_id)
            .toList();
        emit(state.copyWith(contact: updatedContacts));
      } else {
        emit(ContactsErrorState("Kullanıcı silinemedi"));
      }
    } catch (e) {
      emit(ContactsErrorState(e.toString()));
    }
  }

  FutureOr<void> _contactFetch(
      ContactsFetch event, Emitter<ContactsState> emit) async {
    final ContactService _contactService = ContactServiceImpl();
    final DatabaseRepository _userDatabaseProvider = DatabaseRepositoryImpl();
    final user = await _userDatabaseProvider.getUserById(1);
    if (state.hasReachedMax) {
      return null;
    }
    try {
      if (state.status == ContactStatus.initial) {
        final contact = await _contactService.getUsers(user!);
        emit(state.copyWith(
            contact: contact,
            hasReachedMax: false,
            status: ContactStatus.success,
            page: state.page));
      }
      final contact = await _contactService.getUsers(user!, state.page + 1);
      contact.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(state.copyWith(
              contact: List.of(state.contact)..addAll(contact),
              hasReachedMax: false,
              status: ContactStatus.success,
              page: state.page + 1));
    } catch (e) {
      emit(state.copyWith(status: ContactStatus.failure));
    }
  }
}
