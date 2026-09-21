import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class PropertyListingsScreen extends StatelessWidget {
  const PropertyListingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final props = [
      {'name': 'The Ocean Club Villa', 'type': 'Oceanfront Villa', 'status': 'Occupied', 'rate': '\$1,850/night', 'color': AppColors.green},
      {'name': 'Paradise Island Penthouse', 'type': 'Resort Penthouse', 'status': 'Available', 'rate': '\$1,200/night', 'color': AppColors.cyan},
      {'name': 'Lyford Cay Cottage', 'type': 'Private Estate', 'status': 'Maintenance', 'rate': '\$3,200/night', 'color': AppColors.gold},
    ];
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('My Properties', style: AppTextStyles.titleLarge),
        actions: [Padding(padding: const EdgeInsets.only(right: 16), child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/provider/property/create'), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(gradient: AppColors.cyanGradient, borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.add, color: AppColors.background, size: 16), const SizedBox(width: 4), Text('Add', style: AppTextStyles.labelMedium.copyWith(color: AppColors.background))]))))]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          Expanded(child: _s('3', 'Listed', AppColors.cyan)), const SizedBox(width: 12),
          Expanded(child: _s('1', 'Occupied', AppColors.green)), const SizedBox(width: 12),
          Expanded(child: _s('\$18,200', 'This Month', AppColors.gold)),
        ])),
        Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: props.length, itemBuilder: (c, i) {
          final p = props[i];
          return Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              Container(height: 100, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), gradient: LinearGradient(colors: [Color(0xFF1A2B40), Color(0xFF0A1520)])), child: const Center(child: Icon(Icons.villa, color: AppColors.textMuted, size: 40))),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p['name'] as String, style: AppTextStyles.headlineSmall), Text(p['type'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [GSStatusBadge(label: p['status'] as String, color: p['color'] as Color), const SizedBox(height: 4), Text(p['rate'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold))]),
              ]),
              const SizedBox(height: 12),
              Row(children: [Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/provider/property/requests'), child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)), child: Center(child: Text('View Requests', style: AppTextStyles.titleMedium))))), const SizedBox(width: 12), Expanded(child: GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(gradient: AppColors.cyanGradient, borderRadius: BorderRadius.circular(10)), child: Center(child: Text('Edit Listing', style: AppTextStyles.buttonText)))))]),
            ]));
        })),
      ]),
    );
  }
  Widget _s(String v, String l, Color color) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 0.5)), child: Column(children: [Text(v, style: AppTextStyles.headlineSmall.copyWith(color: color)), Text(l, style: AppTextStyles.caption)]));
}
