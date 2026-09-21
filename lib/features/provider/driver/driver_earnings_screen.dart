import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class DriverEarningsScreen extends StatelessWidget {
  final bool embedded;
  const DriverEarningsScreen({super.key, this.embedded = false});
  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (!embedded) ...[Text('Earnings', style: AppTextStyles.headlineLarge), const SizedBox(height: 16)],
      if (embedded) ...[Text('Earnings', style: AppTextStyles.headlineLarge), const SizedBox(height: 16)],
      // Stats
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0A2030), Color(0xFF0D1117)]), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.cyan.withOpacity(0.2))),
        child: Column(children: [
          Text('Total Earnings This Week', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8), Text('\$1,284.50', style: AppTextStyles.price),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _eBox('Today', '\$284.00', AppColors.cyan)),
            const SizedBox(width: 12), Expanded(child: _eBox('This Month', '\$4,820.00', AppColors.gold)),
          ]),
        ])),
      const SizedBox(height: 24),
      Text('Transaction History', style: AppTextStyles.headlineSmall),
      const SizedBox(height: 12),
      ...[
        {'id': '#SW-8521', 'from': 'NAS Airport', 'to': 'Ocean Club', 'fare': '\$118.50', 'date': 'Today 4:18 PM'},
        {'id': '#SW-8498', 'from': 'Atlantis', 'to': 'Cable Beach', 'fare': '\$65.00', 'date': 'Today 2:00 PM'},
        {'id': '#SW-8471', 'from': 'Baha Mar', 'to': 'NAS Airport', 'fare': '\$98.00', 'date': 'Yesterday 9:00 AM'},
        {'id': '#SW-8450', 'from': 'Lyford Cay', 'to': 'Paradise Island', 'fare': '\$145.00', 'date': 'Apr 19, 3:00 PM'},
      ].map((t) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.directions_car, color: AppColors.cyan, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${t['from']} → ${t['to']}', style: AppTextStyles.titleMedium), Text('${t['id']}  •  ${t['date']}', style: AppTextStyles.bodySmall)])),
          Text(t['fare']!, style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold)),
        ]))),
    ]));
    return embedded ? content : Scaffold(appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))), title: Text('Earnings', style: AppTextStyles.titleLarge)), body: content);
  }
  Widget _eBox(String l, String v, Color color) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.3), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: AppTextStyles.bodySmall), const SizedBox(height: 4), Text(v, style: AppTextStyles.headlineSmall.copyWith(color: color))]));
}
