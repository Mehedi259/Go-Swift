import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class FoodCartScreen extends StatelessWidget {
  const FoodCartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Your Order Cart', style: AppTextStyles.titleLarge)),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Dune by Jean-Georges', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.cyan)),
          const SizedBox(height: 4), Text('Ocean Club, Paradise Island', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          ...[
            {'name': 'Yellowfin Tuna Tartare', 'qty': 1, 'price': 38},
            {'name': 'Crispy Black Cod Miso', 'qty': 1, 'price': 68},
            {'name': 'Bahamian Lobster Bisque', 'qty': 2, 'price': 42},
          ].map((item) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.set_meal, color: AppColors.textSecondary, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['name'] as String, style: AppTextStyles.titleMedium), Text('×${item['qty']}', style: AppTextStyles.bodySmall)])),
              Text('\$${(item['price'] as int) * (item['qty'] as int)}', style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold)),
              const SizedBox(width: 8), const Icon(Icons.delete_outline, color: AppColors.textMuted, size: 18),
            ]))),
          const SizedBox(height: 16),
          // Delivery note
          TextFormField(maxLines: 2, style: AppTextStyles.bodyMedium, decoration: const InputDecoration(hintText: 'Special instructions for your chef or delivery (e.g. yacht slip #12)')),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              _row('Subtotal (3 items)', '\$190.00'),
              _row('Delivery Fee', '\$0.00', sub: 'FREE (Yacht delivery included)'),
              _row('Service Fee', '\$12.50'),
              const Divider(color: AppColors.border, height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TOTAL', style: AppTextStyles.headlineSmall), Text('\$202.50', style: AppTextStyles.price)]),
            ])),
        ]))),
        Padding(padding: const EdgeInsets.all(20), child: GSButton(label: 'Proceed to Checkout →', onTap: () => Navigator.pushNamed(context, '/customer/food/checkout'))),
      ]),
    );
  }
  Widget _row(String l, String v, {String? sub}) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: AppTextStyles.bodyMedium), if (sub != null) Text(sub, style: AppTextStyles.bodySmall.copyWith(color: AppColors.green))]), Text(v, style: AppTextStyles.titleMedium)]));
}
