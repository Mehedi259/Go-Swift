import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class FoodOrderStatusScreen extends StatelessWidget {
  const FoodOrderStatusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final steps = [
      {'label': 'Order Confirmed', 'sub': 'Dune by Jean-Georges acknowledged', 'done': true},
      {'label': 'Chef Preparing', 'sub': 'Your meal is being prepared', 'done': true},
      {'label': 'Out for Delivery', 'sub': 'Courier en route to you', 'done': false},
      {'label': 'Delivered', 'sub': 'Estimated 4:18 PM', 'done': false},
    ];
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Order Status', style: AppTextStyles.titleLarge)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: AppColors.cyan.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)), const SizedBox(width: 6), Text('ORDER #GS-2847 • DUNE BY JEAN-GEORGES', style: AppTextStyles.cyanLabel)])),
        const SizedBox(height: 16),
        Text('Your Order is\nOn Its Way!', style: AppTextStyles.displayMedium),
        const SizedBox(height: 8),
        Text('Expected delivery: 4:18 PM  •  30-40 min remaining', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 24),
        // Progress
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Column(children: steps.asMap().entries.map((e) => _step(e.value['label'] as String, e.value['sub'] as String, e.value['done'] as bool, e.key == steps.length - 1)).toList())),
        const SizedBox(height: 20),
        // Courier info
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle), child: const Icon(Icons.delivery_dining, color: AppColors.cyan, size: 24)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Marcus Rolle', style: AppTextStyles.titleLarge), Text('Premium Courier  •  4.95 ★', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold))])), Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.phone_outlined, color: AppColors.cyan, size: 20))])),
        const SizedBox(height: 20),
        GSButton(label: 'Track on Map →', onTap: () {}),
        const SizedBox(height: 12),
        GSButton(label: 'Return to Hub', isSecondary: true, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false)),
      ])),
    );
  }
  Widget _step(String label, String sub, bool done, bool isLast) => Column(children: [
    Row(children: [
      Column(children: [Container(width: 28, height: 28, decoration: BoxDecoration(color: done ? AppColors.cyan : AppColors.surface, shape: BoxShape.circle, border: Border.all(color: done ? AppColors.cyan : AppColors.border)), child: Icon(done ? Icons.check : Icons.radio_button_unchecked, size: 14, color: done ? AppColors.background : AppColors.textMuted)),
        if (!isLast) Container(width: 2, height: 30, color: done ? AppColors.cyan.withOpacity(0.4) : AppColors.border)]),
      const SizedBox(width: 14),
      Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: AppTextStyles.titleMedium.copyWith(color: done ? AppColors.textPrimary : AppColors.textSecondary)), Text(sub, style: AppTextStyles.bodySmall)]))),
    ]),
  ]);
}
