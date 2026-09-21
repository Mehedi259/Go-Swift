import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class RideDriverAcceptedScreen extends StatelessWidget {
  const RideDriverAcceptedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
          const Spacer(), Container(width: 40, height: 40, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle), child: const Icon(Icons.person, color: AppColors.background, size: 22)),
        ])),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [
          // Badge
          Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: AppColors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)), const SizedBox(width: 8), Text('CHAUFFEUR EN ROUTE • TRIP #SW-8492', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green))])),
          const SizedBox(height: 16),
          Text('Your Chauffeur is On His Way', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Expected arrival: 4 minutes', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          // Driver card
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              Row(children: [
                Container(width: 64, height: 64, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: AppColors.cyan, width: 2)), child: const Icon(Icons.person, color: AppColors.cyan, size: 32)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Captain Terrence Rolle', style: AppTextStyles.headlineSmall),
                  Text('Official Licensed VIP Chauffeur #CH-402', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 6),
                  Row(children: [const Icon(Icons.star, size: 14, color: AppColors.gold), const SizedBox(width: 4), Text('4.98', style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold)), const SizedBox(width: 8), Text('620+ Trips', style: AppTextStyles.bodySmall)]),
                ])),
              ]),
              const SizedBox(height: 16),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 16),
              // Vehicle info
              Row(children: [const Icon(Icons.directions_car, color: AppColors.textSecondary, size: 18), const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Cadillac Escalade ESV', style: AppTextStyles.titleMedium),
                  Text('Onyx Black • Tinted Privacy Glass • Luggage Cap: 6 Bags', style: AppTextStyles.bodySmall),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)), child: Text('BS-942-EX', style: AppTextStyles.labelMedium.copyWith(color: AppColors.cyan))),
              ]),
              const SizedBox(height: 16),
              // Progress steps
              Row(children: [
                _step('Chauffeur Assigned', true),
                Expanded(child: Container(height: 1, color: AppColors.border)),
                _step('En Route to You', true),
                Expanded(child: Container(height: 1, color: AppColors.border)),
                _step('Arrived', false),
                Expanded(child: Container(height: 1, color: AppColors.border)),
                _step('In Transit', false),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.phone_outlined, color: AppColors.cyan, size: 18), const SizedBox(width: 8), Text('Call Chauffeur', style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan))])))),
                const SizedBox(width: 12),
                Expanded(child: GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.message_outlined, color: AppColors.textSecondary, size: 18), const SizedBox(width: 8), Text('Message', style: AppTextStyles.titleMedium)])))),
              ]),
            ])),
          const SizedBox(height: 20),
          GSButton(label: 'Track Live Ride →', onTap: () => Navigator.pushNamed(context, '/customer/ride/active')),
          const SizedBox(height: 16),
        ]))),
      ])),
    );
  }

  Widget _step(String label, bool done) => Column(children: [
    Container(width: 28, height: 28, decoration: BoxDecoration(color: done ? AppColors.cyan : AppColors.surface, shape: BoxShape.circle, border: Border.all(color: done ? AppColors.cyan : AppColors.border)),
      child: Icon(done ? Icons.check : Icons.radio_button_unchecked, size: 14, color: done ? AppColors.background : AppColors.textMuted)),
    const SizedBox(height: 4), Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
  ]);
}
