import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/widgets/gs_button.dart';

class RideCompletedScreen extends StatelessWidget {
  const RideCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = ModalRoute.of(context)?.settings.arguments as RideModel?;
    final tripCode = ride != null ? '#SW-${ride.id}' : '#SW-8492';
    final dest = ride?.destinationAddress ?? 'The Ocean Club, A Four Seasons Resort';
    final totalFare = ride != null ? '\$${(ride.finalFare ?? ride.estimatedFare).toStringAsFixed(2)}' : '\$118.50';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text('TRIP COMPLETED • $tripCode', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('You\'ve Arrived\nSafely', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(dest, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                    Text('Nassau & Paradise Island, Bahamas', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                    const SizedBox(height: 28),
                    // Fare breakdown
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('TRIP #SW-8492', style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal)),
                              Text('4:18 PM Apr 20', style: AppTextStyles.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _fareRow('Base Fare', '\$85.00'),
                          _fareRow('Distance (14.2 km)', '\$28.40'),
                          _fareRow('Island Service Fee', '\$5.10'),
                          const Divider(color: AppColors.border, height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('TOTAL FARE', style: AppTextStyles.titleLarge),
                              Text(totalFare, style: AppTextStyles.price.copyWith(fontSize: 22)),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.cardTouchpoint,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.credit_card, color: AppColors.primaryTeal, size: 18),
                                const SizedBox(width: 10),
                                Text('Visa •••• 4291 — Paid', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                                const Spacer(),
                                Text('SETTLED', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Trip stats
                    Row(
                      children: [
                        Expanded(child: _stat('Duration', '18 min', Icons.access_time)),
                        const SizedBox(width: 12),
                        Expanded(child: _stat('Distance', '14.2 km', Icons.route)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GSButton(
                      label: 'Rate Your Ride →',
                      onTap: () => Navigator.pushNamed(context, '/customer/ride/rating', arguments: ride),
                    ),
                    const SizedBox(height: 12),
                    GSButton(
                      label: 'Book Another Ride',
                      isSecondary: true,
                      onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/ride/booking', (_) => false),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false),
                      child: Text('Return to Hub', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fareRow(String label, String val) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(val, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ],
    ),
  );

  Widget _stat(String label, String value, IconData icon) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.cardShadow,
    ),
    child: Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryTeal),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            Text(value, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ],
    ),
  );
}
