import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Container(height: 220, color: const Color(0xFF1A2B40), child: Stack(children: [
          Center(child: Icon(Icons.directions_car, color: AppColors.textMuted, size: 64)),
          Positioned(top: 12, left: 12, child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.background.withOpacity(0.8), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))),
          Positioned(top: 12, right: 12, child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.background.withOpacity(0.8), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.favorite_border, color: AppColors.textPrimary, size: 20))),
        ])),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('LUXURY SUV • MOST BOOKED', style: AppTextStyles.cyanLabel),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Cadillac Escalade ESV', style: AppTextStyles.headlineLarge), GSRatingRow(rating: 4.97, reviews: 142)]),
          const SizedBox(height: 4),
          Text('Onyx Black  •  Tinted Privacy Glass  •  2024 Model', style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
          Text('\$285/day', style: AppTextStyles.price),
          const SizedBox(height: 16),
          // Features
          Wrap(spacing: 8, runSpacing: 8, children: ['6 Seats', '6 Bags', 'Full Insurance', 'GPS', 'Concierge Delivery', '24/7 Support'].map((f) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.check, size: 12, color: AppColors.cyan), const SizedBox(width: 4), Text(f, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))]))).toList()),
          const SizedBox(height: 20),
          Text('About This Vehicle', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text('Premium luxury SUV perfect for Nassau Island tours, airport transfers, and resort-to-resort travel. Features extended wheelbase, panoramic sunroof, and premium Bose sound system.', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 20),
          // Rental duration
          Text('Select Rental Duration', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Column(children: [Text('Pick-up', style: AppTextStyles.bodySmall), const SizedBox(height: 4), Text('Apr 21, 2026', style: AppTextStyles.titleMedium)]))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: const Icon(Icons.arrow_forward, color: AppColors.textSecondary, size: 20)),
            Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Column(children: [Text('Return', style: AppTextStyles.bodySmall), const SizedBox(height: 4), Text('Apr 25, 2026', style: AppTextStyles.titleMedium)]))),
          ]),
          const SizedBox(height: 20),
          // Summary
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              _row('4 days × \$285/day', '\$1,140.00'), _row('Insurance & Protection', 'Included'), _row('Concierge Delivery', '\$0.00'),
              const Divider(color: AppColors.border, height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TOTAL', style: AppTextStyles.headlineSmall), Text('\$1,140.00', style: AppTextStyles.price)]),
            ])),
        ]))),
        Padding(padding: const EdgeInsets.all(20), child: GSButton(label: 'Reserve Vehicle →', onTap: () => Navigator.pushNamed(context, '/customer/car-rental/booking'))),
      ])),
    );
  }
  Widget _row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: AppTextStyles.bodyMedium), Text(v, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary))]));
}
