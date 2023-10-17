import 'package:contacts_app/src/core/model/contacts.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class UserEvent extends Equatable {}

class LoadUserEvent extends UserEvent {
  @override
  List<Object?> get props => [];
}

class PostUserEvent extends UserEvent {
  Contacts data;
  PostUserEvent({required this.data});
  @override
  List<Object?> get props => [data];
}
