import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Appearance', style: AppTextStyles.titleLarge),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            _selectionTile(Icons.light_mode, 'Bahamian Sovereign Light', true),
            const SizedBox(height: 10),
            _selectionTile(Icons.phone_iphone, 'System Default', false),
            const SizedBox(height: 10),
            _selectionTile(Icons.dark_mode, 'Dark Mode', false),
          ],
        ),
      ),
    );
  }

  Widget _selectionTile(IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primaryTeal : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? AppColors.softShadow : AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? AppColors.primaryTeal : AppColors.textSecondary, size: 22),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primaryTeal, size: 22),
        ],
      ),
    );
  }
}
