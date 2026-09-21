import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class PropertyEarningsScreen extends StatelessWidget {
  const PropertyEarningsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Property Earnings', style: AppTextStyles.titleLarge)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0A2030), Color(0xFF0D1117)]), borderRadius: BorderRadius.circular(20)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Total Revenue This Month', style: AppTextStyles.bodyMedium), const SizedBox(height: 8),
            Text('\$18,200.00', style: AppTextStyles.price),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _s('4', 'Bookings', AppColors.cyan)), const SizedBox(width: 12),
              Expanded(child: _s('19 nights', 'Booked', AppColors.gold)), const SizedBox(width: 12),
              Expanded(child: _s('78%', 'Occupancy', AppColors.green)),
            ]),
          ])),
        const SizedBox(height: 24),
        Text('Booking Revenue', style: AppTextStyles.headlineSmall), const SizedBox(height: 12),
        ...[
          {'id': '#PB-1041', 'property': 'Ocean Club Villa', 'nights': '5 nights', 'amount': '\$10,175.00'},
          {'id': '#PB-1029', 'property': 'Paradise Island Penthouse', 'nights': '4 nights', 'amount': '\$4,800.00'},
          {'id': '#PB-1011', 'property': 'Ocean Club Villa', 'nights': '2 nights', 'amount': '\$3,700.00'},
        ].map((e) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.villa_outlined, color: AppColors.cyan, size: 20)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e['property']!, style: AppTextStyles.titleMedium), Text('${e['id']}  •  ${e['nights']}', style: AppTextStyles.bodySmall)])), Text(e['amount']!, style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold))]))),
      ])),
    );
  }
  Widget _s(String v, String l, Color color) => Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.3), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: AppTextStyles.caption), Text(v, style: AppTextStyles.headlineSmall.copyWith(color: color))]));
}

class PropertyOwnerProfileScreen extends StatelessWidget {
  const PropertyOwnerProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(backgroundColor: AppColors.background, title: Text('Owner Profile', style: AppTextStyles.titleLarge), leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))), body: Center(child: Text('Property Owner Profile', style: AppTextStyles.headlineMedium)));
}
