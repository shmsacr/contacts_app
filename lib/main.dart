import 'package:contacts_app/src/core/bloc/authentication/authenctication_bloc.dart';
import 'package:contacts_app/src/core/bloc/city_bloc/city_bloc.dart';
import 'package:contacts_app/src/core/bloc/city_bloc/city_event.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_bloc.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_event.dart';
import 'package:contacts_app/src/core/bloc/town/town_bloc.dart';
import 'package:contacts_app/src/core/data/repository/user/user_repository/user_repository.dart';
import 'package:contacts_app/src/core/data/repository/user/user_repository/user_repository_impl.dart';
import 'package:contacts_app/src/core/data/service/city_service/city_service.dart';
import 'package:contacts_app/src/core/data/service/city_service/city_service_impl.dart';
import 'package:contacts_app/src/screens/splash_screen/splash_screen.dart';
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
      home: SplashScreen(),
    );
  }
}
