import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class PropertyBookingScreen extends StatelessWidget {
  const PropertyBookingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Confirm Property Booking', style: AppTextStyles.titleLarge)),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('The Ocean Club Villa', style: AppTextStyles.headlineLarge),
          Text('Apr 21 – Apr 26, 2026  •  5 nights', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan)),
          const SizedBox(height: 20),
          Text('GUEST INFORMATION', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          _field('Lead Guest Name', Icons.person_outline, 'Alexander Vance'),
          const SizedBox(height: 12), _field('Email', Icons.mail_outline, 'alexander@email.com'),
          const SizedBox(height: 12), _field('Mobile Phone', Icons.phone_outlined, '+1 (242) 555-0199'),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('NUMBER OF GUESTS', style: AppTextStyles.labelSmall), Text('Max: 12', style: AppTextStyles.bodySmall)]),
          const SizedBox(height: 8),
          TextFormField(initialValue: '4', style: AppTextStyles.bodyLarge, keyboardType: TextInputType.number, decoration: const InputDecoration(prefixIcon: Icon(Icons.people_outline, color: AppColors.textSecondary, size: 20))),
          const SizedBox(height: 16),
          TextFormField(maxLines: 3, style: AppTextStyles.bodyMedium, decoration: const InputDecoration(hintText: 'Special requests for butler or concierge...')),
          const SizedBox(height: 20),
          Text('ADD-ON SERVICES', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          ...[
            {'label': 'Private Chef (5 nights)', 'price': '+\$1,500', 'icon': Icons.restaurant},
            {'label': 'Airport Transfer (both ways)', 'price': '+\$240', 'icon': Icons.flight},
            {'label': 'Yacht Charter (half day)', 'price': '+\$2,200', 'icon': Icons.sailing},
          ].map((a) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: Icon(a['icon'] as IconData, color: AppColors.textSecondary, size: 20)), const SizedBox(width: 12), Expanded(child: Text(a['label'] as String, style: AppTextStyles.titleMedium)), Text(a['price'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold)), const SizedBox(width: 8), Container(width: 24, height: 24, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: AppColors.border)), child: const Icon(Icons.add, size: 14, color: AppColors.textSecondary))]))),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
            child: Column(children: [
              _row('5 nights × \$1,850/night', '\$9,250.00'), _row('Butler & Concierge Service', 'Included'), _row('Daily Housekeeping', 'Included'), _row('Taxes & Fees', '\$925.00'),
              const Divider(color: AppColors.border), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TOTAL', style: AppTextStyles.headlineSmall), Text('\$10,175.00', style: AppTextStyles.price.copyWith(fontSize: 22))]),
            ])),
        ]))),
        Padding(padding: const EdgeInsets.all(20), child: GSButton(label: 'Confirm Booking  •  \$10,175.00 →', onTap: () => Navigator.pushNamed(context, '/customer/properties/rating'))),
      ]),
    );
  }
  Widget _field(String label, IconData icon, String hint) => TextFormField(style: AppTextStyles.bodyLarge, decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20)));
  Widget _row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: AppTextStyles.bodyMedium), Text(v, style: AppTextStyles.titleMedium)]));
}
