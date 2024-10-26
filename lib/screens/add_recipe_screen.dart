import 'package:flutter/material.dart';

class AddRecipeScreen extends StatelessWidget {
  const AddRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Recet a'),
      ),
      body: const Center(
        child: Text(
            'Formulario para añadir receta'), // Reemplaza esto con tu formulario
      ),
    );
  }
}
