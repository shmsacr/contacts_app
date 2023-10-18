import 'package:bloc/bloc.dart';
import 'package:contacts_app/src/core/model/user.dart';
import 'package:contacts_app/src/core/repository/user/user_repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authenctication_event.dart';
part 'authenctication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc(this.userRepository) : super(AuthenticationInitial());
  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    yield AuthenticationLoading();

    if (event is LoggedInEvent) {
      try {
        final user = await userRepository.getUser(event.data);
        if (user != null) yield AuthenticationSuccess(data: user);
      } catch (e) {
        yield AuthenticationFailure(error: e.toString());
      }
    }
    if (event is LoggedOutEvent) {
      try {
        await userRepository.singOut();
        yield AuthenticationFailure(error: "Kullanıcı silindi");
      } catch (e) {
        yield AuthenticationFailure(error: e.toString());
      }
    }
  }
}
