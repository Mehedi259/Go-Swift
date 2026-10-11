import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_card.dart';

class PropertyListingsScreen extends StatelessWidget {
  const PropertyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final props = [
      {'name': 'The Ocean Club Villa', 'type': 'Oceanfront Villa', 'status': 'Occupied', 'rate': '\$1,850/night', 'color': AppColors.green},
      {'name': 'Paradise Island Penthouse', 'type': 'Resort Penthouse', 'status': 'Available', 'rate': '\$1,200/night', 'color': AppColors.cyan},
      {'name': 'Lyford Cay Cottage', 'type': 'Private Estate', 'status': 'Maintenance', 'rate': '\$3,200/night', 'color': AppColors.gold},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Text('My Properties', style: AppTextStyles.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/provider/property/create'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Add Property',
                      style: AppTextStyles.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: _s('3', 'Listed', AppColors.cyan)),
                const SizedBox(width: 10),
                Expanded(child: _s('1', 'Occupied', AppColors.green)),
                const SizedBox(width: 10),
                Expanded(child: _s('\$18,200', 'This Month', AppColors.gold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: props.length,
              itemBuilder: (c, i) {
                final p = props[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.cardTouchpoint,
                        ),
                        child: const Center(
                          child: Icon(Icons.villa, color: AppColors.cyan, size: 48),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p['name'] as String, style: AppTextStyles.headlineSmall),
                                const SizedBox(height: 2),
                                Text(p['type'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GSStatusBadge(label: p['status'] as String, color: p['color'] as Color),
                              const SizedBox(height: 4),
                              Text(p['rate'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/provider/property/requests'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Center(
                                  child: Text('View Requests', style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                decoration: BoxDecoration(
                                  color: AppColors.cyanLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
                                ),
                                child: Center(
                                  child: Text('Edit Listing', style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan, fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _s(String v, String l, Color color) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Text(v, style: AppTextStyles.headlineSmall.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 2),
            Text(l, style: AppTextStyles.caption),
          ],
        ),
      );
}
