import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class MenuManagementScreen extends StatelessWidget {
  const MenuManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'name': 'Yellowfin Tuna Tartare', 'price': '\$38', 'available': true},
      {'name': 'Crispy Black Cod Miso', 'price': '\$68', 'available': true},
      {'name': 'Wagyu Beef Tenderloin', 'price': '\$145', 'available': false},
      {'name': 'Bahamian Lobster Bisque', 'price': '\$42', 'available': true},
      {'name': 'Truffle Risotto', 'price': '\$55', 'available': true},
    ];
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Menu Management', style: AppTextStyles.titleLarge),
        actions: [Padding(padding: const EdgeInsets.only(right: 16), child: GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(gradient: AppColors.cyanGradient, borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.add, color: AppColors.background, size: 16), const SizedBox(width: 4), Text('Add Item', style: AppTextStyles.labelMedium.copyWith(color: AppColors.background))]))))]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Dune by Jean-Georges', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.cyan)),
          Text('Ocean Club, Paradise Island', style: AppTextStyles.bodySmall),
          const SizedBox(height: 12),
          Row(children: [_stat('24', 'Menu Items'), const SizedBox(width: 12), _stat('8', 'Active Orders'), const SizedBox(width: 12), _stat('4.9 ★', 'Rating')]),
        ])),
        Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: menuItems.length, itemBuilder: (c, i) {
          final item = menuItems[i];
          return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.set_meal, color: AppColors.textSecondary, size: 22)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['name'] as String, style: AppTextStyles.titleMedium), Text(item['price'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold))])),
              Switch(value: item['available'] as bool, onChanged: (_) {}, activeColor: AppColors.cyan),
              const Icon(Icons.more_vert, color: AppColors.textMuted, size: 20),
            ]));
        })),
        Padding(padding: const EdgeInsets.all(20), child: GSButton(label: 'View Orders →', onTap: () => Navigator.pushNamed(context, '/provider/restaurant/orders'))),
      ]),
    );
  }
  Widget _stat(String v, String l) => Expanded(child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border, width: 0.5)), child: Column(children: [Text(v, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.cyan)), Text(l, style: AppTextStyles.caption)])));
}
