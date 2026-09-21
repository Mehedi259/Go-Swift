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
        color: AppColors.surface.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
                  Text(data['status'] as String, style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6)),
                child: Text(data['id'] as String, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Title Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
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
                        Expanded(child: Text(data['title'] as String, style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 16))),
                        if (data['rating'] != null) ...[
                          const Icon(Icons.star, color: AppColors.gold, size: 14),
                          const SizedBox(width: 4),
                          Text(data['rating'].toString(), style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold)),
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
          const SizedBox(height: 16),

          // Details Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
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
                      color: isPrimary ? color : AppColors.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: isPrimary ? null : Border.all(color: AppColors.border),
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
                              Icon(action['icon'] as IconData, color: isPrimary ? AppColors.background : AppColors.textPrimary, size: 16),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              action['label'] as String,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: isPrimary ? AppColors.background : AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            if (action['trailingIcon'] != null) ...[
                              const SizedBox(width: 8),
                              Icon(action['trailingIcon'] as IconData, color: isPrimary ? AppColors.background : AppColors.textPrimary, size: 16),
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: AppColors.cyan, size: 14),
                  const SizedBox(width: 6),
                  Text('ARRIVING IN 4 MINS', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('78% Completed', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(2)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.78,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [BoxShadow(color: AppColors.cyan.withOpacity(0.5), blurRadius: 4)],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _locationRow(AppColors.cyan, 'Odyssey Aviation FBO Terminal', 'Pickup'),
          const SizedBox(height: 10),
          _locationRow(AppColors.gold, 'Albany Marina & Resort', 'VIP Dock', isCyanText: true),
        ],
      );
    } else if (type == 'food') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Yellowfin Tuna Tartare, Wagyu Beef Filet  2 items', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.pedal_bike, color: AppColors.cyan, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text('Devon Rolle (Electric Chilled Box)', style: AppTextStyles.bodySmall)),
              Text('12 - 15 mins', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 2), child: Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 14)),
              const SizedBox(width: 8),
              Expanded(child: Text('Drop-off: Lyford Cay Gate Guardhouse & Villa', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
            ],
          ),
        ],
      );
    } else if (type == 'courier') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: AppColors.cyan, size: 16),
                  const SizedBox(width: 8),
                  Text('Passed Cable Beach\nCheckpoint', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                ],
              ),
              Text('ETA 18\nMINS', textAlign: TextAlign.right, style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: AppColors.border, height: 1)),
          Row(
            children: [
              Text('From:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(width: 12),
              Expanded(child: Text('Lyford Cay Club Concierge Desk', style: AppTextStyles.bodySmall.copyWith(color: Colors.white), textAlign: TextAlign.right)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('To:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(width: 12),
              Expanded(child: Text('Parliament Square, Nassau Chamber', style: AppTextStyles.bodySmall.copyWith(color: Colors.white), textAlign: TextAlign.right)),
            ],
          ),
        ],
      );
    } else if (type == 'prep') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Black Cod Miso, Yellowtail Jalapeño, Rol  3 items', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.soup_kitchen, color: AppColors.textSecondary, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text('Chef Escort: Kendal Cartwright\n(Dual-Thermal Safe)', style: AppTextStyles.bodySmall)),
              Text('ETA 25 - 30\nmins', textAlign: TextAlign.right, style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 2), child: Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 14)),
              const SizedBox(width: 8),
              Expanded(child: Text('Drop-off: Albany Marina & Yacht Slip #42', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
            ],
          ),
        ],
      );
    } else if (type == 'rental') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.key, color: AppColors.cyan, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text('Odyssey FBO -> Coral\nHarbour', style: AppTextStyles.bodySmall.copyWith(color: Colors.white))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Scheduled Return:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              Text('Nov 18, 12:00 PM (Albany Bay)', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
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
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: AppTextStyles.bodySmall.copyWith(color: Colors.white))),
        Text(trailing, style: AppTextStyles.labelSmall.copyWith(color: isCyanText ? AppColors.cyan : AppColors.textSecondary)),
      ],
    );
  }
}
