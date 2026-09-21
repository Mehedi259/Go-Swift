import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class FoodCheckoutScreen extends StatelessWidget {
  const FoodCheckoutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Checkout', style: AppTextStyles.titleLarge)),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('DELIVERY ADDRESS', style: AppTextStyles.labelSmall),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.cyan, size: 20), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('The Ocean Club, Four Seasons', style: AppTextStyles.titleMedium), Text('One Ocean Drive, Paradise Island, Bahamas', style: AppTextStyles.bodySmall)])), const Icon(Icons.edit_outlined, color: AppColors.textMuted, size: 18)])),
          const SizedBox(height: 20),
          Text('DELIVERY SLOT', style: AppTextStyles.labelSmall),
          const SizedBox(height: 8),
          Row(children: [_slot('ASAP', '30-40 min', true), const SizedBox(width: 10), _slot('12:00 PM', 'Scheduled', false), const SizedBox(width: 10), _slot('7:00 PM', 'Evening', false)]),
          const SizedBox(height: 20),
          Text('PAYMENT METHOD', style: AppTextStyles.labelSmall),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cyan, width: 1.5)),
            child: Row(children: [const Icon(Icons.credit_card, color: AppColors.cyan, size: 20), const SizedBox(width: 12), Expanded(child: Text('Visa •••• 4291', style: AppTextStyles.titleMedium)), const Icon(Icons.check_circle, color: AppColors.cyan, size: 18)])),
          const SizedBox(height: 12),
          GestureDetector(onTap: () {}, child: Row(children: [const Icon(Icons.add_circle_outline, color: AppColors.cyan, size: 18), const SizedBox(width: 8), Text('Add payment method', style: AppTextStyles.cyanLabel)])),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              _row('Subtotal', '\$190.00'), _row('Delivery', 'FREE'), _row('Service Fee', '\$12.50'),
              const Divider(color: AppColors.border, height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TOTAL', style: AppTextStyles.headlineSmall), Text('\$202.50', style: AppTextStyles.price)]),
            ])),
        ]))),
        Padding(padding: const EdgeInsets.all(20), child: GSButton(label: 'Place Order  •  \$202.50 →', onTap: () => Navigator.pushNamed(context, '/customer/food/order-status'))),
      ]),
    );
  }
  Widget _slot(String time, String label, bool active) => Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(gradient: active ? AppColors.cyanGradient : null, color: active ? null : AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: active ? Colors.transparent : AppColors.border)),
    child: Column(children: [Text(time, style: AppTextStyles.titleMedium.copyWith(color: active ? AppColors.background : AppColors.textPrimary)), Text(label, style: AppTextStyles.caption.copyWith(color: active ? AppColors.background : AppColors.textMuted))])));
  Widget _row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: AppTextStyles.bodyMedium), Text(v, style: AppTextStyles.titleMedium.copyWith(color: v == 'FREE' ? AppColors.green : AppColors.textPrimary))]));
}
