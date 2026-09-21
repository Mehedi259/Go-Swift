import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = [
      {'id': '#GS-2847', 'customer': 'Alexander Vance', 'items': '3 items', 'total': '\$202.50', 'status': 'Preparing', 'time': '1:15 PM'},
      {'id': '#GS-2840', 'customer': 'Victoria Stubbs', 'items': '5 items', 'total': '\$312.00', 'status': 'New', 'time': '12:58 PM'},
      {'id': '#GS-2821', 'customer': 'Marcus Thompson', 'items': '2 items', 'total': '\$98.00', 'status': 'Ready', 'time': '12:30 PM'},
    ];
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Active Orders', style: AppTextStyles.titleLarge)),
      body: ListView.builder(padding: const EdgeInsets.all(20), itemCount: orders.length, itemBuilder: (c, i) {
        final o = orders[i];
        final statusColor = o['status'] == 'New' ? AppColors.gold : o['status'] == 'Preparing' ? AppColors.cyan : AppColors.green;
        return GestureDetector(onTap: () => Navigator.pushNamed(context, '/provider/restaurant/order-detail'),
          child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Text(o['id']!, style: AppTextStyles.cyanLabel), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text(o['status']!, style: AppTextStyles.labelSmall.copyWith(color: statusColor)))]),
              const SizedBox(height: 8),
              Row(children: [const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text(o['customer']!, style: AppTextStyles.titleMedium)]),
              Row(children: [const Icon(Icons.receipt_outlined, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text(o['items']!, style: AppTextStyles.bodySmall), const Spacer(), Text(o['total']!, style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold))]),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: GSButton(label: 'Reject', isSecondary: true, onTap: () {})),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: GSButton(label: o['status'] == 'Ready' ? 'Hand to Courier →' : 'Start Preparing →', onTap: () => Navigator.pushNamed(context, '/provider/restaurant/order-detail'))),
              ]),
            ])));
      }),
    );
  }
}
