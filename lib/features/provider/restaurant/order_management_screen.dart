import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Order #GS-2847', style: AppTextStyles.titleLarge)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: AppColors.cyan.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text('PREPARING  •  ORDER #GS-2847', style: AppTextStyles.cyanLabel)),
        const SizedBox(height: 16),
        Text('Alexander Vance', style: AppTextStyles.headlineLarge),
        Row(children: [const Icon(Icons.local_shipping_outlined, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text('Yacht delivery  •  Slip #12, Albany Marina', style: AppTextStyles.bodySmall)]),
        const SizedBox(height: 20),
        Text('Order Items', style: AppTextStyles.headlineSmall), const SizedBox(height: 12),
        ...[
          {'name': 'Yellowfin Tuna Tartare', 'qty': 1, 'price': '\$38'},
          {'name': 'Crispy Black Cod Miso', 'qty': 1, 'price': '\$68'},
          {'name': 'Bahamian Lobster Bisque', 'qty': 2, 'price': '\$84'},
        ].map((item) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Row(children: [
            Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)),
            const SizedBox(width: 12), Expanded(child: Text('×${item['qty']} ${item['name']}', style: AppTextStyles.titleMedium)),
            Text(item['price'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold)),
          ]))),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)), child: Column(children: [_r('Subtotal', '\$190.00'), _r('Delivery', 'Courier Assigned'), const Divider(color: AppColors.border), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TOTAL', style: AppTextStyles.headlineSmall), Text('\$202.50', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold))])])),
        const SizedBox(height: 20),
        GSButton(label: 'Ready for Pickup  →', onTap: () => Navigator.pop(context)),
      ])),
    );
  }
  Widget _r(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: AppTextStyles.bodyMedium), Text(v, style: AppTextStyles.titleMedium)]));
}

