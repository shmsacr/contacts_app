import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/model/contacts.dart';

@immutable
abstract class ContactsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactsLoadingState extends ContactsState {
  @override
  List<Object?> get props => [];
}

class ContactsLoadedState extends ContactsState {
  ContactsLoadedState(this.users);
  final List<Contacts> users;

  @override
  List<Object?> get props => [users];
}

class ContactsSuccessState extends ContactsState {
  @override
  List<Object?> get props => [];
}

class ContactsCreateState extends ContactsState {}

class ContactsErrorState extends ContactsState {
  ContactsErrorState(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
