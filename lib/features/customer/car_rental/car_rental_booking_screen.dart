import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class CarRentalBookingScreen extends StatelessWidget {
  const CarRentalBookingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Confirm Rental Booking', style: AppTextStyles.titleLarge)),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cadillac Escalade ESV', style: AppTextStyles.headlineLarge),
          Text('4 Days • Apr 21 – Apr 25, 2026', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan)),
          const SizedBox(height: 20),
          Text('DRIVER INFORMATION', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          _field('Full Name', Icons.person_outline, 'Alexander Vance'),
          const SizedBox(height: 12), _field('Driver\'s License', Icons.badge_outlined, 'DL-000-000000'),
          const SizedBox(height: 12), _field('Mobile Phone', Icons.phone_outlined, '+1 (242) 555-0199'),
          const SizedBox(height: 20),
          Text('DELIVERY OPTION', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          ...[
            {'icon': Icons.location_on_outlined, 'label': 'Self Pick-up', 'sub': 'Cable Beach Fleet Hub, Nassau'},
            {'icon': Icons.hotel, 'label': 'Hotel / Resort Delivery', 'sub': 'Concierge delivery to your property • FREE'},
            {'icon': Icons.flight, 'label': 'Airport Delivery (NAS)', 'sub': 'Available at Lynden Pindling Int\'l Airport'},
          ].map((o) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Row(children: [Icon(o['icon'] as IconData, color: AppColors.textSecondary, size: 20), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(o['label'] as String, style: AppTextStyles.titleMedium), Text(o['sub'] as String, style: AppTextStyles.bodySmall)]))]))),
          const SizedBox(height: 20),
          Text('PAYMENT', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cyan, width: 1.5)), child: Row(children: [const Icon(Icons.credit_card, color: AppColors.cyan, size: 20), const SizedBox(width: 12), Expanded(child: Text('Visa •••• 4291', style: AppTextStyles.titleMedium)), const Icon(Icons.check_circle, color: AppColors.cyan, size: 18)])),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
            child: Column(children: [_row('4 Days Rental', '\$1,140.00'), _row('Comprehensive Insurance', 'Included'), _row('Concierge Delivery', 'FREE'), const Divider(color: AppColors.border), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TOTAL', style: AppTextStyles.headlineSmall), Text('\$1,140.00', style: AppTextStyles.price)])])),
        ]))),
        Padding(padding: const EdgeInsets.all(20), child: GSButton(label: 'Confirm Rental  •  \$1,140.00 →', onTap: () => Navigator.pushNamed(context, '/customer/car-rental/active'))),
      ]),
    );
  }
  Widget _field(String label, IconData icon, String hint) => TextFormField(style: AppTextStyles.bodyLarge, decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20)));
  Widget _row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: AppTextStyles.bodyMedium), Text(v, style: AppTextStyles.titleMedium)]));
}
