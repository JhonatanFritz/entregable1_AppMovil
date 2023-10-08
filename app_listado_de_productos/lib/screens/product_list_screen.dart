import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';
import '../screens/add_product_screen.dart';
import '../widgets/delete_confirmation_dialog.dart'; // Importa el widget de confirmación

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Establecer el estado de carga y llamar al proveedor
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      // Manejo de errores básico, puede ser mejorado
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocurrió un error'),
          content: Text('Algo salió mal al cargar los productos.'),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = productsData.products;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // Fondo rojo
        title: Text(
          'AUTOMOTRIZ LUZ',
          style: TextStyle(color: Colors.white), // Letras blancas
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white), // Ícono blanco
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => AddProductScreen()));
            },
          )
        ],
        iconTheme: IconThemeData(
            color: Colors
                .white), // Esto asegura que todos los íconos en la AppBar sean blancos
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(products[index].id),
                direction: DismissDirection.horizontal,
                background: Container(
                  color: const Color.fromARGB(255, 248, 155, 149),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                ),
                confirmDismiss: (direction) async {
                  // Mostrar el cuadro de diálogo de confirmación
                  final shouldDelete = await showDialog(
                    context: context,
                    builder: (ctx) => DeleteConfirmationDialog(
                      onConfirm: (confirmed) {
                        if (confirmed) {
                          final productId = products[index].id;
                          if (productId != null) {
                            Provider.of<ProductsProvider>(context,
                                    listen: false)
                                .deleteProduct(productId);
                          }
                        }
                      },
                    ),
                  );
                  return shouldDelete ?? false; // Si es nulo, no eliminar
                },
                onDismissed: (direction) {
                  // Eliminar el producto si se confirmó
                  final productId = products[index].id ??
                      ''; // Valor predeterminado vacío si es nulo
                  Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(productId);
                },
                child: ProductItem(
                  imageUrl: products[index].imageUrl ??
                      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fmx%2Ffotos%2Fmec%25C3%25A1nico&psig=AOvVaw0QZ3Z3Z2Z2Z2Z2Z2Z2Z2Z2&ust=1629788455744000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCJjQ4ZqH9_ICFQAAAAAdAAAAABAD',
                  name: products[index].name,
                  price: products[index].price.toString(),
                  product: products[index],
                ),
              ),
            ),
    );
  }
}
