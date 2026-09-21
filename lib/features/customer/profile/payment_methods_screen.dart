import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Payment Methods', style: AppTextStyles.titleLarge),
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
            Text('Saved Cards', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            _cardTile('Visa', 'ending in 4242', true),
            const SizedBox(height: 12),
            _cardTile('Mastercard', 'ending in 8891', false),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cyan.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add_circle_outline, color: AppColors.cyan, size: 24),
                    const SizedBox(width: 12),
                    Text('Add New Payment Method', style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardTile(String type, String ending, bool isDefault) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 32,
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6)),
            alignment: Alignment.center,
            child: Icon(Icons.credit_card, color: AppColors.textSecondary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: AppTextStyles.titleMedium),
                Text(ending, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          if (isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.cyan.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: Text('DEFAULT', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan)),
            ),
        ],
      ),
    );
  }
}
