//  Macros Row

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MacrosRow extends StatelessWidget {
  final dynamic scan;
  const MacrosRow({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MacroChip(
          label: 'Calories',
          value: '${scan.calories.toStringAsFixed(0)} kcal',
          color: AppColors.calColor,
        ),
        const SizedBox(width: 8),
        _MacroChip(
          label: 'Protein',
          value: '${scan.protein.toStringAsFixed(1)} g',
          color: AppColors.proteinColor,
        ),
        const SizedBox(width: 8),
        _MacroChip(
          label: 'Fat',
          value: '${scan.fat.toStringAsFixed(1)} g',
          color: AppColors.fatColor,
        ),
        const SizedBox(width: 8),
        _MacroChip(
          label: 'Carbs',
          value: '${scan.carbs.toStringAsFixed(1)} g',
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MacroChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins',
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontFamily: 'Poppins',
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
