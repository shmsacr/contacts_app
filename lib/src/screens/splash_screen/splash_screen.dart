import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/authentication/authenctication_bloc.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen() : super();
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
          ),
        ],
      ),
      splashIconSize: 350,
      backgroundColor: Colors.blueGrey,
      nextScreen: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationSuccess) {
            return const HomeScreen();
          } else if (state is AuthenticationNotAuthenticated) {
            return const LoginScreen();
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      duration: 2000,
      centered: true,
    );
  }
}
