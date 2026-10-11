import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'id': '#GS-2847', 'customer': 'Alexander Vance', 'items': '3 items • Black Cod Miso', 'total': '\$202.50', 'status': 'Preparing', 'time': '1:15 PM'},
      {'id': '#GS-2840', 'customer': 'Victoria Stubbs', 'items': '5 items • Bahamian Lobster', 'total': '\$312.00', 'status': 'New', 'time': '12:58 PM'},
      {'id': '#GS-2821', 'customer': 'Marcus Thompson', 'items': '2 items • Wagyu Tenderloin', 'total': '\$98.00', 'status': 'Ready', 'time': '12:30 PM'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Text('Active Orders', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: orders.length,
        itemBuilder: (c, i) {
          final o = orders[i];
          final Color statusColor;
          final Color statusBg;
          if (o['status'] == 'New') {
            statusColor = AppColors.gold;
            statusBg = AppColors.goldLight;
          } else if (o['status'] == 'Preparing') {
            statusColor = AppColors.cyan;
            statusBg = AppColors.cyanLight;
          } else {
            statusColor = AppColors.green;
            statusBg = AppColors.greenLight;
          }

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/provider/restaurant/order-detail'),
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(o['id']!, style: AppTextStyles.cyanLabel),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          o['status']!,
                          style: AppTextStyles.labelSmall.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: AppColors.cyan),
                      const SizedBox(width: 8),
                      Text(o['customer']!, style: AppTextStyles.headlineSmall.copyWith(fontSize: 17)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.receipt_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(o['items']!, style: AppTextStyles.bodySmall)),
                      Text(
                        o['total']!,
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: GSButton(
                          label: 'Reject',
                          isSecondary: true,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: GSButton(
                          label: o['status'] == 'Ready' ? 'Hand to Courier →' : 'Start Preparing →',
                          onTap: () => Navigator.pushNamed(context, '/provider/restaurant/order-detail'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
