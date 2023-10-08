import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/products_provider.dart';
import '../models/product.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    name: '',
    description: '',
    imageUrl: '',
    price: 0.0,
  );
  XFile? _pickedImage; // Variable para almacenar la imagen seleccionada

  // Método para seleccionar una imagen desde la galería
  Future<void> _pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = pickedImageFile;
      });
    }
  }

  void _saveForm() async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();

      // Sube la imagen al servidor y obtén la URL de Cloudinary
      final imageUrl = await uploadImageToServer(_pickedImage);

      final newProduct = Product(
        name: _editedProduct.name!,
        description: _editedProduct.description!,
        price: _editedProduct.price,
        imageUrl: imageUrl, // Usa la URL de la imagen subida
      );

      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(newProduct, _pickedImage);

      // Cierra la pantalla de edición de producto
      Navigator.of(context).pop();
    }
  }

  // Método para subir una imagen al servidor
  Future<String> uploadImageToServer(XFile? image) async {
    final url = 'http://tu-servidor.com/upload'; // Cambia a tu URL
    final imageBytes = await File(image!.path).readAsBytes();
    final imageBase64 = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse(url),
      body: {'imageBase64': imageBase64},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final imageUrl = jsonResponse['imageUrl'];
      return imageUrl;
    } else {
      throw Exception('Error al subir la imagen al servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // Fondo rojo
        title: Text(
          'Agregar Producto',
          style: TextStyle(color: Colors.white), // Letras blancas
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save, color: Colors.white), // Ícono blanco
            onPressed: _saveForm,
          )
        ],
        iconTheme: IconThemeData(
            color: Colors
                .white), // Esto asegura que todos los íconos en la AppBar sean blancos
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _editedProduct = Product(
                    name: value!,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    id: null,
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre válido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _editedProduct = Product(
                    name: _editedProduct.name!,
                    description: value!,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    id: null,
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una descripción válida.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Precio'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _editedProduct = Product(
                    name: _editedProduct.name!,
                    description: _editedProduct.description,
                    price: double.parse(value!),
                    imageUrl: _editedProduct.imageUrl,
                    id: null,
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un precio válido.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, ingrese un número válido.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Por favor, ingrese un precio mayor que cero.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Imagen'),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.url,
                onSaved: (value) {
                  _editedProduct = Product(
                    name: _editedProduct.name!,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: value!,
                    id: null,
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una URL válida.';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Seleccionar Imagen'),
              ),
              if (_pickedImage != null)
                Image.file(
                  File(_pickedImage!.path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
