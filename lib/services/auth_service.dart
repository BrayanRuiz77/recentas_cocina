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
        email: email,
        password: password,
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
        email: email,
        password: password,
      );

      if (result.user != null) {
        final userData =
            await _firestore.collection('users').doc(result.user!.uid).get();
        return UserModel.fromJson(userData.data()!);
      }
      return null;
    } catch (e) {
      print('Error en el inicio de sesión: $e');
      rethrow;
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

  // Obtener usuario actual
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userData =
            await _firestore.collection('users').doc(user.uid).get();
        return UserModel.fromJson(userData.data()!);
      }
      return null;
    } catch (e) {
      print('Error al obtener usuario actual: $e');
      return null;
    }
  }
}
