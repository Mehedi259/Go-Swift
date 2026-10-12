import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class CancelledHistoryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const CancelledHistoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final type = data['type'] as String;
    final cancelReason = data['cancelReason'] as String;
    final isPax = cancelReason == 'CANCELLED BY PAX';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.cardTouchpoint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(data['icon'] as IconData, color: AppColors.textPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['category'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(data['date'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.cardTouchpoint, borderRadius: BorderRadius.circular(6)),
                      child: Text(data['id'] as String, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPax ? const Color(0xFFFDE8E8) : AppColors.badgeGold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cancelReason,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isPax ? AppColors.red : const Color(0xFF8A5300),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.badgeTeal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '100%\nREFUNDED',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 10, height: 1.2),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Middle Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardTouchpoint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildMiddleSection(type),
          ),

          if (type == 'ride' && data['driverName'] != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(color: AppColors.cardTouchpoint, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('VIP', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['driverName'] as String, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    if (data['vehicle'] != null)
                      Text(data['vehicle'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ],

          const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(color: AppColors.border, height: 1)),

          // Bottom Footer (Pricing & Button)
          _buildFooter(type, data['actionLabel'] as String? ?? 'Rebook', data['actionIcon'] as IconData?),
        ],
      ),
    );
  }

  Widget _buildMiddleSection(String type) {
    final from = data['pickup'] as String? ?? (data['subtitle'] as String? ?? 'Origin Departure');
    final to = data['destination'] as String? ?? (data['title'] as String? ?? 'Destination Arrival');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _locationRow(AppColors.primaryTeal, from),
        _dashedLine(),
        _locationRow(Colors.transparent, 'Reservation Terminated / Refunded', isRoute: true),
        _dashedLine(),
        _locationRow(AppColors.gold, to),
      ],
    );
  }

  Widget _locationRow(Color dotColor, String label, {bool isRoute = false, Color? color}) {
    return Row(
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: isRoute
                ? AppTextStyles.labelSmall.copyWith(color: color ?? AppColors.textSecondary, fontWeight: FontWeight.bold)
                : AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _dashedLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, top: 4, bottom: 4),
      child: Container(width: 2, height: 12, color: AppColors.border),
    );
  }

  Widget _buildFooter(String type, String actionLabel, IconData? actionIcon) {
    final fare = data['fare'] as String? ?? '\$0.00';
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Original Estimate', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                Text(fare, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, decoration: TextDecoration.lineThrough)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Net Settled (100% Refund)', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                Text('\$0.00 BSD', style: AppTextStyles.titleMedium.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: type == 'ride' ? AppColors.primaryTeal : AppColors.cyanPill,
            borderRadius: BorderRadius.circular(24),
            boxShadow: type == 'ride' ? AppColors.cardShadow : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (actionIcon != null) ...[
                    Icon(actionIcon, color: type == 'ride' ? Colors.white : AppColors.primaryTeal, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    actionLabel,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: type == 'ride' ? Colors.white : AppColors.primaryTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
