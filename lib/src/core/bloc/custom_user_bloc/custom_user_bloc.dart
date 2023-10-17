import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login/flutter_login.dart';

import '../../repository/custom_user/custom_user.dart';

part 'custom_user_event.dart';
part 'custom_user_state.dart';

class CustomUserBloc extends Bloc<CustomUserEvent, CustomUserState> {
  final CustomUserRepository _customUserRepository;
  CustomUserBloc(this._customUserRepository) : super(CustomUserLoading()) {
    on<LoadCustomUserEvent>(_loadCustomUserEvent);
  }

  FutureOr<void> _loadCustomUserEvent(
      LoadCustomUserEvent event, Emitter<CustomUserState> emit) async {
    try {
      emit(CustomUserLoading());
      final user = await _customUserRepository.addUser(event.data!);
      emit(CustomUserLoaded(user: user));
    } catch (e) {
      print(e.toString());
    }
  }
}
