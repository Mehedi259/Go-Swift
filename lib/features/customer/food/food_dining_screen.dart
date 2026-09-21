import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_card.dart';

class FoodDiningScreen extends StatefulWidget {
  const FoodDiningScreen({super.key});
  @override State<FoodDiningScreen> createState() => _FoodDiningScreenState();
}

class _FoodDiningScreenState extends State<FoodDiningScreen> {
  int _cat = 0;
  final _cats = ['All Restaurants', 'Bahamian Seafood', 'Fine Dining', 'Japanese', 'Caribbean'];

  final _restaurants = [
    {'name': 'Dune by Jean-Georges', 'type': 'FRENCH-ASIAN FUSION • FINE DINING', 'location': 'Ocean Club, Paradise Island • 3.2 miles', 'rating': 4.9, 'reviews': 280, 'time': '30-40 min', 'badge': 'OCEAN CLUB', 'price': '\$\$\$\$', 'special': 'Dockside Ready', 'feature': 'Free Yacht Delivery'},
    {'name': 'Nobu Bahamas', 'type': 'JAPANESE • SUSHI & OMAKASE', 'location': 'Atlantis, Paradise Island • 2.8 miles', 'rating': 4.9, 'reviews': 410, 'time': '25-35 min', 'badge': 'ATLANTIS RESORT', 'price': '\$\$\$\$', 'special': 'Thermal Vaulted', 'feature': 'Omakase Available'},
    {'name': 'Graycliff Restaurant', 'type': 'HERITAGE CARIBBEAN • WINE CELLAR', 'location': 'Downtown Nassau • 1.9 miles', 'rating': 4.8, 'reviews': 190, 'time': '35-45 min', 'badge': 'HISTORIC NASSAU', 'price': '\$\$\$\$', 'special': 'Sommelier Paired', 'feature': 'Grand Award Cellar'},
    {'name': 'Sapodilla Estate', 'type': 'BAHAMIAN CONTINENTAL • FINE DINING', 'location': 'West Bay Street • 5.4 miles', 'rating': 4.8, 'reviews': 140, 'time': '40-50 min', 'badge': 'WEST BAY', 'price': '\$\$\$\$', 'special': 'Villa Catering Spec', 'feature': 'Private Chef Kit'},
    {'name': 'Katsuya Baha Mar', 'type': 'MODERN JAPANESE & ROBATA', 'location': 'Cable Beach • 4.1 miles', 'rating': 4.7, 'reviews': 220, 'time': '30-40 min', 'badge': 'BAHA MAR RESORT', 'price': '\$\$\$', 'special': 'Swift Priority', 'feature': 'Cocktail Pairing'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        // Header
        Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Food & Dining', style: AppTextStyles.headlineLarge),
            Row(children: [const Icon(Icons.location_on, size: 12, color: AppColors.cyan), const SizedBox(width: 4), Text('Delivering to: Albany Marin  ▾', style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan))]),
          ])),
          Stack(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.notifications_none_outlined, color: AppColors.textPrimary, size: 22)),
            Positioned(top: 6, right: 6, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle))),
          ]),
          const SizedBox(width: 8),
          Container(width: 40, height: 40, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle), child: const Icon(Icons.person, color: AppColors.background, size: 22)),
        ])),
        // Search
        Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 0), child: Row(children: [
          Expanded(child: TextFormField(style: AppTextStyles.bodyLarge, decoration: InputDecoration(hintText: 'Search restaurants, cuisines, dishes...', prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
          const SizedBox(width: 8),
          Container(width: 44, height: 44, decoration: BoxDecoration(gradient: AppColors.cyanGradient, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.tune, color: AppColors.background, size: 20)),
        ])),
        // Yacht delivery banner
        Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 0), child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: const Color(0xFF0A2030), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cyan.withOpacity(0.3))),
          child: Row(children: [const Icon(Icons.sailing, color: AppColors.cyan, size: 16), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Yacht Dock & Private Villa Delivery •', style: AppTextStyles.titleMedium), Text('White-glove Butler Handover • Climate Vaulted', style: AppTextStyles.bodySmall)]))]))),
        // Category tabs
        SizedBox(height: 48, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          itemCount: _cats.length, itemBuilder: (c, i) => GestureDetector(onTap: () => setState(() => _cat = i),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(gradient: _cat == i ? AppColors.cyanGradient : null, color: _cat == i ? null : AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: _cat == i ? Colors.transparent : AppColors.border)),
              child: Text(_cats[i], style: AppTextStyles.bodySmall.copyWith(color: _cat == i ? AppColors.background : AppColors.textPrimary, fontWeight: FontWeight.w600)))))),
        // Filters
        Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 0), child: Row(children: [_filter('Top Rated', Icons.star), const SizedBox(width: 8), _filter('Under 35m', Icons.access_time), const SizedBox(width: 8), _filter('Marina Delivery', Icons.sailing)])),
        // Restaurant list
        Expanded(child: ListView.builder(padding: const EdgeInsets.fromLTRB(20, 12, 20, 20), itemCount: _restaurants.length,
          itemBuilder: (c, i) => _RestaurantCard(data: _restaurants[i]))),
      ])),
      bottomNavigationBar: _bottomBar(context),
    );
  }

  Widget _filter(String label, IconData icon) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 12, color: AppColors.textSecondary), const SizedBox(width: 4), Text(label, style: AppTextStyles.bodySmall)]));

  Widget _bottomBar(BuildContext context) => Container(decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.border, width: 0.5))),
    child: SafeArea(top: false, child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      _navItem(Icons.home, 'Home', true, () => Navigator.pop(context)),
      _navItem(Icons.receipt_long_outlined, 'History', false, () {}),
      _navItem(Icons.favorite_border, 'Favorites', false, () {}),
      _navItem(Icons.headset_mic_outlined, 'Support', false, () {}),
      _navItem(Icons.person_outline, 'Profile', false, () {}),
    ]))));

  Widget _navItem(IconData icon, String label, bool active, VoidCallback onTap) => GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: active ? AppColors.cyan : AppColors.textMuted, size: 24), const SizedBox(height: 4), Text(label, style: AppTextStyles.caption.copyWith(color: active ? AppColors.cyan : AppColors.textMuted))]));
}

class _RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _RestaurantCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/food/restaurant'),
      child: Container(margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Image placeholder
          Container(height: 130, decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)), gradient: const LinearGradient(colors: [Color(0xFF1A2B40), Color(0xFF0A1520)])),
            child: Stack(children: [
              Center(child: Icon(Icons.restaurant, color: AppColors.textMuted, size: 40)),
              Positioned(top: 10, left: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.8), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [Text(data['badge'] as String, style: AppTextStyles.labelSmall), const SizedBox(width: 6), Text(data['price'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold))]))),
              Positioned(top: 10, right: 10, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.background.withOpacity(0.8), shape: BoxShape.circle), child: const Icon(Icons.favorite_border, color: AppColors.textPrimary, size: 16))),
              Positioned(bottom: 10, left: 10, child: Text(data['type'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary))),
              Positioned(bottom: 10, right: 10, child: GSRatingRow(rating: data['rating'] as double, reviews: data['reviews'] as int)),
            ])),
          Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text(data['name'] as String, style: AppTextStyles.headlineSmall)),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
            ]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textSecondary), const SizedBox(width: 4), Expanded(child: Text(data['location'] as String, style: AppTextStyles.bodySmall))]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.access_time, size: 12, color: AppColors.textSecondary), const SizedBox(width: 4), Text(data['time'] as String, style: AppTextStyles.bodySmall), const SizedBox(width: 12),
              const Icon(Icons.anchor, size: 12, color: AppColors.cyan), const SizedBox(width: 4), Text(data['special'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan)),
            ]),
            const SizedBox(height: 6),
            Row(children: [const Icon(Icons.restaurant_menu, size: 12, color: AppColors.textSecondary), const SizedBox(width: 4), Text('Chef Curated: ${data['feature']}', style: AppTextStyles.bodySmall)]),
          ])),
        ])));
  }
}
