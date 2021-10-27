import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual_2_0/models/cart_manager.dart';
import 'package:loja_virtual_2_0/models/order.dart';
import 'package:loja_virtual_2_0/models/product.dart';

class CheckoutManager extends ChangeNotifier{

  CartManager cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }
  
  final Firestore firestore = Firestore.instance;

  //ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager){
    this.cartManager = cartManager;
  }

  Future<void> checkout({Function onStockFail, Function onSucess}) async{
    loading = true;

    //verifica se tem estoque e então decrementa
    try{
      await _decrementStock();
    } catch (e){
      onStockFail(e);
      loading = false;
      return;
    }

    //TODO: Processar Pagamento

    //gera um numero unico do pedido
    final orderId = await _getOrderId();

    final order = Order.fromCartManager(cartManager);
    //atribuindo o numero do pedido ao atributo do objeto do pedido
    order.orderId = orderId.toString();

    //salvando o pedido completo
    await order.save();

    //limpando o carrinho
    cartManager.clear();

    onSucess(order);
    loading = false;
  }
  
  Future<int> _getOrderId() async {
    final ref = firestore.document('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc.data['current'] as int;
        await tx.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  Future<void> _decrementStock(){
    // 1. Ler todos os estoques
    // 2. Decremento localmente os estoques
    // 3. Salvar os estoquesno firebase

    return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      //laço que verifica cada produto do carrinho
      for(final cartProduct in cartManager.items){

        Product product;
        //verifica se o produto ja existe (por causa do tamanho diferente)
        //na lista productsToUpdate
        if(productsToUpdate.any((p) => p.id == cartProduct.productId)){
          //se existir, pega o mesmo produto da lista e n do firebase
          product = productsToUpdate.firstWhere(
                  (p) => p.id == cartProduct.productId);
        }
        else {
          //senão, procura o produto no firebase pelo id dele
          final doc = await tx.get(
              firestore.document('products/${cartProduct.productId}')
          );
          //obtem o produto atualizado do firebase
          product = Product.fromDocument(doc);
        }

        //atualiza o valor real dos estoques no objeto produto do carrinho
        cartProduct.product = product;

        //obtem o tamanho do produto
        final size = product.findSize(cartProduct.size);
        //compara o estoque com a quantidade no carrinho
        if(size.stock - cartProduct.quantity < 0){
          productsWithoutStock.add(product);
        }
        //se tiver disponivel, decrementa a quantidade do carrinho no estoque
        else{
          size.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if(productsWithoutStock.isNotEmpty){
        return Future.error(''
            '${productsWithoutStock.length} produtos sem estoque');
      }

      for(final product in productsToUpdate){
        tx.update(firestore.document('products/${product.id}'),
            {'sizes' : product.exportSizeList()});
      }

    });
  }
}