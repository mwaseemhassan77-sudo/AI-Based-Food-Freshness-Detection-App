//  Top Image Section

// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../controller/result_controller.dart';

class TopImageSection extends GetView<ResultController> {
  final dynamic scan;

  const TopImageSection({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: 280,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              //  Actual scanned image
              Expanded(
                child: scan.imagePath != null
                    ? Image.file(
                        File(scan.imagePath!),
                        fit: BoxFit.cover,
                        height: 280,
                        errorBuilder: (_, __, ___) => _foodPlaceholder(),
                      )
                    : _foodPlaceholder(),
              ),

              //  Ingredient category icons
              // Container(
              //   width: 100,
              //   color: Colors.white,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: scan.ingredients.map<Widget>((ingredient) {
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 10),
              //         child: Column(
              //           children: [
              //             Container(
              //               width: 58,
              //               height: 58,
              //               decoration: const BoxDecoration(
              //                 color: AppColors.surface,
              //                 shape: BoxShape.circle,
              //               ),
              //               child: Icon(
              //                 _ingredientIcon(ingredient),
              //                 color: AppColors.primary,
              //                 size: 28,
              //               ),
              //             ),
              //             const SizedBox(height: 5),
              //             Text(
              //               ingredient,
              //               style: const TextStyle(
              //                 fontSize: 11,
              //                 fontWeight: FontWeight.w600,
              //                 fontFamily: 'Poppins',
              //                 color: AppColors.textPrimary,
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     }).toList(),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _foodPlaceholder() => Container(
    color: AppColors.surface,
    child: const Center(
      child: Icon(Icons.restaurant_rounded, color: AppColors.primary, size: 60),
    ),
  );

  // IconData _ingredientIcon(String ingredient) {
  //   switch (ingredient.toLowerCase()) {
  //     case 'meat':
  //       return Icons.kebab_dining_rounded;
  //     case 'vegetable':
  //       return Icons.eco_rounded;
  //     case 'dairy':
  //       return Icons.local_drink_rounded;
  //     case 'grain':
  //       return Icons.grain_rounded;
  //     default:
  //       return Icons.restaurant_rounded;
  //   }
  // }

}
