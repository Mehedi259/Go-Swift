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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Hero
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE8F4F8), Color(0xFFD6EDF4)],
                ),
              ),
              child: Stack(
                children: [
                  Center(child: Icon(Icons.restaurant, color: AppColors.primaryTeal.withValues(alpha: 0.4), size: 64)),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: const Icon(Icons.favorite_border, color: AppColors.primaryTeal, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.badgeTeal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('OCEAN CLUB • \$\$\$\$', style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('Dune by Jean-Georges', style: AppTextStyles.headlineLarge)),
                        GSRatingRow(rating: 4.9, reviews: 280),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('FRENCH-ASIAN FUSION • FINE DINING', style: AppTextStyles.bodySmall),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('Ocean Club, Paradise Island • 3.2 miles', style: AppTextStyles.bodySmall),
                        const SizedBox(width: 14),
                        const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('30-40 min', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _badge('Free Yacht Delivery', AppColors.badgeCyan, AppColors.primaryTeal),
                        const SizedBox(width: 8),
                        _badge('Dockside Ready', AppColors.badgeTeal, AppColors.primaryTeal),
                        const SizedBox(width: 8),
                        _badge('Open Now', const Color(0xFFE8F7ED), AppColors.green),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Featured Menu', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    ...[
                      {'name': 'Yellowfin Tuna Tartare', 'desc': 'With avocado, crispy wonton, yuzu ponzu', 'price': '\$38'},
                      {'name': 'Crispy Black Cod Miso', 'desc': 'Bahamian miso glaze, pickled daikon', 'price': '\$68'},
                      {'name': 'Wagyu Beef Tenderloin', 'desc': 'A5 grade, truffle jus, roasted bone marrow', 'price': '\$145'},
                      {'name': 'Bahamian Lobster Bisque', 'desc': 'Fresh island lobster, cream, cognac', 'price': '\$42'},
                    ].map((item) => GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/customer/food/item'),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(color: AppColors.cardTouchpoint, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.set_meal, color: AppColors.primaryTeal, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name']!, style: AppTextStyles.titleMedium),
                                  const SizedBox(height: 2),
                                  Text(item['desc']!, style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(item['price']!, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle),
                                  child: const Icon(Icons.add, color: Colors.white, size: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),
                    GSButton(label: 'View Cart →', onTap: () => Navigator.pushNamed(context, '/customer/food/cart')),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color bg, Color text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: text, fontWeight: FontWeight.bold)),
  );
}
