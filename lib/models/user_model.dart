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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      favoriteRecipes: List<String>.from(json['favoriteRecipes'] ?? []),
    );
  }
}
