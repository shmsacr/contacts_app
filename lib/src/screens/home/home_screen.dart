import 'package:contacts_app/src/core/model/contacts.dart';
import 'package:contacts_app/src/screens/add_contact/add_contact_screen.dart';
import 'package:contacts_app/src/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kartal/kartal.dart';

import '../../core/bloc/contacts_bloc/contacts_bloc.dart';
import '../../core/bloc/contacts_bloc/contacts_state.dart';
import '../../core/model/user_database_provider.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserLoadedState) {
          List<Contacts> userList = state.users;
          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                  child: Container(color: Color(0xff072027)),
                ),
                Positioned(
                  top: context.general.mediaQuery.size.height * 0.035,
                  left: context.general.mediaQuery.size.width * 0.75,
                  right: 0,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: SearchScreen(contacts: userList));
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          int userId = 1;

                          UserDatabaseProvider databaseProvider =
                              UserDatabaseProvider();
                          bool success =
                              await databaseProvider.deleteUser(userId);

                          if (success) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                              (route) => false,
                            );
                          } else {
                            print('Failed to delete user');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                _AddUserIconButton(),
                _TextAppTitle(),
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Card(
                    color: Color(0xff003344),
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: context.padding.low,
                        child: ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            final user = userList[index];
                            return buildPadding(context, user);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
      },
    );
  }

  Widget buildPadding(BuildContext context, Contacts isdata) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: Colors.red,
            icon: Icons.delete,
          ),
          SlidableAction(
            onPressed: (context) {
              Navigator.push(
                context,
                MaterialPageRoute<AddContactScreen>(
                  builder: (context) => AddContactScreen(
                    contacts: isdata,
                  ),
                ),
              );
            },
            backgroundColor: Colors.orange,
            icon: Icons.edit,
          ),
        ],
      ),
      child: Card(
        elevation: 10,
        child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  isdata.cinsiyet == 1 ? Colors.blueAccent : Colors.pinkAccent,
              child: Icon(Icons.person),
            ),
            title: Text(
              isdata.kisi_ad!,
            ),
            subtitle: Text(
              isdata.kisi_tel!,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            trailing: Text(isdata.city_name + " / " + isdata.town_name)),
      ),
    );
  }
}

class _AddUserIconButton extends StatelessWidget {
  const _AddUserIconButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.general.mediaQuery.size.height * 0.035,
      right: context.general.mediaQuery.size.width * 0.9,
      left: 0,
      child: IconButton(
        icon: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddContactScreen()),
          );
        },
      ),
    );
  }
}

class _TextAppTitle extends StatelessWidget {
  const _TextAppTitle();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.general.mediaQuery.size.height * 0.035,
      right: 0,
      left: 0,
      child: Align(
          alignment: Alignment.center,
          child: Text(
            "AREGON",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          )),
    );
  }
}
