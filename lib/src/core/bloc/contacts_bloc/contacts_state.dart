import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/model/contacts.dart';

enum ContactStatus { initial, success, failure }

@immutable
class ContactsState extends Equatable {
  final List<Contacts> contact;
  final bool hasReachedMax;
  final ContactStatus status;
  final int page;

  const ContactsState(
      {this.contact = const <Contacts>[],
      this.hasReachedMax = false,
      this.status = ContactStatus.initial,
      this.page = 0});

  @override
  List<Object?> get props => [contact, hasReachedMax, status];

  ContactsState copyWith({
    List<Contacts>? contact,
    bool? hasReachedMax,
    ContactStatus? status,
    int? page,
  }) {
    return ContactsState(
      contact: contact ?? this.contact,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      page: page ?? this.page,
    );
  }
}

class ContactsLoadingState extends ContactsState {
  @override
  List<Object?> get props => [];
}

class ContactsLoadedState extends ContactsState {
  final int? currentPage;
  final List<Contacts> users;

  ContactsLoadedState(this.users, this.currentPage);

  @override
  List<Object?> get props => [users, currentPage];
}

class ContactsSuccessState extends ContactsState {
  @override
  List<Object?> get props => [];
}

class ContactsCreateState extends ContactsState {}

class ContactsErrorState extends ContactsState {
  final String message;
  ContactsErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
