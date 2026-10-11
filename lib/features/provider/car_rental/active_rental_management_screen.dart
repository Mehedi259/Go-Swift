import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class ActiveRentalManagementScreen extends StatelessWidget {
  const ActiveRentalManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
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
        title: Text('Active Rental #CR-5821', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.greenLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.green.withOpacity(0.3)),
              ),
              child: Text(
                'ACTIVE  •  2 DAYS REMAINING',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 14),
            Text('Cadillac Escalade ESV', style: AppTextStyles.displayMedium),
            const SizedBox(height: 20),
            _info('Renter', 'Alexander Vance'),
            _info('Rental Period', 'Apr 21 – Apr 25, 2026'),
            _info('Total Paid', '\$1,140.00'),
            _info('Insurance Tier', 'Full Bahamian Sovereign Coverage'),
            _info('Drop-off Location', 'Lynden Pindling Int\'l Airport (NAS)'),
            const SizedBox(height: 24),
            GSButton(
              label: 'Complete Return →',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _info(String l, String v) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l, style: AppTextStyles.bodyMedium),
            Text(v, style: AppTextStyles.titleMedium),
          ],
        ),
      );
}
