import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class RideCompletedScreen extends StatelessWidget {
  const RideCompletedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(children: [
          const SizedBox(height: 32),
          Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFF3FB950), Color(0xFF238636)]),
            boxShadow: [BoxShadow(color: AppColors.green.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)]),
            child: const Icon(Icons.check, color: Colors.white, size: 40)),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: AppColors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)), const SizedBox(width: 6), Text('TRIP COMPLETED • #SW-8492', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green))])),
          const SizedBox(height: 16),
          Text('You\'ve Arrived\nSafely', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('The Ocean Club, A Four Seasons Resort', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
          Text('One Ocean Drive, Paradise Island, Bahamas', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 28),
          // Fare breakdown
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TRIP #SW-8492', style: AppTextStyles.cyanLabel), Text('4:18 PM  Apr 20', style: AppTextStyles.bodySmall)]),
              const SizedBox(height: 16),
              _fareRow('Base Fare', '\$85.00'),
              _fareRow('Distance (14.2 km)', '\$28.40'),
              _fareRow('Island Service Fee', '\$5.10'),
              const Divider(color: AppColors.border, height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TOTAL FARE', style: AppTextStyles.titleLarge), Text('\$118.50', style: AppTextStyles.price)]),
              const SizedBox(height: 12),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: Row(children: [const Icon(Icons.credit_card, color: AppColors.textSecondary, size: 18), const SizedBox(width: 10), Text('Visa •••• 4291 — Paid', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)), const Spacer(), Text('SETTLED', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green))])),
            ])),
          const SizedBox(height: 20),
          // Trip stats
          Row(children: [
            Expanded(child: _stat('Duration', '18 min', Icons.access_time)),
            const SizedBox(width: 12), Expanded(child: _stat('Distance', '14.2 km', Icons.route)),
          ]),
          const SizedBox(height: 20),
          GSButton(label: 'Rate Your Ride →', onTap: () => Navigator.pushNamed(context, '/customer/ride/rating')),
          const SizedBox(height: 12),
          GSButton(label: 'Book Another Ride', isSecondary: true, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/ride/booking', (_) => false)),
          const SizedBox(height: 12),
          TextButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false), child: Text('Return to Hub', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))),
          const SizedBox(height: 24),
        ]))),
      ])),
    );
  }

  Widget _fareRow(String label, String val) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: AppTextStyles.bodyMedium), Text(val, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))]));

  Widget _stat(String label, String value, IconData icon) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 0.5)),
    child: Row(children: [Icon(icon, size: 18, color: AppColors.textSecondary), const SizedBox(width: 10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: AppTextStyles.bodySmall), Text(value, style: AppTextStyles.titleMedium)])]));
}
