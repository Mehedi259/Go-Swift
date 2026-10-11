import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class RentalEarningsScreen extends StatelessWidget {
  const RentalEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Fleet Earnings', style: AppTextStyles.titleLarge),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  Text('Total Earnings This Month', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 6),
                  Text(
                    '\$4,200.00',
                    style: AppTextStyles.price.copyWith(color: AppColors.gold, fontSize: 36),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _statPill('Active Rentals', '1', AppColors.green)),
                      const SizedBox(width: 12),
                      Expanded(child: _statPill('Payout Pending', '\$1,140.00', AppColors.cyan)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Recent Rental Payouts', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            ...[
              {'vehicle': 'Cadillac Escalade ESV', 'dates': 'Apr 21 – 25', 'payout': '\$1,140.00', 'renter': 'Alexander Vance'},
              {'vehicle': 'Range Rover Sport', 'dates': 'Apr 14 – 18', 'payout': '\$980.00', 'renter': 'Victoria Stubbs'},
              {'vehicle': 'Lamborghini Urus', 'dates': 'Apr 02 – 05', 'payout': '\$2,550.00', 'renter': 'David Sterling'},
            ].map((p) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.cardTouchpoint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.directions_car, color: AppColors.cyan, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['vehicle']!, style: AppTextStyles.titleMedium),
                            const SizedBox(height: 2),
                            Text('${p['renter']} • ${p['dates']}', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Text(
                        p['payout']!,
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _statPill(String l, String v, Color color) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l, style: AppTextStyles.bodySmall),
            const SizedBox(height: 4),
            Text(v, style: AppTextStyles.headlineSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      );
}
