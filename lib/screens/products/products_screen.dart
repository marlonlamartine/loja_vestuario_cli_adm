import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_2_0/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual_2_0/models/product_manager.dart';
import 'package:loja_virtual_2_0/models/user_manager.dart';
import 'package:loja_virtual_2_0/screens/products/components/product_list_tile.dart';
import 'package:loja_virtual_2_0/screens/products/components/search.dialog.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (_, productManager,__){
            if (productManager.search.isEmpty){
              return const Text('Produtos');
            }
            else{
              return LayoutBuilder(
                builder: (_, constraints){
                  return GestureDetector(
                    onTap: () async{
                      final search = await showDialog<String>(context: context,
                          builder: (_) => SearchDialog(
                            productManager.search
                          ));
                      if(search != null){
                        productManager.search = search;
                      }
                    },
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                            productManager.search,
                            textAlign: TextAlign.center,
                        )
                    ),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: [
          Consumer<ProductManager>(
            builder: (_, productManager, __){
              if(productManager.search.isEmpty){
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async{
                    final search = await showDialog<String>(context: context,
                        builder: (_) => SearchDialog(
                          productManager.search
                        ));
                    if(search != null){
                      productManager.search = search;
                    }
                  },
                );
              }
              else {
                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async{
                      productManager.search = '';
                  },
                );
              }
            },
          ),
          Consumer<UserManager>(
            builder: (_, userManager, __){
              if(userManager.adminEnabled){
                return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: (){
                      Navigator.of(context).pushNamed('/edit_product',);
                    }
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __){
          final filteredProducts = productManager.filteredProducts;
          return ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (_, index){
                return ProductListTile(filteredProducts[index]);
              }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          Navigator.of(context).pushNamed('/cart');
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
