import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class CourierActiveDeliveryScreen extends StatelessWidget {
  const CourierActiveDeliveryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Active Delivery', style: AppTextStyles.titleLarge)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: AppColors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text('ACTIVE DELIVERY #CS-3182', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green))),
        const SizedBox(height: 16), Text('Parcel In Transit', style: AppTextStyles.displayMedium),
        const SizedBox(height: 12),
        Container(height: 180, decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(16)), child: const Center(child: Icon(Icons.delivery_dining, color: AppColors.cyan, size: 40))),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Column(children: [
            Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.cyan, size: 16), const SizedBox(width: 8), Expanded(child: Text('Graycliff Boutique, Nassau  •  Picked Up', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)))]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.flag_outlined, color: AppColors.gold, size: 16), const SizedBox(width: 8), Expanded(child: Text('The Ocean Club, Paradise Island  •  5.2 km', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)))]),
          ])),
        const SizedBox(height: 20),
        GSButton(label: 'Mark as Delivered →', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/provider/courier/hub', (_) => false)),
      ])),
    );
  }
}
