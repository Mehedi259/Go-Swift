import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class ActiveRentalManagementScreen extends StatelessWidget {
  const ActiveRentalManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Active Rental #CR-5821', style: AppTextStyles.titleLarge)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: AppColors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text('ACTIVE  •  2 DAYS REMAINING', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green))),
        const SizedBox(height: 16), Text('Cadillac Escalade ESV', style: AppTextStyles.displayMedium),
        const SizedBox(height: 20),
        _info('Renter', 'Alexander Vance'), _info('Rental Period', 'Apr 21 – Apr 25, 2026'), _info('Total Paid', '\$1,140.00'),
        const SizedBox(height: 20),
        GSButton(label: 'Complete Return', onTap: () => Navigator.pop(context)),
      ])),
    );
  }
  Widget _info(String l, String v) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: AppTextStyles.bodyMedium), Text(v, style: AppTextStyles.titleMedium)]));
}
