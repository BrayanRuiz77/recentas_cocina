import 'package:flutter/material.dart';
import '../models/shopping_item.dart';
import '../theme/app_colors.dart';

class ShoppingListItem extends StatelessWidget {
  final ShoppingItem item;
  final Function(bool?) onChanged;

  const ShoppingListItem({
    Key? key,
    required this.item,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: CheckboxListTile(
        value: item.isCompleted,
        onChanged: onChanged,
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(item.quantity),
        activeColor: AppColors.primary,
      ),
    );
  }
}
