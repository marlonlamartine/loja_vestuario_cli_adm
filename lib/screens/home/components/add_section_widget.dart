import 'package:flutter/material.dart';
import 'package:loja_virtual_2_0/models/home_manager.dart';
import 'package:loja_virtual_2_0/models/section.dart';

class AddSectionWidget extends StatelessWidget {

  const AddSectionWidget({this.homeManager});

  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
            child: TextButton(
              onPressed: (){
                homeManager.addSection(Section(type: 'List'));
              },
              child: const Text('Adicionar Lista'),
              style: TextButton.styleFrom(
                primary: Colors.white
              ),
            ),
        ),
        Expanded(
          child: TextButton(
            onPressed: (){
              homeManager.addSection(Section(type: 'Staggered'));
            },
            child: const Text('Adicionar Grade'),
            style: TextButton.styleFrom(
                primary: Colors.white
            ),
          ),
        ),
      ],
    );
  }
}
