import 'package:contacts_app/src/core/bloc/authentication/authenctication_bloc.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_event.dart';
import 'package:contacts_app/src/screens/add_contact/add_contact_screen.dart';
import 'package:contacts_app/src/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kartal/kartal.dart';

import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_bloc.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_state.dart';
import 'package:contacts_app/src/core/data/model/contacts.dart';
import 'package:contacts_app/src/screens/login/login_screen.dart';

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
        if (state is ContactsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ContactsLoadedState) {
          List<Contacts> userList = state.users;
          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                  child: Container(color: Color(0xff072027)),
                ),
                _Positioned(userList: userList),
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
            onPressed: (_) => _showAlertDialog(context, isdata),
            backgroundColor: Colors.red,
            icon: Icons.delete,
          )
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
              isdata.kisi_ad,
            ),
            subtitle: Text(
              isdata.kisi_tel,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            trailing: Text(isdata.city_name! + " / " + isdata.town_name!)),
      ),
    );
  }

  _showAlertDialog(BuildContext context, Contacts isdata) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kişi Sil"),
          content: Text("Kişiyi silmek istediğinize emin misiniz?"),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Sil"),
              onPressed: () async {
                BlocProvider.of<ContactsBloc>(context)
                    .add(DeleteUserEvent(data: isdata));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _Positioned extends StatelessWidget {
  const _Positioned({
    super.key,
    required this.userList,
  });

  final List<Contacts> userList;

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
              AuthenticationBloc authBloc =
                  BlocProvider.of<AuthenticationBloc>(context);
              authBloc.add(LoggedOutEvent());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
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
