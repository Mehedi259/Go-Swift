import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class MenuManagementScreen extends StatelessWidget {
  const MenuManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'name': 'Yellowfin Tuna Tartare', 'price': '\$38.00', 'available': true},
      {'name': 'Crispy Black Cod Miso', 'price': '\$68.00', 'available': true},
      {'name': 'Wagyu Beef Tenderloin', 'price': '\$145.00', 'available': false},
      {'name': 'Bahamian Lobster Bisque', 'price': '\$42.00', 'available': true},
      {'name': 'Truffle Risotto', 'price': '\$55.00', 'available': true},
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
        title: Text('Menu Management', style: AppTextStyles.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {},
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
                      'Add Item',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dune by Jean-Georges', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.cyan)),
                const SizedBox(height: 2),
                Text('Ocean Club, Paradise Island', style: AppTextStyles.bodySmall),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _statCard('24', 'Menu Items'),
                    const SizedBox(width: 10),
                    _statCard('8', 'Active Orders'),
                    const SizedBox(width: 10),
                    _statCard('4.9 ★', 'Rating'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: menuItems.length,
              itemBuilder: (c, i) {
                final item = menuItems[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.cardTouchpoint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.restaurant_menu, color: AppColors.cyan, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'] as String, style: AppTextStyles.titleMedium),
                            const SizedBox(height: 2),
                            Text(item['price'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Switch(
                        value: item['available'] as bool,
                        onChanged: (_) {},
                        activeColor: AppColors.cyan,
                        activeTrackColor: AppColors.cyanLight,
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.more_vert, color: AppColors.textMuted, size: 20),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GSButton(
              label: 'View Active Orders →',
              onTap: () => Navigator.pushNamed(context, '/provider/restaurant/orders'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String v, String l) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: [
              Text(v, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 2),
              Text(l, style: AppTextStyles.caption),
            ],
          ),
        ),
      );
}
