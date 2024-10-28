import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Cloud Firestore

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final DateTime createdAt;
  final List<String> favoriteRecipes;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.createdAt,
    this.favoriteRecipes = const [],
  });

  // Conversión de UserModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'favoriteRecipes': favoriteRecipes,
    };
  }

  // Creación de UserModel desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Convierte 'createdAt' de Timestamp a DateTime si es necesario
    Timestamp? createdAtTimestamp = json['createdAt'];
    DateTime createdAt = createdAtTimestamp != null
        ? createdAtTimestamp.toDate()
        : DateTime.now(); // Valor por defecto si el timestamp no existe

    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      createdAt: createdAt,
      favoriteRecipes: List<String>.from(json['favoriteRecipes'] ?? []),
    );
  }
}
