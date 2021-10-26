import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual_2_0/models/order.dart';
import 'package:loja_virtual_2_0/models/user.dart';
import 'package:loja_virtual_2_0/models/user_manager.dart';

class OrdersManager extends ChangeNotifier{

  User user;

  List<Order> orders = [];

  final Firestore firestore = Firestore.instance;

  void updateUser(User user){
    this.user = user;

    if(user != null){
      _listenToOrders();
    }
  }

  void _listenToOrders(){
    firestore.collection('orders')
        .where('user', isEqualTo: user.id)
        .snapshots().listen(
            (event) {
              orders.clear();
              for(final doc in event.documents){
                orders.add(Order.fromDocument(doc));
              }
              print(orders);
    });
  }

}