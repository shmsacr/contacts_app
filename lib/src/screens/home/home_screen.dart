import 'package:contacts_app/src/core/bloc/authentication/authenctication_bloc.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_bloc.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_event.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_state.dart';
import 'package:contacts_app/src/core/data/model/contacts.dart';
import 'package:contacts_app/src/screens/add_contact/add_contact_screen.dart';
import 'package:contacts_app/src/screens/login/login_screen.dart';
import 'package:contacts_app/src/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kartal/kartal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      BlocProvider.of<ContactsBloc>(context).add(const ContactsFetch());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * .9);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        switch (state.status) {
          case ContactStatus.failure:
            return const Center(
              child: Text('Something went wrong!'),
            );
          case ContactStatus.success:
            if (state.contact.isEmpty) {
              return const Center(
                child: Text('No Data'),
              );
            }
            return Stack(
              children: [
                Positioned(
                  child: Container(color: const Color(0xff072027)),
                ),
                _Positioned(userList: state.contact),
                const _AddUserIconButton(),
                const _TextAppTitle(),
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Card(
                    color: const Color(0xff003344),
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: context.padding.low,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: state.hasReachedMax
                              ? state.contact.length
                              : state.contact.length + 1,
                          itemBuilder: (context, index) {
                            if (index < state.contact.length) {
                              final user = state.contact[index];
                              return buildPadding(context, user);
                            } else {
                              // Loading indicator for infinite scrolling
                              return const IndicatorWidget();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    ));
  }

  Widget buildPadding(BuildContext context, Contacts isdata) {
    Color _textColor = Colors.white;
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
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
            onTap: () {
              showModalBottomSheet<void>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Stack(
                          children: [
                            Container(
                              color: const Color(0xff003344),
                              margin: const EdgeInsets.only(top: 100),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isdata.kisi_ad,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: _textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    isdata.kisi_tel,
                                    style: TextStyle(
                                      color: _textColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${isdata.city_name!} / ${isdata.town_name!}",
                                    style: TextStyle(
                                      color: _textColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 50,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: isdata.cinsiyet == 1
                                ? Colors.blueAccent
                                : Colors.pinkAccent,
                            child: const Icon(Icons.person, size: 50),
                          ),
                        ),
                      ],
                    );
                  });
            },
            leading: CircleAvatar(
              backgroundColor:
                  isdata.cinsiyet == 1 ? Colors.blueAccent : Colors.pinkAccent,
              child: const Icon(Icons.person),
            ),
            title: Text(
              isdata.kisi_ad,
            ),
            subtitle: Text(
              isdata.kisi_tel,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            trailing: Text("${isdata.city_name!} / ${isdata.town_name!}")),
      ),
    );
  }

  _showAlertDialog(BuildContext context, Contacts isdata) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Kişi Sil"),
          content: const Text("Kişiyi silmek istediğinize emin misiniz?"),
          actions: [
            TextButton(
              child: const Text("İptal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Sil"),
              onPressed: () async {
                BlocProvider.of<ContactsBloc>(context)
                    .add(DeleteContactEvent(data: isdata));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 33,
        height: 33,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
        ),
      ),
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
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              showSearch(
                  context: context, delegate: SearchScreen(contacts: userList));
            },
          ),
          IconButton(
            icon: const Icon(
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
        icon: const Icon(Icons.add, color: Colors.white),
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
      child: const Align(
          alignment: Alignment.center,
          child: Text(
            "AREGON",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          )),
    );
  }
}
