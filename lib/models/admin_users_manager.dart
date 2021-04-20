import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual_2_0/models/user.dart';
import 'package:loja_virtual_2_0/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier{

  List<User> users = [];

  final Firestore firestore = Firestore.instance;

  void updateUser(UserManager userManager)
  {
    if(userManager.adminEnabled){
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers()
  {
    firestore.collection('users').getDocuments().then((snapshot) {
      users = snapshot.documents.map((e) => User.fromDocument(e)).toList();
      users.sort((a,b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.name).toList();

}