import 'package:flutter/material.dart';
import 'package:loja_virtual_2_0/common/price_card.dart';
import 'package:loja_virtual_2_0/models/cart_manager.dart';
import 'package:loja_virtual_2_0/screens/adress/components/address_card.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Endereço de Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AddressCard(),
          Consumer<CartManager>(
              builder: (_, cartManager, __){
                return PriceCard(
                  buttonText: 'Continuar para o pagamento',
                  onPressed: cartManager.isAddresValid ? (){

                  } : null,
                );
              }
          ),
        ],
      ),
    );
  }
}
