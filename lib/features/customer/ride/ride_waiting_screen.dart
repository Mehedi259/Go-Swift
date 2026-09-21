import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class RideWaitingScreen extends StatelessWidget {
  const RideWaitingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
          const SizedBox(width: 12), Text('GO SWIFT', style: AppTextStyles.titleLarge.copyWith(color: AppColors.cyan)), const Spacer(),
          Container(width: 40, height: 40, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle), child: const Icon(Icons.person, color: AppColors.background, size: 22)),
        ])),
        Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.search, size: 14, color: AppColors.gold), const SizedBox(width: 6), Text('FINDING YOUR CHAUFFEUR', style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold))])),
          const SizedBox(height: 16),
          Text('Matching you with a\ncertified VIP chauffeur', style: AppTextStyles.displayMedium),
          const SizedBox(height: 8),
          Text('Nassau & Paradise Island dispatch network', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 24),
          // Searching animation placeholder
          Center(child: Container(width: 140, height: 140, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.cyan.withOpacity(0.3), width: 2), gradient: RadialGradient(colors: [AppColors.cyan.withOpacity(0.1), AppColors.background])),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.directions_car, color: AppColors.cyan, size: 40), const SizedBox(height: 8), Text('Searching...', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan))]))),
          const SizedBox(height: 24),
          // Trip details
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)), const SizedBox(width: 10), Expanded(child: Text('Lynden Pindling Int\'l Airport (NAS)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)))]),
              Padding(padding: const EdgeInsets.only(left: 4), child: Container(width: 1, height: 24, color: AppColors.border, margin: const EdgeInsets.symmetric(vertical: 4))),
              Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle)), const SizedBox(width: 10), Expanded(child: Text('The Ocean Club, Four Seasons Resort', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)))]),
            ])),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _infoBox('Est. Fare', '\$118.50', AppColors.gold)),
            const SizedBox(width: 12),
            Expanded(child: _infoBox('Est. Time', '12-18 min', AppColors.cyan)),
          ]),
          const Spacer(),
          GSButton(label: 'Cancel Request', isSecondary: true, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false)),
          const SizedBox(height: 16),
          Center(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/ride/driver-accepted'),
            child: Text('Simulate: Driver Accepted →', style: AppTextStyles.cyanLabel))),
          const SizedBox(height: 24),
        ]))),
      ])),
    );
  }

  Widget _infoBox(String label, String value, Color color) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 0.5)),
    child: Column(children: [Text(label, style: AppTextStyles.bodySmall), const SizedBox(height: 4), Text(value, style: AppTextStyles.headlineSmall.copyWith(color: color))]));
}
