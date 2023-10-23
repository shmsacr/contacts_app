import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import '../../core/bloc/authentication/authenctication_bloc.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  final AuthenticationState state;
  SplashScreen({required this.state}) : super();
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
      nextScreen: state is AuthenticationSuccess ? HomeScreen() : LoginScreen(),
      duration: 2000,
      centered: true,
    );
  }
}
