import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PastBookingsScreen extends StatelessWidget {
  const PastBookingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)),
        ),
        title: Text('Past Bookings', style: AppTextStyles.titleLarge),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 4,
        itemBuilder: (c, i) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('#PB-${1040 - i}', style: AppTextStyles.cyanLabel),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.textMuted.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Text('COMPLETED', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted))),
            ]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text('Guest ${i + 1}', style: AppTextStyles.titleMedium)]),
            Row(children: [const Icon(Icons.villa_outlined, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text('Ocean Club Villa', style: AppTextStyles.bodySmall)]),
            Row(children: [const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text('Apr ${10 - i} – Apr ${15 - i}, 2026  •  5 nights', style: AppTextStyles.bodySmall), const Spacer(), Text('\$${9250 - i * 500}', style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold))]),
          ]),
        ),
      ),
    );
  }
}
