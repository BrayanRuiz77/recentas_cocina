import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_recipe_screen.dart';
import 'services/auth_service.dart';
import 'services/recipe_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final recipeService = RecipeService(); // Inicializa recipeService

  runApp(MyApp(recipeService: recipeService));
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();
  final RecipeService recipeService;

  MyApp({super.key, required this.recipeService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REC App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: _authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/add_recipe': (context) => AddRecipeScreen(
            recipeService: recipeService), // Pasa recipeService aquí
      },
    );
  }
}
