import 'package:contacts_app/src/core/model/contacts.dart';
import 'package:flutter/material.dart';

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
    List<Contacts> matchQuery = [];
    for (var fruit in contacts) {
      if ((fruit.kisi_ad!.toLowerCase().contains(query.toLowerCase()) ||
              fruit.city_name!.toLowerCase().contains(query.toLowerCase())) &&
          (query.toLowerCase().contains('erkek') && fruit.cinsiyet == 1 ||
              query.toLowerCase().contains('kadın') && fruit.cinsiyet == 2)) {
        matchQuery.add(fruit);
      }
    }
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            final isdata = matchQuery[index];
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
                    isdata.kisi_ad!,
                  ),
                  subtitle: Text(
                    isdata.kisi_tel!,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  trailing:
                      Text(isdata.city_name! + " / " + isdata.town_name!)),
            );
          });
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<Contacts> matchQuery = [];
    for (var fruit in contacts) {
      if ((fruit.kisi_ad!.toLowerCase().contains(query.toLowerCase()) ||
              fruit.city_name!.toLowerCase().contains(query.toLowerCase())) &&
          (query.toLowerCase().contains('erkek') && fruit.cinsiyet == 1 ||
              query.toLowerCase().contains('kadın') && fruit.cinsiyet == 2)) {
        matchQuery.add(fruit);
      }
    }
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            final isdata = matchQuery[index];
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
                    isdata.kisi_ad!,
                  ),
                  subtitle: Text(
                    isdata.kisi_tel!,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  trailing:
                      Text(isdata.city_name! + " / " + isdata.town_name!)),
            );
          });
    });
  }
}
