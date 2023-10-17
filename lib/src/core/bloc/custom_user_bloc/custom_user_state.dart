part of 'custom_user_bloc.dart';

abstract class CustomUserState extends Equatable {
  const CustomUserState();
}

class CustomUserLoading extends CustomUserState {
  @override
  List<Object> get props => [];
}

class CustomUserLoaded extends CustomUserState {
  final LoginData user;
  CustomUserLoaded({required this.user});
  @override
  List<Object> get props => [user];
}
