import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../../data/model/contacts.dart';

@immutable
abstract class ContactsEvent extends Equatable {
  const ContactsEvent();
  @override
  List<Object?> get props => [];
}

class ContactsFetch extends ContactsEvent {
  const ContactsFetch();
  @override
  List<Object?> get props => [];
}

class LoadContactEvent extends ContactsEvent {
  final int page;
  LoadContactEvent({this.page = 1});
  @override
  List<Object?> get props => [page];
}

class ResetContactEvent extends ContactsEvent {
  @override
  List<Object?> get props => [];
}

class PostContactEvent extends ContactsEvent {
  final Contacts data;
  final File? file;
  PostContactEvent({required this.data, this.file});
  @override
  List<Object?> get props => [data];
}

class DeleteContactEvent extends ContactsEvent {
  final Contacts data;
  DeleteContactEvent({required this.data});
  @override
  List<Object?> get props => [data];
}
