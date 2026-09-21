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
        color: AppColors.surface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: type == 'rental' || type == 'property' ? AppColors.gold.withOpacity(0.3) : AppColors.border),
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
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(data['icon'] as IconData, color: data['color'] as Color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['category'] as String, style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 16)),
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
                  color: AppColors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.green.withOpacity(0.3)),
                ),
                child: Text(status, style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Middle Box
          _buildMiddleSection(type),
          
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: AppColors.border, height: 1)),

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
          _locationRow(AppColors.cyan, 'PICKUP (FBO JET CENTER)', 'Odyssey Aviation FBO, Coral Harbour'),
          const SizedBox(height: 12),
          _locationRow(AppColors.gold, 'DROPOFF DESTINATION', 'Albany Marina & Resort, New Providence'),
        ],
      );
    } else if (type == 'food') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RESTAURANT / CULINARY PARTNER', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text('Dune at The Ocean Club, Paradise Island', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.background.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: AppColors.cyan, size: 16),
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
          _locationRow(AppColors.cyan, 'DISPATCH POINT', 'Lyford Cay Club Concierge Desk'),
          const SizedBox(height: 12),
          _locationRow(const Color(0xFFC0C0C0), 'SECURED DESTINATION', 'Parliament Square, Downtown Nassau'),
        ],
      );
    } else if (type == 'rental') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('2024 Porsche 911 Carrera Cabriolet', style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 15)),
          const SizedBox(height: 12),
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
          Text('The Sovereign Ocean Villa', style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 14),
              const SizedBox(width: 6),
              Text('Ocean Club Estates, Paradise Island', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Host: Julian Turnquest [Superhost] • 4 Private\nBeachfront Nights', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
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
              Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle), alignment: Alignment.center, child: Text('MV', style: AppTextStyles.labelSmall.copyWith(color: Colors.white))),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Driver Marcus Vance', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                      const SizedBox(width: 6),
                      const Icon(Icons.star, color: AppColors.gold, size: 12),
                      Text('5.0', style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold)),
                    ],
                  ),
                  Text('Mercedes-Maybach S580 •\nObsidian Black', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Total Paid', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              Text('\$165.00', style: AppTextStyles.titleLarge.copyWith(color: AppColors.cyan)),
              Text('BSD', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
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
                const Icon(Icons.verified_user_outlined, color: AppColors.cyan, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('Tamper-Evident Legal Dossier (<\n5 lbs)', style: AppTextStyles.bodySmall)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Delivery\nFee', textAlign: TextAlign.right, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              Text('\$85.00', style: AppTextStyles.titleLarge.copyWith(color: AppColors.cyan)),
              Text('BSD', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
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
                  Text('100% Released &\nAudited', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Total Settled', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              Text('\$11,400.00 BSD', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
            ],
          ),
        ],
      );
    } else {
      // generic footer for food, rental
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type == 'rental' ? 'Settled Total' : 'Bill Total (VAT incl.)', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(type == 'rental' ? '\$1,386.00 BSD' : '\$248.50 BSD', style: AppTextStyles.titleMedium.copyWith(color: type == 'rental' ? Colors.white : AppColors.cyan)),
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
          child: Text(value, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}
