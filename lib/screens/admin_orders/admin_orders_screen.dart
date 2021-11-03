import 'package:flutter/material.dart';
import 'package:loja_virtual_2_0/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual_2_0/common/custom_icon_button.dart';
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
          final filteredOrders = ordersManager.filteredOrders;

          return Column(
            children: [
              if(ordersManager.userFilter != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Pedido de ${ordersManager.userFilter.name}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white
                          ),
                        ),
                      ),
                      CustomIconButton(
                        iconData: Icons.close,
                        color: Colors.white,
                        onTap: (){
                          ordersManager.setUserFilter(null);
                        },
                      )
                    ],
                  ),
                ),
              if(filteredOrders.isEmpty)
                const Expanded(
                  child: EmptyCard(
                    title: 'Nenhuma venda realizada!',
                    iconData: Icons.border_clear,
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (_, index){
                        return OrderTile(
                          filteredOrders.reversed.toList()[index],
                          showControls: true,
                        );
                      }
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
