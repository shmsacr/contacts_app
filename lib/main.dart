import 'package:contacts_app/src/core/bloc/authentication/authenctication_bloc.dart';
import 'package:contacts_app/src/core/bloc/city_bloc/city_bloc.dart';
import 'package:contacts_app/src/core/bloc/city_bloc/city_event.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_bloc.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_event.dart';
import 'package:contacts_app/src/core/bloc/town_bloc.dart';
import 'package:contacts_app/src/core/data/repository/user/user_repository/user_repository.dart';
import 'package:contacts_app/src/core/data/repository/user/user_repository/user_repository_impl.dart';
import 'package:contacts_app/src/core/data/service/city_service/city_service.dart';
import 'package:contacts_app/src/core/data/service/city_service/city_service_impl.dart';
import 'package:contacts_app/src/screens/home/home_screen.dart'; // Import your HomeScreen
import 'package:contacts_app/src/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    RepositoryProvider<UserRepository>(
      create: (context) {
        return UserRepositoryImpl();
      },
      child: MultiBlocProvider(
        providers: [
          RepositoryProvider<CityService>(
            create: (context) => CityServiceImpl(),
          ),
          BlocProvider<ContactsBloc>(
            create: (ctx) {
              return ContactsBloc()
                ..add(
                  LoadUserEvent(),
                );
            },
          ),
          BlocProvider<CityBloc>(
            create: (ctx) {
              return CityBloc()
                ..add(
                  LoadCityEvent(),
                );
            },
          ),
          BlocProvider<AuthenticationBloc>(
            create: (ctx) {
              final repository = RepositoryProvider.of<UserRepository>(ctx);
              return AuthenticationBloc(repository)..add(AppLoaded());
            },
          ),
          BlocProvider<TownBloc>(create: (ctx) {
            return TownBloc();
          }),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationSuccess) {
            return HomeScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}
