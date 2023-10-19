part of 'authenctication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  final User data;
  const AuthenticationSuccess({required this.data});
  @override
  List<Object> get props => [data];
}

class AuthenticationNotAuthenticated extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String error;
  const AuthenticationFailure({required this.error});
  @override
  List<Object> get props => [error];
}
