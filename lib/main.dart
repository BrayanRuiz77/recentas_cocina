import 'package:flutter/material.dart';
import 'package:recetas_cocina/screens/home_screen.dart';
import 'package:recetas_cocina/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: AppTheme.light, // Utiliza el tema personalizado
      home: HomeScreen(),
    );
  }
}
