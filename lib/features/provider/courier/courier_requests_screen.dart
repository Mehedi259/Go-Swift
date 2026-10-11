import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class CourierRequestsScreen extends StatelessWidget {
  const CourierRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Parcel Requests', style: AppTextStyles.titleLarge),
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.cardTouchpoint,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.inventory_2_outlined, color: AppColors.cyan, size: 36),
            ),
            const SizedBox(height: 16),
            Text('No Pending Requests', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 6),
            Text('New incoming delivery requests will appear here.', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
