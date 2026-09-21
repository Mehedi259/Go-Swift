import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class CancelledBookingsScreen extends StatelessWidget {
  const CancelledBookingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background,
        leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Cancelled Bookings', style: AppTextStyles.titleLarge)),
      body: ListView.builder(padding: const EdgeInsets.all(20), itemCount: 2,
        itemBuilder: (c, i) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.directions_car, color: AppColors.textMuted, size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Ocean Club → NAS Airport', style: AppTextStyles.titleMedium),
              Text('Apr ${12 - i}, 10:00 AM', style: AppTextStyles.bodySmall),
              const SizedBox(height: 4),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.red.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle)), const SizedBox(width: 4), Text('CANCELLED', style: AppTextStyles.caption.copyWith(color: AppColors.red))])),
            ])),
            Text('\$98.00', style: AppTextStyles.titleLarge.copyWith(color: AppColors.textSecondary)),
          ]))),
    );
  }
}
