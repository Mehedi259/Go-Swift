import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  const RestaurantDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        // Hero
        Container(height: 200, color: const Color(0xFF1A2B40), child: Stack(children: [
          Center(child: Icon(Icons.restaurant, color: AppColors.textMuted, size: 60)),
          Positioned(top: 12, left: 12, child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.background.withOpacity(0.8), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))),
          Positioned(top: 12, right: 12, child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.background.withOpacity(0.8), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.favorite_border, color: AppColors.textPrimary, size: 20))),
        ])),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('OCEAN CLUB  •  \$\$\$\$', style: AppTextStyles.cyanLabel),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text('Dune by Jean-Georges', style: AppTextStyles.headlineLarge)),
            GSRatingRow(rating: 4.9, reviews: 280),
          ]),
          const SizedBox(height: 4),
          Text('FRENCH-ASIAN FUSION • FINE DINING', style: AppTextStyles.bodySmall),
          const SizedBox(height: 4),
          Row(children: [const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textSecondary), const SizedBox(width: 4), Text('Ocean Club, Paradise Island  •  3.2 miles', style: AppTextStyles.bodySmall), const SizedBox(width: 12), const Icon(Icons.access_time, size: 12, color: AppColors.textSecondary), const SizedBox(width: 4), Text('30-40 min', style: AppTextStyles.bodySmall)]),
          const SizedBox(height: 12),
          Row(children: [_badge('Free Yacht Delivery', AppColors.cyan), const SizedBox(width: 8), _badge('Dockside Ready', AppColors.teal), const SizedBox(width: 8), _badge('Open Now', AppColors.green)]),
          const SizedBox(height: 20),
          Text('Featured Menu', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          ...[
            {'name': 'Yellowfin Tuna Tartare', 'desc': 'With avocado, crispy wonton, yuzu ponzu', 'price': '\$38'},
            {'name': 'Crispy Black Cod Miso', 'desc': 'Bahamian miso glaze, pickled daikon', 'price': '\$68'},
            {'name': 'Wagyu Beef Tenderloin', 'desc': 'A5 grade, truffle jus, roasted bone marrow', 'price': '\$145'},
            {'name': 'Bahamian Lobster Bisque', 'desc': 'Fresh island lobster, cream, cognac', 'price': '\$42'},
          ].map((item) => GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/food/item'),
            child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
              child: Row(children: [Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.set_meal, color: AppColors.textSecondary, size: 24)),
                const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['name']!, style: AppTextStyles.titleMedium), Text(item['desc']!, style: AppTextStyles.bodySmall)])),
                Column(children: [Text(item['price']!, style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold)), const SizedBox(height: 4), Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(gradient: AppColors.cyanGradient, shape: BoxShape.circle), child: const Icon(Icons.add, color: AppColors.background, size: 14))])]))),
          ),
          const SizedBox(height: 20),
          GSButton(label: 'View Cart →', onTap: () => Navigator.pushNamed(context, '/customer/food/cart')),
        ]))),
      ])),
    );
  }
  Widget _badge(String label, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.3))), child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)));
}
