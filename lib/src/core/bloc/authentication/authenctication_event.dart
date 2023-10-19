part of 'authenctication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class AppLoaded extends AuthenticationEvent {}

class LoggedInEvent extends AuthenticationEvent {
  final User data;
  const LoggedInEvent({required this.data});
  @override
  List<Object> get props => [data];
}

class LoggedOutEvent extends AuthenticationEvent {}
