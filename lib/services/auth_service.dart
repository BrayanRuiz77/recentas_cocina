import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      if (result.user != null) {
        // Crear el documento del usuario en Firestore
        final userModel = UserModel(
          id: result.user!.uid,
          email: email,
          name: name,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .set(userModel.toJson());

        return userModel;
      }
      return null;
    } catch (e) {
      print('Error en el registro: $e');
      rethrow;
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
        // Obtener los datos del usuario desde Firestore
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

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
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
