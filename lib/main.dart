import 'package:contacts_app/src/core/model/customUser.dart';
import 'package:contacts_app/src/core/model/user_database_provider.dart';
import 'package:contacts_app/src/screens/login/home_screen.dart'; // Import your HomeScreen
import 'package:contacts_app/src/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserDatabaseProvider databaseProvider = UserDatabaseProvider();
  await databaseProvider.open(); // Initialize the database

  List<CustomUser> users = await databaseProvider.getAllUsers();
  Widget homeScreen = users.isNotEmpty ? HomeScreen() : LoginScreen();

  runApp(MyApp(homeScreen: homeScreen));
}

class MyApp extends StatelessWidget {
  final Widget homeScreen;

  MyApp({required this.homeScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: homeScreen,
      ),
    );
  }
}
