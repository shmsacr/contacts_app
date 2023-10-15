import 'package:contacts_app/src/core/model/customUser.dart';
import 'package:contacts_app/src/core/model/user_database_provider.dart';
import 'package:contacts_app/src/core/repository/contacts/user_repository.dart';
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
    RepositoryProvider<UserRepository>(
        create: (context) {
          return UserRepository();
        },
        child: MyApp(homeScreen: homeScreen)),
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
