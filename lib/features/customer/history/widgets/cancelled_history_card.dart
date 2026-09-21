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
        color: AppColors.surface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
                child: Icon(data['icon'] as IconData, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['category'] as String, style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(data['date'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6)),
                      child: Text(data['id'] as String, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
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
                      color: isPax ? AppColors.red.withOpacity(0.8) : AppColors.gold.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(cancelReason, style: AppTextStyles.labelSmall.copyWith(color: isPax ? Colors.white : AppColors.gold, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003333),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('100%\nREFUNDED', textAlign: TextAlign.center, style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold, fontSize: 10, height: 1.2)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Middle Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildMiddleSection(type),
          ),
          
          if (type == 'ride') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Container(width: 40, height: 40, decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle), alignment: Alignment.center, child: Text('MV', style: AppTextStyles.labelSmall.copyWith(color: Colors.white))),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Driver Marcus Vance', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
                    Text('Mercedes-Maybach S580\nObsidian Black', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ],
          
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: AppColors.border, height: 1)),

          // Bottom Footer (Pricing & Button)
          _buildFooter(type, data['actionLabel'] as String, data['actionIcon'] as IconData?),
        ],
      ),
    );
  }

  Widget _buildMiddleSection(String type) {
    if (type == 'ride') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationRow(AppColors.cyan, 'Lynden Pindling Int\'l (NAS) Odyssey FBO'),
          _dashedLine(),
          _locationRow(Colors.transparent, 'Direct Chauffeur Corridor • Nassau West', isRoute: true),
          _dashedLine(),
          _locationRow(AppColors.gold, 'Rosewood Baha Mar, Cable Beach'),
        ],
      );
    } else if (type == 'food') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationRow(AppColors.cyan, 'Nobu Atlantis • Paradise Island'),
          _dashedLine(),
          _locationRow(Colors.transparent, 'Squall Advisory On Route • Sea Channel', isRoute: true, color: AppColors.red.withOpacity(0.7)),
          _dashedLine(),
          _locationRow(AppColors.gold, 'Albany Marina Yacht Slip #14'),
        ],
      );
    }
    return const SizedBox();
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
            style: isRoute ? AppTextStyles.labelSmall.copyWith(color: color ?? AppColors.textSecondary, fontWeight: FontWeight.bold) : AppTextStyles.bodySmall.copyWith(color: Colors.white),
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (type == 'ride') ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$110.00', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, decoration: TextDecoration.lineThrough)),
                  Text('BSD', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$0.00', style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan)),
                  Text('BSD', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
            ] else if (type == 'food') ...[
              Expanded(
                child: Text('RTD-REF-8842 • 0 BSD Fee\nApplied', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$195.00', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, decoration: TextDecoration.lineThrough)),
                  Text('BSD', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visa ••••', style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan, fontSize: 14)),
                  Text('4242', style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan, fontSize: 14)),
                ],
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: type == 'ride' ? AppColors.cyan : AppColors.surface,
            borderRadius: BorderRadius.circular(24),
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
                    Icon(actionIcon, color: type == 'ride' ? AppColors.background : AppColors.cyan, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    actionLabel,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: type == 'ride' ? AppColors.background : AppColors.cyan,
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
