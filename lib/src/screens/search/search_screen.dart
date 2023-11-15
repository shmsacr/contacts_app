import 'package:flutter/material.dart';

import '../../core/data/model/contacts.dart';

class SearchScreen extends SearchDelegate<Contacts> {
  final List<Contacts> contacts;
  SearchScreen({required this.contacts});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(
              context,
              const Contacts(
                  city_id: 0,
                  cinsiyet: 0,
                  kisi_ad: "",
                  city_name: "",
                  resim: "",
                  town_id: 0,
                  town_name: "",
                  kisi_tel: "",
                  kisi_id: 0));
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return customListViewBuilder(contacts: contacts);
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<Contacts> matchQuery = [];

    for (var fruit in contacts) {
      var nameMatch =
          fruit.kisi_ad.toLowerCase().startsWith(query.toLowerCase());
      var cityMatch =
          fruit.city_name!.toLowerCase().startsWith(query.toLowerCase());
      var genderMatch =
          (query.toLowerCase().startsWith("erkek") && fruit.cinsiyet == 1) ||
              (query.toLowerCase().startsWith("kadin") && fruit.cinsiyet == 2);

      if (nameMatch || cityMatch || genderMatch) {
        matchQuery.add(fruit);
      }
    }
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return customListViewBuilder(contacts: matchQuery);
    });
  }
}

class customListViewBuilder extends StatelessWidget {
  const customListViewBuilder({
    super.key,
    required this.contacts,
  });

  final List<Contacts> contacts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final isdata = contacts[index];
          return Card(
            elevation: 10,
            child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isdata.cinsiyet == 1
                      ? Colors.blueAccent
                      : Colors.pinkAccent,
                  child: Icon(Icons.person),
                ),
                title: Text(
                  isdata.kisi_ad,
                ),
                subtitle: Text(
                  isdata.kisi_tel,
                  style: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w600),
                ),
                trailing: Text(isdata.city_name! + " / " + isdata.town_name!)),
          );
        });
  }
}
