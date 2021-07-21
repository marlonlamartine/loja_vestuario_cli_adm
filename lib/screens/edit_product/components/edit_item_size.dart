import 'package:flutter/material.dart';
import 'package:loja_virtual_2_0/common/custom_icon_button.dart';
import 'package:loja_virtual_2_0/models/item_size.dart';

class EditItemSize extends StatelessWidget {

  const EditItemSize({Key key, this.size, this.onRemove, this.onMoveup, this.onMovedown}) : super(key: key);

  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveup;
  final VoidCallback onMovedown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration: const InputDecoration(
              labelText: 'Título',
              isDense: true
            ),
            validator: (name){
              if(name.isEmpty){
                return 'Inválido';
              }
              return null;
            },
            onChanged: (name) => size.name = name,
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            decoration: const InputDecoration(
                labelText: 'Estoque',
                isDense: true
            ),
            validator: (stock){
              if(int.tryParse(stock) == null){
                return 'Inválido';
              }
              return null;
            },
            onChanged: (stock) => size.stock = int.tryParse(stock),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
                labelText: 'Preço',
                isDense: true,
                prefixText: 'R\$ '
            ),
            validator: (price){
              if(num.tryParse(price) == null){
                return 'Inválido';
              }
              return null;
            },
            onChanged: (price) => size.price = num.tryParse(price),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveup,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMovedown,
        ),
      ],
    );
  }
}
