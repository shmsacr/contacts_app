import 'package:contacts_app/src/core/bloc/city_bloc/city_bloc.dart';
import 'package:contacts_app/src/core/bloc/city_bloc/city_event.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/user_bloc.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/user_event.dart';
import 'package:contacts_app/src/core/bloc/custom_user_bloc/custom_user_bloc.dart';
import 'package:contacts_app/src/core/model/customUser.dart';
import 'package:contacts_app/src/core/model/user_database_provider.dart';
import 'package:contacts_app/src/core/repository/city/city_repository.dart';
import 'package:contacts_app/src/core/repository/custom_user/custom_user.dart';
import 'package:contacts_app/src/screens/home/home_screen.dart'; // Import your HomeScreen
import 'package:contacts_app/src/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserDatabaseProvider databaseProvider = UserDatabaseProvider();
  await databaseProvider.open(); // Initialize the database
  List<CustomUser> users = await databaseProvider.getAllUsers();
  Widget homeScreen = users.isNotEmpty ? HomeScreen() : LoginScreen();

  runApp(
    RepositoryProvider<CustomUserRepository>(
        create: (context) {
          return CustomUserRepository();
        },
        child: MultiBlocProvider(providers: [
          RepositoryProvider<CityRepository>(
              create: (context) => CityRepository()),
          BlocProvider<UserBloc>(
            create: (ctx) {
              return UserBloc()..add(LoadUserEvent());
            },
          ),
          BlocProvider<CityBloc>(create: (ctx) {
            return CityBloc()..add(LoadCityEvent());
          }),
          BlocProvider<CustomUserBloc>(create: (ctx) {
            final repository = RepositoryProvider.of<CustomUserRepository>(ctx);
            return CustomUserBloc(repository)..add(LoadCustomUserEvent());
          }),
        ], child: MyApp(homeScreen: homeScreen))),
  );
}

class MyApp extends StatelessWidget {
  final Widget homeScreen;

  MyApp({required this.homeScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeScreen,
    );
  }
}
