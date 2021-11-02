import 'package:flutter/material.dart';
import 'package:loja_virtual_2_0/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual_2_0/common/empty_card.dart';
import 'package:loja_virtual_2_0/models/admin_orders_manager.dart';
import 'package:loja_virtual_2_0/common/order_tile.dart';
import 'package:provider/provider.dart';

class AdminOrdersScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Todos os Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __){
          if(ordersManager.orders.isEmpty){
            return const EmptyCard(
              title: 'Nenhuma venda realizada!',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
              itemCount: ordersManager.orders.length,
              itemBuilder: (_, index){
                return OrderTile(
                    ordersManager.orders.reversed.toList()[index],
                  showControls: true,
                );
              }
          );
        },
      ),
    );
  }
}
