import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual_2_0/models/order.dart';

class AdminOrdersManager extends ChangeNotifier{

  List<Order> orders = [];

  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  void updateAdmin({bool adminEnabled}){
    orders.clear();

    //caso ocorra mudança de user, cancela e refaz a lista
    _subscription?.cancel();
    if(adminEnabled){
      _listenToOrders();
    }
  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders')
        .snapshots().listen(
            (event) {
          orders.clear();
          for(final doc in event.documents){
            orders.add(Order.fromDocument(doc));
          }
          notifyListeners();
        });
  }

  //caso o subscription nunca tenha acontecido é nulo e pode dar problema
  @override
  void dispose() {
    super.dispose();
    _subscription ?.cancel();
  }
}