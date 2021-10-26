import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual_2_0/models/address.dart';
import 'package:loja_virtual_2_0/models/cart_manager.dart';
import 'package:loja_virtual_2_0/models/cart_product.dart';

class Order{

  Order.fromCartManager(CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
  }

  final Firestore firestore = Firestore.instance;

  String orderId;
  List<CartProduct> items;
  num price;
  String userId;
  Address address;
  Timestamp date;

  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData(
      {
        'items': items.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'user': userId,
        'address': address.toMap(),
      }
    );
  }
}