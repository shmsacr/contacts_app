part of 'custom_user_bloc.dart';

@immutable
abstract class CustomUserEvent extends Equatable {}

class LoadCustomUserEvent extends CustomUserEvent {
  final LoginData? data;
  LoadCustomUserEvent({this.data});
  @override
  List<Object> get props => [data ?? ''];
}
