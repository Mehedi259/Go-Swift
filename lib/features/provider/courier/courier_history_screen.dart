import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class CourierHistoryScreen extends StatelessWidget {
  final bool embedded;
  const CourierHistoryScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final content = ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (c, i) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.delivery_dining, color: AppColors.cyan, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Graycliff → Ocean Club', style: AppTextStyles.titleMedium),
                  Text('#CS-${3180 - i * 10}  •  Apr ${20 - i}', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Text('\$${42 + i * 5}.00', style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold)),
          ],
        ),
      ),
    );

    return embedded
        ? SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text('Delivery History', style: AppTextStyles.headlineLarge),
                ),
                Expanded(child: content),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.background,
              title: Text('Delivery History', style: AppTextStyles.titleLarge),
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                ),
              ),
            ),
            body: content,
          );
  }
}
