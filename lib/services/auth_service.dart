import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream para escuchar cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registro con email y contraseña
  Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), // Eliminar espacios en blanco
        password: password.trim(), // Eliminar espacios en blanco
      );

      final user = result.user;

      if (user != null) {
        // Crear el documento del usuario en Firestore
        final userModel = UserModel(
          id: user.uid,
          email: email,
          name: name,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());
        return userModel;
      } else {
        return null; // Devuelve null si el usuario no se crea
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('Error de Firebase Auth: ${e.code}, ${e.message}');
        if (e.code == 'weak-password') {
          throw Exception('La contraseña es demasiado débil.');
        } else if (e.code == 'email-already-in-use') {
          throw Exception('El correo electrónico ya está en uso.');
        }
      } else {
        print('Otro error de registro: $e');
      }
      rethrow; // Re-lanza la excepción para que se maneje en la UI
    }
  }

  // Inicio de sesión con email y contraseña
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(), // Eliminar espacios en blanco
        password: password.trim(), // Eliminar espacios en blanco
      );

      final user = result.user; // Obtener el usuario del resultado

      if (user != null) {
        final userData =
            await _firestore.collection('users').doc(user.uid).get();

        if (userData.data() != null) {
          return UserModel.fromJson(userData.data()! as Map<String, dynamic>);
        } else {
          // Manejar el caso donde no se encuentran datos del usuario.
          print('No se encontraron datos de usuario para ${user.uid}');
          return null;
        }
      } else {
        print('Error: Usuario nulo después del inicio de sesión.');
        return null;
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('Error de Firebase Auth: ${e.code}, ${e.message}');
        switch (e.code) {
          case 'user-not-found':
            throw Exception('Usuario no encontrado.');
          case 'wrong-password':
            throw Exception('Contraseña incorrecta.');
          default:
            throw Exception('Error de autenticación: ${e.message}');
        }
      } else {
        print('Otro error de inicio de sesión: $e');
        throw Exception(
            'Error de inicio de sesión: $e'); // Relanza la excepción general.
      }
    }
  }

  // Cerrar sesión modificado con BuildContext
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navega a la pantalla de login después de cerrar sesión
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Error al cerrar sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
      rethrow;
    }
  }

  // Obtener usuario actual (modificado)
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        print("UID del usuario actual: ${user.uid}");

        final userData = await _firestore
            .collection('users')
            .doc(user.uid.trim())
            .get(); // trim() añadido

        if (userData.exists) {
          // Verifica si el documento existe.
          print(
              'Datos de Firestore: ${userData.data()}'); // Print de depuración
          return UserModel.fromJson(userData.data()! as Map<String, dynamic>);
        } else {
          print(
              'No se encontraron datos del usuario en Firestore. Creando nuevo documento...');

          // Crea un nuevo documento de usuario si no existe.
          final userModel = UserModel(
            id: user.uid,
            email: user.email ?? '', // Maneja el caso donde el email es nulo
            name: user
                .displayName, // Puedes obtener el nombre de usuario si está disponible.
            createdAt: DateTime.now(),
          );
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toJson());

          return userModel;
        }
      }
      return null; // No hay usuario con sesión iniciada
    } catch (e) {
      print('Error al obtener usuario actual: $e');
      return null;
    }
  }
}
