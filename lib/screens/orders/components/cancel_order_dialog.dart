import 'package:flutter/material.dart';
import 'package:loja_virtual_2_0/models/order.dart';

class CancelOrderDialog extends StatelessWidget {

  const CancelOrderDialog(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar pedido ${order.formattedId}?'),
      content: const Text('Esta ação não poderá ser desfeita!'),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text('Não vou cancelar!'),
        ),
        TextButton(
          onPressed: (){
            order.cancel();
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar Pedido?',
          style: TextStyle(color: Colors.red),),
        ),
      ],
    );
  }
}
