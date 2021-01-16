import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual_2_0/helpers/firebase_errors.dart';
import 'package:loja_virtual_2_0/models/user.dart';

class UserManager extends ChangeNotifier{

  UserManager()
  {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseUser user;

  bool _loading = false;

  bool get loading => _loading;

  /*
  método para logar o usuário que recebe como parâmetros opcionais um obj user e duas funções de callback:
  onFail - caso o login dê errado, onSuccess - caso o login de certo.
  */
  Future<void> signIn({User user, Function onFail, Function onSuccess}) async
  {
    loading = true;

    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      this.user = result.user;

      onSuccess();
    } on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  /*
  método recebe um valor bool como parâmetro, modifica o valor da var privada _loading com o valor do parâmetro
  e chama o método notifyListeners().
  */
  set loading(bool value)
  {
    _loading = value;
    notifyListeners();
  }

  /*
  método privado assíncrono que autentica o usuário de acordo com a instância da variável auth e insere numa variável do tipo
  FirebaseUser. Se a variável currentUSer não for null a variável user recebe o currentUSer.
  */
  Future<void> _loadCurrentUser() async
  {
    final FirebaseUser currentUser = await auth.currentUser();
    if(currentUser != null)
    {
      user = currentUser;
    }
    notifyListeners();
  }
}