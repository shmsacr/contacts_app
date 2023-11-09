import 'dart:io';

import '../../model/contacts.dart';
import '../../model/user.dart';

abstract class ContactService {
  Future<List<Contacts>> getUsers(User user, [int page = 1]);
  Future<bool> addUserWithImage(User user, Contacts contacts, File? imageFile);
  Future<bool> deleteContact(User user, Contacts contacts);
}
