import 'package:flutter/material.dart';
import 'package:loja_virtual_2_0/common/empty_card.dart';
import 'package:loja_virtual_2_0/common/login_card.dart';
import 'package:loja_virtual_2_0/common/price_card.dart';
import 'package:loja_virtual_2_0/models/cart_manager.dart';
import 'package:loja_virtual_2_0/screens/cart/components/cart_tile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __){
          if(cartManager.user == null){
            return LoginCard();
          }
          if(cartManager.items.isEmpty){
            return EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum Produto no carrinho!',
            );
          }
          return ListView(
            children: [
              Column(
                children: cartManager.items.map(
                        (cartProduct) => CartTile(cartProduct)
                ).toList(),
              ),
              PriceCard(
                buttonText: 'Continuar para Entrega',
                onPressed: cartManager.isCartValid ? ()
                    {
                    Navigator.of(context).pushNamed('/address');
                    }
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
