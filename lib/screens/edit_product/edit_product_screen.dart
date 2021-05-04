import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_2_0/models/product.dart';
import 'package:loja_virtual_2_0/screens/edit_product/components/images_form.dart';
import 'package:loja_virtual_2_0/screens/edit_product/components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {

  EditProductScreen(this.product);

  final Product product;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Anúncio'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            ImagesForm(product),
            Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: product.name,
                  decoration: const InputDecoration(
                      hintText: 'Título',
                      border: InputBorder.none
                  ),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                  validator: (name){
                    if(name.length < 6){
                      return 'Título muito curto';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'A partir de',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13
                    ),
                  ),
                ),
                Text(
                  'R\$ ...',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                TextFormField(
                  initialValue: product.description,
                  style: const TextStyle(
                    fontSize: 16
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Descrição',
                    border: InputBorder.none
                  ),
                  maxLines: null,
                  validator: (desc){
                    if(desc.length < 10){
                      return 'Descrição muito curta';
                    }
                    return null;
                  },
                ),
                SizesForm(product),
                ElevatedButton(
                    onPressed: (){
                      if(formKey.currentState.validate()){
                        print('válido');
                      }
                    },
                    child: const Text('Salvar')
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}