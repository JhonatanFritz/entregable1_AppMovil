import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function(bool) onConfirm;

  DeleteConfirmationDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          const Color.fromARGB(255, 0, 0, 0), // Color de fondo claro de rojo
      title: Text(
        'Eliminar Producto',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        '¿Estás seguro de que quieres eliminar este producto?',
        style: TextStyle(
            color: Colors.white70), // Texto en blanco con algo de opacidad
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey,
            primary: Colors.white,
          ),
          onPressed: () {
            onConfirm(false); // No eliminar
            Navigator.of(context).pop();
          },
          child: Text('No'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            primary: Colors.white,
          ),
          onPressed: () {
            onConfirm(true); // Sí, eliminar
            Navigator.of(context).pop();
          },
          child: Text('Sí'),
        ),
      ],
    );
  }
}
