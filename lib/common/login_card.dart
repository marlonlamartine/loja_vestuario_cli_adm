import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.account_circle,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Faça login para acessar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed('/login');
                },
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      primary: Theme.of(context).primaryColor,
                  ),
                child: const Text('LOGIN'),

              )
            ],
          ),
        ),
      ),
    );
  }
}
