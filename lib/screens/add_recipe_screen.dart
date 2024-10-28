// add_recipe_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recetas_cocina/models/recipe.dart';
import 'package:recetas_cocina/services/recipe_service.dart';
import 'package:uuid/uuid.dart';

class AddRecipeScreen extends StatefulWidget {
  final RecipeService recipeService;

  const AddRecipeScreen({super.key, required this.recipeService});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ingredientesController = TextEditingController();
  final _instruccionesController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController =
      TextEditingController(); // Añade el controlador para la descripción

  @override
  void dispose() {
    _nombreController.dispose();
    _ingredientesController.dispose();
    _instruccionesController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose(); // Libera el controlador de descripción
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Receta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // Usa SingleChildScrollView para evitar el overflow
            child: Column(
              children: <Widget>[
                // ... (otros campos del formulario)

                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newRecipe = Recipe(
                        id: const Uuid().v4(), // Genera un UUID único
                        title: _nombreController.text,
                        description: _descriptionController
                            .text, // Incluye la descripción
                        ingredients: _ingredientesController.text
                            .split('\n'), // Divide los ingredientes por líneas
                        instructions: _instruccionesController.text
                            .split('\n'), // Divide las instrucciones por líneas
                        imageUrl: _imageUrlController.text,
                        userId: FirebaseAuth.instance.currentUser!
                            .uid, // Obtén el userId del usuario actual
                        createdAt: DateTime.now(),
                        isFavorite: false,
                      );

                      try {
                        await widget.recipeService.addRecipe(newRecipe);
                        if (mounted) Navigator.of(context).pop();
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
