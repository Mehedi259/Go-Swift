import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class ActiveHistoryCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const ActiveHistoryCard({super.key, required this.data, this.onTap});

  double _getProgress(String type, String status) {
    final s = status.toLowerCase();
    if (type == 'ride') {
      if (s == 'requested' || s == 'matching') return 0.25;
      if (s == 'accepted') return 0.50;
      if (s == 'arrived') return 0.70;
      if (s == 'in_progress') return 0.85;
      if (s == 'completed') return 1.0;
      return 0.25;
    } else if (type == 'food') {
      if (s == 'placed') return 0.20;
      if (s == 'confirmed') return 0.35;
      if (s == 'in_prep') return 0.50;
      if (s == 'kitchen_sealed') return 0.65;
      if (s == 'courier_assigned') return 0.75;
      if (s == 'in_transit') return 0.85;
      if (s == 'handed_over' || s == 'delivered' || s == 'completed') return 1.0;
      return 0.25;
    } else if (type == 'courier') {
      if (s == 'requested' || s == 'matching') return 0.25;
      if (s == 'accepted') return 0.50;
      if (s == 'picked_up' || s == 'in_transit') return 0.80;
      if (s == 'delivered' || s == 'completed') return 1.0;
      return 0.25;
    } else if (type == 'rental') {
      if (s == 'pending') return 0.30;
      if (s == 'confirmed') return 0.60;
      if (s == 'active' || s == 'in_progress') return 0.85;
      if (s == 'completed' || s == 'returned') return 1.0;
      return 0.30;
    } else if (type == 'property') {
      if (s == 'pending') return 0.30;
      if (s == 'confirmed') return 0.60;
      if (s == 'checked_in' || s == 'active') return 0.85;
      if (s == 'checked_out' || s == 'completed') return 1.0;
      return 0.30;
    }
    return 0.25;
  }

  String _getPhaseLabel(String type, String status) {
    final s = status.toLowerCase();
    if (type == 'ride') {
      if (s == 'requested' || s == 'matching') return 'FINDING CHAUFFEUR';
      if (s == 'accepted') return 'CHAUFFEUR EN ROUTE';
      if (s == 'arrived') return 'CHAUFFEUR ARRIVED';
      if (s == 'in_progress') return 'EN ROUTE TRANSIT';
      if (s == 'completed') return 'TRIP COMPLETED';
      return s.toUpperCase();
    } else if (type == 'food') {
      if (s == 'placed') return 'ORDER PLACED';
      if (s == 'confirmed') return 'KITCHEN CONFIRMED';
      if (s == 'in_prep') return 'PREPARING DISHES';
      if (s == 'kitchen_sealed') return 'KITCHEN SEALED';
      if (s == 'courier_assigned') return 'COURIER DISPATCHED';
      if (s == 'in_transit') return 'EN ROUTE DELIVERY';
      if (s == 'handed_over' || s == 'delivered' || s == 'completed') return 'DELIVERED';
      return s.toUpperCase();
    } else if (type == 'courier') {
      if (s == 'requested' || s == 'matching') return 'MATCHING COURIER';
      if (s == 'accepted') return 'COURIER ASSIGNED';
      if (s == 'picked_up' || s == 'in_transit') return 'SECURE ESCORT IN TRANSIT';
      if (s == 'delivered' || s == 'completed') return 'PARCEL DELIVERED';
      return s.toUpperCase();
    } else if (type == 'rental') {
      if (s == 'pending') return 'RESERVATION PENDING';
      if (s == 'confirmed') return 'FLEET RESERVED';
      if (s == 'active' || s == 'in_progress') return 'ACTIVE VEHICLE HIRE';
      if (s == 'completed' || s == 'returned') return 'VEHICLE RETURNED';
      return s.toUpperCase();
    } else if (type == 'property') {
      if (s == 'pending') return 'BOOKING PENDING';
      if (s == 'confirmed') return 'VILLA RESERVED';
      if (s == 'checked_in' || s == 'active') return 'IN-RESIDENCE STAY';
      if (s == 'checked_out' || s == 'completed') return 'CHECKED OUT';
      return s.toUpperCase();
    }
    return s.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final type = data['type'] as String;
    final color = data['color'] as Color;
    final rawStatus = data['rawStatus'] as String? ?? (data['status'] as String? ?? 'ACTIVE');
    final statusDisplay = data['status'] as String? ?? 'ACTIVE';

    final double progress = _getProgress(type, rawStatus);
    final String phaseLabel = _getPhaseLabel(type, rawStatus);

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

            // Dynamic Progress Bar & Phase Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, color: color, size: 14),
                          const SizedBox(width: 6),
                          Text(phaseLabel, style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text(
                        statusDisplay,
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Real Dynamic Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      height: 6,
                      width: double.infinity,
                      color: Colors.white,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.05, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailsBox(type),
                ],
              ),
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
          const SizedBox(height: 6),
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
              const Icon(Icons.restaurant_menu, size: 13, color: Color(0xFFC78400)),
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
          const SizedBox(height: 6),
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
          const SizedBox(height: 6),
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
