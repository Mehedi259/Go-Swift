import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Appearance', style: AppTextStyles.titleLarge),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
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
            _selectionTile(Icons.phone_iphone, 'System Default', false),
            const SizedBox(height: 8),
            _selectionTile(Icons.light_mode, 'Light Mode', false),
            const SizedBox(height: 8),
            _selectionTile(Icons.dark_mode, 'Dark Mode', true),
          ],
        ),
      ),
    );
  }

  Widget _selectionTile(IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? AppColors.cyan : AppColors.border, width: isSelected ? 1 : 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: AppTextStyles.titleMedium)),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.cyan, size: 20),
        ],
      ),
    );
  }
}
