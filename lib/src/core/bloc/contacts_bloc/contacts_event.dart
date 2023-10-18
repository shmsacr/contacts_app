import 'dart:io';

import 'package:contacts_app/src/core/model/contacts.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ContactsEvent extends Equatable {}

class LoadUserEvent extends ContactsEvent {
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
