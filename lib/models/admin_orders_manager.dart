import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual_2_0/models/order.dart';
import 'package:loja_virtual_2_0/models/user.dart';

class AdminOrdersManager extends ChangeNotifier{

  final List<Order> _orders = [];

  User userFilter;
  List<Status> statusFilter = [Status.preparing];

  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  void updateAdmin({bool adminEnabled}){
    _orders.clear();

    //caso ocorra mudança de user, cancela e refaz a lista
    _subscription?.cancel();
    if(adminEnabled){
      _listenToOrders();
    }
  }

  List<Order> get filteredOrders {
    List<Order> output = _orders.reversed.toList();

    if(userFilter != null){
      output = output.where((o) => o.userId == userFilter.id).toList();
    }

    return output = output.where((o) => statusFilter.contains(o.status)).toList();

  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders')
        .snapshots().listen(
            (event) {
          for(final change in event.documentChanges){
            //verifica qual mudança ocorreu e aplica uma ação
            switch(change.type){
              case DocumentChangeType.added:
                _orders.add(
                  Order.fromDocument(change.document)
                );
                break;
              case DocumentChangeType.modified:
                //busca qual documento sofreu modificação
                final modOrder = _orders.firstWhere(
                        (o) => o.orderId == change.document.documentID);
                modOrder.updateFromDocument(change.document);
                break;
              case DocumentChangeType.removed:
                debugPrint('Deu problema sério');
                break;
            }
          }
          notifyListeners();
        });
  }

  void setUserFilter(User user){
    userFilter = user;
    notifyListeners();
  }

  void setStatusFilter({Status status, bool enabled}){
    if(enabled){
      statusFilter.add(status);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  //caso o subscription nunca tenha acontecido é nulo e pode dar problema
  @override
  void dispose() {
    super.dispose();
    _subscription ?.cancel();
  }
}