import 'package:cloud_firestore/cloud_firestore.dart';
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
  final Firestore firestore = Firestore.instance;

  User user;

  bool _loading = false;

  bool get loading => _loading;

  bool get isLogged => user != null;

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

      _loadCurrentUser(firebaseUser: result.user);


      onSuccess();
    } on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }


  /**
  método para criar o usuário que recebe como parâmetros opcionais um obj user e duas funções de callback:
  onFail - caso o login dê errado, onSuccess - caso o login de certo.
  */
  Future<void> signUp({User user, Function onFail, Function onSuccess}) async
  {
    loading = true;

    try{
      final AuthResult result = await auth.createUserWithEmailAndPassword(email: user.email, password: user.password);

      //this.user = result.user;

      user.id = result.user.uid;
      this.user = user;

      await user.saveData();

      onSuccess();
    } on PlatformException catch(e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut()
  {
    auth.signOut();
    user = null;
    notifyListeners();
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

  /**
  método privado assíncrono que busca as informações do usuário de acordo com os dados armazenados no Firestore.
  Se a variável currentUSer não for null, a variável user vai receber os dados do usuário logado.
  */
  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async
  {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if(currentUser != null)
    {
      final DocumentSnapshot docUser = await firestore.collection('users')
          .document(currentUser.uid).get();
      
      user = User.fromDocument(docUser);

      notifyListeners();
    }
  }
}