import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/product_list_screen.dart'; // Asegúrate de crear este archivo según los pasos previos.
import 'providers/products_provider.dart'; // Asegúrate de tener este archivo creado.

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ctx) =>
          ProductsProvider(), // Asegúrate de haber creado este proveedor.
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          ProductListScreen(), // Usamos la pantalla que definimos anteriormente.
    );
  }
}
