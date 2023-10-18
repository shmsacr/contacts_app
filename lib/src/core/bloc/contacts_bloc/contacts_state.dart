import 'package:contacts_app/src/core/model/contacts.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ContactsState extends Equatable {}

class UserLoadingState extends ContactsState {
  @override
  List<Object?> get props => [];
}

class UserLoadedState extends ContactsState {
  UserLoadedState(this.users);
  final List<Contacts> users;

  @override
  List<Object?> get props => [users];
}

class UserErrorState extends ContactsState {
  UserErrorState(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
