import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class LanguageRegionScreen extends StatelessWidget {
  const LanguageRegionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Language & Region', style: AppTextStyles.titleLarge),
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
            Text('Language', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            _selectionTile('English', true),
            const SizedBox(height: 8),
            _selectionTile('Spanish', false),
            const SizedBox(height: 8),
            _selectionTile('French', false),
            const SizedBox(height: 24),
            Text('Region & Currency', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            _selectionTile('Bahamas (BSD \$)', true),
            const SizedBox(height: 8),
            _selectionTile('United States (USD \$)', false),
          ],
        ),
      ),
    );
  }

  Widget _selectionTile(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? AppColors.cyan : AppColors.border, width: isSelected ? 1 : 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.titleMedium),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.cyan, size: 20),
        ],
      ),
    );
  }
}
