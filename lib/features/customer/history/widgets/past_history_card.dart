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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationRow(AppColors.primaryTeal, 'PICKUP (FBO JET CENTER)', 'Odyssey Aviation FBO, Coral Harbour'),
          const SizedBox(height: 10),
          _locationRow(AppColors.gold, 'DROPOFF DESTINATION', 'Albany Marina & Resort, New Providence'),
        ],
      );
    } else if (type == 'food') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RESTAURANT / CULINARY PARTNER', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text('Dune at The Ocean Club, Paradise Island', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.cardTouchpoint, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: AppColors.primaryTeal, size: 16),
                const SizedBox(width: 12),
                Expanded(child: Text('Yellowfin Tuna Tartare, Prime Beef\nTenderloin (2 curated items)', style: AppTextStyles.bodySmall)),
              ],
            ),
          ),
        ],
      );
    } else if (type == 'courier') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationRow(AppColors.primaryTeal, 'DISPATCH POINT', 'Lyford Cay Club Concierge Desk'),
          const SizedBox(height: 10),
          _locationRow(AppColors.primaryTeal, 'SECURED DESTINATION', 'Parliament Square, Downtown Nassau'),
        ],
      );
    } else if (type == 'rental') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('2024 Porsche 911 Carrera Cabriolet', style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.palette_outlined, color: AppColors.gold, size: 14),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Chalk White /\nBordeaux Leather', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Lyford Cay Marina\nHandover', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else if (type == 'property') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('The Sovereign Ocean Villa', style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 14),
              const SizedBox(width: 6),
              Text('Ocean Club Estates, Paradise Island', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          Text('Host: Julian Turnquest [Superhost] • 4 Private Beachfront Nights', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildFooter(String type) {
    if (type == 'ride') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(color: AppColors.cardTouchpoint, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('MV', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Driver Marcus Vance', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      const Icon(Icons.star, color: AppColors.gold, size: 12),
                      Text('5.0', style: AppTextStyles.labelSmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text('Mercedes-Maybach S580 • Obsidian Black', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Total Paid', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              Text('\$165.00', style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
              Text('BSD', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      );
    } else if (type == 'courier') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.verified_user_outlined, color: AppColors.primaryTeal, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('Tamper-Evident Legal Dossier (< 5 lbs)', style: AppTextStyles.bodySmall)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Delivery Fee', textAlign: TextAlign.right, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              Text('\$85.00', style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
              Text('BSD', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      );
    } else if (type == 'property') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Escrow Disposition', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.lock_outline, color: AppColors.green, size: 14),
                  const SizedBox(width: 6),
                  Text('100% Released & Audited', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Total Settled', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              Text('\$11,400.00 BSD', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type == 'rental' ? 'Settled Total' : 'Bill Total (VAT incl.)', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(type == 'rental' ? '\$1,386.00 BSD' : '\$248.50 BSD', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      );
    }
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
