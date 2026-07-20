import 'package:flutter/material.dart';
import '../models/ingredient_model.dart';
import '../utils/app_theme.dart';

class IngredientCheckTile extends StatelessWidget {
  final IngredientModel ingredient;
  final ValueChanged<bool?> onChanged;

  const IngredientCheckTile({
    super.key,
    required this.ingredient,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: ingredient.isChecked
            ? AppTheme.secondaryColor.withValues(alpha: 0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ingredient.isChecked
              ? AppTheme.secondaryColor.withValues(alpha: 0.3)
              : const Color(0xFFE0E0E0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: CheckboxListTile(
          value: ingredient.isChecked,
          onChanged: onChanged,
          activeColor: AppTheme.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            ingredient.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: ingredient.isChecked
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: ingredient.isChecked
                  ? AppTheme.textSecondary
                  : AppTheme.textPrimary,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ingredient.amount,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              if (ingredient.preparation.isNotEmpty) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '(${ingredient.preparation})',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: ingredient.isChecked
                          ? AppTheme.textSecondary
                          : const Color(0xFF666666),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
