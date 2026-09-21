import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class RentalEarningsScreen extends StatelessWidget {
  const RentalEarningsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(backgroundColor: AppColors.background, title: Text('Fleet Earnings', style: AppTextStyles.titleLarge), leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))), body: Center(child: Text('\$4,200.00 This Month', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.gold))));
}

