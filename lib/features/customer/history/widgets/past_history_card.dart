import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class PastHistoryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const PastHistoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final type = data['type'] as String;
    final status = data['status'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: type == 'rental' || type == 'property' ? AppColors.gold.withValues(alpha: 0.5) : AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.badgeTeal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(data['icon'] as IconData, color: data['color'] as Color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['category'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('Ref ${data['id']}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(width: 8),
                        Container(width: 3, height: 3, decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(data['date'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary))),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7ED),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                ),
                child: Text(status, style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Middle Box
          _buildMiddleSection(type),

          const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(color: AppColors.border, height: 1)),

          // Bottom Footer
          _buildFooter(type),
        ],
      ),
    );
  }

  Widget _buildMiddleSection(String type) {
    if (type == 'ride') {
      final pickup = data['pickup'] as String? ?? 'Nassau Departure';
      final dest = data['destination'] as String? ?? (data['title'] as String? ?? 'Arrival Terminal');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationRow(AppColors.primaryTeal, 'PICKUP', pickup),
          const SizedBox(height: 10),
          _locationRow(AppColors.gold, 'DROPOFF DESTINATION', dest),
        ],
      );
    } else if (type == 'food') {
      final restaurant = data['restaurant'] as String? ?? (data['title'] as String? ?? 'Bahamian Kitchen');
      final items = data['items'] as String? ?? (data['subtitle'] as String? ?? 'Curated Selection');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RESTAURANT / CULINARY PARTNER', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(restaurant, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.cardTouchpoint, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: AppColors.primaryTeal, size: 16),
                const SizedBox(width: 12),
                Expanded(child: Text(items, style: AppTextStyles.bodySmall)),
              ],
            ),
          ),
        ],
      );
    } else if (type == 'courier') {
      final from = data['pickup'] as String? ?? 'Dispatch Point';
      final to = data['destination'] as String? ?? (data['title'] as String? ?? 'Delivery Point');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationRow(AppColors.primaryTeal, 'DISPATCH POINT', from),
          const SizedBox(height: 10),
          _locationRow(AppColors.primaryTeal, 'SECURED DESTINATION', to),
        ],
      );
    } else if (type == 'rental') {
      final title = data['vehicle'] as String? ?? (data['title'] as String? ?? 'Luxury Fleet Vehicle');
      final sub = data['subtitle'] as String? ?? 'Completed Rental Period';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(sub, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        ],
      );
    } else if (type == 'property') {
      final title = data['property'] as String? ?? (data['title'] as String? ?? 'Luxury Villa Stay');
      final sub = data['subtitle'] as String? ?? 'Completed Reservation';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(sub, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildFooter(String type) {
    final fare = data['fare'] as String? ?? '\$0.00';
    final driverName = data['driverName'] as String?;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.cardTouchpoint, borderRadius: BorderRadius.circular(8)),
              child: Text(
                'Settled',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              driverName ?? 'VAT & Fees Included',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Total Paid', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
            Text(fare, style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _locationRow(Color dotColor, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 4),
          child: Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}
