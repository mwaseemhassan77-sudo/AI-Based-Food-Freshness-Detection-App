// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class NutrientBar extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final double maxValue;
  final Color color;

  const NutrientBar({super.key, 
    required this.label,
    required this.value,
    required this.unit,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (value / maxValue).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              '${value.toStringAsFixed(0)} $unit',
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: percent),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOut,
          builder: (_, val, __) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: val,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 10,
            ),
          ),
        ),
      ],
    );
  }
}
