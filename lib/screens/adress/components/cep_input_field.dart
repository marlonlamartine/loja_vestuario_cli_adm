import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual_2_0/common/custom_icon_button.dart';
import 'package:loja_virtual_2_0/models/address.dart';
import 'package:loja_virtual_2_0/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputfield extends StatefulWidget {

  const CepInputfield(this.address);

  final Address address;


  @override
  _CepInputfieldState createState() => _CepInputfieldState();
}

class _CepInputfieldState extends State<CepInputfield> {

  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final primaryColor = Theme.of(context).primaryColor;

    if(widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !cartManager.loading,
            controller: cepController,
            decoration: const InputDecoration(
                isDense: true,
                labelText: 'CEP',
                hintText: '12.345-678'
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: (cep) {
              if (cep.isEmpty) {
                return 'Campo Obrigatório';
              }
              else if (cep.length != 10) {
                return 'Cep Inválido';
              }
              return null;
            },
          ),
          if(cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          ElevatedButton(
              onPressed: !cartManager.loading ? () async {
                if (Form.of(context).validate()) {
                  try {
                   await context.read<CartManager>().getAddress(cepController.text);
                  } catch (e){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$e'),
                          backgroundColor: Colors.red,
                        )
                    );
                  }
                }
              } : null,
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(color: Colors.white),
                  primary: primaryColor,
                  onSurface: primaryColor.withAlpha(100)
              ),
              child: const Text('Buscar CEP')
          )
        ],
      );
    }
    else{
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              size: 20,
              onTap: (){
                context.read<CartManager>().removeAddress();
              },
            ),
          ],
        ),
      );
    }
  }
}
