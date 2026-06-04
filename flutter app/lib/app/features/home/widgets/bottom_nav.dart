// lib/modules/home/widgets/bottom_nav.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safebite/core/theme/app_theme.dart';
import '../controller/home_controller.dart';

class BottomNav extends GetView<HomeController> {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            // ── Home ──────────────────────────────────────────────
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isActive: controller.selectedTabIndex.value == 0,
              onTap: () => controller.onTabChanged(0),
            ),

            // ── Scan ──────────────────────────────────────────────
            _NavItem(
              icon: Icons.crop_free_outlined,
              label: 'Scan',
              isActive: controller.selectedTabIndex.value == 1,
              isScan: true,
              onTap: () => controller.onTabChanged(1),
            ),
             _NavItem(
              icon: Icons.smart_toy,
              label: 'chatbot',
              isActive: controller.selectedTabIndex.value == 2,
              isScan: true,
              onTap: () => controller.onTabChanged(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isScan;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isScan = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppColors.primary
                  : (isScan ? AppColors.textPrimary : AppColors.textSecondary),
              size: isScan ? 30 : 26,
            ),
            if (label.isNotEmpty)
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
