import 'package:flutter/material.dart';
import '../models/product.dart';
import './edit_product_screen.dart'; // Asegúrate de importar esto

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // Fondo rojo
        title: Text(
          product.name,
          style: TextStyle(color: Colors.white), // Letras blancas
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white), // Ícono blanco
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => EditProductScreen(product: product),
              ));
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        // Añadiendo un degradado
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Espaciado alrededor
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300, // Tamaño fijo para la imagen
                width: double.infinity,
                child: Image.network(
                  product.imageUrl ??
                      'https://placeimg.com/640/480/tech', // Imagen placeholder
                  fit: BoxFit.contain, // Cambiado a contain
                ),
              ),
              SizedBox(height: 20),
              Text(
                product.name ?? '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Precio: \$${product.price?.toStringAsFixed(2) ?? ''}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
              Text(
                product.description ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
