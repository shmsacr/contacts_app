import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/model/contacts.dart';

@immutable
abstract class ContactsEvent extends Equatable {}

class LoadUserEvent extends ContactsEvent {
  @override
  List<Object?> get props => [];
}

class ResetUserEvent extends ContactsEvent {
  @override
  List<Object?> get props => [];
}

class PostUserEvent extends ContactsEvent {
  Contacts data;
  File? file;
  PostUserEvent({required this.data, this.file});
  @override
  List<Object?> get props => [data];
}

class DeleteUserEvent extends ContactsEvent {
  Contacts data;
  DeleteUserEvent({required this.data});
  @override
  List<Object?> get props => [data];
}
