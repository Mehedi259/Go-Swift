import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class DriverRideRequestsScreen extends StatelessWidget {
  const DriverRideRequestsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Ride Requests', style: AppTextStyles.titleLarge)),
      body: ListView.builder(padding: const EdgeInsets.all(20), itemCount: 3, itemBuilder: (c, i) => Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
        child: Column(children: [
          Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text('NEW REQUEST', style: AppTextStyles.goldLabel)), const Spacer(), Text('\$${(85 + i * 20)}.00', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold))]),
          const SizedBox(height: 12),
          Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.cyan, size: 16), const SizedBox(width: 8), Text('NAS Airport', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))]),
          const SizedBox(height: 4),
          Row(children: [const Icon(Icons.flag_outlined, color: AppColors.gold, size: 16), const SizedBox(width: 8), Text('The Ocean Club', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))]),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: GSButton(label: 'Decline', isSecondary: true, onTap: () {})), const SizedBox(width: 12), Expanded(flex: 2, child: GSButton(label: 'Accept →', onTap: () => Navigator.pushNamed(context, '/provider/driver/active-ride')))]),
        ]))));
  }
}
