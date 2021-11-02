import 'package:flutter/material.dart';
import 'package:loja_virtual_2_0/models/order.dart';
import 'package:loja_virtual_2_0/screens/orders/components/order_product_tile.dart';

class OrderTile extends StatelessWidget {

  const OrderTile(this.order, {this.showControls = false});

  final Order order;
  final bool showControls;

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'R\$ ${order.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
                order.statusText,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: order.status == Status.canceled
                    ? Colors.red : primaryColor,
                fontSize: 14,
              ),
            )
          ],
        ),
        children: [
          Column(
            children: order.items.map((e) {
              return OrderProductTile(e);
            }).toList(),
          ),
          if(showControls && order.status != Status.canceled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 90,
                    child: TextButton(
                        onPressed: order.cancel,
                        style: TextButton.styleFrom(),
                        child: const Text('Cancelar', style: TextStyle(color: Colors.red),)
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextButton(
                        onPressed: order.back,
                        child: const Text('Recuar')
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextButton(
                        onPressed: order.advance,
                        child: const Text('Avançar')
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextButton(
                        onPressed: (){},
                        child: Text('Endereço', style: TextStyle(color: primaryColor),)
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
