class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final String imageUrl;
  final String userId;
  final DateTime createdAt;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.userId,
    required this.createdAt,
    this.isFavorite = false,
  });

  Recipe copyWith({String? id, bool? isFavorite}) {
    return Recipe(
      id: id ?? this.id,
      title: title,
      description: description,
      ingredients: ingredients,
      instructions: instructions,
      imageUrl: imageUrl,
      userId: userId,
      createdAt: createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      imageUrl: json['imageUrl'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
