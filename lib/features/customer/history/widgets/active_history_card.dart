import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class ActiveHistoryCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const ActiveHistoryCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final type = data['type'] as String;
    final color = data['color'] as Color;
    final statusDisplay = data['status'] as String? ?? 'ACTIVE';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Status dot + Status label + Booking ID Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      statusDisplay,
                      style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.cardTouchpoint, borderRadius: BorderRadius.circular(6)),
                  child: Text(data['id'] as String, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Title Row: Service Icon + Destination / Restaurant Name + Subtitle
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.badgeTeal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data['icon'] as IconData, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] as String,
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['subtitle'] as String,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Details Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: _buildDetailsBox(type),
            ),
            const SizedBox(height: 12),

            // Action / Live Tracking Tap Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (data['fare'] != null)
                  Text(
                    data['fare'] as String,
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  )
                else
                  const SizedBox(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Live Tracking',
                      style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 14, color: color),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsBox(String type) {
    if (type == 'ride') {
      final pickup = data['pickup'] as String? ?? 'Island Departure';
      final dest = data['destination'] as String? ?? (data['title'] as String? ?? 'VIP Destination');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationRow(AppColors.primaryTeal, pickup, 'Pickup'),
          const SizedBox(height: 8),
          _locationRow(AppColors.gold, dest, 'Dropoff', isCyanText: true),
        ],
      );
    } else if (type == 'food') {
      final items = data['items'] as String? ?? 'Curated Culinary Delivery';
      final dest = data['destination'] as String? ?? (data['subtitle'] as String? ?? 'VIP Villa Drop-off');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant_menu, size: 14, color: Color(0xFFC78400)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  items,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _locationRow(AppColors.gold, dest, 'Delivery Address'),
        ],
      );
    } else if (type == 'courier') {
      final from = data['pickup'] as String? ?? (data['subtitle'] as String? ?? 'Origin');
      final to = data['destination'] as String? ?? (data['title'] as String? ?? 'Destination');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationRow(AppColors.primaryTeal, from, 'Pickup'),
          const SizedBox(height: 8),
          _locationRow(AppColors.gold, to, 'Dropoff', isCyanText: true),
        ],
      );
    } else if (type == 'rental') {
      final subtitle = data['subtitle'] as String? ?? 'Active Booking Window';
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Booking Period:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        ],
      );
    } else if (type == 'property') {
      final subtitle = data['subtitle'] as String? ?? 'Active Stay';
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Stay Window:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _locationRow(Color dotColor, String title, String trailing, {bool isCyanText = false}) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          trailing,
          style: AppTextStyles.labelSmall.copyWith(color: isCyanText ? AppColors.primaryTeal : AppColors.textSecondary, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
