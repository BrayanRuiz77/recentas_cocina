class MealPlan {
  final String id;
  final DateTime date;
  final String recipeId;
  final String recipeName;
  final String recipeImage;

  MealPlan({
    required this.id,
    required this.date,
    required this.recipeId,
    required this.recipeName,
    required this.recipeImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'recipeId': recipeId,
      'recipeName': recipeName,
      'recipeImage': recipeImage,
    };
  }

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      date: DateTime.parse(json['date']),
      recipeId: json['recipeId'],
      recipeName: json['recipeName'],
      recipeImage: json['recipeImage'],
    );
  }
}
