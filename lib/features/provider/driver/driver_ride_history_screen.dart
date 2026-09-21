import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class DriverRideHistoryScreen extends StatelessWidget {
  final bool embedded;
  const DriverRideHistoryScreen({super.key, this.embedded = false});
  @override
  Widget build(BuildContext context) {
    final content = ListView.builder(padding: const EdgeInsets.all(20), itemCount: 8, itemBuilder: (c, i) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.directions_car, color: AppColors.cyan, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('NAS Airport → Ocean Club', style: AppTextStyles.titleMedium), Text('#SW-${8500 - i * 22}  •  Apr ${20 - i}, ${(4 - i % 4) + 10}:00 PM', style: AppTextStyles.bodySmall)])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('\$${(118 - i * 6)}.50', style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold)), const SizedBox(height: 4), Row(children: [const Icon(Icons.star, size: 12, color: AppColors.gold), Text(' 5.0', style: AppTextStyles.caption.copyWith(color: AppColors.gold))])]),
      ])));
    return embedded ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Text('Ride History', style: AppTextStyles.headlineLarge)), const SizedBox(height: 8), Expanded(child: content)]) : Scaffold(appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))), title: Text('Ride History', style: AppTextStyles.titleLarge)), body: content);
  }
}
