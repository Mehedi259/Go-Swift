import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class ActiveHistoryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const ActiveHistoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final type = data['type'] as String;
    final color = data['color'] as Color;

    return Container(
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(
                    data['status'] as String,
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

          // Title Row
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data['title'] as String,
                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (data['rating'] != null) ...[
                          const Icon(Icons.star, color: AppColors.gold, size: 14),
                          const SizedBox(width: 4),
                          Text(data['rating'].toString(), style: AppTextStyles.labelSmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(data['subtitle'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Details Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardTouchpoint,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: _buildDetailsBox(type),
          ),
          const SizedBox(height: 16),

          // Actions
          if (data['actions'] != null)
            Row(
              children: (data['actions'] as List).map((action) {
                final isPrimary = action['isPrimary'] == true;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    height: 44,
                    decoration: BoxDecoration(
                      color: isPrimary ? AppColors.primaryTeal : AppColors.cyanPill,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: isPrimary ? AppColors.cardShadow : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (action['icon'] != null) ...[
                              Icon(action['icon'] as IconData, color: isPrimary ? Colors.white : AppColors.primaryTeal, size: 16),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              action['label'] as String,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: isPrimary ? Colors.white : AppColors.primaryTeal,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (action['trailingIcon'] != null) ...[
                              const SizedBox(width: 8),
                              Icon(action['trailingIcon'] as IconData, color: isPrimary ? Colors.white : AppColors.primaryTeal, size: 16),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: AppColors.primaryTeal, size: 14),
                  const SizedBox(width: 6),
                  Text('EN ROUTE TRANSIT', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(data['status'] as String? ?? 'ACTIVE', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.85,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
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
          Text(items, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.pedal_bike, color: AppColors.primaryTeal, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(data['title'] as String? ?? 'Culinary Dispatch', style: AppTextStyles.bodySmall)),
              Text('In Transit', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 2), child: Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 14)),
              const SizedBox(width: 8),
              Expanded(child: Text('Drop-off: $dest', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
            ],
          ),
        ],
      );
    } else if (type == 'courier') {
      final from = data['pickup'] as String? ?? (data['subtitle'] as String? ?? 'Origin');
      final to = data['destination'] as String? ?? (data['title'] as String? ?? 'Destination');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: AppColors.primaryTeal, size: 16),
                  const SizedBox(width: 8),
                  Text('Secure Escort in Progress', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                ],
              ),
              Text('ACTIVE', textAlign: TextAlign.right, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: AppColors.border, height: 1)),
          Row(
            children: [
              Text('From:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(width: 12),
              Expanded(child: Text(from, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.right)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('To:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(width: 12),
              Expanded(child: Text(to, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.right)),
            ],
          ),
        ],
      );
    } else if (type == 'rental') {
      final subtitle = data['subtitle'] as String? ?? 'Active Booking Window';
      final title = data['title'] as String? ?? 'Luxury Vehicle';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.key, color: AppColors.primaryTeal, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Booking Period:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      );
    } else if (type == 'property') {
      final subtitle = data['subtitle'] as String? ?? 'Active Stay';
      final title = data['title'] as String? ?? 'Luxury Estate';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.hotel_outlined, color: AppColors.primaryTeal, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reservation:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
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
        Expanded(child: Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))),
        Text(trailing, style: AppTextStyles.labelSmall.copyWith(color: isCyanText ? AppColors.primaryTeal : AppColors.textSecondary, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
