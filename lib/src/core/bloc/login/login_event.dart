part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginButtonPressedEvent extends LoginEvent {
  final User data;
  const LoginButtonPressedEvent({required this.data});
  @override
  List<Object> get props => [data];
}
