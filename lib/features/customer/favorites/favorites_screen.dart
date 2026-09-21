import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_card.dart';

class FavoritesScreen extends StatelessWidget {
  final bool embedded;
  const FavoritesScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Text('Saved Favorites', style: AppTextStyles.headlineLarge)),
      Padding(padding: const EdgeInsets.fromLTRB(20, 4, 20, 0), child: Text('Your saved restaurants, drivers & properties', style: AppTextStyles.bodyMedium)),
      const SizedBox(height: 16),
      Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
        _sectionHeader('Saved Restaurants'),
        const SizedBox(height: 8),
        _favCard(context, Icons.restaurant, 'Dune by Jean-Georges', 'Ocean Club • 4.9 ★', '\$\$\$\$', '/customer/food/restaurant'),
        _favCard(context, Icons.restaurant, 'Nobu Bahamas', 'Atlantis • 4.9 ★', '\$\$\$\$', '/customer/food/restaurant'),
        const SizedBox(height: 16),
        _sectionHeader('Saved Properties'),
        const SizedBox(height: 8),
        _favCard(context, Icons.villa, 'The Ocean Club Villa', 'Paradise Island • 4.98 ★', '\$1,850/night', '/customer/properties/details'),
        _favCard(context, Icons.villa, 'Lyford Cay Estate', 'Lyford Cay • 5.0 ★', '\$4,500/night', '/customer/properties/details'),
        const SizedBox(height: 16),
        _sectionHeader('Saved Drivers'),
        const SizedBox(height: 8),
        _favCard(context, Icons.person, 'Captain Terrence Rolle', 'VIP Chauffeur • 4.98 ★', '620+ trips', '/customer/ride/booking'),
      ])),
    ]);
    return embedded ? content : Scaffold(body: SafeArea(child: content));
  }

  Widget _sectionHeader(String title) => Text(title, style: AppTextStyles.headlineSmall);

  Widget _favCard(BuildContext context, IconData icon, String name, String sub, String detail, String route) =>
    GestureDetector(onTap: () => Navigator.pushNamed(context, route),
      child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.cyan, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: AppTextStyles.titleMedium), Text(sub, style: AppTextStyles.bodySmall)])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(detail, style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold)), const SizedBox(height: 4), const Icon(Icons.favorite, color: AppColors.red, size: 18)]),
        ])));
}
